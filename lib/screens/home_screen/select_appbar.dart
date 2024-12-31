import 'package:AgriGuide/localization/locales.dart';
import 'package:AgriGuide/screens/marketplace/farmer/cart_screen.dart';
import 'package:AgriGuide/screens/notification_Screen/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

AppBar selectAppBar(BuildContext context, int selectedIndex,
    int notificationCount, bool newNotification) {
  // print(newNotification);
  return AppBar(
    title: Center(
      child: Text(
        selectedIndex == 0
            ? LocaleData.home.getString(context)
            : selectedIndex == 1
                ? LocaleData.cropCare.getString(context)
                : selectedIndex == 2
                    ? LocaleData.marketplace.getString(context)
                    : selectedIndex == 3
                        ? LocaleData.weather.getString(context)
                        : LocaleData.feed.getString(context),
        style: const TextStyle(
          color: Color.fromARGB(255, 84, 135, 85),
          fontWeight: FontWeight.w500,
          fontSize: 30,
        ),
      ),
    ),
    elevation: 3,
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    ),
    actions: [
      selectedIndex == 0
          ? Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(
                          newNotification: newNotification,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 11,
                  top: 11,
                  child: notificationCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$notificationCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(),
                ),
              ],
            )
          : selectedIndex == 2
              ? IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                )
              : const SizedBox(
                  width: 12,
                )
    ],
  );
}
