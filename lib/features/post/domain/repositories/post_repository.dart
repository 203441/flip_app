import '../entities/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class PostRepository {
  Stream<List<Post>> getPosts();
  Future<Post> uploadPost(String description, String? filePath,
      [LatLng? location]);
}
