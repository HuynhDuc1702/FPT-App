// lib/blocs/notes/notes_state.dart

import 'package:equatable/equatable.dart';

abstract class NotesState extends Equatable{
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}
class NotesLoaded extends NotesState {
  final List<Map<String, dynamic>> notes;
  const NotesLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class NotesError extends NotesState {
  final String error;
  const NotesError(this.error);

  @override
  List<Object?> get props => [error];
}
