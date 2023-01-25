import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/post.dart';
import '../screens/post_detail.dart';

class PostItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final post = Provider.of<Post>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(PostDetail.routeName, arguments: post.id);
          },
          child: Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            post.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
