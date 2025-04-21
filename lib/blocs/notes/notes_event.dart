import 'package:equatable/equatable.dart';
abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object?> get props => [];
}
class LoadNotes extends NotesEvent {}
class AddNote extends NotesEvent {
  final String note;
  const AddNote(this.note);

  @override
  List<Object?> get props => [note];
}
class UpdateNote extends NotesEvent {
  final String docID;
  final String newNote;
  const UpdateNote(this.docID, this.newNote);

  @override
  List<Object?> get props => [docID, newNote];
}
class DeleteNote extends NotesEvent{
  final String docID;
  const DeleteNote(this.docID);

   @override
  List<Object?> get props => [docID];
}