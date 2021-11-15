import 'package:gallery/api_base_helper.dart';
import 'package:gallery/quote_response.dart';

class QuoteRepository {
  //final String _apiKey = "78b9f63937763a206bff26c070b94158";

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Quote>> fetchQuoteList() async {
    final response = await _helper.get('quote');
    return QuoteResponse.fromJson(response as Map<String, dynamic>).results;
  }
}
