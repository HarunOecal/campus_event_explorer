import 'package:flutter/material.dart';

import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFull = event.availablePlaces == 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              event.imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onFavoritePressed,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Category: ${event.category}'),
                  Text('Venue: ${event.venue}'),
                  Text(
                    'Date: ${event.dateTime.day}/'
                    '${event.dateTime.month}/'
                    '${event.dateTime.year} '
                    '${event.dateTime.hour.toString().padLeft(2, '0')}:'
                    '${event.dateTime.minute.toString().padLeft(2, '0')}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isFull
                        ? 'Full'
                        : '${event.availablePlaces} places available',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isFull ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
