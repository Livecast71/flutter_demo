import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final List<String> _words = [
    'apple',
    'banana',
    'cherry',
    'date',
    'elderberry',
    'fig',
    'grape',
    'honeydew',
  ];
  late List<String> _randomWords;
  final Set<String> _favorites = {};
  final Map<String, Color> _wordColors = {};
  late TabController _tabController;
  int _currentIndex = 0;

  final Random _random = Random();

  Color _getRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1.0,
    );
  }

  void _toggleFavorite(String word) {
    setState(() {
      if (_favorites.contains(word)) {
        _favorites.remove(word);
      } else {
        _favorites.add(word);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _randomWords = List.from(_words)..shuffle(_random);
    _tabController = TabController(length: 2, vsync: this);
    // Generate colors for each word
    for (var word in _randomWords) {
      _wordColors[word] = _getRandomColor();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildWordItem(String word, bool isFavorite) {
    final color = _wordColors[word] ?? Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () => _toggleFavorite(word),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  word,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'dit is een random list',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: _randomWords.map((word) {
                return _buildWordItem(word, _favorites.contains(word));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesView() {
    final favoriteWords = _randomWords.where((word) => _favorites.contains(word)).toList();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Favorites (${favoriteWords.length})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          favoriteWords.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'No favorites yet!\nTap on items in the list to add them.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView(
                    children: favoriteWords.map((word) {
                      return _buildWordItem(word, true);
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildListView(),
          _buildFavoritesView(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            tabs: const [
              Tab(icon: Icon(Icons.list), text: 'List'),
              Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
            ],
          ),
        ),
      ),
    );
  }
}
