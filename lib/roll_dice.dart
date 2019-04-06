import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class RollDice extends StatefulWidget {
  @override
  _RollDiceState createState() => _RollDiceState();
}

class _RollDiceState extends State<RollDice>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  String image1 = "dice_1.png";
  String image2 = "dice_3.png";

  @override
  void initState() {
    setImage1();
    setImage2();

    controller =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 0.5, curve: Curves.linear)));
    animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        print("completed");
        controller.reset();
      } else if (status == AnimationStatus.forward) {
        // operation has started
        // get the two random images
        setImage1();
        setImage2();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// this function will roll the dice
  void rollDice() {
    if (controller.isAnimating) return;
    controller.forward();
  }

  /// generate a random number for dice
  int getRandomNumber() {
    var rnd = Random();
    return rnd.nextInt(6) + 1; // start from 0 and the max is exclusive
  }

  /// set the image for dice 1
  void setImage1() {
    image1 = "dice_${getRandomNumber()}.png";
  }

  /// set the image for dice 2
  void setImage2() {
    image2 = "dice_${getRandomNumber()}.png";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Roll Dice App"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Transform(
                      transform: Matrix4.rotationZ(2 * pi * animation.value),
                      alignment: Alignment.center,
                      child: Transform(
                        transform: Matrix4.rotationX(2 * pi * animation.value),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "images/$image1",
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Transform(
                      transform: Matrix4.rotationZ(2 * pi * animation.value),
                      alignment: Alignment.center,
                      child: Transform(
                        transform: Matrix4.rotationY(2 * pi * animation.value),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "images/$image2",
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Expanded(child: Container()),
            RaisedButton(
              onPressed: rollDice,
              child: Text("Roll"),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
