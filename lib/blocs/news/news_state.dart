import 'package:equatable/equatable.dart';
import 'package:fptapp/models/news_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> newsList;

  const NewsLoaded(this.newsList);

  @override
  List<Object?> get props => [newsList];
}

class NewsError extends NewsState {
  final String error;

  const NewsError(this.error);

  @override
  List<Object?> get props => [error];
}
