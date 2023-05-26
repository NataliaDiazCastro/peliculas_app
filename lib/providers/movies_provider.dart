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

  //

  MoviesProvider() {
    print('MoviesProvider inicializado');

    this.getOnDisplayMovies();
  }

  //
  // Funcion encargada de traer la información de la API, de las peliculas del momento
  getOnDisplayMovies() async {
    var url = Uri.https(
        _baseUrl, '3/movie/now_playing', {'language': _language, 'page': '1'});

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    });

    final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }
}
