import 'package:flutter/material.dart';
import 'values.dart';
import 'TabScreen.dart';

class HomeActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomeState();
  }
}

class _HomeState extends State<HomeActivity> with TickerProviderStateMixin {
  TabController controller;
  int tabIndex = 0;

//  var tabListener;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: getTabLength(tabIndex), vsync: this);
//    tabListener = () {};
//    controller.addListener(tabListener);
  }

  //侧边Drawer
  Widget drawer() {
    return new Column(
      children: <Widget>[
        new Container(
          color: Colors.blue,
          height: 160.0,
          child: new Center(
              child: new Text(
            HomeTitle,
            style: new TextStyle(color: Colors.white),
          )),
        ),
        new Expanded(
            child: new ListView.builder(
                itemCount: drawerTabs.length,
                itemBuilder: (context, index) =>
                    drawerListItem(context, index)))
      ],
    );
  }

  /// Drawer ListView Item
  /// 如果只是简单的Item ListTitle是个不错的选择
  /// 点击之后有个SnackBar提示然后重新初始化Tab管理器
  /// 因为目前为止Tab管理器的length不能动态设置
  /// 关闭抽屉 Navigator.pop(context);
  Widget drawerListItem(context, index) {
    var text = drawerTabs[index];
    return new ListTile(
      leading: new Icon(Icons.android),
      title: new Text(text,
          style: new TextStyle(
              color: tabIndex == index ? Colors.blue : Colors.black)),
      onTap: () {
        Navigator.pop(context);
        Scaffold
            .of(context)
            .showSnackBar(new SnackBar(content: new Text("开始加载$text")));
        setState(() {
//          controller.removeListener(tabListener);
          controller =
              new TabController(length: getTabLength(index), vsync: this);
//          controller.addListener(tabListener);

          tabIndex = index;
        });
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //一个list
  List getList(index) {
    return getTabTitle(index).map((text) => new Tab(text: text)).toList();
  }

  List getBodyView(index) {
    List<String> tabList = getTabTitle(index);
    List<Widget> tabViews = [];
    for (int i = 0; i < tabList.length; i++) {
      tabViews.add(new TabScreen(getTabSuffix(index, i)));
    }
    return tabViews;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(
        child: drawer(),
      ),
      appBar: new AppBar(
        title: new Text(drawerTabs[tabIndex]),
        bottom: new TabBar(
          tabs: getList(tabIndex),
          isScrollable: true,
          controller: controller,
        ),
      ),
      body: new TabBarView(
          children: getBodyView(tabIndex), controller: controller),
    );
  }
}
