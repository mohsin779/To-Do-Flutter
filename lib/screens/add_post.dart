import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/post.dart';
import '../provider/posts.dart';

class AddPost extends StatefulWidget {
  static const routeName = 'add-post';
  const AddPost({Key key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editPost = Post(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      if (args['postId'] != null) {
        _editPost = Provider.of<Posts>(context).findById(args['postId']);
        _initValues = {
          'title': _editPost.title,
          'description': _editPost.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editPost.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //To clrea focus nodes from memory after we leave that page use dispose()
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https') ||
          !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editPost.id != null) {
      Provider.of<Posts>(context, listen: false)
          .updatePost(_editPost.id, _editPost);
    } else {
      try {
        await Provider.of<Posts>(context, listen: false).addPost(_editPost);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text("Something went wrong"),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(args['title']),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editPost = Post(
                          title: value,
                          description: _editPost.description,
                          imageUrl: _editPost.imageUrl,
                          id: _editPost.id,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Pleas enetr a title";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editPost = Post(
                          title: _editPost.title,
                          description: value,
                          imageUrl: _editPost.imageUrl,
                          id: _editPost.id,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Pleas enetr a description";
                        }
                        if (value.length < 10) {
                          return "should be atleast 10 characters long";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'ImageUrl'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editPost = Post(
                                title: _editPost.title,
                                description: _editPost.description,
                                imageUrl: value,
                                id: _editPost.id,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Pleas enetr an imageUrl";
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Pleas enter a valid URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Pleas enter a valid image URL';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
