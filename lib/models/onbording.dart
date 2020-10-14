class OnboardingModel{

    final String title0;
    final String desc0;
    final String image0;

    final String title1;
    final String desc1;
    final String image1;

    final String title2;
    final String desc2;
    final String image2;

    final String title3;
    final String desc3;
    final String image3;

    final String title4;
    final String desc4;
    final String image4;

    OnboardingModel({this.title1, this.desc1, this.image1, this.title2, this.desc2, this.image2, this.title3, this.desc3, this.image3, this.title0, this.image0, this.desc0, this.desc4, this.image4, this.title4});


    factory OnboardingModel.fromJson(List<dynamic> json){
      return OnboardingModel(
        title0: json[0]['title'],
        desc0: json[0]['description'],
        image0: json[0]['image'],

        title1: json[1]['title'],
        desc1: json[1]['description'],
        image1: json[1]['image'],

        title2: json[2]['title'],
        desc2: json[2]['description'],
        image2: json[2]['image'],

        title3: json[3]['title'],
        desc3: json[3]['description'],
        image3: json[3]['image'],


        title4: json[4]['title'],
        desc4: json[4]['description'],
        image4: json[4]['image']
      );
    }



}