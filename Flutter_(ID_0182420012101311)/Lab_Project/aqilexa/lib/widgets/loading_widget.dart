import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
class LoadingWidget extends StatelessWidget { final String message; const LoadingWidget({super.key, this.message='Loading...'}); @override Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children:[const CircularProgressIndicator(color: AppColors.primary), const SizedBox(height:12), Text(message)])); }
