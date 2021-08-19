import 'dart:async';

import 'package:gallery/api_response.dart';
import 'package:gallery/quote_repository.dart';
import 'package:gallery/quote_response.dart';

class QuoteBloc {
  QuoteRepository _quoteRepository;

  StreamController _quoteListController;

  StreamSink<ApiResponse<List<Quote>>> get quoteListSink {
    var sink1 = _quoteListController.sink;
    return (sink1 as StreamSink<ApiResponse<List<Quote>>>);
  }

  Stream<ApiResponse<List<Quote>>> get quoteListStream {
    var stream = _quoteListController.stream;
    return (stream as Stream<ApiResponse<List<Quote>>>);
  }

  QuoteBloc() {
    _quoteListController = StreamController<ApiResponse<List<Quote>>>();
    _quoteRepository = QuoteRepository();
    fetchQuoteList();
  }

  Future<void> fetchQuoteList() async {
    quoteListSink.add(ApiResponse.loading('Fetching Quotes'));
    try {
      List<Quote> quotes = await _quoteRepository.fetchQuoteList();
      quoteListSink.add(ApiResponse.completed(quotes));
    } catch (e) {
      quoteListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _quoteListController?.close();
  }
}
