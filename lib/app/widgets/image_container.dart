import 'dart:io';
import 'dart:typed_data';
import 'package:school_app/app/app.dart';
import 'package:flutter/material.dart';

/// Use imageFile parameter where applicable.
class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
    this.height = 90,
    this.width = 90,
    this.imageFile,
    this.imagePath,
    this.memoryImageBytes,
    this.assetPath,
    this.backgroundColor,
    this.imageUrl,
    this.onContainerTap,
    this.alignment = Alignment.bottomRight,
    this.padding,
    this.circularDecoration = true,
    this.overlayIcon = const Icon(
      Icons.camera_enhance_rounded,
    ),
    this.border,
    this.borderRadius,
    this.child,
    this.fit = BoxFit.fill,
  }) : super(key: key);

  final File? imageFile;
  final String? imagePath;
  final Uint8List? memoryImageBytes;
  final String? assetPath;
  final String? imageUrl;
  final Color? backgroundColor;
  final VoidCallback? onContainerTap;
  final bool circularDecoration;
  final Widget overlayIcon;
  final double? width;
  final double? height;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onContainerTap,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        child: Container(
          height: height,
          width: width,
          alignment: alignment,
          padding: padding,
          decoration: BoxDecoration(
            shape: circularDecoration ? BoxShape.circle : BoxShape.rectangle,
            color: backgroundColor ?? Colors.grey[300],
            image: DecorationImage(
              image:
                  // Prefer to show selected image.
                  Utility.notEmptyValidator(imagePath)
                      ? FileImage(File(imagePath!))
                      : imageFile != null
                          ? FileImage(imageFile!)
                          : Utility.notEmptyValidator(imageUrl)
                              ? NetworkImage(
                                  imageUrl!,
                                )
                              : memoryImageBytes != null
                                  ? MemoryImage(memoryImageBytes!)
                                      as ImageProvider
                                  : AssetImage(
                                      assetPath ?? AssetConstants.icAvatar,
                                    ),
              fit: fit,
            ),
            border: border,
            borderRadius: !circularDecoration
                ? borderRadius ?? BorderRadius.circular(3)
                : null,
          ),
          child: onContainerTap is VoidCallback ? overlayIcon : child,
        ),
      );
}
