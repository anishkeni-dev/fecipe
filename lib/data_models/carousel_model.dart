class CarouselData{
  final String title;
  final String image;

  CarouselData({required this.title,required this.image});

  factory CarouselData.fromJson(Map<String, dynamic> json) {
  return CarouselData(
  title: json['title'],
  image: json['image'],
  );
  }

  Map<String, dynamic> toJson() {
  return {
  'title': title,
  'image': image,
  };
  }
  }
