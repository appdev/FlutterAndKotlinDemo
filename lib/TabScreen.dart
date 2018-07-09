import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:temp_flutter_webview_plugin/flutter_webview_plugin.dart';
import 'entity.dart';
import 'values.dart';
import 'package:flutter_plugin/router_plugin.dart';

//类似于list_view的item 初始化之后不再改变所以使用less
// ignore: non_abstract_class_inherits_abstract_member_one
class TabScreen extends StatelessWidget {
  String suffix;

  //构造函数，表示第一个值传给suffix
  TabScreen(this.suffix);

  //使用inkwell点击效果
  Widget listItem(BuildContext context, int index, ListEntity info) {
    print(info.toString());
    //卡片布局
    return new Card(
        child: new InkWell(
      onTap: () {
        //跳转页面
//        RouterPlugin.startActivity(
//            "app.efs.flutterapp.DetailsActivity");
        if (index % 2 == 0) {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new WebviewScaffold(
                        url: getDetailWebUrl(info.slug),
                        appBar: new AppBar(
                          title: new Text(info.title),
                        ),
                      )));
        } else {
          Map<String, String> map = {
            "title": info.title,
            "slug": info.slug.toString(),
          };
          RouterPlugin.startActivity("app.efs.flutterapp.DetailsActivity", map);
        }
      },
      //列表布局
      child: new Column(
        children: <Widget>[
          //图片内存
          new FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image:
                  (info.titleImage).isEmpty ? defaultImageUrl : info.titleImage,
              height: 180.0,
              width: 1000.0,
              fit: BoxFit.cover),
          new Padding(
            //padding
            padding: new EdgeInsets.all(8.0),
            child: new Text(info.title),
          )
        ],
      ),
    ));
  }

  /// 这里使用`FutureBuilder`
  /// 不得不说`Flutter`封装使用的非常方便，简单的就能实现不同情况下显示不同`widget`
  /// 默认是返回一个`loading`加载框,出现错误只是简单的显示一个`Text`
  /// 数据之后使用`ListView.Builder`构建出样式
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new FutureBuilder<List<ListEntity>>(
          future: fetchList(suffix),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) =>
                      listItem(context, index, snapshot.data[index]));
            } else if (snapshot.hasError) {
              return new Center(child: new Text('${snapshot.error}'));
            }
            return CircularProgressIndicator();
          }),
    );
  }

  Future<List<ListEntity>> fetchList(String suffix) async {
    var response = await http.get(getListUrl(suffix));
    return ListEntity.fromJson(json.decode(response.body));
  }
}
