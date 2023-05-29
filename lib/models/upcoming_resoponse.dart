// To parse this JSON data, do
//
//     final upcomingResponse = upcomingResponseFromMap(jsonString);

import 'dart:convert';

import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/movie.dart';

class UpcomingResponse {
  Dates dates;
  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  UpcomingResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory UpcomingResponse.fromJson(String str) =>
      UpcomingResponse.fromMap(json.decode(str));

  factory UpcomingResponse.fromMap(Map<String, dynamic> json) =>
      UpcomingResponse(
        dates: Dates.fromMap(json["dates"]),
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
