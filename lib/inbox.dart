import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:window_manager/window_manager.dart';

class SendNotePage extends StatefulWidget {
  const SendNotePage({super.key});

  @override
  State<SendNotePage> createState() => _SendNotePageState();
}

class _SendNotePageState extends State<SendNotePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _apiController = TextEditingController();
  String _responseBody = '';
  bool _isLocked = false;
  String url = '';

//按下发送按钮后事件
  Future<void> sendNoteToInbox() async {
    setState(() {
      _isLocked = true;
    });

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
        // _responseBody = json.decode(response.body).toString();
        _responseBody = "发送成功！";
        _controller.clear(); // 清空输入框
      } else {
        _responseBody = '发送失败...';
      }
    } catch (e) {
      _responseBody = 'Error: $e';
    }
    // 检查BuildContext是否仍然有效
    // if (ScaffoldMessenger.of(context).mounted) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text(_responseBody)));
    // }
    setState(() {
      _isLocked = false;
    });
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
        title: DragToMoveArea(
          child: Row(
            children: [
              const Text('Inbox'),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _apiController,
                      maxLines: 1,
                      //textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        //icon: Icon(Icons.api),
                        prefixIcon: Icon(Icons.api),
                        hintText: 'Enter your inbox API',
                      ),
                      //style: const TextStyle(fontSize: 16.0),
                      onChanged: (text) {
                        // print("Editing complete: ${_apiController.text}");
                        url = _apiController.text;
                      },
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.minimize),
                onPressed: () {
                  windowManager.minimize();
                },
              ),
              IconButton(
                icon: Icon(isMaximized
                    ? Icons.browser_not_supported
                    : Icons.crop_square_outlined),
                onPressed: toggleMaximize,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  windowManager.close();
                },
              ),
            ],
          ),
        ),
        //leading: Icon(Icons.menu),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                enabled: !_isLocked,
                maxLines: null,
                minLines: 99,
                decoration: const InputDecoration(
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
              child: const Text('send'),
            ),
          ),
          Text(_responseBody),
        ],
      ),
    );
  }
}
