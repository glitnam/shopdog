import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_store/api/fetch_api.dart';
import 'package:pet_store/model/dog.dart';
import 'package:pet_store/pages/breed/breed_detail.dart';

import 'package:pet_store/r.dart';

class BreedList extends StatefulWidget {
  const BreedList({Key? key}) : super(key: key);

  @override
  State<BreedList> createState() => _BreedListState();
}

class _BreedListState extends State<BreedList> {
  List<Dog> breeds = [];
  List<Dog> filteredBreeds = [];
  bool isLoading = true;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    //gọi data đầu vào để lấy dữ liệu
    fetchData(updateBreeds);
  }

  //nếu có nhập tìm kiếm thì update
  void updateBreeds(List<Dog> fetchedBreeds) {
    setState(() {
      breeds = fetchedBreeds;
      filteredBreeds = breeds;
      isLoading = false;
    });
  }

  //tìm kiếm theo ký tự
  void filterBreeds(String query) {
    setState(() {
      searchText = query;
      //check nếu có chữ thì ký tự sẽ được tìm kiếm theo name nếu không thì hiển thị tất cả gioogns loài
      if (query.isNotEmpty) {
        filteredBreeds = breeds.where((breed) {
          return breed.name!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      } else {
        //ko có ký tự hiển thị hết
        filteredBreeds = breeds;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _headerWidget(),
              _bodyWidget(),
            ],
          ),
        ),
      ),
    );
  }

  //tạo ô search
  Widget _headerWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        onChanged: filterBreeds,
        decoration: InputDecoration(
          hintText: 'Search breeds...',
          border: OutlineInputBorder(),
          suffixIcon: Padding(
            padding: EdgeInsets.all(15.0),
            child: SvgPicture.asset(
              AssetIcons.search,
              height: 25,
              width: 25,
            ),
          ),
        ),
      ),
    );
  }

  //tạo body
  Widget _bodyWidget() {
    //nếu data đang loading thì hiện loading tròn
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      //tạo biến để check xem có tìm kiếm ko nếu tìm kiếm thì hiện mỗi tìm kiếm không thì hiện tất cả
      List<Dog> displayBreeds = searchText.isNotEmpty ? filteredBreeds : breeds;
      return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(
          displayBreeds.length,
          (index) => _breedItemWidget(displayBreeds[index]),
        ),
      );
    }
  }

  Widget _breedItemWidget(Dog breed) {
    return GestureDetector(
      //điều hướng sang màn detail truyền cả model Dog để nhận dữ liệu
      onTap: () => navigateToBreedDetail(breed),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //check link ảnh null thì hiện container nếu có thì hiện ảnh
            breed.imageUrl != null && breed.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: Image.network(
                      breed.imageUrl!,
                      fit: BoxFit.cover,
                      height: 100,
                      width: double.infinity,
                    ),
                  )
                : Container(
                    color: Colors.grey,
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //hiện tên
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          breed.name ?? '',
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //hiện giới tính nếu id chăn là nam lẻ là nữ
                      SvgPicture.asset(
                        breed.id! % 2 == 0
                            ? AssetIcons.male
                            : AssetIcons.female,
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                  Text('Mã số: ${breed.referenceImageId ?? ''}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //hàm chuyển trang truyền model vào để bên detail nhận đc dữ liệu
  void navigateToBreedDetail(Dog breed) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BreedDetail(breed: breed),
      ),
    );
  }
}
