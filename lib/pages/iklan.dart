
import 'package:flutter/material.dart';

import 'package:aplikasi_omah/model/slider_model.dart';

class Iklan extends StatefulWidget {
  @override
  _IklanState createState() => _IklanState();
}

class _IklanState extends State<Iklan> {
  List<SliderModel> sliders = [];
  int currentState = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    sliders = SliderModel.getSlides();
  }

  Widget pageIndexIndicator(bool isCurrentWidget){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: isCurrentWidget? 10 : 6,
      width: isCurrentWidget? 10 : 6,
      decoration: BoxDecoration(
        color: isCurrentWidget ? Colors.grey: Colors.grey[300],
        borderRadius: BorderRadius.circular(12)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        itemCount: sliders.length,
        onPageChanged: (val) {
          setState(() {
            currentState = val;
          });
        },
        itemBuilder: (context, index) {
          return SlideTiles(sliders[index].imagePath, sliders[index].title,
              sliders[index].text);
        },
        controller: pageController,
      ),
      bottomSheet: currentState != sliders.length - 1
          ? Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      pageController.animateToPage(sliders.length - 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                    }, 
                    child: Text("SKIP"),
                  ),
                  // GestureDetector(
                  //   child: Text("SKIP"),
                  //   onTap: () {
                  //     pageController.animateToPage(sliders.length - 1,
                  //         duration: Duration(milliseconds: 400),
                  //         curve: Curves.linear);
                  //   },
                  // ),
                  Row(
                    children: [
                      for (int i = 0; i < sliders.length; i++)
                        i == currentState
                            ? pageIndexIndicator(true)
                            : pageIndexIndicator(false)
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      pageController.animateToPage(currentState + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                    }, 
                    child: Text('NEXT'),
                  ),
                  // GestureDetector(
                  //   child: Text("NEXT"),
                  //   onTap: () {
                  //     pageController.animateToPage(currentState + 1,
                  //         duration: Duration(milliseconds: 400),
                  //         curve: Curves.linear);
                  //   },
                  // ),
                ],
              ),
            )
          : TextButton(
            onPressed: () => Navigator.pushNamed(context, 'login_screen'),
            child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 60,
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
          ),
          // GestureDetector(
          //     child: Container(
          //       alignment: Alignment.center,
          //       width: double.infinity,
          //       height: 60,
          //       child: Text(
          //         "Done",
          //         style: TextStyle(color: Colors.grey[700]),
          //       ),
          //     ),
          //     onTap: () {
          //       Navigator.pushNamed(context, 'login_screen');
          //     },
          //   ),
    );
  }
}

// ignore: must_be_immutable
class SlideTiles extends StatelessWidget {
  String imagePath;
  String title;
  String text;

  SlideTiles(this.imagePath, this.title, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 200,
            width: 250,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 18, color: Colors.black38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}