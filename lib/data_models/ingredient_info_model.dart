class IngredientInfo {
  int id;
  String name;
  String image;

  IngredientInfo({
    required this.id,
    required this.name,
    required this.image,
  });

  factory IngredientInfo.fromJson(Map<String, dynamic> json) {
    return IngredientInfo(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

class IdModel {
  final String id;
  IdModel({required this.id});
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }

  factory IdModel.fromJson(dynamic json) {
    final data = json.data()! as Map<String, dynamic>;
    return IdModel(id: data['id']);
  }

}
