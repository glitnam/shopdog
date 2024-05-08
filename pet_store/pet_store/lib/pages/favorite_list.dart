import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_store/model/dog.dart';
import 'package:pet_store/pages/breed/breed_detail.dart';

class FavoriteList extends StatefulWidget {
  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Breeds'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        //chỉ định dữ liệu StreamBuilder lắng nghe (trạng thái của user_favorites) thoogn qua snapshot
        stream:
            FirebaseFirestore.instance.collection('user_favorites').snapshots(),
        builder: (context, snapshot) {
          //check lỗi nếu có thì hiện lỗi
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          //đang loading hiện vòng tròn load
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          //mỗi item trong snapshot được ánh xạ thành 1 item của đối tượng Dog
          //danh sách các đối tượng Dog sau khi được chuyển đổi được lưu trong biến favoriteBreeds.
          final List<Dog> favoriteBreeds = snapshot.data!.docs.map((doc) {
            //tạo biến data để đọc dữ liệu cho model DOg
            final data = doc.data() as Map<String, dynamic>;
            return Dog(
                id: int.parse(doc.id),
                name: data['name'],
                imageUrl: data['imageUrl'],
                bredFor: data['bredFor'],
                bredGroup: data['bredGroup'],
                lifeSpan: data['lifeSpan'],
                temperament: data['temperament'],
                origin: data['origin']);
          }).toList();
          return ListView.builder(
            itemCount: favoriteBreeds.length,
            itemBuilder: (context, index) {
              final breed = favoriteBreeds[index];
              return _item(breed: breed);
            },
          );
        },
      ),
    );
  }

  Widget _item({required Dog breed}) {
    return GestureDetector(
      onTap: () => navigateToBreedDetail(breed),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.blueAccent, shape: BoxShape.circle),
              child: Center(child: Text('${breed.id ?? 0}')),
            ),
            breed.imageUrl != null && breed.imageUrl!.isNotEmpty
                ? Image.network(
                    breed.imageUrl!,
                    fit: BoxFit.cover,
                    height: 150,
                    width: 180,
                  )
                : Container(
                    color: Colors.grey,
                  ),
            Text(breed.name ?? '')
          ],
        ),
      ),
    );
  }

  void navigateToBreedDetail(Dog breed) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BreedDetail(breed: breed),
      ),
    );
  }
}
