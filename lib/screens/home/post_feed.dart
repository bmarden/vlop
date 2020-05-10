import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/utilities/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
              return _imgTile(context, pics[index]);
            },
          );
  }

  Widget _imgTile(context, Photo curPhoto) {
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
            SizedBox(
              height: 300.0,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: curPhoto?.url,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
