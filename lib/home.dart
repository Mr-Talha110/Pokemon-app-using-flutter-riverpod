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
    final favouritePokemon = ref.watch(favouritePokemonsProvider);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SafeArea(
                    child: Text(
                      'Favourite pokemons',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.43,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: favouritePokemon.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final pokemon = ref.watch(pokemonDataProvider(
                            _homePageData.data!.results[index].url));
                        return Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.40),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: pokemon.when(
                            data: (data) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const Spacer(),
                                  CircleAvatar(
                                    radius: 30,
                                    child: Image.network(
                                      data.sprites.frontDefault,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${data.abilities.length} moves',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                      )
                                    ],
                                  )
                                ],
                              );
                            },
                            error: (error, stackTrace) {
                              return Text('Error $error');
                            },
                            loading: () {
                              return const Skeletonizer(
                                enabled: true,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'data!.name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Spacer(),
                                    CircleAvatar(
                                      radius: 30,
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          ' moves',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'All pokemons',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
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
  const PokemonItem({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context, ref) {
    final favouritePokemonsController =
        ref.watch(favouritePokemonsProvider.notifier);
    final favouritePokemon = ref.watch(favouritePokemonsProvider);
    final pokemon = ref.watch(pokemonDataProvider(url));
    return pokemon.when(
      data: (data) {
        return PokemonDetailItem(
          favouritePokemonsController: favouritePokemonsController,
          url: url,
          favouritePokemon: favouritePokemon,
          pokemon: data,
          isLoading: false,
        );
      },
      error: (error, stackTrace) {
        return Text('ERROR $error');
      },
      loading: () {
        return PokemonDetailItem(
          favouritePokemonsController: favouritePokemonsController,
          url: url,
          pokemon: null,
          favouritePokemon: favouritePokemon,
          isLoading: true,
        );
      },
    );
  }
}

class PokemonDetailItem extends StatelessWidget {
  final Pokemon? pokemon;
  final String url;
  final bool isLoading;
  final List<String> favouritePokemon;
  final FavouritePokemonsController favouritePokemonsController;
  const PokemonDetailItem({
    super.key,
    required this.pokemon,
    required this.isLoading,
    required this.favouritePokemon,
    required this.url,
    required this.favouritePokemonsController,
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
            IconButton(
                onPressed: () {
                  if (favouritePokemon.contains(url)) {
                    favouritePokemonsController.removeFavouritePokemon(url);
                    return;
                  }
                  favouritePokemonsController.addFavouritePokemon(url);
                },
                icon: Icon(
                  favouritePokemon.contains(url)
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  size: 20,
                  color: Colors.redAccent,
                ))
          ],
        ),
      ),
    );
  }
}
