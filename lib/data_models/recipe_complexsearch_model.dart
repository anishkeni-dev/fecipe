class ComplexSearchModel {
  final int id;
  final String title;
  final String image;
  ComplexSearchModel({
    required this.id,
    required this.title,
    required this.image,
  });
  factory ComplexSearchModel.fromJson(Map<String, dynamic> json) {
    return ComplexSearchModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }

}
