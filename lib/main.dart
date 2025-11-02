import 'package:flutter/material.dart';
import 'dart:math';
import 'models/confetti_particle.dart';
import 'widgets/confetti_painter.dart';
import 'widgets/word_item.dart';
import 'services/app_group_storage.dart';

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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
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
  final List<ConfettiParticle> _confettiParticles = [];
  late AnimationController _confettiController;
  late AnimationController _fabController;
  final Random _random = Random();

  Color _getRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1.0,
    );
  }

  void _toggleFavorite(String word) async {
    final wasFavorite = _favorites.contains(word);
    setState(() {
      if (wasFavorite) {
        _favorites.remove(word);
      } else {
        _favorites.add(word);
        _startConfettiAnimation();
        _fabController.forward(from: 0.0).then((_) {
          _fabController.reverse();
        });
      }
    });
    // Save to app group storage
    await AppGroupStorage.saveFavorites(_favorites.toList());
  }

  void _startConfettiAnimation() {
    _confettiParticles.clear();
    for (int i = 0; i < 30; i++) {
      _confettiParticles.add(ConfettiParticle(_random));
    }
    _confettiController.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();
    _randomWords = List.from(_words)..shuffle(_random);
    _tabController = TabController(length: 2, vsync: this);
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _confettiParticles.clear();
          });
        }
      });
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Generate colors for each word
    for (var word in _randomWords) {
      _wordColors[word] = _getRandomColor();
    }
    // Load favorites from app group storage
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final savedFavorites = await AppGroupStorage.loadFavorites();
    if (mounted) {
      setState(() {
        _favorites.addAll(savedFavorites);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _confettiController.dispose();
    _fabController.dispose();
    super.dispose();
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
            child: Stack(
              children: [
                ListView(
                  children: _randomWords.map((word) {
                    return WordItem(
                      word: word,
                      isFavorite: _favorites.contains(word),
                      color: _wordColors[word] ?? Colors.grey,
                      onTap: () => _toggleFavorite(word),
                    );
                  }).toList(),
                ),
                if (_confettiParticles.isNotEmpty)
                  IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _confettiController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: ConfettiPainter(
                            _confettiParticles,
                            _confettiController.value,
                          ),
                          size: MediaQuery.of(context).size,
                        );
                      },
                    ),
                  ),
              ],
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
                      return WordItem(
                        word: word,
                        isFavorite: true,
                        color: _wordColors[word] ?? Colors.grey,
                        onTap: () => _toggleFavorite(word),
                      );
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
      floatingActionButton: AnimatedBuilder(
        animation: _fabController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_fabController.value * 0.2),
            child: Transform.rotate(
              angle: _fabController.value * 0.5,
              child: FloatingActionButton(
                onPressed: () async {
                  setState(() {
                    _favorites.clear();
                    _confettiParticles.clear();
                  });
                  // Clear from app group storage
                  await AppGroupStorage.clearFavorites();
                },
                backgroundColor: Colors.deepPurple,
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
            ),
          );
        },
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
