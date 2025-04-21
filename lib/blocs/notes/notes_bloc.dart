

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState>{
  final CollectionReference notes=
FirebaseFirestore.instance.collection('notes');

  NotesBloc():super(NotesInitial()){
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNotes);
    on<UpdateNote>(_onUpdateNotes);
    on<DeleteNote>(_onDeleteNotes);
  }

  Future<void>_onLoadNotes(LoadNotes event,Emitter<NotesState> emit) async{
    emit(NotesLoading());
    try{
      final snapshots= notes.orderBy('timestamp',descending: true).snapshots();
      await emit.forEach<QuerySnapshot>(
        snapshots,
        onData: (snapshots){
          final notes=snapshots.docs.map((doc){
            final data=doc.data() as Map<String, dynamic>;
            return{
              'id':doc.id,
              'note':data['notes'],
              'timestamp':data['timestamp']
            };
          }).toList();
          return NotesLoaded(notes);
        },
          onError: (_, __) => NotesError("Failed to load notes"),
      );
     } catch (e) {
      emit(NotesError("Error: ${e.toString()}"));
    }
  }
 Future<void> _onAddNotes(AddNote event, Emitter<NotesState> emit) async {
    await notes.add({
      'notes': event.note,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> _onUpdateNotes(UpdateNote event, Emitter<NotesState> emit) async {
    await notes.doc(event.docID).update({
      'notes': event.newNote,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> _onDeleteNotes(DeleteNote event, Emitter<NotesState> emit) async {
    await notes.doc(event.docID).delete();
  }
} 