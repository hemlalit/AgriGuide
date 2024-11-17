import 'package:AgriGuide/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
          onPressed: () async {
            await auth.loginWithGoogle();
          },
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
          onPressed: () async {
            await auth.loginWithFacebook();
          },
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
          onPressed: () async {
            await auth.loginWithInstagram(context);
          },
        ),
      ],
    );
  }
}
