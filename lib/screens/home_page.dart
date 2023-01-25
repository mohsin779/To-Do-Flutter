import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/posts_grid.dart';
import '../provider/posts.dart';
import './add_post.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isInit = true;
  var _isLoding = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoding = true;
      });
      Provider.of<Posts>(context).fetchAndSetPosts().then((_) {
        setState(() {
          _isLoding = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPost.routeName,
                  arguments: {'title': 'Create Post'});
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _isLoding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PostsGrid(),
    );
  }
}
