class OnboardingModel{

    final String title;
    final String desc;
    final String image;

    OnboardingModel({this.title, this.image, this.desc});


    factory OnboardingModel.fromJson(Map<String, dynamic> json){
      return OnboardingModel(
        title: json['title'],
        desc: json['description'],
        image: json['image']
      );
    }



}