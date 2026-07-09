import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../domain/repositories/bible_repository.dart';
import '../models/bible_model.dart';
import '../models/bible_note.dart';
import '../core/security/encryption_service.dart';
import 'database_service.dart';
import 'logging_service.dart';

class HiveBibleRepository implements BibleRepository {
  static const String _bibleBoxName = 'bible_box';
  static const String _notesBoxName = 'bible_notes';

  @override
  Future<void> initialize() async {
    final bibleBox = await DatabaseService.openBox<BibleBook>(_bibleBoxName);
    if (bibleBox.isEmpty) {
      await _loadBibleFromAssets(bibleBox);
    }
    await DatabaseService.openBox<BibleNote>(_notesBoxName);
  }

  Future<void> _loadBibleFromAssets(Box<BibleBook> box) async {
    try {
      final response = await rootBundle.loadString('assets/librairie/bible_tob.json');
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
        await box.add(book);
      }
    } catch (e) {
      LoggingService.error('Erreur lors du chargement de la Bible', e);
    }
  }

  @override
  Future<List<BibleBook>> getBooks() async {
    final box = await DatabaseService.openBox<BibleBook>(_bibleBoxName);
    return box.values.toList();
  }

  @override
  Future<BibleBook?> getBook(String id) async {
    final box = await DatabaseService.openBox<BibleBook>(_bibleBoxName);
    return box.values.firstWhere((b) => b.id == id);
  }

  @override
  Future<void> toggleFavorite(BibleBook book, BibleVerse verse) async {
    verse.isFavorite = !verse.isFavorite;
    await book.save();
  }

  @override
  Future<void> saveNote({
    required String bookId,
    required int chapterNumber,
    required int verseNumber,
    required String content,
  }) async {
    final notesBox = await DatabaseService.openBox<BibleNote>(_notesBoxName);
    final encryptedContent = await EncryptionService.encryptPastoralNote(content);
    final note = BibleNote(
      id: '${bookId}_${chapterNumber}_$verseNumber',
      bookId: bookId,
      chapterNumber: chapterNumber,
      verseNumber: verseNumber,
      content: encryptedContent,
    );
    await notesBox.put(note.id, note);
  }

  @override
  Future<String?> getNote(String bookId, int chapterNumber, int verseNumber) async {
    final notesBox = await DatabaseService.openBox<BibleNote>(_notesBoxName);
    final note = notesBox.get('${bookId}_${chapterNumber}_$verseNumber');
    if (note == null) return null;
    return EncryptionService.decryptPastoralNote(note.content);
  }

  @override
  Future<List<BibleVerse>> search(String query) async {
    if (query.isEmpty) return [];
    final box = await DatabaseService.openBox<BibleBook>(_bibleBoxName);
    final results = <BibleVerse>[];
    for (var book in box.values) {
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
