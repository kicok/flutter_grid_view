import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String PIXABAY_KEY = '17368288-b20c3369024b51a2e1df52944';
const String BASE_URL = 'https://pixabay.com/api';

class PixabayPhotoItem {
  final int id;
  final String user;
  final int views;
  final int downloads;
  final int favorites;
  final int webformatHeight;
  final int webformatWidth;
  final String webformatURL;

  PixabayPhotoItem({
    this.id,
    this.user,
    this.views,
    this.downloads,
    this.favorites,
    this.webformatHeight,
    this.webformatWidth,
    this.webformatURL,
  });

  PixabayPhotoItem.fromJson(json)
      : this.id = json['id'],
        this.user = json['user'],
        this.views = json['views'],
        this.downloads = json['downloads'],
        this.favorites = json['favorites'],
        this.webformatHeight = json['webformatHeight'],
        this.webformatWidth = json['webformatWidth'],
        this.webformatURL = json['webformatURL'];
}

class PixabayPhotos with ChangeNotifier {
  final String url =
      '$BASE_URL/?key=$PIXABAY_KEY&q=yellow+flower&image_type=photo';

  List<PixabayPhotoItem> _photos = [];

  List<PixabayPhotoItem> get photos {
    return [..._photos];
  }

  Future<void> getPixabayPhotos(int page, int perPage) async {
    try {
      final response = await http.get('$url&page=$page&per_page=$perPage');
      final items = json.decode(response.body)['hits'];
      print('$url&page=$page&per_page=$perPage');
      items.forEach((item) {
        // print(item);
        final newPhoto = PixabayPhotoItem.fromJson(item);
        _photos.add(newPhoto);
      });

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
