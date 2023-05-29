import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final moviesProvider = Provider.of<MoviesProvider>(context);
    // print(moviesProvider.onDisplayMovies);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Películas en Cines'),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search_outlined),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Tarjetas principales
              CardSwipper(movies: moviesProvider.onDisplayMovies),

              // Slider de peliculas
              MovieSlider(
                movies: moviesProvider.popularMovies,
                title: 'Populares',
                onNextPage: () => moviesProvider.getPopularMovies(),
              ),
              // Slider de peliculas
              MovieSlider(
                movies: moviesProvider.topRatedMovies,
                title: 'Más Votadas',
                onNextPage: () => moviesProvider.getTopRatedMovies(),
              ),
              MovieSlider(
                movies: moviesProvider.upcomingMovies,
                title: 'Próximos Estrenos',
                onNextPage: () => moviesProvider.getUpcomingMovies(),
              ),
              // MovieSlider(),
              // MovieSlider()
            ],
          ),
        ));
  }
}
