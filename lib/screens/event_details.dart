import 'package:flutter/material.dart';

import '../models/event.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;
  final bool isFavorite;
  final bool isJoined;
  final VoidCallback onFavoritePressed;
  final VoidCallback onJoinPressed;
  final VoidCallback onCancelPressed;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.isJoined,
    required this.onFavoritePressed,
    required this.onJoinPressed,
    required this.onCancelPressed,
  });

  String get formattedDate {
    final d = event.dateTime;
    return '${d.day}/${d.month}/${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isFull = event.availablePlaces == 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: const Text('Event Image')),
                          body: Center(
                            child: InteractiveViewer(
                              child: Image.asset(event.imagePath),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    event.imagePath,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: onFavoritePressed,
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Category: ${event.category}'),
                      Text('Date: $formattedDate'),
                      Text('Venue: ${event.venue}'),
                      const SizedBox(height: 16),
                      Text(event.description),
                      const SizedBox(height: 20),
                      Text('Total Capacity: ${event.totalCapacity}'),
                      Text(
                        'Available Places: ${event.availablePlaces}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isFull ? Colors.red : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isJoined
                              ? onCancelPressed
                              : isFull
                              ? null
                              : onJoinPressed,
                          child: Text(
                            isJoined
                                ? 'Cancel Participation'
                                : isFull
                                ? 'Full'
                                : 'Join Event',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
