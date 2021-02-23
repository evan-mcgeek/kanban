import 'dart:convert';
import 'package:kanban/src/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kanban/src/models/card_for_listing.dart';

const API = 'https://trello.backend.tests.nekidaem.ru/api/v1';
Future<String> attemptLogIn(String username, String password) async {
  var response = await http.post("$API/users/login/",
      body: {"username": username, "password": password});
  if (response.statusCode == 200) return response.body;

  return null;
}

class KanbanService {
  dynamic jsonDecodeUtf8(List<int> codeUnits,
          {Object reviver(Object key, Object value)}) =>
      json.decode(utf8.decode(codeUnits), reviver: reviver);

  Future<APIResponse<List<CardForListing>>> getCardsList() async {
    return http.get(API + '/cards/', headers: {
      "Authorization": "JWT ${await FlutterSecureStorage().read(key: "jwt")}"
    }).then((data) {
      if (data.statusCode == 200) {
        //final jsonData = jsonDecode(data.body);
        final jsonData = jsonDecodeUtf8(data.bodyBytes);
        final cards = <CardForListing>[];
        for (var item in jsonData) {
          cards.add(CardForListing.fromJson(item));
        }
        cards.sort(CardForListing().sortById);

        return APIResponse<List<CardForListing>>(data: cards);
      }
      print(data.statusCode);
      return APIResponse<List<CardForListing>>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<CardForListing>>(
        error: true, errorMessage: 'An error occured'));
  }
}
