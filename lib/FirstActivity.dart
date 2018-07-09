import 'package:flutter/material.dart';
import 'values.dart';
import 'HomeActivity.dart';

class FirstActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FirstActivityState();
  }
}

class FirstActivityState extends State<FirstActivity>
    with SingleTickerProviderStateMixin {
// 动画
  Animation animation;

  // 动画管理器
  AnimationController controller;

  var animationStateListener;

  @override
  void initState() {
    super.initState();
    //初始化动画管理器
    controller = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    //初始化动画
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //跳转
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => new HomeActivity()),
              (route) => route == null);
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
        opacity: animation,
        child: new Image.asset(
          SplashImage,
          fit: BoxFit.cover,
        ));
  }
}
