import 'package:flutter/material.dart';
import '../models/post_model.dart';

/// One card, used by the Posts screen and the Favorites screen, so both
/// lists always look the same.
class PostCard extends StatelessWidget {
  final Post post;
  final bool isFavorite;
  final VoidCallback onStarPressed;

  const PostCard({
    super.key,
    required this.post,
    required this.isFavorite,
    required this.onStarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(child: Text(post.id.toString())),
        title: Text(
          post.title,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(post.body, maxLines: 2),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.amber : null,
          ),
          onPressed: onStarPressed,
        ),
      ),
    );
  }
}
