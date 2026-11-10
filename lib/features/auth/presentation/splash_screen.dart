import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'sign_in_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colors.bg,
        body: const Center(child: ThabatLogo(size: 84)),
      );
}
