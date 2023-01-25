import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './post_item.dart';
import '../provider/posts.dart';

class PostsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postsData = Provider.of<Posts>(context);
    final posts = postsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: posts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: posts[i],
        child: PostItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
