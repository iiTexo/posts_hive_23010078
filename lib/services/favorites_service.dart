import 'package:hive/hive.dart';
import '../models/post_model.dart';

/// All favourites logic lives here. The screens never touch Hive directly.
///
/// favoritesBox is a separate box because getPosts() calls postsBox.clear()
/// on every refresh, which would otherwise wipe the user's favourites.
class FavoritesService {
  static const String boxName = 'favoritesBox';

  // The box is already opened in main.dart, so reading it is synchronous.
  Box<Post> get _box => Hive.box<Post>(boxName);

  /// The post id is used as the key, so lookups are O(1).
  bool isFavorite(int id) => _box.containsKey(id);

  /// Adds the post if it is not saved, removes it if it is.
  Future<void> toggleFavorite(Post post) async {
    if (isFavorite(post.id)) {
      await _box.delete(post.id);
    } else {
      await _box.put(post.id, post.copy());
    }
  }

  List<Post> getFavorites() => _box.values.toList();
}
