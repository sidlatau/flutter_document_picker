import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _path = '-';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;

  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.mwfbak',
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: _pickFileInProgress ? null : _pickDocument,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Picked file path:',
                style: Theme.of(context).textTheme.title,
              ),
              Text('$_path'),
              _pickFileInProgress ? CircularProgressIndicator() : Container(),
              Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Params',
                          style: Theme.of(context).textTheme.headline,
                        ),
                        Text(
                          'iOS',
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Text(
                          'Example app is configured to pick custom document type with extension ".mwfbak"',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Allow pick all documents("public.data" UTI will be used).',
                                softWrap: true,
                              ),
                            ),
                            Checkbox(
                              value: _iosPublicDataUTI,
                              onChanged: (value) {
                                setState(() {
                                  _iosPublicDataUTI = value;
                                });
                              },
                            ),
                          ],
                        ),
                        TextField(
                          controller: _utiController,
                          enabled: !_iosPublicDataUTI,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Uniform Type Identifier to pick:',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _pickDocument() async {
    String result;
    try {
      setState(() {
        _path = '-';
        _pickFileInProgress = true;
      });

      FlutterDocumentPickerParams params;
      if (!_iosPublicDataUTI) {
        params = FlutterDocumentPickerParams(
          utiTypes: [
            _utiController.text,
          ],
        );
      }

      result = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      result = 'Error: $e';
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }

    setState(() {
      _path = result;
    });
  }
}
