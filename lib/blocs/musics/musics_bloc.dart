import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fptapp/blocs/musics/musics_event.dart';
import 'package:fptapp/blocs/musics/musics_state.dart';
import 'package:fptapp/models/musics_model.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final CollectionReference musics = FirebaseFirestore.instance.collection('musics');

  MusicBloc() : super(MusicInitial()) {
    on<LoadMusic>(_onLoadMusic);
    on<AddMusic>(_onAddMusic);
    on<DeleteMusic>(_onDeleteMusic);
    on<UpdateMusic>(_onUpdateMusic);
  }

  Future<void> _onLoadMusic(LoadMusic event, Emitter<MusicState> emit) async {
    emit(MusicLoading());
    try {
      final snapshots = musics.snapshots();
      await emit.forEach<QuerySnapshot>(
        snapshots,
        onData: (snapshots) {
          final musicList = snapshots.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Musics.fromMap(doc.id, data);
          }).toList();
          return MusicLoaded(musicList);
        },
        onError: (_, __) => MusicError("Failed to load musics"),
      );
    } catch (e) {
      emit(MusicError("Error: ${e.toString()}"));
    }
  }

  Future<void> _onAddMusic(AddMusic event, Emitter<MusicState> emit) async {
    await musics.add({
      'tiles': event.tiles,
      'filename': event.filename,
    });
  }

  Future<void> _onDeleteMusic(DeleteMusic event, Emitter<MusicState> emit) async {
    await musics.doc(event.docID).delete();
  }

  Future<void> _onUpdateMusic(UpdateMusic event, Emitter<MusicState> emit) async {
    await musics.doc(event.docID).update({
      'tiles': event.tiles,
      'filename': event.filename,
    });
  }
}
