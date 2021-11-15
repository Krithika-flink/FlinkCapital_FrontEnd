class QuoteResponse {
  int page;
  int totalResults;
  int totalPages;
  List<Quote> results;

  QuoteResponse({this.page, this.totalResults, this.totalPages, this.results});

  QuoteResponse.fromJson(Map<String, dynamic> json) {
    page = json['page'] as int;
    totalResults = json['total_results'] as int;
    totalPages = json['total_pages'] as int;
    if (json['results'] != null) {
      // ignore: deprecated_member_use
      results = <Quote>[];
      json['results'].forEach((v) {
        results.add(Quote.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['page'] = page;
    data['total_results'] = totalResults;
    data['total_pages'] = totalPages;
    if (results != null) {
      data['results'] = results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Quote {
  int voteCount;
  int id;
  bool video;
  var voteAverage;
  String title;
  double popularity;
  String posterPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  String releaseDate;

  Quote(
      {this.voteCount,
      this.id,
      this.video,
      this.voteAverage,
      this.title,
      this.popularity,
      this.posterPath,
      this.originalLanguage,
      this.originalTitle,
      this.genreIds,
      this.backdropPath,
      this.adult,
      this.overview,
      this.releaseDate});

  Quote.fromJson(Map<String, dynamic> json) {
    voteCount = json['vote_count'] as int;
    id = json['id'] as int;
    video = json['video'] as bool;
    voteAverage = json['vote_average'];
    title = json['title'] as String;
    popularity = json['popularity'] as double;
    posterPath = json['poster_path'] as String;
    originalLanguage = json['original_language'] as String;
    originalTitle = json['original_title'] as String;
    genreIds = json['genre_ids'].cast<int>() as List<int>;
    backdropPath = json['backdrop_path'] as String;
    adult = json['adult'] as bool;
    overview = json['overview'] as String;
    releaseDate = json['release_date'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['vote_count'] = voteCount;
    data['id'] = id;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['title'] = title;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    data['original_language'] = originalLanguage;
    data['original_title'] = originalTitle;
    data['genre_ids'] = genreIds;
    data['backdrop_path'] = backdropPath;
    data['adult'] = adult;
    data['overview'] = overview;
    data['release_date'] = releaseDate;
    return data;
  }
}
