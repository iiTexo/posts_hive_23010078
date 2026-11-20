import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/post_model.dart';
import 'services/favorites_service.dart';
import 'screens/posts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Order matters: initialise, register adapters, open boxes, then run.
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());

  await Hive.openBox<Post>('postsBox');
  await Hive.openBox<Post>(FavoritesService.boxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Posts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const PostsScreen(),
    );
  }
}
