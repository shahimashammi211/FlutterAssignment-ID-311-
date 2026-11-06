
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/upload_service.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final UploadService uploadService = UploadService();

  XFile? selectedImage;
  String? uploadedImageUrl;

  bool isLoading = false;
  bool isFetching = true;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  // Load existing profile image
  Future<void> loadProfileImage() async {
    try {
      final imageUrl = await uploadService.getProfileImage();

      if (!mounted) return;

      setState(() {
        uploadedImageUrl = imageUrl;
        isFetching = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isFetching = false;
      });
    }
  }

  // Pick image from gallery
  Future<void> selectImage() async {
    try {
      final image = await uploadService.pickImage();

      if (image == null || !mounted) return;

      setState(() {
        selectedImage = image;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image selection failed: $error')),
      );
    }
  }

  // Upload selected image
  Future<void> uploadImage() async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image first'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final imageUrl =
          await uploadService.uploadImage(selectedImage!);

      if (!mounted) return;

      setState(() {
        uploadedImageUrl = imageUrl;
        selectedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image uploaded successfully'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Profile Image',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Select an image from your gallery and upload it.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grayText,
                ),
              ),

              const SizedBox(height: 35),

              Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  color: AppColors.lightTeal,
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: selectedImage != null
                    ? FutureBuilder<Uint8List>(
                        future: selectedImage!.readAsBytes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                    : isFetching
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : uploadedImageUrl != null
                            ? Image.network(
                                uploadedImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) {
                                  return const Icon(
                                    Icons.broken_image_outlined,
                                    size: 75,
                                    color: AppColors.primary,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.image_outlined,
                                size: 85,
                                color: AppColors.primary,
                              ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : selectImage,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Choose from Gallery'),
                ),
              ),

              const SizedBox(height: 15),

              CustomButton(
                text: 'Upload Image',
                isLoading: isLoading,
                onPressed: uploadImage,
              ),

              const SizedBox(height: 20),

              if (selectedImage != null)
                const Text(
                  'New image selected. Upload to save it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
