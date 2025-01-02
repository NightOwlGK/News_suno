import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_apk/contollers/breaking_news_controller.dart';
import 'package:news_apk/contollers/recommendation_news_controller.dart';
import 'package:news_apk/modals/articles_modal.dart';
import 'package:news_apk/screens/detail_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    bool _isDarkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
        appBar: AppBar(
          title: Text(
            "News Suno",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isDarkTheme ? Colors.white : Colors.black),
          ),
          centerTitle: true,
          backgroundColor: _isDarkTheme ? Colors.black : Color(0xff4CC9FE),
          leading: InkWell(
            borderRadius: BorderRadius.circular(50),
            splashColor: const Color.fromARGB(255, 47, 139, 214),
            child: Icon(
              Icons.menu,
              color: _isDarkTheme ? Colors.white : Colors.black,
            ),
            onTap: () {},
          ),
          actions: [
            InkWell(
              onTap: () {
                setState(() {});
              },
              borderRadius: BorderRadius.circular(50),
              splashColor: const Color.fromARGB(255, 47, 139, 214),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.replay,
                    color: _isDarkTheme ? Colors.white : Colors.black),
              ),
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(50),
              splashColor: const Color.fromARGB(255, 47, 139, 214),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.notifications,
                    color: _isDarkTheme ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  "Breaking News",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: FutureBuilder(
                  future: BreakingNewsController().getBreakingNewsList(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CustomSliderShimmer(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Failed to load news. Please try again later.",
                          style: TextStyle(
                            fontSize: 16,
                            color: _isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<Articles> articles = snapshot.data as List<Articles>;

                      // If no articles are available
                      if (articles.isEmpty) {
                        return Center(
                          child: Text(
                            "No news articles available.",
                            style: TextStyle(
                              fontSize: 16,
                              color: _isDarkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }

                      return CarouselSlider.builder(
                        itemCount: articles.length,
                        itemBuilder: (_, index, __) {
                          return CustomSliderContainer(
                            artcile: articles[index],
                            isDarkTheme: _isDarkTheme,
                          );
                        },
                        options: CarouselOptions(
                          height: 300,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.25,
                          autoPlay: true,
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        "No data available.",
                        style: TextStyle(
                          fontSize: 16,
                          color: _isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Recommendation",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ),
              FutureBuilder(
                future: RecommendationNewsController().getRecommendationList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CustomRecommendationShimmer(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Failed to load news. Please try again later.",
                        style: TextStyle(
                          fontSize: 16,
                          color: _isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    List<Articles> articles = snapshot.data as List<Articles>;

                    if (articles.isEmpty) {
                      return Center(
                        child: Text(
                          "No news articles available.",
                          style: TextStyle(
                            fontSize: 16,
                            color: _isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (_, index) {
                          return CustomRecommendationListCard(
                            artcile: articles[index],
                            isDarkTheme: _isDarkTheme,
                          );
                        },
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      "No data available.",
                      style: TextStyle(
                        fontSize: 16,
                        color: _isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class CustomRecommendationShimmer extends StatelessWidget {
  const CustomRecommendationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200.0,
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 177, 177, 177),
            highlightColor: Colors.white,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 177, 177, 177),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 200.0,
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 177, 177, 177),
            highlightColor: Colors.white,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 177, 177, 177),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSliderShimmer extends StatelessWidget {
  const CustomSliderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300.0,
      child: Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 177, 177, 177),
        highlightColor: Colors.white,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 177, 177, 177),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class CustomRecommendationListCard extends StatelessWidget {
  final Articles artcile;
  final bool isDarkTheme;
  const CustomRecommendationListCard({
    super.key,
    required this.artcile,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailNewsScreen(
              articles: artcile,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
        width: double.infinity,
        height: 150,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: artcile.imageUrl.isEmpty
                        ? AssetImage("assets/images/nullImage.jpeg")
                        : NetworkImage(artcile.imageUrl),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  color: isDarkTheme ? Colors.black : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: isDarkTheme
                          ? const Color.fromARGB(255, 65, 65, 65)
                          : const Color.fromARGB(255, 191, 191, 191),
                      spreadRadius: 5,
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      artcile.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSliderContainer extends StatelessWidget {
  final Articles artcile;
  final bool isDarkTheme;
  const CustomSliderContainer({
    super.key,
    required this.artcile,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailNewsScreen(
              articles: artcile,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: NetworkImage(artcile.imageUrl),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            colorFilter: ColorFilter.mode(
              const Color.fromARGB(107, 0, 0, 0),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              artcile.title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              artcile.description,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(),
          ],
        ),
      ),
    );
  }
}
