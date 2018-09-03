import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_notes/firebase/firebase.dart';
import 'package:flutter_notes/model/note.dart';
import 'package:flutter_notes/view/camera_widget.dart';

class NewNoteWidget extends StatefulWidget {
  @override
  _NewNoteWidgetState createState() => _NewNoteWidgetState();
}

class _NewNoteWidgetState extends State<NewNoteWidget> {
  FirebaseService _service = new FirebaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  bool _isLoading = false;

  String _title;
  String _text;
  Uri _imageLink;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("New Note"),
      ),
      body: Column(
        children: <Widget>[
          new Flexible(
            child: CustomScrollView(
              slivers: <Widget>[
                new SliverList(
                    delegate: new SliverChildListDelegate(<Widget>[
                  new Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 24.0,
                            ),
                            new TextFormField(
                              decoration: InputDecoration(labelText: "Title"),
                              controller: _titleController,
                              keyboardType: TextInputType.text,
                              validator: (val) =>
                                  val.isEmpty ? "Title can\'t be empty" : null,
                              onSaved: (val) => _title = val.trim(),
                            ),
                            const SizedBox(
                              height: 24.0,
                            ),
                            new TextFormField(
                              decoration: InputDecoration(labelText: "Text"),
                              controller: _textController,
                              keyboardType: TextInputType.text,
                              validator: (val) =>
                                  val.isEmpty ? "Text can\'t be empty" : null,
                              onSaved: (val) => _text = val.trim(),
                            ),
                            const SizedBox(
                              height: 24.0,
                            ),
                            new FlatButton(
                              padding: EdgeInsets.all(16.0),
                              textColor: Colors.white,
                              onPressed: _openCamera,
                              child: Text(
                                "Add File",
                                textScaleFactor: 1.5,
                              ),
                              color: Theme.of(context).primaryColor,
                            )
                          ],
                        ),
                      ))
                ]))
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.all(12.0),
            color: Theme.of(context).primaryColor,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new FlatButton(
                    onPressed: _addNewNoteClickListener,
                    child: new Text(
                      "Add Note",
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  _addNewNoteClickListener() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();

      if (_isLoading) {
        showInSnackBar("Image uploading, please wait");
        return;
      }

      Note note = new Note(
          title: _title,
          text: _text,
          imageUrl: _imageLink != null ? _imageLink.toString() : null);
      _service.postItem(note);

      Navigator.pop(context);
    }
  }

  _openCamera() async {
    final filePath = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraWidget()),
    );

    File imageFile = new File(filePath);
    _isLoading = true;
    imageFile.exists().then((exist) async {
      if (exist) {
        _imageLink = await _service.postItemImage(imageFile);
        _isLoading = false;
      }
    });
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
