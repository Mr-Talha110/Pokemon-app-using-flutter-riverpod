import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_app/models/pokemon.dart';
import 'package:riverpod_app/services/dio_service.dart';
import 'package:riverpod_app/services/local_database.dart';

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
final favouritePokemonsProvider =
    StateNotifierProvider<FavouritePokemonsController, List<String>>((ref) {
  return FavouritePokemonsController([]);
});

class FavouritePokemonsController extends StateNotifier<List<String>> {
  final LocalDatabase localDatabase = GetIt.instance.get<LocalDatabase>();
  FavouritePokemonsController(super._state) {
    _setup();
  }

  _setup() async {
    List<String> favPokemons = await LocalDatabase().getList('fav-pokemon');
    state = favPokemons; 
  }

  void addFavouritePokemon(String url) async {
    state = [...state, url];
    localDatabase.saveList('fav-pokemon', state);
  }

  void removeFavouritePokemon(String url) async {
    state = state.where((e) => e != url).toList();
    localDatabase.saveList('fav-pokemon', state);
  }
}
