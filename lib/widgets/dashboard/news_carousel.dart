import 'package:flutter/material.dart';
import '../../models/news_model.dart';
import '../../views/news_detail_screen.dart';

class NewsCarousel extends StatelessWidget {
  final List<News> newsList;

  const NewsCarousel({super.key, required this.newsList});

  @override
  Widget build(BuildContext context) {
    if (newsList.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 24),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final news = newsList[index];
          return Container(
            width: 380,
            margin: const EdgeInsets.only(right: 16),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NewsDetailScreen(news: news))),
                child: Row(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(news.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NewsDetailScreen(news: news))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003366),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                minimumSize: const Size(64, 32),
                              ),
                              child: const Text('Lire', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

