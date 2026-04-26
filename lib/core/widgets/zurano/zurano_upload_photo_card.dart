import 'package:flutter/material.dart';

import '../../theme/zurano_tokens.dart';
import '../app_network_image.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class ZuranoUploadPhotoCard extends StatelessWidget {
  const ZuranoUploadPhotoCard({
    super.key,
    required this.imageUrl,
    required this.onTap,
    this.onRemove,
    required this.uploadTitle,
    required this.formatsHint,
    required this.sizeHint,
    this.busy = false,
  });

  final String? imageUrl;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final String uploadTitle;
  final String formatsHint;
  final String sizeHint;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    final url = imageUrl?.trim() ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: busy ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ZuranoTokens.uploadFill,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ZuranoTokens.secondary.withValues(alpha: 0.55),
                  width: 1.2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: ZuranoTokens.lightPurple,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: hasImage
                        ? AppNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            errorWidget: const Icon(
                              AppIcons.broken_image_outlined,
                              color: ZuranoTokens.secondary,
                              size: 32,
                            ),
                          )
                        : const Icon(
                            AppIcons.add_photo_alternate_outlined,
                            color: ZuranoTokens.secondary,
                            size: 34,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          uploadTitle,
                          style: const TextStyle(
                            color: ZuranoTokens.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formatsHint,
                          style: const TextStyle(
                            color: ZuranoTokens.textGray,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          sizeHint,
                          style: const TextStyle(
                            color: ZuranoTokens.textGray,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasImage && onRemove != null)
                    IconButton(
                      onPressed: busy ? null : onRemove,
                      icon: const Icon(AppIcons.close_rounded),
                      color: ZuranoTokens.textGray,
                    ),
                ],
              ),
            ),
            if (busy)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: ZuranoTokens.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
