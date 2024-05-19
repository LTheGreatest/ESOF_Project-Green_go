import 'package:flutter/material.dart';
import 'package:green_go/model/achievements_model.dart';
import 'package:green_go/view/pages/achievements_page.dart';
import 'package:flutter/foundation.dart';

class AchievementPopup {

  void show(BuildContext context, AchievementsModel achievement) async {
    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 40),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AchievementsPage(),
              ),
            );
            entry?.remove();
            entry = null;
          },
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Achievement unlocked: ${achievement.name}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            achievement.description,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    try {
      Overlay.of(context).insert(entry!);
      await Future.delayed(const Duration(seconds: 4));
    } catch (e) {
      if (kDebugMode) {
        print('Error showing achievement popup: $e');
      }
    } finally {
      entry?.remove();
      entry = null;
    }
  }
}