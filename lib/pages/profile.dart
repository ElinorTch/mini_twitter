import 'package:flutter/material.dart';
import 'package:mini_twitter/components/profile_info.dart';
import 'package:mini_twitter/models/post.dart';
import 'package:mini_twitter/models/user.dart';
import 'package:mini_twitter/pages/liked_post.dart';
import 'package:mini_twitter/pages/my_post.dart';
import 'package:mini_twitter/providers/current_user_provider.dart';
import 'package:mini_twitter/data/services/post_service.dart';
import 'package:mini_twitter/data/services/user_service.dart';
import 'package:mini_twitter/core/utils/tab_bar_delegate.dart';
import 'package:provider/provider.dart';
import 'package:mini_twitter/authentication/logout.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<PostModel> posts = [];
  List<PostModel> likedPosts = [];
  UserModel? userInfo;
  bool _isLoading = true;

  final PostService _postService = PostService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initialFetch());
  }

  Future<void> _initialFetch() async {
    final provider = context.read<CurrentUserProvider>();
    final uid = widget.userId ?? provider.currentUser?.uid;
    print("Le user id recupere: ${widget.userId}");
    print("Le user id provider: ${provider.currentUser?.uid}");
    print("Le uid est: $uid");

    if (uid == null) return;

    await Future.wait([
      _fetchPosts(uid),
      _fetchLikedPosts(uid),
      _fetchUserInfo(uid),
    ]);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPosts(String uid) async {
    final userPosts = await _postService.getMyPosts(uid);
    if (mounted) {
      setState(() => posts = userPosts);
    }
  }

  Future<void> _fetchLikedPosts(String uid) async {
    final likedPostsFetched = await _postService.getLikedPosts(uid);
    if (mounted) {
      setState(() => likedPosts = likedPostsFetched);
    }
  }

  Future<void> _fetchUserInfo(String uid) async {
    if (widget.userId != uid) {
      final provider = context.read<CurrentUserProvider>();
      setState(() => userInfo = provider.currentUser);
    } else {
      final user = await _userService.getUserById(uid);
      if (mounted) {
        setState(() => userInfo = user);
        print("Je suis dans le mounted user");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CurrentUserProvider>();

    if (userInfo == null) {
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
          actions: [LogoutButton()],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: ProfileHeader(user: userInfo!)),
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
                LikedPostPage(likedPosts: likedPosts, userInfo: userInfo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
