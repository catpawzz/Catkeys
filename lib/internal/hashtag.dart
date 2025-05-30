import 'dart:convert';
import 'package:catkeys/inc/features.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../inc/nav.dart';
import '../main/home.dart';

class HashTagPage extends StatefulWidget {
  const HashTagPage({super.key, required this.hashtag});

  final String hashtag;

  @override
  State<HashTagPage> createState() => _HashTagPageState();
}

class _HashTagPageState extends State<HashTagPage> {
  late Future<List<Map<String, dynamic>>> _posts;
  int posts = 0;
  String url = '';

  @override
  void initState() {
    super.initState();
    _posts = fetchPosts(widget.hashtag);
  }

  Future<List<Map<String, dynamic>>> fetchPosts(String hashtag) async {
    final prefs = await SharedPreferences.getInstance();
    final limit = prefs.getInt('catkeys_posts_shows');
    final server_url = prefs.getString('catkeys_url');
    final urls = 'https://$server_url/api/notes/search';
    final response = await http.post(
      Uri.parse(urls),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': '#$hashtag',
        'limit': limit,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      List<Map<String, dynamic>> fetchedPosts =
          data.map((post) => post as Map<String, dynamic>).toList();
      setState(() {
        posts = fetchedPosts.length;
        url = server_url!;
      });
      return fetchedPosts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  openLink(urlInput) async {
    var url = urlInput;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: 'There was an error while launching a browser!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Theme.of(context).colorScheme.onErrorContainer,
        textColor: Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
          ),
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  vibrateSelection();
                  navHome(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${widget.hashtag}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Showing ${posts} posts',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.open_in_browser_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                vibrateSelection();
                openLink('https://$url/tags/${widget.hashtag}');
              },
            ),
          ],
          automaticallyImplyLeading: false,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 2.0,
            ),
          ),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _posts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No posts found.'));
            } else {
              return AnimationLimiter(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimationConfiguration.synchronized(
                    duration: const Duration(milliseconds: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 700),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: snapshot.data!.asMap().entries.map((entry) {
                          final post = entry.value;
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  post['user']['name'] ??
                                      post['user']['username'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (post['text'] != null)
                                      MarkdownBody(
                                        data: post['text'],
                                        onTapLink: (text, post_url, title) {
                                          if (post_url != null) {
                                            vibrateSelection();
                                            if (post_url.startsWith("#")) {
                                              navHashtag(context,
                                                  post_url.substring(1));
                                            } else if (post_url
                                                .startsWith("@")) {
                                              openLink(
                                                  "https://cat-space.net/$post_url");
                                            } else {
                                              openLink(post_url);
                                            }
                                          }
                                        },
                                        styleSheet: MarkdownStyleSheet(
                                          p: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          a: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    if (post['files'] != null &&
                                        post['files'].isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Wrap(
                                          spacing: 8.0,
                                          runSpacing: 8.0,
                                          children: post['files']
                                              .map<Widget>((file) {
                                            return GestureDetector(
                                              onTap: () {
                                                vibrateSelection();
                                                openLink(file['url']);
                                              },
                                              child: Image.network(
                                                file['url'],
                                                fit: BoxFit.cover,
                                                height: 150,
                                                width: 150,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}