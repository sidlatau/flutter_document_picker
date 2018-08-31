import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _path = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Open file picker'),
                onPressed: () async {
                  String result;
                  try {
                    result = await FlutterDocumentPicker.openDocument();
                  } catch (e) {
                    result = 'Error: $e';
                  }

                  setState(() {
                    _path = result;
                  });
                },
              ),
              Text(_path)
            ],
          ),
        ),
      ),
    );
  }
}
