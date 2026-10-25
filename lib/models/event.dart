class Event {
  final int id;
  final String title;
  final String category;
  final DateTime dateTime;
  final String venue;
  final String description;
  final String imagePath;
  final int totalCapacity;
  int availablePlaces;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.venue,
    required this.description,
    required this.imagePath,
    required this.totalCapacity,
    required this.availablePlaces,
  });
}
