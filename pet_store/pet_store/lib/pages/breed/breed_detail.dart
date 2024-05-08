import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_store/model/dog.dart';
import 'package:pet_store/r.dart';

class BreedDetail extends StatefulWidget {
  final Dog breed;

  const BreedDetail({Key? key, required this.breed}) : super(key: key);

  @override
  _BreedDetailState createState() => _BreedDetailState();
}

class _BreedDetailState extends State<BreedDetail> {
  //tạo 2 biến isFavorite để check đã yêu thích hay chưa index để đếm số lượng
  bool isFavorite = false;
  int _index = 0;

  //gọi hàm checkFavoriteStatus để check yêu thích
  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    try {
      //tạo biến breedId đón nhận id và biến userFavoritesRef để nhận người dùng đang đăng nhập
      String breedId = widget.breed.id.toString();
      final userFavoritesRef =
          FirebaseFirestore.instance.collection('user_favorites');
      //doc(breedId) để truy vấn dữ liệu trong cái user get để lấy dữ liệu
      final snapshot = await userFavoritesRef.doc(breedId).get();
      //xử lý tồn tại yêu thích hay chưa nếu tài liệu tồn tại, isFavorite được đặt thành true, ngược lại, nó được đặt thành false.
      setState(() {
        isFavorite = snapshot.exists;
      });
    }
    //xử lý ngoại lệ
    catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  //thay đổi trạng thái yêu thích
  Future<void> toggleFavoriteStatus() async {
    try {
      String breedId = widget.breed.id.toString();
      final userFavoritesRef =
          FirebaseFirestore.instance.collection('user_favorites');
      //dogData đọn nhận những dữ liệu từ model Dog
      Map<String, dynamic> dogData = widget.breed.toMap();
      //nếu đã tồn tại yêu thích nếu có yêu cầu thì hủy yêu thích
      if (isFavorite) {
        await userFavoritesRef.doc(breedId).delete();
      }
      //ngược lại
      else {
        //nếu chưa yêu thích thì nó sẽ lưu hết tất cả dữ liệu trong model
        await userFavoritesRef.doc(breedId).set(dogData);
      }
      //cập nhật lại trạng thái yêu thích
      setState(() {
        isFavorite = !isFavorite;
      });
    }
    //xử lý ngoại lệ
    catch (e) {
      print('Error toggling favorite status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          //in ra tên
          centerTitle: true,
          title: Text(widget.breed.name ?? ''),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  //in ra ảnh
                  Column(
                    children: [
                      widget.breed.imageUrl != null &&
                              widget.breed.imageUrl!.isNotEmpty
                          ? Image.network(
                              widget.breed.imageUrl!,
                              fit: BoxFit.cover,
                              height: 400,
                            )
                          : Container(
                              color: Colors.grey,
                            ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        //button yêu thích nếu được yêu thích thì hiện favorite không thì remve_favorite
                        //toggleFavoriteStatus để thay đổi trạng thái khi ấn vào
                        IconButton(
                          icon: isFavorite
                              ? SvgPicture.asset(AssetIcons.favorite)
                              : SvgPicture.asset(AssetIcons.removeFavorite),
                          onPressed: () {
                            toggleFavoriteStatus();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _infoWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoWidget() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 300,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              widget.breed.name!,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  inherit: false,
                  color: Colors.black),
            ),
            _infoDetail(),
          ],
        ),
      ),
    );
  }

  Widget _infoDetail() {
    //tạo 2 list 1 list cho tiêu đề title 1 list cho dữ liệu info
    List<String> title = [
      'Name: ',
      'Bred For: ',
      'Bred Group: ',
      'Life Span: ',
      'Temperament: ',
      'Origin: ',
      'Gender: '
    ];

    List<String> infoDetails = [
      widget.breed.name ?? '',
      widget.breed.bredFor ?? '',
      widget.breed.bredGroup ?? '',
      widget.breed.lifeSpan ?? '',
      widget.breed.temperament ?? '',
      widget.breed.origin ?? '',
      widget.breed.gender ?? '',
    ];

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.redAccent.withOpacity(0.2),
      ),
      child: Row(
        children: [
          //icon left đề ấn chuyển về nếu biến index đã gọi ở đầu mà lớn hơn 0 (tương ứng với name trong list)
          GestureDetector(
            onTap: () {
              setState(() {
                if (_index > 0) {
                  _index--;
                }
              });
            },
            child: SvgPicture.asset(
              AssetIcons.left,
              height: 30,
              width: 30,
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.amberAccent,
              ),
              height: 190,
              width: 230,
              child: Column(
                children: [
                  Text(
                    title[_index],
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        inherit: false,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        infoDetails[_index],
                        maxLines: 5,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            inherit: false,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //nút right để chuyển tiếp tới khi index =infoDetails.length - 1 thì không chuyển được nữa
          GestureDetector(
            onTap: () {
              setState(() {
                if (_index < infoDetails.length - 1) {
                  _index++;
                }
              });
            },
            child: SvgPicture.asset(
              AssetIcons.right,
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
    );
  }
}
