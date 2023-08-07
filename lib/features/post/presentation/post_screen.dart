import 'package:app_auth/features/post/presentation/post_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:app_auth/features/post/domain/usecases/post_usecase.dart';
import 'package:app_auth/features/post/domain/entities/post.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'my_posts.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  // controlador para el campo de descripción
  final _descriptionController = TextEditingController();

  // variable para guardar la ruta del archivo seleccionado
  String? _selectedFilePath;
  LatLng? _selectedLocation;
  String? _latitude;
  String? _longitude;

  Future<void> _getUbication() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      _latitude = _locationData.latitude.toString();
      _longitude = _locationData.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 229, 0, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(255, 229, 0, 1),
        elevation: 0.0,
      ),
      body:
          // icono para seleccionar archivo, campo para agregar descripción y botón para subir
          Column(
        children: [
          const Text(
            "Subir archivo",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                // escoger un archivo
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: [
                    'jpg',
                    'jpeg',
                    'png',
                    'mp4',
                    'mp3',
                    'pdf'
                  ],
                );
                // if (result != null && result.files.isNotEmpty) {
                // guardar la ruta del archivo seleccionado en lugar de subirlo de inmediato
                _selectedFilePath = result?.files.single.path!;
                // }
              },
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 200,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text('Ubicación actual'),
                            onTap: () async {
                              await _getUbication();
                              setState(() {
                                _selectedLocation = LatLng(
                                  double.parse(_latitude!),
                                  double.parse(_longitude!),
                                );
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Text(
            "Descripción",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Descripción',
                border: InputBorder.none, // Elimina el borde del TextFormField
                contentPadding: EdgeInsets.all(
                    16), // Ajusta el relleno interno del TextFormField
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final createPostUseCase =
                  Provider.of<UploadPostUseCase>(context, listen: false);
              try {
                // ignore: unused_local_variable
                final post = await createPostUseCase.call(
                  _descriptionController.text,
                  _selectedFilePath!,
                  _selectedLocation!,
                );
                _selectedFilePath = null;
                _selectedLocation = null;
                _descriptionController.clear();
                Navigator.of(context).pushNamed('/post_home');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al crear post: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(),
            child: Text('Subir'),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(255, 229, 0, 1),
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home_sharp),
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
                icon: Icon(Icons.add_box),
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
