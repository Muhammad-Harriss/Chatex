import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RoundedImageNetwork extends StatelessWidget {
  final String imagePath;
  final double size;

  const RoundedImageNetwork({
    super.key,
    required this.imagePath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        color: Colors.black,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imagePath),
        ),
        borderRadius: BorderRadius.circular(size / 2), // circular shape
      ),
    );
  }
}

class RoundedImageFile extends StatelessWidget {
  final PlatformFile image;
  final double size;

  const RoundedImageFile({
    super.key,
    required this.image,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: kIsWeb
              ? MemoryImage(image.bytes!) as ImageProvider
              : FileImage(File(image.path!)), // use FileImage, not AssetImage
        ),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}

class RoundedImageNetworkWithStatusIndicator extends RoundedImageNetwork {
  final bool isActive;

  RoundedImageNetworkWithStatusIndicator({
    required Key key,
    required String imagePath,
    required double size,
    required this.isActive,
  }) : super(key: key, imagePath: imagePath, size: size);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        super.build(context),
        Container(
          height: size * 0.20,
          width: size * 0.20,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(size),
          ),
        ),
      ],
    );
  }
}
