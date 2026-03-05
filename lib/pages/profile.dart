import 'package:flutter/material.dart';
import 'package:mini_twitter/components/profile_info.dart';
import 'package:mini_twitter/models/post.dart';
import 'package:mini_twitter/models/user.dart';
import 'package:mini_twitter/pages/my_post.dart';
import 'package:mini_twitter/providers/current_user_provider.dart';
import 'package:mini_twitter/services/post_service.dart';
import 'package:mini_twitter/services/user_service.dart';
import 'package:mini_twitter/utils/tab_bar_delegate.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<PostModel> posts = [];
  UserModel? userInfo;
  bool _isLoading = true;

  // Initialisez vos services ici
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    // On utilise microtask pour s'assurer que le context est prêt
    Future.microtask(() => _initialFetch());
  }

  Future<void> _initialFetch() async {
    final provider = context.read<CurrentUserProvider>();

    // 1. Déterminer l'ID de l'utilisateur (soit le profil visité, soit moi-même)
    final uid = widget.userId ?? provider.currentUser?.uid;

    if (uid == null) return;

    // 2. Lancer les deux appels en parallèle pour gagner du temps
    await Future.wait([_fetchPosts(uid), _fetchUserInfo(uid)]);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPosts(String uid) async {
    print("Fetching posts for user ID: $uid");
    final userPosts = await _postService.getMyPosts(uid);
    print("Uid: $uid, posts récupérés: ${userPosts.length}");
    if (mounted) {
      setState(() => posts = userPosts);
      print("les posts ont été récupérés : ${posts.length}");
    }
  }

  Future<void> _fetchUserInfo(String uid) async {
    // Si c'est mon propre profil, on a déjà les infos dans le provider
    if (widget.userId == null) {
      final provider = context.read<CurrentUserProvider>();
      setState(() => userInfo = provider.currentUser);
    } else {
      final user = await _userService.getUserById(uid);
      if (mounted) {
        setState(() => userInfo = user);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CurrentUserProvider>();

    if (provider.currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(color: Colors.grey, height: 0.5),
          ),

          title: Text('Profile'),
          actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: ProfileHeader(
                  user: provider.currentUser!,
                ), 
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: TabBarDelegate(
                  TabBar(
                    labelColor: Color(0xFF137FEC),
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: "Posts"),
                      Tab(text: "Media"),
                      Tab(text: "Liked"),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TabBarView(
              children: [
                MyPostPage(posts: posts, userInfo: userInfo),
                Center(child: Text("Photos / vidéos")),
                Center(child: Text("Posts likés")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
