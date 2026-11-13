import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; final List<Widget> actions;
  const CustomAppBar({super.key, required this.title, this.actions = const []});
  @override Widget build(BuildContext context) => AppBar(title: Text(title), actions: actions, backgroundColor: AppColors.background);
  @override Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
