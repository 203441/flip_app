import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// user
import 'package:app_auth/features/user/presentation/login_screen.dart';
import 'package:app_auth/features/user/presentation/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/user/domain/usecases/user_usecase.dart';
import 'package:app_auth/features/user/data/repositories/auth_repository_imp.dart';
import 'package:app_auth/features/user/data/datasources/firebase_datasource.dart';
// post
import 'package:app_auth/features/post/domain/usecases/post_usecase.dart';
import 'package:app_auth/features/post/presentation/post_screen.dart';
import 'package:app_auth/features/post/data/repositories/post_repository_impl.dart';
import 'package:app_auth/features/post/data/datasources/post_datasource.dart';
import 'package:app_auth/features/post/presentation/post_home.dart';
import 'package:app_auth/features/post/presentation/my_posts.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<SignUpUseCase>(
          create: (context) => SignUpUseCase(
            UserRepositoryImpl(
              FirebaseUserDataSource(
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          ),
        ),
        Provider<SignInUseCase>(
          create: (context) => SignInUseCase(
            UserRepositoryImpl(
              FirebaseUserDataSource(
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          ),
        ),
        Provider<SignOutUseCase>(
          create: (context) => SignOutUseCase(
            UserRepositoryImpl(
              FirebaseUserDataSource(
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          ),
        ),
        Provider<GetPostsUseCase>(
          create: (context) => GetPostsUseCase(
            PostRepositoryImp(
              FirebasePostDataSource(
                firebaseStorage: FirebaseStorage.instance,
                firebaseFirestore: FirebaseFirestore.instance,
              ),
            ),
          ),
        ),
        Provider<UploadPostUseCase>(
          create: (context) => UploadPostUseCase(
            PostRepositoryImp(
              FirebasePostDataSource(
                firebaseStorage: FirebaseStorage.instance,
                firebaseFirestore: FirebaseFirestore.instance,
              ),
            ),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi aplicación',
      initialRoute: '/posts',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/posts': (context) => PostsScreen(),
        '/post_home': (context) => PostsHome(),
        '/my_posts': (context) => MyPosts(),
      },
    );
  }
}
