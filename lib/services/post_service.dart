// ignore_for_file: avoid_print
// The prints are the proof of which source the data came from (lab Step 6).

import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class PostService {
  // Real API by default. Overridable with --dart-define=API_URL=... for local testing.
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com/posts',
  );

  Future<List<Post>> getPosts() async {
    var box = await Hive.openBox<Post>('postsBox');

    try {
      // 1. Try to fetch online
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Post> onlinePosts = data.map((e) => Post.fromJson(e)).toList();

        // 2. Save to Hive
        await box.clear();
        await box.addAll(onlinePosts);

        print('Loaded from API and cached to Hive: ${onlinePosts.length}');
        return onlinePosts;
      }
    } catch (e) {
      print('API Failed, reason: $e');
    }

    // 3. OFFLINE MODE: return from Hive (works in airplane mode)
    if (box.isNotEmpty) {
      print('Loaded from Hive offline: ${box.length}');
      return box.values.toList();
    } else {
      throw Exception('No Internet and No Cached Data');
    }
  }
}
