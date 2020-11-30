import 'package:flutter/material.dart';
import 'package:flutter_grid_view/providers/pixabay_photos.dart';

class ImageDetail extends StatelessWidget {
  final PixabayPhotoItem photo;

  ImageDetail(this.photo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${photo.user}'),
      ),
    );
  }
}
