import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';
import '../services/favorites_service.dart';
import '../widgets/post_card.dart';
import 'favorites_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostService _service = PostService();
  final FavoritesService _favorites = FavoritesService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _service.getPosts();
  }

  void _reload() {
    setState(() {
      _postsFuture = _service.getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            tooltip: 'Favorites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _reload, child: const Text('Retry')),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async {
                _reload();
                await _postsFuture;
              },
              // Listens to favoritesBox so the star flips the moment it is tapped.
              child: ValueListenableBuilder<Box<Post>>(
                valueListenable:
                    Hive.box<Post>(FavoritesService.boxName).listenable(),
                builder: (context, box, _) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final Post post = snapshot.data![index];
                      return PostCard(
                        post: post,
                        isFavorite: _favorites.isFavorite(post.id),
                        onStarPressed: () => _favorites.toggleFavorite(post),
                      );
                    },
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
