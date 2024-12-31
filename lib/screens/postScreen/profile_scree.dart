import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String username;
  final String bio;
  final String profileImage;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.username,
    required this.bio,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    const EdgeInsets globalPadding =
        EdgeInsets.all(16.0); // Assuming you have defined this somewhere

    return Scaffold(
      appBar: AppBar(
        title: Text('@$username'),
      ),
      body: Padding(
        padding: globalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImage),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              bio,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
