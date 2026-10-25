import 'package:flutter/material.dart';

import 'data/events.dart';
import 'models/event.dart';
import 'screens/event_details.dart';
import 'widgets/event_card.dart';

void main() {
  runApp(const CampusEventApp());
}

class CampusEventApp extends StatelessWidget {
  const CampusEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Event Explorer',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),

      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  String searchQuery = '';
  String selectedCategory = 'All';

  final List<String> categories = ['All', 'Technology', 'Arts', 'Sports'];

  final Set<int> favoriteIds = {};
  final Set<int> joinedIds = {};
  final TextEditingController searchController = TextEditingController();

  final List<String> pageTitles = [
    'Explore Events',
    'My Favorites',
    'My Events',
  ];

  void toggleFavorite(int eventId) {
    setState(() {
      if (favoriteIds.contains(eventId)) {
        favoriteIds.remove(eventId);
      } else {
        favoriteIds.add(eventId);
      }
    });
  }

  String formatDate(Event event) {
    final d = event.dateTime;
    return '${d.day}/${d.month}/${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }

  Future<void> joinEvent(Event event) async {
    if (joinedIds.contains(event.id) || event.availablePlaces == 0) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Participation'),
        content: Text(
          'Do you want to join this event?\n\n'
          'Event: ${event.title}\n'
          'Date: ${formatDate(event)}\n'
          'Venue: ${event.venue}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    if (joinedIds.contains(event.id) || event.availablePlaces == 0) {
      return;
    }

    setState(() {
      joinedIds.add(event.id);
      event.availablePlaces--;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully joined the event!')),
    );
  }

  Future<void> cancelEvent(Event event) async {
    if (!joinedIds.contains(event.id)) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Participation'),
        content: Text(
          'Do you want to cancel your participation?\n\n'
          'Event: ${event.title}\n'
          'Date: ${formatDate(event)}\n'
          'Venue: ${event.venue}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    if (!joinedIds.contains(event.id)) return;

    setState(() {
      joinedIds.remove(event.id);
      if (event.availablePlaces < event.totalCapacity) {
        event.availablePlaces++;
      }
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Participation cancelled.')));
  }

  List<Event> getVisibleEvents() {
    List<Event> events = campusEvents;

    // Filter by selected tab
    if (selectedIndex == 1) {
      events = events.where((event) => favoriteIds.contains(event.id)).toList();
    } else if (selectedIndex == 2) {
      events = events.where((event) => joinedIds.contains(event.id)).toList();
    }

    // Filter by category
    if (selectedCategory != 'All') {
      events = events
          .where((event) => event.category == selectedCategory)
          .toList();
    }

    // Search by title
    final query = searchQuery.trim().toLowerCase();

    if (query.isNotEmpty) {
      events = events
          .where((event) => event.title.toLowerCase().contains(query))
          .toList();
    }

    return events;
  }

  Future<void> openDetails(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (routeContext) {
          return StatefulBuilder(
            builder: (context, refreshDetails) {
              return EventDetailsScreen(
                event: event,
                isFavorite: favoriteIds.contains(event.id),
                isJoined: joinedIds.contains(event.id),
                onFavoritePressed: () {
                  toggleFavorite(event.id);
                  refreshDetails(() {});
                },
                onJoinPressed: () async {
                  await joinEvent(event);
                  if (context.mounted) {
                    refreshDetails(() {});
                  }
                },
                onCancelPressed: () async {
                  await cancelEvent(event);
                  if (context.mounted) {
                    refreshDetails(() {});
                  }
                },
              );
            },
          );
        },
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleEvents = getVisibleEvents();

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[selectedIndex]),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          if (selectedIndex == 2)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  'Joined: ${joinedIds.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        prefixIcon: const Icon(Icons.search),

                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();

                            setState(() {
                              searchQuery = '';
                            });

                            FocusScope.of(context).unfocus();
                          },
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      controller: searchController,
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: selectedCategory == category,
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
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${visibleEvents.length} events found',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: visibleEvents.isEmpty
                ? Center(
                    child: Text(
                      searchQuery.trim().isNotEmpty || selectedCategory != 'All'
                          ? 'No events match your search or filter.'
                          : selectedIndex == 1
                          ? 'No favorite events yet'
                          : selectedIndex == 2
                          ? 'You have not joined any events yet'
                          : 'No events available',
                      textAlign: TextAlign.center,
                    ),
                  )
                : Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: ListView.builder(
                        itemCount: visibleEvents.length,
                        itemBuilder: (context, index) {
                          final event = visibleEvents[index];

                          return EventCard(
                            event: event,
                            isFavorite: favoriteIds.contains(event.id),
                            onFavoritePressed: () {
                              toggleFavorite(event.id);
                            },
                            onTap: () {
                              openDetails(event);
                            },
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'My Events',
          ),
        ],
      ),
    );
  }
}
