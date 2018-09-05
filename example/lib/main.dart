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
  bool _checkByCustomExtension = false;

  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.mwfbak',
  );

  final _extensionController = TextEditingController(
    text: 'mwfbak',
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
        body: SingleChildScrollView(
          child: Padding(
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
                _buildCommonParams(),
                Theme.of(context).platform == TargetPlatform.iOS
                    ? _buildIOSParams()
                    : Container(),
              ],
            ),
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

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions:
            _checkByCustomExtension ? [_extensionController.text] : null,
        allowedUtiTypes: _iosPublicDataUTI ? null : [_utiController.text],
      );

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

  _buildIOSParams() {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'iOS Params',
                  style: Theme.of(context).textTheme.headline,
                ),
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
    );
  }

  _buildCommonParams() {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Common Params',
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Check file by extension - if picked file does not have wantent extension - return "extension_mismatch" error',
                        softWrap: true,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: _checkByCustomExtension,
                    onChanged: (value) {
                      setState(() {
                        _checkByCustomExtension = value;
                      });
                    },
                  ),
                ],
              ),
              TextField(
                controller: _extensionController,
                enabled: _checkByCustomExtension,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'File extension to pick:',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
