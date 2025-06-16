
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';


class Hiveservice
{
  late Box<Map<dynamic,dynamic>> notesBox;

  Future<void> inithive() async
  {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    notesBox = await Hive.openBox<Map<dynamic, dynamic>>('notes');
  }

  Future<void> addnotes(Map<String, dynamic> notesmap) async
  {
    await notesBox.add(notesmap);
    print(notesmap);
  }

  List<Map<dynamic, dynamic>> getnotes()
  {
    return notesBox.toMap().entries.map((entry) {
      final note= Map<String, dynamic>.from(entry.value);
      note['id'] = entry.key;
      return note;
    }).toList();
  }

  Map<dynamic , dynamic>? getnotesbyid(int id)
  {
    return notesBox.get(id);
  }

  Future<void> updateNote(int id, Map<String, dynamic> updatedNote) async {
    await notesBox.put(id, updatedNote);
    print("note update ${updatedNote}");
  }

  Future<void> deleteTransaction(int id) async {
    await notesBox.delete(id);
  }



  Future<void> clearAll() async {
    await notesBox.clear();

  }

}