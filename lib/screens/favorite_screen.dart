import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/jenis_kopi.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<JenisKopi> _favoriteCoffees = [];
  ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorites') ?? [];

    final allCoffees = await _apiService.fetchCoffees();
    setState(() {
      _favoriteCoffees = allCoffees.where((coffee) => favoriteIds.contains(coffee.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Coffees'),
      ),
      body: _favoriteCoffees.isEmpty
          ? Center(child: Text('No favorite coffees'))
          : ListView.builder(
        itemCount: _favoriteCoffees.length,
        itemBuilder: (context, index) {
          final coffee = _favoriteCoffees[index];
          return ListTile(
            title: Text(coffee.name ?? 'No Name'),
            subtitle: Text(coffee.region ?? 'No Region'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(coffee: coffee),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
