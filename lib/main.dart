import 'package:flutter/material.dart';

void main() {
  runApp(const BeanAndBloomApp());
}

const Color cream = Color(0xFFFAF7F0);
const Color coffeeBrown = Color(0xFF493629);
const Color sageGreen = Color(0xFF789477);
const Color softGreen = Color(0xFFE8EEE3);

class BeanAndBloomApp extends StatelessWidget {
  const BeanAndBloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bean & Bloom',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: sageGreen),
        fontFamily: 'Arial',
      ),
      home: const MenuPage(),
    );
  }
}

class MenuItem {
  final String name;
  final String category;
  final String description;
  final String price;
  final String image;

  const MenuItem({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.image,
  });
}

const List<MenuItem> menuItems = [
  MenuItem(
    name: 'Iced Latte',
    category: 'Coffee',
    description: 'Smooth espresso & fresh milk',
    price: 'RM 12.00',
    image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=700',
  ),
  MenuItem(
    name: 'Iced Matcha',
    category: 'Matcha',
    description: 'Earthy matcha & creamy milk',
    price: 'RM 13.00',
    image: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?auto=format&fit=crop&w=700&q=80',
  ),
  MenuItem(
    name: 'Cappuccino',
    category: 'Coffee',
    description: 'Espresso with silky foam',
    price: 'RM 10.00',
    image: 'https://images.unsplash.com/photo-1534778101976-62847782c213?w=700',
  ),
  MenuItem(
    name: 'Caramel Latte',
    category: 'Coffee',
    description: 'Espresso with caramel sweetness',
    price: 'RM 14.00',
    image: 'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=700',
  ),
  MenuItem(
    name: 'Matcha Cloud',
    category: 'Matcha',
    description: 'Creamy matcha with a soft finish',
    price: 'RM 15.00',
    image: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=700',
  ),
  MenuItem(
    name: 'Iced Peach Tea',
    category: 'Tea',
    description: 'Refreshing tea with peach notes',
    price: 'RM 9.00',
    image: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=700',
  ),
];

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int selectedTab = 0;
  String selectedCategory = 'All';
  String searchQuery = '';

  final Set<String> favourites = {};
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = ['All', 'Coffee', 'Matcha', 'Tea'];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void changeTab(int index) {
    setState(() {
      selectedTab = index;
      if (index == 1) {
        searchQuery = '';
        searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: selectedTab == 3 ? buildProfile() : buildMenuContent(),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: softGreen,
        selectedIndex: selectedTab,
        onDestinationSelected: changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildMenuContent() {
    final isFavourites = selectedTab == 2;

    final filteredItems = menuItems.where((item) {
      final matchesCategory =
          selectedCategory == 'All' || item.category == selectedCategory;

      final matchesSearch =
          item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesFavourite = !isFavourites || favourites.contains(item.name);

      return matchesCategory && matchesSearch && matchesFavourite;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1100
            ? 4
            : width >= 750
            ? 3
            : 2;

        final horizontalPadding = width >= 750 ? 32.0 : 18.0;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    const SizedBox(height: 28),
                    if (selectedTab == 0) ...[
                      const Text(
                        'Find your',
                        style: TextStyle(
                          fontSize: 32,
                          height: 1.1,
                          color: coffeeBrown,
                        ),
                      ),
                      const Text(
                        'daily brew.',
                        style: TextStyle(
                          fontSize: 38,
                          height: 1.2,
                          color: coffeeBrown,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'A little cup of happiness, just for you.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 22),
                      buildPromotion(),
                      const SizedBox(height: 26),
                    ] else if (selectedTab == 1) ...[
                      const Text(
                        'Find your favourite.',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: coffeeBrown,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() => searchQuery = value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search drinks...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                    ] else ...[
                      const Text(
                        'Your favourites',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: coffeeBrown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The drinks you love, all in one place.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 22),
                    ],
                    const Text(
                      'Our menu',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: coffeeBrown,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          final selected = selectedCategory == category;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: selected,
                              showCheckmark: false,
                              selectedColor: sageGreen,
                              backgroundColor: Colors.white,
                              side: BorderSide.none,
                              labelStyle: TextStyle(
                                color: selected ? Colors.white : coffeeBrown,
                                fontWeight: FontWeight.w600,
                              ),
                              onSelected: (_) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            if (filteredItems.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFavourites
                              ? Icons.favorite_border_rounded
                              : Icons.search_off_rounded,
                          size: 48,
                          color: sageGreen,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isFavourites
                              ? 'No favourites yet'
                              : 'No drinks found',
                          style: const TextStyle(
                            color: coffeeBrown,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Try another category or explore our menu.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  24,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = filteredItems[index];
                    return buildProductCard(item, width);
                  }, childCount: filteredItems.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: width < 400 ? 258 : 290,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: softGreen,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.local_cafe_rounded,
            color: sageGreen,
            size: 27,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BEAN & BLOOM',
                style: TextStyle(
                  color: coffeeBrown,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Coffee, made with love.',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'View favourites',
          onPressed: () => changeTab(2),
          icon: const Icon(Icons.favorite_border_rounded, color: coffeeBrown),
        ),
      ],
    );
  }

  Widget buildPromotion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: softGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR DAILY MOMENT',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.4,
                    color: sageGreen,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Slow down.\nSip something lovely.',
                  style: TextStyle(
                    color: coffeeBrown,
                    fontSize: 19,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.coffee_rounded, size: 60, color: sageGreen),
        ],
      ),
    );
  }

  Widget buildProductCard(MenuItem item, double width) {
    final isFavourite = favourites.contains(item.name);

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: softGreen,
                      child: const Center(
                        child: Icon(
                          Icons.local_cafe_rounded,
                          size: 48,
                          color: sageGreen,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: isFavourite
                          ? 'Remove from favourites'
                          : 'Add to favourites',
                      iconSize: 20,
                      constraints: const BoxConstraints(
                        minWidth: 38,
                        minHeight: 38,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          if (isFavourite) {
                            favourites.remove(item.name);
                          } else {
                            favourites.add(item.name);
                          }
                        });
                      },
                      icon: Icon(
                        isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavourite ? Colors.redAccent : coffeeBrown,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: coffeeBrown,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Text(
                    item.price,
                    style: const TextStyle(
                      color: sageGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: softGreen,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.local_cafe_rounded,
                size: 54,
                color: sageGreen,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Bean & Bloom',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: coffeeBrown,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your little corner for coffee and comfort.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => changeTab(2),
              icon: const Icon(Icons.favorite_border_rounded),
              label: const Text('View my favourites'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: sageGreen),
              onPressed: () => changeTab(0),
              icon: const Icon(Icons.local_cafe_rounded),
              label: const Text('Explore the menu'),
            ),
          ],
        ),
      ),
    );
  }
}
