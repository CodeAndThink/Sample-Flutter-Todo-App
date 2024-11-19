import 'dart:core';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/models/note_model.dart';

class ApiProvider {
  //MARK: Authentication

  Future<void> signIn(String username, String password) async {
    final response = await Supabase.instance.client.auth
        .signInWithPassword(email: username, password: password);
    if (response.user != null) {
    } else {}
  }

  Future<void> signUp(String username, String password) async {
    final response = await Supabase.instance.client.auth
        .signUp(email: username, password: password);
    if (response.user != null) {
    } else {}
  }

  //MARK: Note interact

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  Future<List<NoteModel>> fetchNotes() async {
    final response = await Supabase.instance.client.from('Notes').select();
    return response.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<void> createNewNote(NoteModel newNote) async {
    await Supabase.instance.client.from('Notes').insert(newNote.toJson());
  }

  Future<void> updateNote(NoteModel newNote) async {
    await Supabase.instance.client.from('Notes').update(newNote.toJson());
  }

  Future<void> deleteNote(int noteId) async {
    await Supabase.instance.client.from('Notes').delete().eq('id', noteId);
  }
}
