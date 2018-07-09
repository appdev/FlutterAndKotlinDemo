import 'package:flutter/material.dart';
import 'entity.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'values.dart';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'package:temp_flutter_webview_plugin/flutter_webview_plugin.dart';

class DetailsActivity extends StatelessWidget {
  final String slug;
  final String title;
  final String titleImage;

  DetailsActivity(this.slug, this.title, this.titleImage);
  Widget boxAdapter(BuildContext context) {
    return new FutureBuilder<DetailEntity>(
        future: fetchDetail(slug),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Center(
              child: new Padding(
                padding: new EdgeInsets.all(8.0),
                child: new RichText(
                    text: new TextSpan(
                        text: snapshot.data.content,
                        style: DefaultTextStyle.of(context).style)),
              ),
            );
          } else if (snapshot.hasError) {
            return new Center(child: new Text('${snapshot.error}'));
          }
          return new Center(child: new CircularProgressIndicator());
        });
  }

  Widget boxAdapterWebView(BuildContext context) {
    return new FutureBuilder<DetailEntity>(
        future: fetchDetail(slug),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new WebviewScaffold(
                url: new Uri.dataFromString(snapshot.data.content,
                        mimeType: 'text/html')
                    .toString());
          } else if (snapshot.hasError) {
            return new Center(child: new Text('${snapshot.error}'));
          }
          return new Center(child: new CircularProgressIndicator());
        });
  }

  Future<DetailEntity> fetchDetail(slug) async {
    var res = await http.get(getDetailUrl(slug));
    return DetailEntity.fromJson(json.decode(res.body));
  }

  @override
  Widget build(BuildContext context) {



    return new Scaffold(
        body: new CustomScrollView(
      slivers: <Widget>[
        new SliverAppBar(
          pinned: true,
          expandedHeight: 180.0,
          flexibleSpace: new FlexibleSpaceBar(
            title: new Text(
              title,
              maxLines: 1,
              style: new TextStyle(fontSize: 15.0),
            ),
            background: new FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: titleImage,
              height: 180.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        new SliverToBoxAdapter(
//          child: new WebviewScaffold(url: getDetailUrl(slug))
          child: boxAdapter(context),
        )
      ],
    ));
  }
}
