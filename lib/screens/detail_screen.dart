import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/jenis_kopi.dart';

class DetailScreen extends StatelessWidget {
  final JenisKopi coffee;

  DetailScreen({required this.coffee});

  Future<void> _toggleFavorite(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteCoffees = prefs.getStringList('favorites') ?? [];

    if (favoriteCoffees.contains(coffee.id)) {
      favoriteCoffees.remove(coffee.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Removed from favorites')));
    } else {
      favoriteCoffees.add(coffee.id!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to favorites')));
    }

    await prefs.setStringList('favorites', favoriteCoffees);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coffee.name ?? 'Coffee Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => _toggleFavorite(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(coffee.imageUrl ?? ''),
            SizedBox(height: 8.0),
            Text(
              coffee.name ?? 'No Name',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              coffee.region ?? 'No Region',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            Text(
              coffee.description ?? 'No Description',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Price: \$${coffee.price?.toStringAsFixed(2) ?? 'N/A'}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Roast Level: ${coffee.roastLevel?.toString() ?? 'N/A'}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Weight: ${coffee.weight?.toString() ?? 'N/A'} g',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Flavor Profile: ${coffee.flavorProfile?.join(', ') ?? 'N/A'}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Grind Option: ${coffee.grindOption?.join(', ') ?? 'N/A'}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
