import 'package:catkeys/main/annoucements.dart';
import 'package:catkeys/main/home.dart';
import 'package:catkeys/main/settings.dart';
import 'package:catkeys/pre/setup.dart';
import 'package:flutter/material.dart';

void navHome(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomePage(title: "Catkeys",),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration:
          const Duration(milliseconds: 200), // Change the animation time here
    ),
  );
}

void navSetup(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SetupPage(title: "Setup",),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration:
          const Duration(milliseconds: 200), // Change the animation time here
    ),
  );
}

void navSettings(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SettingsPage(title: "Settings",),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration:
          const Duration(milliseconds: 200), // Change the animation time here
    ),
  );
}

void navAnnoucements(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AnnouncementsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration:
          const Duration(milliseconds: 200), // Change the animation time here
    ),
  );
}