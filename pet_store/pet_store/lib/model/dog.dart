//tạo model cho đối tượng

class Dog {
  Dog({
    this.weight,
    this.height,
    this.id,
    this.name,
    this.bredFor,
    this.bredGroup,
    this.lifeSpan,
    this.temperament,
    this.origin,
    this.imageUrl,
    this.referenceImageId,
  }) : gender = id! % 2 == 0 ? 'Male' : 'Female';

  factory Dog.fromJson(Map<String, dynamic> json) => Dog(
        weight: json['weight'] == null
            ? null
            : WeightAndHeight.fromJson(json['weight']),
        height: json['height'] == null
            ? null
            : WeightAndHeight.fromJson(json['height']),
        id: json['id'],
        name: json['name'],
        bredFor: json['bred_for'],
        bredGroup: json['breed_group'],
        lifeSpan: json['life_span'],
        temperament: json['temperament'],
        origin: json['origin'],
        referenceImageId: json['reference_image_id'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'bredFor': bredFor,
      'bredGroup': bredGroup,
      'lifeSpan': lifeSpan,
      'temperament': temperament,
      'origin': origin,
      'gender': gender,
    };
  }

  WeightAndHeight? weight;
  WeightAndHeight? height;
  int? id;
  String? name;
  String? bredFor;
  String? bredGroup;
  String? lifeSpan;
  String? temperament;
  String? origin;
  String? imageUrl;
  String? referenceImageId;
  String? gender;
}

class WeightAndHeight {
  WeightAndHeight({
    this.imperial,
    this.metric,
  });

  factory WeightAndHeight.fromJson(Map<String, dynamic> json) =>
      WeightAndHeight(
        imperial: json['imperial'],
        metric: json['metric'],
      );

  String? imperial;
  String? metric;
}
