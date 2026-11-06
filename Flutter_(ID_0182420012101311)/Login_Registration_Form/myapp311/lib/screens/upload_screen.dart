import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/loading_widget.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _isUploading = false;
  String? _imageUrl;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() {
        _selectedImage = File(image.path);
      });
    } catch (error) {
      _showMessage('Image selection failed: $error');
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      _showMessage('Please select an image first');
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      _showMessage('Please login first');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final fileName =
          '${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final storage = Supabase.instance.client.storage.from('images');

      await storage.upload(
        fileName,
        _selectedImage!,
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

      final publicUrl = storage.getPublicUrl(fileName);

      await Supabase.instance.client.from('profiles').upsert({
        'id': user.id,
        'avatar_url': publicUrl,
      });

      if (!mounted) return;

      setState(() {
        _imageUrl = publicUrl;
        _selectedImage = null;
        _isUploading = false;
      });

      _showMessage('Image uploaded successfully');
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isUploading = false;
      });

      _showMessage('Upload failed: $error');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isUploading
              ? const LoadingWidget(
                  message: 'Uploading image...',
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (_imageUrl != null
                              ? NetworkImage(_imageUrl!)
                              : null) as ImageProvider?,
                      child: _selectedImage == null && _imageUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 70,
                            )
                          : null,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose Image'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _uploadImage,
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Upload Image'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}