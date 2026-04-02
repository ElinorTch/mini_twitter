import 'package:flutter/material.dart';
import 'package:mini_twitter/features/gouvAPI/widgets/bodacc_annonces_widget.dart';

class BodaccPage extends StatelessWidget {
  const BodaccPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Annonces BODACC")),
      body: const BodaccAnnoncesWidget(),
    );
  }
}
