import 'dart:io';
import 'package:uuid/uuid.dart';

class Photo {
  final String id = Uuid().v1();
  final String userOwner;
  final List<String> tags;
  File imageFile;
  Photo({this.imageFile, this.userOwner, this.tags});
}
