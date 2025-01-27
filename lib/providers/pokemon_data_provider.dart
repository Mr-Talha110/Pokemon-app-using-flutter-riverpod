import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_app/models/pokemon.dart';
import 'package:riverpod_app/services/dio_service.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>(
  (ref, url) async {
    DioService dioService = GetIt.instance.get<DioService>();
    Response? response = await dioService.get(url);
    if (response != null) {
      return pokemonFromJson(jsonEncode(response.data));
    }
    return null;
  },
);
final favouritePokemonsProvider = StateNotifierProvider((ref) {
  return FavouritePokemonsController([]);
});

class FavouritePokemonsController extends StateNotifier<List<String>> {
  FavouritePokemonsController(super._state) {
    _setup();
  }

  _setup() {}
}
