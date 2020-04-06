import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'RandomWords.dart';
import 'bean/CataBean.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Expandable Demo',
      debugShowCheckedModeBanner: false,
      home: new HeaderPage(title: "Expandable List"),
    );
  }
}

class HeaderPage extends StatelessWidget {
  final title;
  const HeaderPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: ExpandableList(),
    );
  }
}

class ExpandableList extends StatefulWidget {
  ExpandableList({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ExpandableList> {
  List<CataBean> _ipAddress = List<CataBean>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState');
    _getIPAddress();
  }

  _getIPAddress() async {
    final List<CataBean> catas = List<CataBean>();
    print('_getIPAddress');
    var url = 'https://baby361.cn/babystudy/audio/catalog.json';

    Response res = await get(url);
    print("url = " + url);
    if (res.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(utf8.decode(res.bodyBytes));
              for (var value in jsonData) {
          CataBean fact = CataBean.fromJson(value);
          catas.add(fact);
        }
        print("catas = " + catas.length.toString());
        setState(() {
          _ipAddress.addAll(catas);
          print("_ipAddress = " + _ipAddress.length.toString());
        });
    } else {
      print("_ipAddress failed  code : " + res.statusCode.toString());
    }

//    var httpClient = new HttpClient();

//    String result;
//    try {
//      var request = await httpClient.getUrl(Uri.parse(url));
//      var response = await request.close();
//      print('response.statusCode = ' + response.statusCode.toString());
//      if (response.statusCode == HttpStatus.OK) {
//        print("111 = ");
//        var jsonStr = await response.transform(utf8.decoder).join();
//        print("jsonStr = " + jsonStr);
//        List<dynamic> jsonData = jsonDecode(jsonStr);
//
//        for (var value in jsonData) {
//          CataBean fact = CataBean.fromJson(value);
//          catas.add(fact);
//        }
//        print("catas = " + catas.length.toString());
//        setState(() {
//          _ipAddress.addAll(catas);
//          print("_ipAddress = " + _ipAddress.length.toString());
//        });
//      } else {
//        result =
//            'Error getting IP address:\nHttp status ${response.statusCode}';
//
//        print("222 = ");
//      }
//    } catch (exception) {
//      result = 'Failed getting IP address';
//      print("exception = " + exception);
//    }

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) => ExpansionTile(
        title: new Text(_ipAddress[i].cata),
        children: _ipAddress[i]
            .cataItem
            .map((val) => new ListTile(
                  title: Padding(
                    //左边添加8像素补白
                    padding: const EdgeInsets.only(left: 8.0),
                    child: new Text(val.name),
                  ),
                  onTap: () {
                    print("valurl = " + val.name);
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return RandomWords();
                    }));
                  },
                ))
            .toList(),
      ),
      itemCount: _ipAddress.length,
    );
  }
}
