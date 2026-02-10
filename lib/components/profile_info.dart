import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_twitter/components/follow_card.dart';
import 'package:mini_twitter/models/user.dart';
import 'package:mini_twitter/services/user_service.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final UserService userService = UserService();

  ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        Center(
          child: GestureDetector(
            onTap: () async {
              final profileUrl = await userService.uploadUserProfilePhoto(user);
              final url = "$profileUrl?v=${DateTime.now().millisecondsSinceEpoch}";
              if (profileUrl != null) {
                userService.updateProfilePhoto(user.uid, url);
              }
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: user.photoUrl != null
                  ? NetworkImage(user.photoUrl!)
                  : const AssetImage('assets/images/user.png')
                      as ImageProvider,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          '@${user.pseudo}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        
        Text(
          user.bio ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
            const SizedBox(width: 5),
            Text(
              'Joined ${DateFormat('MMMM yyyy').format(user.joinedAt)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: FollowCard(
                title: '128',
                subtitle: 'POSTS',
                textColor: const Color(0xFF137FEC),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: FollowCard(
                title: user.following.length.toString(),
                subtitle: 'FOLLOWING',
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: FollowCard(
                title: user.followers.length.toString(),
                subtitle: 'FOLLOWERS',
              ),
            ),
          ],
        ),
      ],
    );
  }
}