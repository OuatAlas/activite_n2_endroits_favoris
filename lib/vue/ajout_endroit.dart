import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/endroits_provider.dart';
import '../widgets/image_prise.dart';
import '../widgets/localisation_prise.dart';

class AjoutEndroit extends ConsumerStatefulWidget {
  const AjoutEndroit({super.key});

  @override
  ConsumerState<AjoutEndroit> createState() => _AjoutEndroitState();
}

class _AjoutEndroitState extends ConsumerState<AjoutEndroit> {
  final _nomController = TextEditingController();

  File? _imageSelectionnee;

  double? _latitude;
  double? _longitude;
  String? _adresse;

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  void _surPhotoSelectionnee(File image) {
    setState(() {
      _imageSelectionnee = image;
    });
  }

  void _surLocalisationSelectionnee(double lat, double lng, String adresse) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
      _adresse = adresse;
    });
  }

  void _enregistrerEndroit() {
    final nom = _nomController.text.trim();

    if (nom.isEmpty || _imageSelectionnee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un nom et prendre une photo.'),
        ),
      );
      return;
    }

    ref.read(endroitsProvider.notifier).ajouterEndroit(
          nom: nom,
          image: _imageSelectionnee!,
          latitude: _latitude,
          longitude: _longitude,
          adresse: _adresse,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajout d\'un nouvel endroit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom de l\'endroit',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            const Text(
              'Photo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ImagePrise(onPhotoSelectionnee: _surPhotoSelectionnee),
            const SizedBox(height: 16),

            const Text(
              'Localisation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            LocalisationPrise(
                onLocalisationSelectionnee: _surLocalisationSelectionnee),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _enregistrerEndroit,
              icon: const Icon(Icons.save),
              label: const Text('Enregistrer l\'endroit'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
