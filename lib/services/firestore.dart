import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
//Get notes
final CollectionReference notes=
FirebaseFirestore.instance.collection('notes');
//Create
Future<void> addNote(String note){
  return notes.add({
    'notes':note,
    'timestamp':Timestamp.now(),
  });
}
//Read
Stream<QuerySnapshot>getNotesStream(){
  final noteStream= notes.orderBy('timestamp',descending: true).snapshots();
  return noteStream;
}
//Update
Future<void> updateNote(String docID,String newNote){
  return notes.doc(docID).update({
    'notes':newNote,
    'timestamp':Timestamp.now(),
  });
}
//Delete
Future<void> deleteNote(String docID){
  return notes.doc(docID).delete();
}
}