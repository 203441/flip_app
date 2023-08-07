import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostModel {
  final String id;
  final String description;
  String? fileUrl;
  LatLng? location;
  final String userId;
  final String userName;
  final DateTime createdAt;
  final String fileName;

  PostModel({
    required this.id,
    required this.description,
    this.fileUrl,
    this.location,
    required this.userId,
    required this.userName,
    required this.createdAt,
    required this.fileName,
  });

  Post toDomain() {
    return Post(
      id: id,
      description: description,
      fileUrl: fileUrl,
      location: location,
      userId: userId,
      userName: userName,
      createdAt: createdAt,
      fileName: fileName,
    );
  }

  factory PostModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return PostModel(
      id: snapshot.id,
      description: data['description'] as String,
      fileUrl: data['fileUrl'] as String?,
      location: data['location'] != null
          ? LatLng(
              data['location']['latitude'] as double,
              data['location']['longitude'] as double,
            )
          : null,
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      fileName: data['fileName'] as String,
    );
  }
}
