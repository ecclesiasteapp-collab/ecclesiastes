import 'package:flutter/material.dart';
import '../services/bible_service.dart';
import '../models/bible_model.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  final BibleService _bibleService = BibleService();
  List<BibleBook> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    await _bibleService.init();
    setState(() {
      _books = _bibleService.getBooks();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible TOB'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: BibleSearchDelegate());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return ListTile(
                  leading: const Icon(Icons.book, color: Color(0xFF003366)),
                  title: Text(book.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${book.chapters.length} chapitres'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BibleChapterListPage(book: book),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class BibleChapterListPage extends StatelessWidget {
  final BibleBook book;
  const BibleChapterListPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: book.chapters.length,
        itemBuilder: (context, index) {
          final chapter = book.chapters[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BibleVerseListPage(book: book, chapter: chapter),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF003366)),
              ),
              alignment: Alignment.center,
              child: Text(
                '${chapter.number}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BibleVerseListPage extends StatelessWidget {
  final BibleBook book;
  final BibleChapter chapter;
  const BibleVerseListPage({super.key, required this.book, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${book.name} ${chapter.number}'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chapter.verses.length,
        itemBuilder: (context, index) {
          final verse = chapter.verses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
                children: [
                  TextSpan(
                    text: '${verse.number} ',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366), fontSize: 14),
                  ),
                  TextSpan(text: verse.text),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BibleSearchDelegate extends SearchDelegate {
  final BibleService _bibleService = BibleService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _bibleService.search(query);
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final verse = results[index];
        return ListTile(
          title: Text(verse.text),
          subtitle: const Text('Résultat de recherche'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
