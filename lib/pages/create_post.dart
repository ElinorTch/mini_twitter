import 'package:flutter/material.dart';
import 'package:mini_twitter/providers/current_user_provider.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CurrentUserProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. La barre du haut (AppBar)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Fermer la page
          },
        ),
        title: const Text(
          "New Post",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Couleur du bouton Publish
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                // TODO: Ajouter la logique pour envoyer le tweet sur Firebase
                print("Contenu du post: ${_textController.text}");
              },
              child: const Text(
                "Publish",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: provider.currentUser?.photoUrl != null
                      ? NetworkImage(provider.currentUser!.photoUrl!)
                      : AssetImage('assets/images/user.png') as ImageProvider,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.currentUser!.pseudo,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Public",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            // B. Zone de texte (What's on your mind?)
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null, // Permet plusieurs lignes
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border:
                      InputBorder.none, // Pas de bordure comme sur le design
                ),
              ),
            ),

            // C. Barre d'icônes en bas + Compteur
            const Divider(), // Ligne de séparation fine
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.blue),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.alternate_email, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.tag, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.sentiment_satisfied_alt,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
                const Spacer(), // Pousse le texte à droite
                const Text("0/280", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
