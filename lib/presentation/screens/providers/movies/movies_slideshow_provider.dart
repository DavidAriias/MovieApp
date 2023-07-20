import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/screens/providers/movies/movies_providers.dart';


final movieSlideShowProvider = Provider<List<Movie>>((ref) {
  final movies = ref.watch(nowPlayingMoviesProvider);

  if (movies.isEmpty) return [];

  return movies.sublist(0, 6);
});
