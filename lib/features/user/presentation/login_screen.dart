import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/user/domain/usecases/user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 229, 0, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 75),
                const SizedBox(
                  width: 188,
                  height: 188,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('lib/features/media/logo.jpg'),
                    radius: 220,
                  ),
                ),
                const SizedBox(height: 5),
                  const Text(
                    'Bienvenido a Flip',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 25,
                    ),
                  ),

                  const SizedBox(height: 5),
                  const Text(
                    'Iniciar sesión para continuar',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18,
                    ),
                  ),
                const SizedBox(height: 25),

                Container(
                  width: 400,
                  height: 491,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'Correo electrónico',
                                style: TextStyle(
                                  color: Color(0xFF7B7B7B),
                                  fontSize: 12,
                                  fontFamily: 'B612',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: TextFormField(
                              style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15,
                              ),
                              controller: _emailController,
                              decoration: const InputDecoration(hintText: 'ejemplo@example.com'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    //password
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Contraseña',
                              style: TextStyle(
                                  color: Color(0xFF7B7B7B),
                                  fontSize: 12,
                                  fontFamily: 'B612',
                                  fontWeight: FontWeight.w400,
                                ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(hintText: '**********'),
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                      const SizedBox(height: 30),
                    Container(
                      width: 231,
                      height: 49,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          try {
                            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            // Autenticación exitosa, puedes realizar la navegación a la página de publicaciones.
                            Navigator.of(context).pushNamed('/posts');
                          } catch (e) {
                            // Error al iniciar sesión, muestra un mensaje de error.
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al iniciar sesión: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                        ),
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 100),
                  Column(
                    children: [
                      // no tiene cuenta? Registrate
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/register');
                          },
                          child: const Text('No tienes cuenta? Registrate'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],         
            ),
          ), 
        ),
      ),
    );
  }
}
