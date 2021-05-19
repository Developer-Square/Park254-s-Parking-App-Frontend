import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloudinary_public/cloudinary_public.dart';

/// Uploads images to cloudinary for storage.
///
/// Returns links to the specific images stored in cloudinary.
/// Requires: [List] of all the images.
Future<CloudinaryResponse> uploadImages({
  @required imagePath,
}) async {
  final CLOUD_NAME = 'ryansimageupload';
  final UPLOAD_PRESET = 'ml_default';
  final cloudinary = CloudinaryPublic(CLOUD_NAME, UPLOAD_PRESET, cache: false);

  try {
    CloudinaryResponse uploadedImage = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePath,
            resourceType: CloudinaryResourceType.Image));

    return uploadedImage;
  } on CloudinaryException catch (e) {
    throw e.message;
  }
}
