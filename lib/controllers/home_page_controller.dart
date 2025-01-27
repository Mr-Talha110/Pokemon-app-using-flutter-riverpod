import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_app/models/home_page_data.dart';
import 'package:riverpod_app/models/pokemon.dart';
import 'package:riverpod_app/services/dio_service.dart';

class HomePageController extends StateNotifier<HomePageData> {
  HomePageController(super._state) {
    _dioService = GetIt.instance<DioService>();
    //THIS IS GONNA CALLED ON INIT
    _setup();
  }

  late DioService _dioService;
  List<PokemonResult> pokemons = [];

  _setup() async {
    await loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? response = await _dioService
          .get('https://pokeapi.co/api/v2/pokemon?limit=500&offset=0');
      if (response != null) {
        PokemonModel pokemonData =
            pokemonModelFromJson(jsonEncode(response.data));
        pokemons = pokemonData.results;
        state = state.copyWith(data: pokemonData);
      }
      return;
    }
  }
}
