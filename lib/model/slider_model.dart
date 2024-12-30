// import 'package:flutter/material.dart';

class SliderModel {
  String imagePath;
  String title;
  String text;

  SliderModel(this.imagePath, this.title, this.text);

  static List<SliderModel> getSlides(){
    List<SliderModel> slides = [];

    SliderModel s1 = new SliderModel("assets/images/clean.png", "LAUNDRY BERSIH\n& WANGI", "Laundry Kami Bisa Cuci\nBaju Kotor Jadi Bersih,\nTapi Nggak Bisa Cuci Dosa!");
    SliderModel s2 = new SliderModel("assets/images/powder.png", "Berbagai layanan\nlaundry", "Laundry Apa Pun, Kami Ahlinya!");
    SliderModel s3 = new SliderModel("assets/images/delivery-bike.png", "Pesanan antar\n& jemput", "Nggak sempat ke laundry?\nJemput-antar jadi solusi!");
    slides.add(s1);
    slides.add(s2);
    slides.add(s3);
      return slides;
  }
}