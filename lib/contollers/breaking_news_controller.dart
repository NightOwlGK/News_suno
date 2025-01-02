import 'dart:convert';

import 'package:news_apk/constants/api_key.dart';
import 'package:news_apk/modals/articles_modal.dart';
import 'package:http/http.dart' as http;

class BreakingNewsController {
  List<Articles> _breakingNewArticlesList = <Articles>[];

  Future<List<Articles>> getBreakingNewsList() async {
    await getAllBreakingNews();
    return _breakingNewArticlesList;
  }

  Future<void> getAllBreakingNews() async {
    try {
      var response = await http.get(Uri.parse(BREAKING_NEWS_URL));
      if (response.statusCode == 200) {
        var obj = jsonDecode(response.body);
        List<dynamic> li = obj["articles"];
        List<Articles> result = li.map((item) {
          return Articles.fromJson(item);
        }).toList();
        _breakingNewArticlesList = result;
      } else {
        print("Error Occured");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
