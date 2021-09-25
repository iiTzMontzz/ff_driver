import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 150, left: 150, bottom: 25, top: 25),
      child: SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/walp.jpg"),
            ),
            Positioned(
              right: -16,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
              ),
            )
          ],
        ),
      ),
    );
  }
}
