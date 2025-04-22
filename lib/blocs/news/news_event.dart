import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNews extends NewsEvent {}

class AddNew extends NewsEvent {
  final String tiles;
  final String content;
  final String img;

  const AddNew(this.tiles, this.content, this.img);

  @override
  List<Object?> get props => [tiles, content, img];
}

class UpdateNew extends NewsEvent {
  final String docID;
  final String tiles;
  final String content;
  final String img;

  const UpdateNew(this.docID, this.tiles, this.content, this.img);

  @override
  List<Object?> get props => [docID, tiles, content, img];
}

class DeleteNew extends NewsEvent {
  final String docID;

  const DeleteNew(this.docID);

  @override
  List<Object?> get props => [docID];
}
