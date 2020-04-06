import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:video_player/video_player.dart';
import 'bean/MusiBean.dart';

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  VideoPlayerController  _controller;

  List<MusiBean> _ipAddress = List<MusiBean>();

  int index = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState');
    _getIPAddress();
  }

  _getIPAddress() async {
    final List<MusiBean> musics = List<MusiBean>();
    print('_getIPAddress');
    var url = 'http://127.0.0.1:8080/tangshi.json';

    Response res = await get(url);

    if (res.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      for (var value in jsonData) {
        MusiBean fact = MusiBean.fromJson(value);
        musics.add(fact);
      }
      print("catas = " + musics.length.toString());
      setState(() {
        _ipAddress.addAll(musics);
        print("_ipAddress = " + _ipAddress.length.toString());
      });
    } else {
      print("_ipAddress failed  code : " + res.statusCode.toString());
    }

//    var httpClient = new HttpClient();
//
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
//          MusiBean fact = MusiBean.fromJson(value);
//          musics.add(fact);
//        }
//        print("catas = " + musics.length.toString());
//        setState(() {
//          _ipAddress.addAll(musics);
//          print("_ipAddress = " + _ipAddress.length.toString());
//        });
//      } else {
//        result =
//        'Error getting IP address:\nHttp status ${response.statusCode}';
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
//    return new Text(new WordPair.random().asPascalCase);
//    return _buildSuggestions();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        ),
        body: _buildSuggestions()
    );

  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called, once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        itemBuilder: (context, i) {

          // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings in the ListView,
          // minus the divider widgets.
          return _buildRow(i, _ipAddress[i]);
        },
      itemCount:_ipAddress.length,
    );
  }

  Widget _buildRow(int i, MusiBean wordPair) {
//    print("_buildRow");
//    final alreadySaved = _saved.contains(wordPair);
    return new ListTile(
        title: new Text(
          wordPair.name,
          style: _biggerFont,
          ),
        trailing: new Icon(
            index == i? Icons.play_arrow : null,
            color:  Colors.red,
        ),
        onTap: (){
          playAudio(i);
          setState((){
//            if(alreadySaved){
//              _saved.remove(wordPair);
//            }else{
//              _saved.add(wordPair);
//            }
          });
        },
    );
  }

  void playAudio(int i) {
    disposeController();
    index = i;
    MusiBean wordPair = _ipAddress[i];
    print("playAudio : index = " + index.toString() + " name = " + wordPair.name);
    _controller = VideoPlayerController.network(wordPair.url);
    
    _controller.initialize();
    _controller.play();

    _controller.addListener(checkVideo);
  }

  void checkVideo() {
    // Implement your calls inside these conditions' bodies :
    if (_controller.value.position ==
        Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if (_controller.value.position == _controller.value.duration) {
      print('video Ended');
      playNext();
    }
  }

  @override
  void dispose() {
    super.dispose();
    disposeController();
  }

  void disposeController() {
    if(_controller != null){
      _controller.removeListener(checkVideo);
      _controller.pause();
      _controller.dispose();
    }
  }

  playNext(){
    setState(() {
      index ++;
      if(index>=_ipAddress.length){
        index = 0;
      }
    });
    playAudio(index);
  }

}
