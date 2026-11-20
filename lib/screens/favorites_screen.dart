import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';
import '../services/favorites_service.dart';
import '../widgets/post_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesService service = FavoritesService();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      // Rebuilds by itself whenever favoritesBox changes.
      body: ValueListenableBuilder<Box<Post>>(
        valueListenable: Hive.box<Post>(FavoritesService.boxName).listenable(),
        builder: (context, box, _) {
          final List<Post> favorites = service.getFavorites();

          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_border, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No favorites yet', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final Post post = favorites[index];
              return PostCard(
                post: post,
                isFavorite: true,
                onStarPressed: () => service.toggleFavorite(post),
              );
            },
          );
        },
      ),
    );
  }
}
