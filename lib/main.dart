import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/posts.dart';
import './screens/home_page.dart';
import './screens/post_detail.dart';
import './screens/add_post.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Posts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo',
        theme: ThemeData(
          fontFamily: 'IBMPlexSerif',
        ).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Colors.blue,
                // secondary: Colors.deepOrange,
              ),
        ),
        home: HomePage(),
        routes: {
          PostDetail.routeName: (ctx) => PostDetail(),
          AddPost.routeName: (ctx) => AddPost(),
        },
      ),
    );
  }
}
