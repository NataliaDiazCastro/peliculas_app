import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  //
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';
  final String _token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYmY3MTQyNDMzZDRlOGMwMzE5NmFmYTA4YWNiODYxYiIsInN1YiI6IjY0NzBlYmMyMzM2ZTAxMDBlODBjNjY5MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Ef0DEaSUu56YCLyz2bFln0EsUEaWVu1zeY0-_Cu53LM';
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> topRatedMovies = [];
  List<Movie> upcomingMovies = [];
//
  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;
  int _topRatedPage = 0;
  int _upcomingPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );
  //
  final StreamController<List<Movie>> _suggestionsStreamController =
      new StreamController.broadcast();
  Stream<List<Movie>> get suggestionsStream =>
      _suggestionsStreamController.stream;
  //

  MoviesProvider() {
    print('MoviesProvider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
    getTopRatedMovies();
    getUpcomingMovies();
  }

  Future<String> _getJsonData(String segment, [int page = 1]) async {
    final url =
        Uri.https(_baseUrl, segment, {'language': _language, 'page': '$page'});

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    });

    return response.body;
  }

  //
  //* Funcion encargada de traer la información de la API, de las peliculas del momento
  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  //* Funcion encargada de obtener las peliculas populares
  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    // print(popularMovies[0]);
    notifyListeners();
  }

  //* Funcion encargada de obtener las peliculas maás votadas
  getTopRatedMovies() async {
    _topRatedPage++;
    final jsonData = await _getJsonData('3/movie/top_rated', _topRatedPage);

    final topRatedResponse = TopRatedResponse.fromJson(jsonData);
    topRatedMovies = [...topRatedMovies, ...topRatedResponse.results];
    // print(topRatedMovies[0]);
    notifyListeners();
  }

//* Funcion encargada de obtener las peliculas maás votadas
  getUpcomingMovies() async {
    _upcomingPage++;
    final jsonData = await _getJsonData('3/movie/upcoming', _upcomingPage);

    final upcomingResponse = UpcomingResponse.fromJson(jsonData);
    upcomingMovies = [...upcomingMovies, ...upcomingResponse.results];
    // print(topRatedMovies[0]);
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    //TODO: revisar el mapa
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');

    final credistResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = credistResponse.cast;
    return credistResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(
        _baseUrl, '3/search/movie', {'language': _language, 'query': query});

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    });

    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('TEnemos valor a buscar: $value');
      final results = await searchMovies(value);
      _suggestionsStreamController.add(results);
      final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
        debouncer.value = searchTerm;
      });

      Future.delayed(Duration(milliseconds: 301))
          .then((value) => timer.cancel());
    };
  }
}
