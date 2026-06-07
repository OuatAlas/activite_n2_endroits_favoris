import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocalisationPrise extends StatefulWidget {
  final void Function(double lat, double lng, String adresse)
      onLocalisationSelectionnee;

  const LocalisationPrise({super.key, required this.onLocalisationSelectionnee});

  @override
  State<LocalisationPrise> createState() => _LocalisationPriseState();
}

class _LocalisationPriseState extends State<LocalisationPrise> {
  double? _latitude;

  double? _longitude;

  String? _adresse;

  bool _chargement = false;

  Future<void> _obtenirLocalisation() async {
    setState(() => _chargement = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _chargement = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _chargement = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String adresse = 'Adresse inconnue';
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        adresse =
            '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';
      }

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _adresse = adresse;
        _chargement = false;
      });

      widget.onLocalisationSelectionnee(_latitude!, _longitude!, _adresse!);
    } catch (e) {
      setState(() => _chargement = false);
      debugPrint('Erreur de localisation : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_chargement) {
      return const SizedBox(
        height: 170,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_latitude != null && _longitude != null) {
      final position = LatLng(_latitude!, _longitude!);
      return Column(
        children: [
          SizedBox(
            height: 170,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: 14, 
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('position_actuelle'),
                  position: position,
                ),
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _adresse ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    }

    return TextButton.icon(
      onPressed: _obtenirLocalisation,
      icon: const Icon(Icons.location_on),
      label: const Text('Obtenir ma localisation'),
    );
  }
}
