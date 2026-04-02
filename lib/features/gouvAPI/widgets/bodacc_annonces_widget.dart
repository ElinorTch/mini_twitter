import 'package:flutter/material.dart';
import 'package:mini_twitter/data/services/bodacc_service.dart';

class BodaccAnnoncesWidget extends StatefulWidget {
  const BodaccAnnoncesWidget({super.key});

  @override
  State<BodaccAnnoncesWidget> createState() => _BodaccAnnoncesWidgetState();
}

class _BodaccAnnoncesWidgetState extends State<BodaccAnnoncesWidget> {
  final BodaccService _service = BodaccService();

  bool isLoading = true;
  String? error;
  List<dynamic> annonces = [];

  @override
  void initState() {
    super.initState();
    _loadAnnonces();
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Future<void> _loadAnnonces() async {
    try {
      final data = await _service.fetchAnnonces(rows: 30);
      setState(() {
        annonces = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text("Erreur : $error"));
    }

    if (annonces.isEmpty) {
      return const Center(child: Text("Aucune annonce trouvée"));
    }

    return ListView.builder(
      itemCount: annonces.length,
      itemBuilder: (context, index) {
        final item = annonces[index];
        final fields = item["fields"] ?? {};

        final titre = fields["typeavis"];
        final entreprise = fields["commercant"] ?? "Entreprise inconnue";
        final ville = fields["ville"] ?? "Ville inconnue";

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            title: Text(
              capitalize(titre),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("$entreprise – $ville"),
          ),
        );
      },
    );
  }
}
