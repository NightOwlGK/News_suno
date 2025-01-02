import 'dart:convert';

import 'package:news_apk/constants/api_key.dart';
import 'package:news_apk/modals/articles_modal.dart';
import 'package:http/http.dart' as http;

class RecommendationNewsController {
  List<Articles> _getRecommendationList = <Articles>[];

  Future<List<Articles>> getRecommendationList() async {
    await getAllRecommendationNews();
    return _getRecommendationList;
  }

  Future<void> getAllRecommendationNews() async {
    try {
      var response = await http.get(Uri.parse(RECOMMENDATION_NEWS_URL));
      if (response.statusCode == 200) {
        var obj = jsonDecode(response.body);
        List<dynamic> li = obj["articles"];
        List<Articles> result = li.map((item) {
          return Articles.fromJson(item);
        }).toList();
        _getRecommendationList = result;
      } else {
        print("Error Occured");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
