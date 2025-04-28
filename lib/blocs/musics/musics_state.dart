import 'package:equatable/equatable.dart';
import 'package:fptapp/models/musics_model.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object?> get props => [];
}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicLoaded extends MusicState {
  final List<Musics> musicList;

  const MusicLoaded(this.musicList);

  @override
  List<Object?> get props => [musicList];
}

class MusicError extends MusicState {
  final String error;

  const MusicError(this.error);

  @override
  List<Object?> get props => [error];
}
