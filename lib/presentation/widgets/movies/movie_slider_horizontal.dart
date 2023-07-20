import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieSliderHorizontal extends StatefulWidget {
  const MovieSliderHorizontal(
      {super.key,
      required this.movies,
      this.title,
      this.subtitle,
      this.loadNextPage});

  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  @override
  State<MovieSliderHorizontal> createState() => _MovieSliderHorizontalState();
}

class _MovieSliderHorizontalState extends State<MovieSliderHorizontal> {
  final scrollControler = ScrollController();

  @override
  void initState() {
    
    super.initState();

    scrollControler.addListener(() {
      if (widget.loadNextPage == null) return;

      if (scrollControler.position.pixels + 200 >=
          scrollControler.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null)
            _Title(title: widget.title, subtitle: widget.subtitle),
          Expanded(
              child: ListView.builder(
            controller: scrollControler,
            itemCount: widget.movies.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                FadeInRight(child: _Slide(movie: widget.movies[index])),
          ))
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  width: 150,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2));
                    }
                    return GestureDetector(
                      onTap: () =>  context.push('/movie/${movie.id}'),
                      child: FadeIn(child: child)
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 150,
              child: Text(
                movie.title,
                maxLines: 2,
                style: textStyle.titleSmall,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star_outlined, color: Colors.amber),
                const SizedBox(width: 3),
                Text('${movie.voteAverage}',
                    style: textStyle.bodyMedium!.copyWith(color: Colors.amber)),
                const SizedBox(width: 10),
                Text(HumanFormat.number(movie.popularity),
                    style: textStyle.bodySmall)
              ],
            )
          ],
        ));
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;
  const _Title({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null) Text(title!, style: textStyle),
          const Spacer(),
          if (subtitle != null)
            FilledButton.tonal(
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                onPressed: () {},
                child: Text(subtitle!))
        ],
      ),
    );
  }
}
