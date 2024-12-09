import 'dart:async';
import 'dart:core';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/models/result.dart';

class ApiProvider {
  //MARK: Shared class
  static final shared = ApiProvider();

  //MARK: Authentication

  Future<Result<String>> signIn(String username, String password) async {
    try {
      final AuthResponse response = await Supabase.instance.client.auth
          .signInWithPassword(email: username, password: password)
          .timeout(Configs.timeOut);
      return Result(data: response.session!.accessToken);
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<String>> signUp(String username, String password) async {
    try {
      final response = await Supabase.instance.client.auth
          .signUp(email: username, password: password)
          .timeout(Configs.timeOut);
      return Result(data: response.session!.accessToken);
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  //MARK: User's Note Interaction

  Future<Result<List<NoteModel>>> fetchNotes() async {
    try {
      final response = await Supabase.instance.client
          .from('Notes')
          .select()
          .eq('date', DateTime.now())
          .timeout(Configs.timeOut);
      final data = response.map((json) => NoteModel.fromJson(json)).toList();
      return Result(data: data);
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<NoteModel>> createNewNote(NoteModel newNote) async {
    try {
      newNote.deviceId = Supabase.instance.client.auth.currentUser!.email;
      final response = await Supabase.instance.client
          .from('Notes')
          .insert(newNote)
          .select()
          .timeout(Configs.timeOut);
      return Result(data: NoteModel.fromJson(response.first));
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<NoteModel>> updateNote(NoteModel newNote) async {
    try {
      final response = await Supabase.instance.client
          .from('Notes')
          .update(newNote.toJson())
          .eq('id', newNote.id!)
          .select()
          .timeout(Configs.timeOut);
      return Result(data: NoteModel.fromJson(response.first));
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<void>> deleteNote(int noteId) async {
    try {
      await Supabase.instance.client
          .from('Notes')
          .delete()
          .eq('id', noteId)
          .timeout(Configs.timeOut);
      return Result(data: null);
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }
}
