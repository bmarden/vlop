import 'package:flutter/material.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/screens/create_post/upload_post.dart';
import 'package:vlop/utilities/constants.dart';
import 'package:vlop/utilities/widgets.dart';

class PostOptions extends StatefulWidget {
  final Photo photo;
  final String userId;
  PostOptions({this.photo, this.userId});

  @override
  _PostOptionsState createState() => _PostOptionsState();
}

class _PostOptionsState extends State<PostOptions> {
  final tagController = TextEditingController();
  final capController = TextEditingController();

  @override
  void initState() {
    super.initState();
    capController.text = widget.photo.caption;
    capController.addListener(() {
      widget.photo.caption = capController.text;
    });
  }

  @override
  void dispose() {
    tagController.dispose();
    capController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  child: Image.file(
                    widget.photo.imageFile,
                    height: 120,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: TextFormField(
                      controller: capController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      maxLength: 250,
                      decoration: kPostInputDecoration('Enter a caption...'),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20),
                  width: 350,
                  child: TextFormField(
                    controller: tagController,
                    decoration: kPostInputDecoration('Add tags...'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Button(
                  onPressed: () {
                    setState(() {
                      widget.photo.tags.add(tagController.text);
                      tagController.clear();
                    });
                  },
                  child: Text('Add tag'),
                ),
              ],
            ),
            Container(
              height: 150.0,
              child: Wrap(
                children: <Widget>[
                  for (var i = 0; i < widget.photo.tags.length; i++) ...[
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: InputChip(
                        onDeleted: () {
                          setState(() {
                            widget.photo.tags.removeAt(i);
                          });
                        },
                        label: Text(widget.photo.tags[i]),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Button(
              child: Text('Next'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // widget.photo.caption = capController.text;
                    return Upload(photo: widget.photo, userId: widget.userId);
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
