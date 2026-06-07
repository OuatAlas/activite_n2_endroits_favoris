import 'package:flutter/material.dart';
import '../modele/endroit.dart';
import '../vue/endroit_detail.dart';

class EndroitsList extends StatelessWidget {
  final List<Endroit> endroits;

  const EndroitsList({super.key, required this.endroits});

  @override
  Widget build(BuildContext context) {
    if (endroits.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 60,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun endroit favori pour le moment.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Appuyez sur + pour en ajouter un.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: endroits.length,
      itemBuilder: (ctx, index) {
        final endroit = endroits[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(endroit.image),
          ),
          title: Text(
            endroit.nom,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: endroit.adresse != null
              ? Text(
                  endroit.adresse!,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => EndroitDetail(endroit: endroit),
              ),
            );
          },
        );
      },
    );
  }
}
