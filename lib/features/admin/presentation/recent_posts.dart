import 'package:flutter/material.dart';

import 'package:notepro/core/constants.dart';
import "package:notepro/core/widgets/sidebar_container.dart";

class RecentPosts extends StatelessWidget {
  const RecentPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return SidebarContainer(
      title: "Recent Post",
      child: Column(
        children: [
          RecentPostCard(
            image: "assets/images/recent_1.png",
            title: "Our “Secret” Formula to Online Workshops",
            press: () {},
          ),
          const SizedBox(height: kDefaultPadding),
          RecentPostCard(
            image: "assets/images/recent_2.png",
            title: "Digital Product Innovations from Warsaw with Love",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class RecentPostCard extends StatelessWidget {
  final String image, title;
  final VoidCallback press;

  const RecentPostCard({
    super.key,
    required this.image,
    required this.title,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: press,
        child: Row(
          children: [
            Expanded(flex: 2, child: Image.asset(image)),
            const SizedBox(width: kDefaultPadding),
            Expanded(
              flex: 5,
              child: Text(
                title,
                maxLines: 2,
                style: const TextStyle(
                  fontFamily: "Raleway",
                  color: kDarkBlackColor,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
