import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'ipfs.dart';

class IpfsScreen extends StatefulWidget {
  IpfsScreen({Key? key}) : super(key: key);

  @override
  _IpfsScreenState createState() => _IpfsScreenState();
}

class _IpfsScreenState extends State<IpfsScreen> {
  late final Ipfs ipfs;

  final url_ctrl = TextEditingController();
  final json_ctrl = TextEditingController();

  @override
  void initState() {
    ipfs = Ipfs(
      host: 'https://demo.ilunafriq.com',
      noPort: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Theme(
          data: ThemeData(
            primarySwatch: Colors.grey,
          ),
          child: TextFormField(
            controller: url_ctrl,
            style: TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              fillColor: Colors.black,
              focusColor: Colors.white,
              icon: Icon(Icons.link),
              hintText: 'Enter ipfs hash',
              labelText: 'URL',
            ),
            onSaved: (String? value) {
              print('saved: ' + value!);
            },
            validator: (String? value) {
              return (value != null && value.contains('@'))
                  ? 'Wrong address.'
                  : null;
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save',
            onPressed: () {
              save();
            },
          ),
          IconButton(
            icon: Icon(Icons.play_arrow_outlined),
            tooltip: 'Request',
            onPressed: () {
              query();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: json_ctrl,
              maxLines: 8,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: query,
        tooltip: 'Query',
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  void save() async {
    final hash = await ipfs.add(
      MultipartFile.fromString('file', json_ctrl.text),
    );
//    print(await r.bytesToString());
    url_ctrl.text = /*jsonDecode*/ hash;
  }

  void query() async {
    final stream = await ipfs.cat(url_ctrl.text);
    json_ctrl.text = /*jsonDecode*/ (await stream.bytesToString());
  }
}
