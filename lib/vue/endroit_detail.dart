import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../modele/endroit.dart';

class EndroitDetail extends StatelessWidget {
  final Endroit endroit;

  const EndroitDetail({super.key, required this.endroit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(endroit.nom),
      ),
      body: Column(
        children: [
          Image.file(
            endroit.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
          ),
          const SizedBox(height: 16),

          // Nom de l'endroit
          Text(
            endroit.nom,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          if (endroit.adresse != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                endroit.adresse!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 16),

          if (endroit.aLocalisation)
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(endroit.latitude!, endroit.longitude!),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(endroit.id),
                    position: LatLng(endroit.latitude!, endroit.longitude!),
                    infoWindow: InfoWindow(title: endroit.nom),
                  ),
                },
              ),
            ),
        ],
      ),
    );
  }
}
