import 'dart:convert';
import 'package:kanban/src/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kanban/src/models/card_for_listing.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const url = 'https://trello.backend.tests.nekidaem.ru/api/v1';
final storage = FlutterSecureStorage();
var jwt = storage.read(key: "jwt");

var headers = {
  "Content-Type": "application/json",
  'Accept': "application/json",
  "Authorization": "JWT ${jwt.toString().split(' ,').join('.')}"
};

class KanbanService {
  Future<APIResponse<List<CardForListing>>> getCardsList() {
    return http.get('$url/cards/', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        final cards = <CardForListing>[];
        for (var item in jsonData) {
          cards.add(CardForListing.fromJson(item));
        }
        return APIResponse<List<CardForListing>>(data: cards);
      }

      return APIResponse<List<CardForListing>>(
          error: true, errorMessage: 'An error appeared');
    }).catchError((_) => APIResponse<List<CardForListing>>(
        error: true, errorMessage: 'An error occured'));
  }
}
