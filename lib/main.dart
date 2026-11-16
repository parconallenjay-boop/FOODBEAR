import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const FoodBearApp());
}

const _brand = Color(0xFFF15A36);
const _ink = Color(0xFF20231F);
const _muted = Color(0xFF858982);
const _canvas = Color(0xFFFFFCF7);

String _formatPesos(double amount) => '₱${amount.toStringAsFixed(2)}';

class FoodBearApp extends StatelessWidget {
  const FoodBearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodBear',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brand,
          primary: _brand,
          surface: _canvas,
        ),
        fontFamily: 'Roboto',
      ),
      home: const FoodBearHome(),
    );
  }
}

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.emoji,
    this.isPopular = false,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final String emoji;
  final bool isPopular;
}

const _foods = <FoodItem>[
  FoodItem(
    id: 'classic-burger',
    name: 'Classic Smash',
    description: 'Double beef · cheddar · house sauce',
    category: 'Burgers',
    price: 289,
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=700&q=85',
    emoji: '🍔',
    isPopular: true,
  ),
  FoodItem(
    id: 'margherita',
    name: 'Garden Margherita',
    description: 'San Marzano tomato · fresh basil',
    category: 'Pizza',
    price: 325,
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1579751626657-72bc17010498?auto=format&fit=crop&w=700&q=85',
    emoji: '🍕',
  ),
  FoodItem(
    id: 'salmon-roll',
    name: 'Salmon Crunch Roll',
    description: 'Salmon · avocado · sesame',
    category: 'Sushi',
    price: 360,
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=700&q=85',
    emoji: '🍣',
    isPopular: true,
  ),
  FoodItem(
    id: 'green-bowl',
    name: 'Green Goddess Bowl',
    description: 'Avocado · quinoa · citrus dressing',
    category: 'Salads',
    price: 279,
    rating: 4.7,
    imageUrl:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=700&q=85',
    emoji: '🥗',
  ),
  FoodItem(
    id: 'bbq-burger',
    name: 'Smoky BBQ Burger',
    description: 'Angus beef · crispy onion · BBQ',
    category: 'Burgers',
    price: 319,
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?auto=format&fit=crop&w=700&q=85',
    emoji: '🍔',
  ),
  FoodItem(
    id: 'pepperoni',
    name: 'Hot Honey Pepperoni',
    description: 'Pepperoni · chili honey · mozzarella',
    category: 'Pizza',
    price: 389,
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=700&q=85',
    emoji: '🍕',
  ),
];

const _categories = <_Category>[
  _Category('All', '✨'),
  _Category('Burgers', '🍔'),
  _Category('Pizza', '🍕'),
  _Category('Sushi', '🍣'),
  _Category('Salads', '🥗'),
];

class _Category {
  const _Category(this.name, this.emoji);

  final String name;
  final String emoji;
}

class FoodBearHome extends StatefulWidget {
  const FoodBearHome({super.key});

  @override
  State<FoodBearHome> createState() => _FoodBearHomeState();
}

class _FoodBearHomeState extends State<FoodBearHome> {
  final _searchController = TextEditingController();
  final _quantities = <String, int>{};
  final _favorites = <String>{};
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _selectedTab = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _cartCount =>
      _quantities.values.fold(0, (total, quantity) => total + quantity);

  double get _cartTotal {
    return _foods.fold(
      0,
      (total, food) => total + food.price * (_quantities[food.id] ?? 0),
    );
  }

  void _addToCart(FoodItem food) {
    setState(() {
      _quantities.update(food.id, (quantity) => quantity + 1, ifAbsent: () => 1);
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${food.name} added to your bag'),
          duration: const Duration(milliseconds: 1100),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _changeQuantity(FoodItem food, int change) {
    setState(() {
      final quantity = (_quantities[food.id] ?? 0) + change;
      if (quantity <= 0) {
        _quantities.remove(food.id);
      } else {
        _quantities[food.id] = quantity;
      }
    });
  }

  List<FoodItem> get _visibleFoods {
    return _foods.where((food) {
      final matchesCategory =
          _selectedCategory == 'All' || food.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          food.name.toLowerCase().contains(query) ||
          food.description.toLowerCase().contains(query) ||
          food.category.toLowerCase().contains(query);
      final matchesTab = _selectedTab != 1 || _favorites.contains(food.id);
      return matchesCategory && matchesSearch && matchesTab;
    }).toList();
  }

  void _selectTab(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (_selectedTab) {
      1 => 'Your favorites',
      2 => 'Your bag',
      3 => 'Your profile',
      _ => null,
    };

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _selectedTab == 2
            ? _buildCart()
            : _selectedTab == 3
                ? _buildProfile()
                : _buildDiscovery(title),
      ),
      bottomNavigationBar: _buildNavigation(),
    );
  }

  Widget _buildDiscovery(String? title) {
    final foods = _visibleFoods;
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
          sliver: SliverToBoxAdapter(
            child: _selectedTab == 0 ? _buildHeader() : _buildPageTitle(title!),
          ),
        ),
        if (_selectedTab == 0)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
            sliver: SliverToBoxAdapter(child: _buildSearch()),
          ),
        if (_selectedTab == 0)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
            sliver: SliverToBoxAdapter(child: _buildPromoBanner()),
          ),
        if (_selectedTab == 0)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 0),
            sliver: SliverToBoxAdapter(child: _buildSectionHeading()),
          ),
        if (_selectedTab == 0)
          SliverToBoxAdapter(child: _buildCategories()),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(22, _selectedTab == 0 ? 20 : 10, 22, 24),
          sliver: foods.isEmpty
              ? SliverToBoxAdapter(child: _buildEmptyFavorites())
              : SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.crossAxisExtent > 600 ? 3 : 2;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final food = foods[index];
                          return FoodCard(
                            key: ValueKey(food.id),
                            food: food,
                            isFavorite: _favorites.contains(food.id),
                            quantity: _quantities[food.id] ?? 0,
                            onAdd: () => _addToCart(food),
                            onFavorite: () {
                              setState(() {
                                if (!_favorites.add(food.id)) {
                                  _favorites.remove(food.id);
                                }
                              });
                            },
                          );
                        },
                        childCount: foods.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 13,
                        mainAxisExtent: 266,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Image.asset(
            'assets/images/foodbear_icon.png',
            width: 43,
            height: 43,
            fit: BoxFit.cover,
            semanticLabel: 'FoodBear bear logo',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FoodBear',
                style: TextStyle(
                  color: _ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: _brand, size: 13),
                  const SizedBox(width: 4),
                  const Text(
                    'Manila, Philippines',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _CircleAction(
          icon: Icons.notifications_none_rounded,
          onTap: () => _showMessage('You’re all caught up!'),
        ),
      ],
    );
  }

  Widget _buildPageTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: _ink,
          fontSize: 27,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFF0EEE8)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search for a dish or restaurant',
          hintStyle: const TextStyle(color: _muted, fontSize: 13),
          prefixIcon:
              const Icon(Icons.search_rounded, color: _muted, size: 22),
          suffixIcon: _searchQuery.isEmpty
              ? IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: const Icon(Icons.tune_rounded, color: _ink, size: 20),
                )
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: const Icon(Icons.close_rounded, color: _muted, size: 19),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      height: 166,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        gradient: const LinearGradient(
          colors: [Color(0xFFEF6845), Color(0xFFF28B59)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -17,
            top: -30,
            child: Container(
              width: 185,
              height: 185,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.11),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: -34,
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.09),
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'GOOD FOOD, GOOD MOOD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 19,
            top: 42,
            child: Text(
              'Your next\nfavorite bite.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 1.08,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const Positioned(
            left: 19,
            bottom: 34,
            child: Text(
              'Get 20% off your first order',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
          Positioned(
            left: 19,
            bottom: 11,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF292A25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'USE BEAR20',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 2,
            child: Transform.rotate(
              angle: -0.12,
              child: const Text('🍔', style: TextStyle(fontSize: 106)),
            ),
          ),
          Positioned(
            right: 116,
            top: 21,
            child: Transform.rotate(
              angle: 0.18,
              child: const Text('✨', style: TextStyle(fontSize: 21)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hungry?',
                style: TextStyle(
                  color: _ink,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Find something delicious',
                style: TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _selectedCategory = 'All';
              _searchQuery = '';
              _searchController.clear();
            });
          },
          style: TextButton.styleFrom(
            foregroundColor: _brand,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          ),
          child: const Text(
            'See all',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category.name == _selectedCategory;
          return ChoiceChip(
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => setState(() => _selectedCategory = category.name),
            backgroundColor: Colors.white,
            selectedColor: _brand,
            side: BorderSide(
              color: isSelected ? _brand : const Color(0xFFF0EEE8),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            label: Row(
              children: [
                Text(category.emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  category.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    final isFavoriteTab = _selectedTab == 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 75),
      child: Column(
        children: [
          Icon(
            isFavoriteTab
                ? Icons.favorite_border_rounded
                : Icons.search_off_rounded,
            color: _brand,
            size: 39,
          ),
          const SizedBox(height: 13),
          Text(
            isFavoriteTab ? 'Nothing saved just yet' : 'No dishes found',
            style: const TextStyle(
                color: _ink, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            isFavoriteTab
                ? 'Tap the heart on anything you love.'
                : 'Try a different search or category.',
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
          if (isFavoriteTab) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _selectTab(0),
              child: const Text('Explore the menu'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCart() {
    final cartFoods = _foods
        .where((food) => (_quantities[food.id] ?? 0) > 0)
        .toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 23, 22, 12),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Your bag',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              Text(
                '$_cartCount ${_cartCount == 1 ? 'item' : 'items'}',
                style: const TextStyle(color: _muted, fontSize: 13),
              ),
            ],
          ),
        ),
        if (cartFoods.isEmpty)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🛍️', style: TextStyle(fontSize: 58)),
                    const SizedBox(height: 16),
                    const Text(
                      'Your bag is waiting',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Add something tasty and we’ll bring it right to you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _muted, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => _selectTab(0),
                      style: FilledButton.styleFrom(
                        backgroundColor: _brand,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 13),
                      ),
                      child: const Text('Explore the menu'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else ...[
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
              itemCount: cartFoods.length,
              separatorBuilder: (_, _) => const SizedBox(height: 13),
              itemBuilder: (context, index) {
                final food = cartFoods[index];
                return _CartItem(
                  food: food,
                  quantity: _quantities[food.id]!,
                  onDecrease: () => _changeQuantity(food, -1),
                  onIncrease: () => _changeQuantity(food, 1),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0EEE8))),
            ),
            child: Column(
              children: [
                _PriceLine(label: 'Subtotal', amount: _cartTotal),
                const SizedBox(height: 7),
                const Row(
                  children: [
                    Expanded(
                      child: Text('Delivery fee',
                          style: TextStyle(color: _muted, fontSize: 13)),
                    ),
                    Text(
                      'FREE',
                      style: TextStyle(
                        color: Color(0xFF388A5C),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                _PriceLine(
                  label: 'Total',
                  amount: _cartTotal,
                  isTotal: true,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      setState(() => _quantities.clear());
                      _showMessage('Order placed! Your food is on its way 🐻');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _brand,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Place order · ${_formatPesos(_cartTotal)}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProfile() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
      children: [
        const Text(
          'Your profile',
          style: TextStyle(
            color: _ink,
            fontSize: 27,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 23),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF0EEE8)),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: Color(0xFFFFE6D9),
                child: Text('🐻', style: TextStyle(fontSize: 25)),
              ),
              SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alex Morgan',
                      style: TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('alex.morgan@email.com',
                      style: TextStyle(color: _muted, fontSize: 11)),
                ],
              ),
              Spacer(),
              Icon(Icons.chevron_right_rounded, color: _muted),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'ACCOUNT',
          style: TextStyle(
            color: _muted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 9),
        _ProfileRow(
          icon: Icons.receipt_long_outlined,
          title: 'My orders',
          onTap: () => _showMessage('Your recent orders will show up here.'),
        ),
        _ProfileRow(
          icon: Icons.location_on_outlined,
          title: 'Saved addresses',
          onTap: () => _showMessage('Manila, Philippines'),
        ),
        _ProfileRow(
          icon: Icons.payment_rounded,
          title: 'Payment methods',
          onTap: () => _showMessage('No payment methods saved yet.'),
        ),
        _ProfileRow(
          icon: Icons.help_outline_rounded,
          title: 'Help & support',
          onTap: () => _showMessage('We’re here to help!'),
        ),
        const SizedBox(height: 22),
        Center(
          child: Text(
            'FOODBEAR · MADE WITH EXTRA CARE',
            style: TextStyle(
              color: _muted.withValues(alpha: 0.8),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigation() {
    final destinations = [
      (icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
      (
        icon: Icons.favorite_border_rounded,
        activeIcon: Icons.favorite_rounded,
        label: 'Favorites'
      ),
      (
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag_rounded,
        label: 'Bag'
      ),
      (
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Profile'
      ),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1EFEA))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(destinations.length, (index) {
              final item = destinations[index];
              final selected = _selectedTab == index;
              return Expanded(
                child: InkWell(
                  onTap: () => _selectTab(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            selected ? item.activeIcon : item.icon,
                            color: selected ? _brand : _muted,
                            size: 22,
                          ),
                          if (index == 2 && _cartCount > 0)
                            Positioned(
                              right: -8,
                              top: -5,
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 15, minHeight: 15),
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                decoration: const BoxDecoration(
                                  color: _brand,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$_cartCount',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: selected ? _brand : _muted,
                          fontSize: 9,
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

class FoodCard extends StatelessWidget {
  const FoodCard({
    required this.food,
    required this.isFavorite,
    required this.quantity,
    required this.onAdd,
    required this.onFavorite,
    super.key,
  });

  final FoodItem food;
  final bool isFavorite;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFF0EEE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF27251F).withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 128,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FoodImage(food: food),
                if (food.isPopular)
                  Positioned(
                    left: 9,
                    top: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.local_fire_department_rounded,
                              color: _brand, size: 12),
                          SizedBox(width: 3),
                          Text(
                            'POPULAR',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.95),
                    shape: const CircleBorder(),
                    child: InkWell(
                      key: ValueKey('favorite-${food.id}'),
                      onTap: onFavorite,
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite ? _brand : _ink,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 8, 10, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          food.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFB33E), size: 14),
                      const SizedBox(width: 2),
                      Text(
                        food.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            color: _ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    food.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _muted, fontSize: 9),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatPesos(food.price),
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 31,
                        height: 31,
                        child: Material(
                          color: quantity > 0
                              ? const Color(0xFFFFEFE9)
                              : _brand,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            key: ValueKey('add-${food.id}'),
                            onTap: onAdd,
                            borderRadius: BorderRadius.circular(10),
                            child: Icon(
                              quantity > 0 ? Icons.add_rounded : Icons.add,
                              color: quantity > 0 ? _brand : Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodImage extends StatelessWidget {
  const FoodImage({required this.food, super.key});

  final FoodItem food;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      food.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFFFE9DF),
          alignment: Alignment.center,
          child: Text(food.emoji, style: const TextStyle(fontSize: 52)),
        );
      },
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({
    required this.food,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final FoodItem food;
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFF0EEE8)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(width: 67, height: 67, child: FoodImage(food: food)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: _ink, fontSize: 13, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatPesos(food.price)} each',
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatPesos(food.price * quantity),
                  style: const TextStyle(
                      color: _brand, fontSize: 12, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          _QuantityControl(
            quantity: quantity,
            onDecrease: onDecrease,
            onIncrease: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuantityButton(
          icon: Icons.remove_rounded,
          label: 'Remove one',
          onTap: onDecrease,
        ),
        SizedBox(
          width: 24,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: _ink, fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ),
        _QuantityButton(
          icon: Icons.add_rounded,
          label: 'Add one',
          onTap: onIncrease,
          filled: true,
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 27,
      height: 27,
      child: Material(
        color: filled ? _brand : const Color(0xFFFFEFE9),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Icon(icon,
              color: filled ? Colors.white : _brand, size: 15, semanticLabel: label),
        ),
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final double amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: isTotal ? _ink : _muted,
      fontSize: isTotal ? 16 : 13,
      fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
    );
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(_formatPesos(amount), style: style),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: _brand, size: 21),
      title: Text(
        title,
        style: const TextStyle(
            color: _ink, fontSize: 13, fontWeight: FontWeight.w600),
      ),
      trailing:
          const Icon(Icons.chevron_right_rounded, color: _muted, size: 20),
      onTap: onTap,
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF0EEE8)),
          ),
          child: Icon(icon, color: _ink, size: 20),
        ),
      ),
    );
  }
}
