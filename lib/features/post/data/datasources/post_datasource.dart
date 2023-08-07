import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class PostDataSource {
  Stream<List<PostModel>> getPosts();
  Future<PostModel> uploadPost(String description, String? filePath,
      [LatLng? location]);
}

class FirebasePostDataSource implements PostDataSource {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;
  // id del usuario actual
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  // nombre del usuario actual
  final String userName = FirebaseAuth.instance.currentUser!.displayName!;

  FirebasePostDataSource({
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  @override
  Stream<List<PostModel>> getPosts() {
    return firebaseFirestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) =>
                  PostModel.fromSnapshot(documentSnapshot))
              .toList(),
        );
  }

  @override
  Future<PostModel> uploadPost(String description, String? filePath,
      [LatLng? location]) async {
    final file = File(filePath!);
    final fileName = file.uri.pathSegments.last;
    final fileReference = firebaseStorage.ref().child('posts/$fileName');

    await fileReference.putFile(file);

    final fileUrl = await fileReference.getDownloadURL();

    final documentReference = await firebaseFirestore.collection('posts').add({
      'description': description,
      'fileUrl': fileUrl,
      'location': location != null
          ? {'latitude': location.latitude, 'longitude': location.longitude}
          : null,
      'userId': userId,
      'userName': userName,
      'createdAt': DateTime.now(),
      'fileName': path.basename(filePath),
    });

    return PostModel(
      id: documentReference.id,
      description: description,
      fileUrl: fileUrl,
      location: location,
      userId: userId,
      userName: userName,
      createdAt: DateTime.now(),
      fileName: path.basename(filePath),
    );
  }
}
