abstract class NotesState {}
class NotesStateRead extends NotesState {
  NotesStateRead();
}

class NoteStateError extends NotesState {
  final String? error;
  NoteStateError({this.error});
}