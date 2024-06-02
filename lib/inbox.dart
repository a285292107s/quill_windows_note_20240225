import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:window_manager/window_manager.dart';

class SendNotePage extends StatefulWidget {
  @override
  _SendNotePageState createState() => _SendNotePageState();
}

class _SendNotePageState extends State<SendNotePage> {
  final TextEditingController _controller = TextEditingController();
  String _responseBody = '';

  Future<void> sendNoteToInbox() async {
    final String url =
        'https://app.gudong.site/api/inbox/bYzIBejD8qBkjY62Wi3cQUIfgmDLHm';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final String content = _controller.text;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _responseBody = json.decode(response.body).toString();
        });
      } else {
        _responseBody = 'Failed to send note.';
      }
    } catch (e) {
      _responseBody = 'Error: $e';
    }
  }

  bool isMaximized = false;

  @override
  void initState() {
    super.initState();
    checkMaximizedStatus();
  }

  void checkMaximizedStatus() async {
    isMaximized = await windowManager.isMaximized();
    setState(() {});
  }

  void toggleMaximize() async {
    isMaximized ? windowManager.restore() : windowManager.maximize();
    isMaximized = !isMaximized;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        //leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: Icon(Icons.minimize),
            onPressed: () {
              windowManager.minimize();
            },
          ),
          IconButton(
            //没找到还原按钮，先用同一个按钮凑合着
            icon: Icon(isMaximized ? Icons.crop_square : Icons.crop_square),
            onPressed: toggleMaximize,
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              windowManager.close();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                maxLines: null,
                minLines: 99,
                decoration: InputDecoration(
                  hintText: 'Enter your note here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: ElevatedButton(
              onPressed: sendNoteToInbox,
              child: Text('Send'),
            ),
          ),
          Text(_responseBody),
        ],
      ),
    );
  }
}
