
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class UploadService {
  final SupabaseClient supabase = SupabaseService.client;

  final ImagePicker imagePicker = ImagePicker();

  // Select image from gallery
  Future<XFile?> pickImage() async {
    return await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
  }

  // Upload image to Supabase Storage
  Future<String> uploadImage(XFile image) async {
    final userId = SupabaseService.currentUserId;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final Uint8List imageBytes = await image.readAsBytes();

    final String filePath =
        '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('images')
        .uploadBinary(
          filePath,
          imageBytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );

    // Get public image URL
    final String imageUrl = supabase.storage
        .from('images')
        .getPublicUrl(filePath);

    // Save image URL in profiles table
    await supabase.from('profiles').upsert({
      'id': userId,
      'email': SupabaseService.currentUser?.email,
      'name': SupabaseService.currentUser?.userMetadata?['name'],
      'avatar_url': imageUrl,
    });

    return imageUrl;
  }

  // Get profile image URL
  Future<String?> getProfileImage() async {
    final userId = SupabaseService.currentUserId;

    if (userId == null) return null;

    final response = await supabase
        .from('profiles')
        .select('avatar_url')
        .eq('id', userId)
        .maybeSingle();

    return response?['avatar_url']?.toString();
  }
}
