import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 65,
      child: Image(
        image: AssetImage('assets/logo/pet.png'),
        fit: BoxFit.scaleDown,
        height: 112,
        width: 112,
      ),
    );
  }
}
