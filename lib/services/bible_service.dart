import 'dart:convert';
import 'package:ecclesiastes/services/logging_service.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/bible_model.dart';
import '../models/bible_note.dart';
import '../core/security/encryption_service.dart';

class BibleService {
  static final BibleService _instance = BibleService._internal();
  factory BibleService() => _instance;
  BibleService._internal();

  Box<BibleBook>? _bibleBox;
  Box<BibleNote>? _notesBox;

  Future<void> init() async {
    _bibleBox = Hive.isBoxOpen('bible_box')
        ? Hive.box<BibleBook>('bible_box')
        : await Hive.openBox<BibleBook>('bible_box');

    _notesBox = Hive.isBoxOpen('bible_notes')
        ? Hive.box<BibleNote>('bible_notes')
        : await Hive.openBox<BibleNote>('bible_notes');

    if (_bibleBox == null) {
      LoggingService.error('Bible box not initialized');
      return;
    }
    if (_bibleBox!.isEmpty) {
      await _loadBibleFromAssets();
    }
  }


  Future<void> _loadBibleFromAssets() async {
    try {
      String response;
      try {
        response = await rootBundle.loadString('assets/librairie/bible_tob.json');
      } catch (e) {
        LoggingService.error('Fichier bible_tob.json introuvable dans les assets', e);
        return;
      }
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
      LoggingService.error('Erreur lors du chargement de la Bible', e);
    }
  }

  List<BibleBook> getBooks() => _bibleBox?.values.toList() ?? [];

  BibleBook? getBook(String id) => _bibleBox?.values.firstWhere((b) => b.id == id);

  // --- FAVORIS ---
  Future<void> toggleFavorite(BibleBook book, BibleChapter chapter, BibleVerse verse) async {
    verse.isFavorite = !verse.isFavorite;
    await book.save(); // Sauvegarde l'état dans Hive
  }

  // --- NOTES PASTORALES (CHIFFRÉES) ---
  Future<void> addNote(String bookId, int chapterNum, int verseNum, String content) async {
    final encryptedContent = await EncryptionService.encryptPastoralNote(content);
    final note = BibleNote(
      id: '${bookId}_${chapterNum}_$verseNum',
      bookId: bookId,
      chapterNumber: chapterNum,
      verseNumber: verseNum,
      content: encryptedContent,
    );
    await _notesBox?.put(note.id, note);
  }

  Future<String?> getNoteForVerse(String bookId, int chapterNum, int verseNum) async {
    final note = _notesBox?.get('${bookId}_${chapterNum}_$verseNum');
    if (note == null) return null;
    return EncryptionService.decryptPastoralNote(note.content);
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

