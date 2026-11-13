import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
class CustomCard extends StatelessWidget { final Widget child; final EdgeInsetsGeometry padding; const CustomCard({super.key,required this.child,this.padding=const EdgeInsets.all(16)}); @override Widget build(BuildContext context)=>Card(color:AppColors.surface,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16)),child:Padding(padding:padding,child:child)); }
