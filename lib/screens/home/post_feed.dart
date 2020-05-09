import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/utilities/loading.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var pics = Provider.of<List<Photo>>(context);
    return pics == null
        ? Loading()
        : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: pics.length,
            itemBuilder: (context, index) {
              return _imgTile(pics[index]);
            },
          );
  }

  Widget _imgTile(Photo curPhoto) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        title: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('posted by: ${curPhoto.userOwner}'),
            ),
            Image.network(curPhoto?.url,
                loadingBuilder: (context, child, progress) {
              return progress == null ? child : LinearProgressIndicator();
            }),
          ],
        ),
      ),
    );
  }
}
