// ═══════════════════════════════════════════════════════════════════
// 3. lib/widgets/image_prise.dart
// ═══════════════════════════════════════════════════════════════════
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePrise extends StatefulWidget {
  const ImagePrise({super.key, required this.onPhotoSelectionnee});

  // Callback : transmet la photo au widget parent
  final void Function(File image) onPhotoSelectionnee;

  @override
  State<ImagePrise> createState() => _ImagePriseState();
}

class _ImagePriseState extends State<ImagePrise> {
  // Photo capturée — nulle au départ
  File? _photoSelectionnee;

  // Ouvre la caméra et capture une photo
  Future<void> _prendrePhoto() async {
    final imagePicker = ImagePicker();
    final photoPrise = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    // Annulé par l'utilisateur
    if (photoPrise == null) return;

    setState(() {
      _photoSelectionnee = File(photoPrise.path);
    });

    // Transmettre la photo au widget parent
    widget.onPhotoSelectionnee(_photoSelectionnee!);
  }

  @override
  Widget build(BuildContext context) {
    // Aucune photo : afficher le bouton
    if (_photoSelectionnee == null) {
      return TextButton.icon(
        onPressed: _prendrePhoto,
        icon: const Icon(Icons.camera_alt),
        label: const Text('Prendre une photo'),
      );
    }

    // Photo disponible : afficher l'aperçu cliquable
    return GestureDetector(
      onTap: _prendrePhoto,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          _photoSelectionnee!,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}