import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:primeiro_app/screens/register_screen.dart';
import 'package:primeiro_app/screens/reset_password_modal.dart';
import 'package:primeiro_app/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const FlutterLogo(size: 76),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'E-mail'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    controller: _senhaController,
                    decoration: const InputDecoration(hintText: 'Senha'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      authService
                          .entrarUsuario(
                        email: _emailController.text,
                        senha: _senhaController.text,
                      )
                          .then((String? erro) {
                        if (erro != null) {
                          final snackBar = SnackBar(
                            content: Text(erro),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    child: const Text('Entrar'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      singinWithGoogle();
                    },
                    child: const Text('Entrar com o Google'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ));
                    },
                    child: const Text('Ainda não tem conta? Crie uma!'),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PasswordResetModal();
                        },
                      );
                    },
                    child: Text('Esqueceu sua senha?'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<UserCredential> singinWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
