import 'dart:io';
import 'package:uuid/uuid.dart';

class Photo {
  final String id = Uuid().v1();
  final File photo;

  Photo(this.photo);
}
