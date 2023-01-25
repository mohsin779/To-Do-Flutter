import 'dart:convert';

import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;

class Post with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  Post({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
  });
}
