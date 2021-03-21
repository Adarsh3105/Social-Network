
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

cachedNetworkImage(String mediaURL) {
  return CachedNetworkImage(
    imageUrl: mediaURL,
    fit: BoxFit.fill,
    placeholder: (context, url) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      );

    },
    errorWidget: (context, url, error) =>
      Icon(Icons.error),
  );
}
