import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/controllers/home_page_controller.dart';
import 'package:riverpod_app/models/home_page_data.dart';
import 'package:riverpod_app/models/pokemon.dart';
import 'package:riverpod_app/providers/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>(
  (ref) => HomePageController(HomePageData.initial()),
);

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  // late HomePageController _homePageController;
  late HomePageData _homePageData;

  @override
  Widget build(BuildContext context) {
    // _homePageController =
    ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: _homePageData.data == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SafeArea(
                    child: Text(
                      'All pokemons',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _homePageData.data?.results.length ?? 0,
                      itemBuilder: (context, index) => PokemonItem(
                        url: _homePageData.data!.results[index].url,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class PokemonItem extends ConsumerWidget {
  final String url;
  const PokemonItem({super.key, required this.url});

  @override
  Widget build(BuildContext context, ref) {
    final pokemon = ref.watch(pokemonDataProvider(url));
    return pokemon.when(
      data: (data) {
        return PokemonDetailItem(
          pokemon: data,
          isLoading: false,
        );
      },
      error: (error, stackTrace) {
        return Text('ERROR $error');
      },
      loading: () {
        return const PokemonDetailItem(
          pokemon: null,
          isLoading: true,
        );
      },
    );
  }
}

class PokemonDetailItem extends StatelessWidget {
  final Pokemon? pokemon;
  final bool isLoading;
  const PokemonDetailItem({
    super.key,
    required this.pokemon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            pokemon != null
                ? CircleAvatar(
                    backgroundImage:
                        NetworkImage(pokemon!.sprites.frontDefault),
                  )
                : const CircleAvatar(
                    radius: 10,
                  ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon?.forms.first.name ?? 'dummy data',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Has ${pokemon?.abilities.length} moves ',
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.favorite,
              size: 20,
              color: Colors.redAccent,
            )
          ],
        ),
      ),
    );
  }
}
