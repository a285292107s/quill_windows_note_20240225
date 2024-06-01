import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendNotePage extends StatefulWidget {
  @override
  _SendNotePageState createState() => _SendNotePageState();
}

class _SendNotePageState extends State<SendNotePage> {
  final TextEditingController _controller = TextEditingController();
  String _responseBody = '';

  Future<void> sendNoteToInbox() async {
    final String url = 'https://app.gudong.site/api/inbox/bYzIBejD8qBkjY62Wi3cQUIfgmDLHm';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send to inBox'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter your note here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
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