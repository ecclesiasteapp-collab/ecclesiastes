import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/bible_model.dart';

class BibleService {
  static final BibleService _instance = BibleService._internal();
  factory BibleService() => _instance;
  BibleService._internal();

  Box<BibleBook>? _bibleBox;

  Future<void> init() async {
    _bibleBox = await Hive.openBox<BibleBook>('bible_box');
    if (_bibleBox!.isEmpty) {
      await _loadBibleFromAssets();
    }
  }

  Future<void> _loadBibleFromAssets() async {
    try {
      final String response = await rootBundle.loadString('assets/library/bible_tob.json');
      final data = json.decode(response) as List<dynamic>;
      
      for (var bookData in data) {
        final chapters = (bookData['chapters'] as List).map((c) {
          final verses = (c['verses'] as List).map((v) {
            return BibleVerse(number: v['number'], text: v['text']);
          }).toList();
          return BibleChapter(number: c['number'], verses: verses);
        }).toList();

        final book = BibleBook(
          id: bookData['id'],
          name: bookData['name'],
          chapters: chapters,
        );
        await _bibleBox!.add(book);
      }
    } catch (e) {
      print('Erreur lors du chargement de la Bible: $e');
    }
  }

  List<BibleBook> getBooks() {
    return _bibleBox?.values.toList() ?? [];
  }

  BibleBook? getBook(String id) {
    return _bibleBox?.values.firstWhere((b) => b.id == id);
  }

  List<BibleVerse> search(String query) {
    if (query.isEmpty) return [];
    final results = <BibleVerse>[];
    for (var book in _bibleBox!.values) {
      for (var chapter in book.chapters) {
        for (var verse in chapter.verses) {
          if (verse.text.toLowerCase().contains(query.toLowerCase())) {
            results.add(verse);
          }
        }
      }
    }
    return results;
  }
}
