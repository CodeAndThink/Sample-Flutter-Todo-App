import 'dart:async';
import 'dart:core';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/models/result.dart';
import 'package:todo_app/utils/converse_datetime.dart';

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

  //MARK: User's Information Interaction

  User fetchUserInformation() {
    return Supabase.instance.client.auth.currentUser!;
  }

  //MARK: User's Note Interaction

  // Fetches all notes and counts the number of notes created on each day of the year.
  Future<Result<List<List<int>>>> countNoteBasedOnDayInYear() async {
    try {
      final notesResult = await fetchAllNotes();
      if (notesResult.error != null) {
        return Result(error: notesResult.error);
      }

      final notes = notesResult.data!;
      List<List<int>> notesCountByDayInYear =
          List.generate(12, (_) => List.filled(31, 0));

      for (var note in notes) {
        DateTime createdAt =
            ConverseDateTime.convertStringToMediumDateTimeType(note.date)
                .toLocal();
        int month = createdAt.month - 1;
        int day = createdAt.day - 1;
        notesCountByDayInYear[month][day]++;
      }

      return Result(data: notesCountByDayInYear);
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  // Fetches all notes from the database.
  Future<Result<List<NoteModel>>> fetchAllNotes() async {
    try {
      final response = await Supabase.instance.client
          .from('Notes')
          .select()
          .timeout(Configs.timeOut);
      final data = response.map((json) => NoteModel.fromJson(json)).toList();
      return Result(data: data);
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  // Fetches notes created today from the database.
  Future<Result<List<NoteModel>>> fetchNotesForToday() async {
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

  // Creates a new note in the database.
  Future<Result<NoteModel>> createNewNote(NoteModel newNote) async {
    try {
      newNote.userId = Supabase.instance.client.auth.currentUser!.id;
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

  // Updates an existing note in the database.
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

  // Deletes a note from the database.
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

  // Counts the number of done notes in the database.
  Future<Result<int>> doneNoteCount() async {
    try {
      final response = await Supabase.instance.client
          .from('Notes')
          .select('id')
          .eq('status', true)
          .timeout(Configs.timeOut);
      return Result(data: response.length);
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  // Counts the number of todo notes in the database.
  Future<Result<int>> todoNoteCount() async {
    try {
      final response = await Supabase.instance.client
          .from('Notes')
          .select('id')
          .eq('status', false)
          .timeout(Configs.timeOut);
      return Result(data: response.length);
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  // Counts the total number of notes for the current user in the database.
  Future<Result<int>> totalNoteCount() async {
    try {
      final response = await Supabase.instance.client
          .from('Notes')
          .select('id')
          .eq('userId', Supabase.instance.client.auth.currentUser!.id)
          .timeout(Configs.timeOut);
      return Result(data: response.length);
    } on TimeoutException catch (_) {
      return Result(error: "Error: Request timed out");
    } catch (e) {
      return Result(error: e.toString());
    }
  }
}
