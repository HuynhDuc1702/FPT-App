import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fptapp/blocs/news/news_event.dart';
import 'package:fptapp/blocs/news/news_state.dart';
import 'package:fptapp/models/news_model.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final CollectionReference news = FirebaseFirestore.instance.collection('news');

  NewsBloc() : super(NewsInitial()) {
    on<LoadNews>(_onLoadNews);
    on<AddNew>(_onAddNews);
    on<DeleteNew>(_onDeleteNews);
    on<UpdateNew>(_onUpdateNews);
  }

  Future<void> _onLoadNews(LoadNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final snapshots = news.snapshots();
      await emit.forEach<QuerySnapshot>(
        snapshots,
        onData: (snapshots) {
          final newss = snapshots.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return News.fromMap(doc.id, data);
          }).toList();
          return NewsLoaded(newss);
        },
        onError: (_, __) => NewsError("Failed to load news"),
      );
    } catch (e) {
      emit(NewsError("Error: ${e.toString()}"));
    }
  }

  Future<void> _onAddNews(AddNew event, Emitter<NewsState> emit) async {
    await news.add({
      'tiles': event.tiles,
      'content': event.content,
      'img': event.img,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _onDeleteNews(DeleteNew event, Emitter<NewsState> emit) async {
    await news.doc(event.docID).delete();
  }

  Future<void> _onUpdateNews(UpdateNew event, Emitter<NewsState> emit) async {
    await news.doc(event.docID).update({
      'tiles': event.tiles,
      'content': event.content,
      'img': event.img,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
