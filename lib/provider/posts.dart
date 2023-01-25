import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import './post.dart';
import '../models/http_exception.dart';

class Posts with ChangeNotifier {
  List<Post> _items = [];

  List<Post> get items {
    return [..._items];
  }

  Post findById(String id) {
    return _items.firstWhere((post) => post.id == id);
  }

  Future<void> fetchAndSetPosts() async {
    final url = Uri.parse(
        'https://to-do-flutter-app-dba18-default-rtdb.firebaseio.com/posts.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Post> loadedPosts = [];
      extractedData.forEach((prodId, prodData) {
        loadedPosts.add(Post(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedPosts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addPost(Post post) async {
    final url = Uri.parse(
        'https://to-do-flutter-app-dba18-default-rtdb.firebaseio.com/posts.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': post.title,
          'description': post.description,
          "imageUrl": post.imageUrl,
        }),
      );
      final newPost = Post(
        title: post.title,
        description: post.description,
        imageUrl: post.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newPost);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updatePost(String id, Post newPost) async {
    final postIndex = _items.indexWhere((post) => post.id == id);
    if (postIndex >= 0) {
      final url = Uri.parse(
          'https://to-do-flutter-app-dba18-default-rtdb.firebaseio.com/posts/$id.json');
      await http.patch(url,
          body: json.encode({
            "title": newPost.title,
            "description": newPost.description,
            "imageUrl": newPost.imageUrl,
          }));
      _items[postIndex] = newPost;
      notifyListeners();
    }
  }

  Future<void> deletePost(String id) async {
    final url = Uri.parse(
        'https://to-do-flutter-app-dba18-default-rtdb.firebaseio.com/posts/$id.json');
    final existingPostIndex = _items.indexWhere((post) => post.id == id);
    var existingPost = _items[existingPostIndex];
    _items.removeAt(existingPostIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingPostIndex, existingPost);
      notifyListeners();

      throw HttpException('Could not load posts');
    }
    existingPost = null;
  }
}
