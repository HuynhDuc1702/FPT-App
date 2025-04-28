import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object?> get props => [];
}

class LoadMusic extends MusicEvent {}

class AddMusic extends MusicEvent {
  final String tiles;
  final String filename;

  const AddMusic(this.tiles, this.filename);

  @override
  List<Object?> get props => [tiles, filename];
}

class UpdateMusic extends MusicEvent {
  final String docID;
  final String tiles;
  final String filename;

  const UpdateMusic(this.docID, this.tiles, this.filename);

  @override
  List<Object?> get props => [docID, tiles, filename];
}

class DeleteMusic extends MusicEvent {
  final String docID;

  const DeleteMusic(this.docID);

  @override
  List<Object?> get props => [docID];
}
