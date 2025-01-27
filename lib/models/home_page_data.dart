import 'package:riverpod_app/models/pokemon.dart';

class HomePageData {
  PokemonModel? data;
  HomePageData({required this.data});

  HomePageData.initial() : data = null;

  HomePageData copyWith({PokemonModel? data}) {
    return HomePageData(data: data ?? this.data);
  }
}
