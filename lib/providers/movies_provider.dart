import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  //
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';
  final String _token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYmY3MTQyNDMzZDRlOGMwMzE5NmFmYTA4YWNiODYxYiIsInN1YiI6IjY0NzBlYmMyMzM2ZTAxMDBlODBjNjY5MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Ef0DEaSUu56YCLyz2bFln0EsUEaWVu1zeY0-_Cu53LM';
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  int _popularPage = 0;

  //

  MoviesProvider() {
    print('MoviesProvider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String segment, [int page = 1]) async {
    var url =
        Uri.https(_baseUrl, segment, {'language': _language, 'page': '$page'});

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    });

    return response.body;
  }

  //
  // Funcion encargada de traer la información de la API, de las peliculas del momento
  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  //
  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    print(popularMovies[0]);
    notifyListeners();
  }
}
