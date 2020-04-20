import 'dart:io';
import 'package:uuid/uuid.dart';

class Photo {
  final String id = Uuid().v1();
  File imageFile;
  Photo(this.imageFile);
}
