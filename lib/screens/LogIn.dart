import 'package:flutter/material.dart';
import 'package:ochat/Widgets/buttom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class LogIn extends StatefulWidget {
  final void Function()? onTap;
  const LogIn({super.key, required this.onTap});
  @override
  State<LogIn> createState() => _LogInState();
}
class _LogInState extends State<LogIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  bool loading = false;
  bool isError = false;

  //sign in user 
void signIn() async {
  final authService = Provider.of<AuthService>(context,listen: false);
  try {
    await authService.signInWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Définir la couleur de fond du Scaffold en noir
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    height: 180,
                    child: Image.asset('images/OChat.png'), // Insérer une image depuis les ressources
                  ),
                  SizedBox(height: 70),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                        isError = false; // Réinitialise l'erreur lors de la saisie de l'e-mail
                      });
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Your Email', // Texte d'aide pour le champ de saisie de l'e-mail
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 211, 56, 0), // Couleur de la bordure
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 211, 56, 0), // Couleur de la bordure lorsque le champ est désactivé
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 211, 56, 0), // Couleur de la bordure lorsque le champ est en focus
                          width: 4,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white, // Couleur du texte d'aide
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Your Password', // Texte d'aide pour le champ de saisie du mot de passe
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 211, 56, 0), // Couleur de la bordure
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 211, 56, 0), // Couleur de la bordure lorsque le champ est désactivé
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 211, 56, 0), // Couleur de la bordure lorsque le champ est en focus
                          width: 4,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white, // Couleur du texte d'aide
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (isError)
                    Text(
                      'Email not found!', // Afficher un message d'erreur si l'e-mail n'est pas trouvé
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  SCButtom(
                    color: Color.fromARGB(255, 211, 56, 0), // Couleur du bouton en orange
                    title: 'Log in', // Titre du bouton "Log in"
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        if (user != null) {
                          Navigator.pushNamed(context, 'Home'); // Naviguer vers l'écran de Home lorsque la connexion est réussie
                          setState(() {
                            loading = false;
                          });
                        }
                      } 
                      catch (e) {
                        print(e);
                        setState(() {
                          isError = true; // Définit isError à true si une erreur se produit lors de la connexion
                          loading = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        )
        );
    //   ),
    // );
  }
}