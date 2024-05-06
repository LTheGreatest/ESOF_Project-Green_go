import 'package:flutter/material.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/leaderboard_page.dart';
import 'package:green_go/view/pages/main_page.dart';
import 'package:green_go/view/pages/profile_page.dart';
import 'package:green_go/view/pages/search_page.dart';
import 'package:green_go/view/pages/trip_page.dart';

enum MenuPage { leaderboard, bus, mainPage, missions, profile, other }

class CustomMenuBar extends StatelessWidget {
  final MenuPage currentPage;
  const CustomMenuBar({super.key, required this.currentPage});

  Widget buildMenuButton(MenuPage page, String iconAsset, BuildContext context) {
    //builds the buttons in the menu
    return SizedBox(
      height: 50,
      width: 50,
      child: IconButton(
        onPressed: currentPage == page
            ? null // Disable the button if it corresponds to the current page
            : () {
          navigateToPage(context, page);
        },
        icon: Image.asset(iconAsset),
      ),
    );
  }

  void navigateToPage(BuildContext context, MenuPage page) {
    //Changes the current page to the one the user chose
    late Widget destinationPage;
    switch (page) {
      case MenuPage.leaderboard:
        destinationPage = const LeaderboardPage();
        break;
      case MenuPage.bus:
        destinationPage = const TripPage();
        break;
      case MenuPage.mainPage:
        destinationPage = const MainPage();
        break;
      case MenuPage.missions:
        destinationPage = const SearchPage();
        break;
      case MenuPage.profile:
        destinationPage = const ProfilePage();
        break;
      case MenuPage.other:
        break;
    }
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.all(Radius.elliptical(20, 15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildMenuButton(MenuPage.leaderboard, "assets/Leaderboard.png", context),
            buildMenuButton(MenuPage.bus, "assets/Bus.png", context),
            buildMenuButton(MenuPage.mainPage, "assets/Home.png", context),
            buildMenuButton(MenuPage.missions, "assets/Search.png", context),
            buildMenuButton(MenuPage.profile, "assets/Profile.png", context),
          ],
        ),
      ),
    );
  }
}
