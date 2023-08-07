import 'package:google_maps_flutter/google_maps_flutter.dart';

class Post {
  final String id;
  final String description;
  String? fileUrl;
  LatLng? location;
  final String userId;
  final String userName;
  final DateTime createdAt;
  final String fileName;

  Post({
    required this.id,
    required this.description,
    this.fileUrl,
    this.location,
    required this.userId,
    required this.userName,
    required this.createdAt,
    required this.fileName,
  });
}
