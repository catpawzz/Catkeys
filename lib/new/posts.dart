import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../inc/features.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> with TickerProviderStateMixin {
  late Misskey client;
  String url = '';
  String token = '';
  int tabIndex = 0;
  int posts = 250;
  final TextEditingController _noteController = TextEditingController();
  late final TabController tabs1 = TabController(length: 3, vsync: this);

  Map<String, String> _customEmojis = {};

  @override
  void initState() {
    super.initState();
    fetchData();

    tabs1.addListener(() {
      setState(() {
        tabIndex = tabs1.index;
      });
      vibrateSelection();
    });
  }

  fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      url = prefs.getString('catkeys_url') ?? '';
      token = prefs.getString('catkeys_token') ?? '';
      posts = prefs.getInt('catkeys_posts_shows') ?? 250;
    });
    if (url.isNotEmpty && token.isNotEmpty) {
      client = Misskey(
        host: url,
        token: token,
      );
      try {
        await _loadEmojis();
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Network error: Unable to fetch data!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          textColor: Theme.of(context).colorScheme.onErrorContainer,
        );
      }
    }
  }

  Future<Map<String, String>> fetchCustomEmojis() async {
    final response = await client.emojis();
    Map<String, String> emojiMap = {};

    for (var emoji in response.emojis) {
      emojiMap[emoji.name] = (emoji.url).toString();
    }

    return emojiMap;
  }

  Future<void> _loadEmojis() async {
    Map<String, String> emojis = await fetchCustomEmojis();
    setState(() {
      _customEmojis = emojis;
    });
  }

  String _replaceEmojis(String text) {
    String modifiedText = text;
    _customEmojis.forEach((emojiCode, emojiUrl) {
      final emojiMarkdown = '![]($emojiUrl)';
      modifiedText = modifiedText.replaceAll(':$emojiCode:', emojiMarkdown);
    });
    return modifiedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: TabBar(
            controller: tabs1,
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Local'),
              Tab(text: 'Global'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabs1,
        children: [
          Center(child: Text('Home Posts')),
          Center(child: Text('Local Posts')),
          Center(child: Text('Global Posts')),
        ],
      ),
    );
  }
}
