import 'package:flutter/material.dart';
import '../models/jenis_kopi.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<JenisKopi> _coffeeList = [];
  List<JenisKopi> _filteredCoffeeList = [];
  TextEditingController _searchController = TextEditingController();
  ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchCoffee();
    _searchController.addListener(_filterCoffee);
  }

  Future<void> _fetchCoffee() async {
    try {
      List<JenisKopi> coffees = await _apiService.fetchCoffees();
      setState(() {
        _coffeeList = coffees;
        _filteredCoffeeList = coffees;
      });
    } catch (e) {
      print('Failed to load coffees: $e');
    }
  }

  void _filterCoffee() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCoffeeList = _coffeeList.where((coffee) {
        return coffee.name?.toLowerCase().contains(query) ?? false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee Types'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredCoffeeList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _filteredCoffeeList.length,
              itemBuilder: (context, index) {
                final coffee = _filteredCoffeeList[index];
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
          ),
        ],
      ),
    );
  }
}
