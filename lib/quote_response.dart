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
      results = new List<Quote>();
      json['results'].forEach((v) {
        results.add(new Quote.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total_results'] = this.totalResults;
    data['total_pages'] = this.totalPages;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vote_count'] = this.voteCount;
    data['id'] = this.id;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['title'] = this.title;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['genre_ids'] = this.genreIds;
    data['backdrop_path'] = this.backdropPath;
    data['adult'] = this.adult;
    data['overview'] = this.overview;
    data['release_date'] = this.releaseDate;
    return data;
  }
}
