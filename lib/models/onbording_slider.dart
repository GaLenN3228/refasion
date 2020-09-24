class SliderModel{

  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath,this.title,this.desc});

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  String getTitle(){
    return title;
  }

  String getDesc(){
    return desc;
  }

}
List<SliderModel> getSlides(){

  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("Продавайте и покупайте почти новые брендовые вещи");
  sliderModel.setTitle("Гарантия подлинности");
  sliderModel.setImageAssetPath("assets/images/png/onbording.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc("Одежда, обувь и аксессуары со скидкой до 90% каждый день");
  sliderModel.setTitle("Умное ценообразование");
  sliderModel.setImageAssetPath("assets/images/png/onbording.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc("Одежда, обувь и аксессуары со скидкой до 90% каждый день");
  sliderModel.setTitle("Умное ценообразование");
  sliderModel.setImageAssetPath("assets/images/png/onbording.png");
  slides.add(sliderModel);


  //4
  sliderModel.setDesc("Одежда, обувь и аксессуары со скидкой до 90% каждый день");
  sliderModel.setTitle("Умное ценообразование");
  sliderModel.setImageAssetPath("assets/images/png/onbording.png");
  slides.add(sliderModel);


  sliderModel = new SliderModel();

  return slides;
}