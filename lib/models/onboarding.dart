class OnBoardingModel {
  final String title;
  final String description;
  final String image;

  OnBoardingModel({this.title, this.description, this.image});

  factory OnBoardingModel.fromJson(Map<String, dynamic> json) {
    return OnBoardingModel(
      title: json['title'],
      description: json['description'],
      image: json['image'] ?? "https://admin.refashioned.ru/media/shutterstock_1484435264_1.jpg",
    );
  }
}
