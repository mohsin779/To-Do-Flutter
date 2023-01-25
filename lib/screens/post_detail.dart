import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/posts.dart';
import '../screens/add_post.dart';

class PostDetail extends StatelessWidget {
  static const routeName = '/post-detail';

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final postId = ModalRoute.of(context).settings.arguments as String;
    final loadedPost =
        Provider.of<Posts>(context, listen: false).findById(postId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedPost.title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPost.routeName,
                  arguments: {'postId': loadedPost.id, 'title': 'Edit Post'});
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              loadedPost.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              loadedPost.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () async {
          try {
            await Provider.of<Posts>(context, listen: false)
                .deletePost(loadedPost.id);
            print('after');
            Navigator.of(context).pop();
          } catch (error) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(
                  'Deleting post failed',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
