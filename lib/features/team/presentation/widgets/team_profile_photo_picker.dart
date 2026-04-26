import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../l10n/app_localizations.dart';

class TeamProfilePhotoPicker extends StatelessWidget {
  const TeamProfilePhotoPicker({
    super.key,
    required this.selectedImage,
    required this.existingImageUrl,
    required this.isUploading,
    required this.onPickImage,
    this.onRemoveImage,
  });

  final XFile? selectedImage;
  final String? existingImageUrl;
  final bool isUploading;
  final VoidCallback onPickImage;
  final VoidCallback? onRemoveImage;

  static const Color zuranoPurple = Color(0xFF7C3AED);
  static const Color softBorder = Color(0xFFE9DDFE);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: softBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: isUploading ? null : onPickImage,
            child: _avatar(),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.teamPhotoPickerTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: softBorder, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildAvatar(),
        ),
        Positioned(
          right: -4,
          bottom: 8,
          child: GestureDetector(
            onTap: isUploading ? null : onPickImage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: softBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: isUploading
                  ? const Padding(
                      padding: EdgeInsets.all(13),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.photo_camera_rounded,
                      color: zuranoPurple,
                      size: 24,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (selectedImage != null) {
      return Image.file(File(selectedImage!.path), fit: BoxFit.cover);
    }
    if (existingImageUrl != null && existingImageUrl!.trim().isNotEmpty) {
      return Image.network(existingImageUrl!, fit: BoxFit.cover);
    }
    return const Center(
      child: Icon(Icons.person_rounded, color: zuranoPurple, size: 58),
    );
  }
}
