import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:mini_twitter/features/auth/auth_gate.dart';
import 'package:mini_twitter/features/posts/feed_page.dart';
import 'package:mini_twitter/features/profile/profile_page.dart';
import 'package:mini_twitter/features/posts/create_post_page.dart';
import 'package:mini_twitter/domain/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'core/utils/firebase_options.dart';
import 'package:mini_twitter/features/shared/widgets/navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.josefinSansTextTheme(),
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
        ),
      ),
      home: AuthGate(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController usernameController = TextEditingController();

  final List<Widget> _pages = [FeedPage(), CreatePostPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages.elementAt(_selectedIndex)),

      bottomNavigationBar: AppNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
