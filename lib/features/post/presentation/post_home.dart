import 'package:app_auth/features/post/presentation/my_posts.dart';
import 'package:app_auth/features/post/presentation/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:app_auth/features/post/domain/usecases/post_usecase.dart';
import 'package:app_auth/features/post/domain/entities/post.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import './pdf_viewer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PostsHome extends StatelessWidget {
  final DateFormat formatter = DateFormat('dd MMMM, yyyy, HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Post>>(
        stream: Provider.of<GetPostsUseCase>(context).call(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.userName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.description),
                    if (post.location != null)
                      Container(
                        // width: 100,
                        height: 130,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(post.location!.latitude,
                                post.location!.longitude),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                                markerId: MarkerId('marker'),
                                position: LatLng(post.location!.latitude,
                                    post.location!.longitude)),
                          },
                        ),
                      )
                    // Text(
                    //     'Latitud: ${post.location!.latitude}, Longitud: ${post.location!.longitude}')
                    else if (post.fileName.endsWith('.jpg') ||
                        post.fileName.endsWith('.jpeg') ||
                        post.fileName.endsWith('.png') ||
                        post.fileName.endsWith('.gif'))
                      Image.network(post.fileUrl!)
                    else if (post.fileName.endsWith('.mp4'))
                      VideoPlayerWidget(post.fileUrl!)
                    else if (post.fileName.endsWith('.mp3'))
                      AudioPlayerWidget(post.fileUrl!)
                    else if (post.fileName.endsWith('.pdf'))
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfMessage(
                                pdfUrl: post.fileUrl!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          // width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'PDF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Text(formatter.format(post.createdAt)),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(255, 229, 0, 1),
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PostsHome()), // Reemplaza 'NewView' con el nombre de tu vista de destino
                  );
                },
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PostsScreen()), // Reemplaza 'NewView' con el nombre de tu vista de destino
                  );
                },
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyPosts()), // Reemplaza 'NewView' con el nombre de tu vista de destino
                  );
                },
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// VideoPlayerWidget and AudioPlayerWidget classes remain the same

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget(this.url);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      child: ClipRRect(
        child: Container(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

// Audio
class AudioPlayerWidget extends StatefulWidget {
  final String url;

  AudioPlayerWidget(this.url);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_isPlaying) {
          await _audioPlayer.pause();
          setState(() {
            _isPlaying = false;
          });
        } else {
          await _audioPlayer.play(UrlSource(
            widget.url,
          ));
          setState(() {
            _isPlaying = true;
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        // width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            SizedBox(width: 8.0),
            Text(
              'Play',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }
}
