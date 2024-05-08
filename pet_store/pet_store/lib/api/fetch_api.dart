//viết hàm fetch để lấy dữ liệu
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_store/model/dog.dart';

typedef FetchCallback = void Function(List<Dog>);

//đón nhận id để trả về 1 đường dẫn
//thực hiện request httpđến link api
Future<String?> fetchImage(int id) async {
  final response = await http
      .get(Uri.parse('https://api.thedogapi.com/v1/images/search?id=$id'));

//nếu mã trạng thái là 200 (tức là không vấn đề gì) thì nó trả về json cho
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    //chỉ lấy mỗi trường url trong đó
    if (data.isNotEmpty) {
      return data[0]['url'];
    }
  }
  return null;
}

//tương tự cái trên
Future<void> fetchData(FetchCallback callback) async {
  final response =
      await http.get(Uri.parse('https://api.thedogapi.com/v1/breeds'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Dog> fetchedBreeds = [];

    for (var json in data) {
      //check tại hàm  rồi trả về trường imageUrl
      Dog dog = Dog.fromJson(json);
      dog.imageUrl = await fetchImage(dog.id ?? -1);
      fetchedBreeds.add(dog);
    }
    //callback về dữ liệu lấy được
    callback(fetchedBreeds);
  }
  //trả lỗi nếu có vấn đề
  else {
    throw Exception('Failed to load data');
  }
}
