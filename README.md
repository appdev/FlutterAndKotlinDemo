# FlutterAndKotlinDemo
Demo developed with flutter kotlin and java 

---
使用Flutter开发的一个demo，对于纯flutter的开发，我更倾向于使用flutter与原生混合使用的方式（目前2018年07月09日来说这种方式对于老项目，硬件相关的项目友好）。  

Demo中演示了Flutter的使用，和如何在Flutter中调用Java、Kotlin Activity的问题，调用方式是通过`MethodChannel`不熟悉的可以[看这里](http://doc.flutter-dev.cn/platform-channels/),`MethodChannel`可以完成Native端和Flutter的相互调用，可以完成。至于使用kotlin调用Flutter Widget(单独的一个界面)可以仿照项目中调用activity的方式扩展插件。

由于目前flutter还没有办法直接加载html代码。所以直接在详情页调用了webview插件，可以看到flutter的界面右上角有个debug字样，原生activity则没有

----
使用flutter module方式：

这种方式应该是官方比较推荐的方式，通过Flutter module中的flutter模块，本质上还是通过MethodChannel进行调用的。   

具体是通过一个`FlutterView`来达到目的的，`FlutterView`可以看做是Android端的一个View，只不过里面包含的是Flutter的内容  
```
fab.setOnClickListener(new View.OnClickListener() {
  @Override
  public void onClick(View view) {
    View flutterView = Flutter.createView(
      MainActivity.this,
      getLifecycle(),
      "route1"
    );
    FrameLayout.LayoutParams layout = new FrameLayout.LayoutParams(600, 800);
    layout.leftMargin = 100;
    layout.topMargin = 200;
    addContentView(flutterView, layout);
  }
});
```
详细的使用方式可以[看这里](https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps)


这个调用是异步的，目前看，Native端调用Flutter层效果并不是很理想。个人测试没有直接调用activity效果好


这个方案目前处于preview阶段，等beta版出现之后在看看具体效果。

---

下面分别是首页、Flutter的详情页、原生Activity  

<img src="https://github.com/huclengyue/FlutterAndKotlinDemo/blob/master/Screenshot/Screenshot_2018-07-09-09-33-55-835_app.efs.flutterapp.png" height="560"/>
<img src="https://github.com/huclengyue/FlutterAndKotlinDemo/blob/master/Screenshot/Screenshot_2018-07-09-09-34-15-080_app.efs.flutterapp.png" height="560"/>  

<img src="https://github.com/huclengyue/FlutterAndKotlinDemo/blob/master/Screenshot/Screenshot_2018-07-09-09-34-32-553_app.efs.flutterapp.png" height="560"/>

