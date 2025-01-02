import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:news_apk/management/sound_tracker.dart';
import 'package:news_apk/modals/articles_modal.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailNewsScreen extends StatelessWidget {
  final Articles articles;
  final FlutterTts _tts = FlutterTts();

  DetailNewsScreen({super.key, required this.articles});

  Future<void> _speak(
      {required String text, required BuildContext context}) async {
    await _tts.setLanguage("en-IN");
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    _tts.setCompletionHandler(() {
      print("Speech completed!");
      Provider.of<SoundTracker>(context, listen: false).doFalse();
    });
    await _tts.setEngine("com.google.android.tts");
    await _tts.speak(text);
  }

  Future<void> _pause() async {
    await _tts.pause();
  }

  Future<void> _stop() async {
    await _tts.stop();
  }

  Future<void> _launchUrl(String url) async {
    if (await launchUrl(Uri.parse(url))) {
      print("Successfully Launched URL");
    } else {
      print("SOmething went wrong.....");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _isDarkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => SoundTracker(),
      child: Scaffold(
        backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
        body: Consumer<SoundTracker>(builder: (ctx, _, __) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      image: articles.imageUrl.isEmpty
                          ? AssetImage("assets/images/nullImage.jpeg")
                          : NetworkImage(articles.imageUrl),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      IconButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _stop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    spacing: 10,
                    children: [
                      Text(
                        articles.title,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: _isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Published date : ",
                            style: TextStyle(
                              color: _isDarkTheme ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            articles.publishDate.substring(0, 10),
                            style: TextStyle(
                              color: _isDarkTheme ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Author : ",
                            style: TextStyle(
                              color: _isDarkTheme ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            articles.author,
                            style: TextStyle(
                              color: _isDarkTheme ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(right: 20),
                        height: 70,
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                onPressed: () async {
                                  Provider.of<SoundTracker>(ctx, listen: false)
                                      .clicked();
                                  Provider.of<SoundTracker>(ctx, listen: false)
                                          .getClicked()
                                      ? await _speak(
                                          text:
                                              "${articles.description} ${articles.content}",
                                          context: ctx,
                                        )
                                      : await _pause();
                                },
                                icon:
                                    Provider.of<SoundTracker>(ctx, listen: true)
                                            .getClicked()
                                        ? Icon(
                                            Icons.pause,
                                            color: _isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                            size: 30,
                                          )
                                        : Icon(
                                            Icons.play_arrow_rounded,
                                            size: 30,
                                            color: _isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await _stop();
                                Provider.of<SoundTracker>(ctx, listen: false)
                                    .doFalse();
                              },
                              icon: Icon(
                                Icons.replay,
                                color:
                                    _isDarkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: LottieBuilder.asset(
                                "assets/lottie/speaker.json",
                                animate:
                                    Provider.of<SoundTracker>(ctx, listen: true)
                                            .getClicked()
                                        ? true
                                        : false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        articles.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15,
                          color: _isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        articles.content,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15,
                          color: _isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _launchUrl(articles.newsUrl);
                          if (Provider.of<SoundTracker>(ctx, listen: false)
                              .getClicked()) {
                            Provider.of<SoundTracker>(ctx, listen: false)
                                .clicked();
                          }
                          await _stop();
                        },
                        child: Text(
                          "Know More",
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
