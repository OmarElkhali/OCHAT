import 'package:flutter/material.dart';
import 'package:ochat/screens/LogIn.dart';
import 'package:ochat/screens/SignIn.dart';
import '../Widgets/buttom.dart';
import'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class welcomS extends StatefulWidget {
  const welcomS({super.key});

  @override
  State<welcomS> createState() => _welcomSState();
}

class _welcomSState extends State<welcomS> {
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
                  height: 400,
                  child: Image.asset('images/OChat.png'), // Insérer une image depuis les ressources
                ),
                Text(
                  'OChat', // Afficher le texte "OChat"
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 247, 244, 243), // Définir la couleur du texte en blanc
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            SCButtom(
              color:Color.fromARGB(255, 211, 56, 0), // Définir la couleur du bouton en orange
              title: 'Sign in', // Définir le titre du bouton
              onPressed: (){
                Navigator.pushNamed(context, 'SingIn'); // Naviguer vers l'écran de connexion lors du clic sur le bouton
              } ,
            ),
            SCButtom(
              color:Color.fromARGB(255, 211, 56, 0), // Définir la couleur du bouton en orange
              title: 'Log in', // Définir le titre du bouton
              onPressed: (){
                Navigator.pushNamed(context, 'LogIn'); // Naviguer vers l'écran de connexion lors du clic sur le bouton
              } ,
            ),
            // SizedBox(height: 60), // Ajouter un espace vertical de 60 pixels
            // ElevatedButton(
            //   onPressed: () {
            //     // Action à effectuer lorsque le bouton est pressé
            //   },
            //   child: Text(
            //     'LogIn', // Afficher le texte "Commencer" sur le bouton
            //     style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black,
            //     ),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.symmetric(vertical: 16), // Définir la marge intérieure verticale du bouton
            //     primary: Color.fromARGB(255, 211, 56, 0), // Définir la couleur de fond du bouton en Orange
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

