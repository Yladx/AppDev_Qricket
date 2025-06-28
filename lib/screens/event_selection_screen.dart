import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../models/feedback_model.dart';
import '../services/event_service.dart';
import '../services/feedback_service.dart';
import '../widgets/event_card.dart';
import 'feedback_screen.dart';
import 'base_screen.dart';
import '../services/storage_service.dart';

/// Main screen for event selection and navigation
class EventSelectionScreen extends BaseScreen {
  const EventSelectionScreen({super.key});

  @override
  State<EventSelectionScreen> createState() => _EventSelectionScreenState();
}

class _EventSelectionScreenState extends BaseScreenState<EventSelectionScreen> {
  final EventService _eventService = EventService();
  final FeedbackService _feedbackService = FeedbackService();
  List<EventModel> _events = [];
  List<FeedbackModel> _feedbackList = [];
  bool _isLoading = true;
  List<String> _participatedEventIds = [];

  @override
  void initState() {
    super.initState();
    _initAndLoadData();
  }

  Future<void> _initAndLoadData() async {
    _participatedEventIds = await SharedPreferencesStorageService.getParticipatedEventIds();
    await _loadData();
  }

  /// Load events and feedback data
  Future<void> _loadData() async {
    try {
      showLoading();
      await _eventService.initialize();
      await _feedbackService.initialize();
      
      _events = _eventService.events;
      _feedbackList = _feedbackService.feedbacks;
      
      hideLoading();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      hideLoading();
      showError('Failed to load data: $e');
    }
  }

  /// Navigate to feedback screen for selected event
  void _navigateToEventFeedback(EventModel event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FeedbackScreen(selectedEvent: event),
      ),
    ).then((_) => _loadData()); // Refresh data when returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qricket'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _events.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No events available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final event = _events[index];
                    final participated = _participatedEventIds.contains(event.id);
                    return EventCard(
                      event: event,
                      feedbackList: _feedbackList,
                      onTap: () => _navigateToEventFeedback(event),
                      participated: participated,
                    );
                  },
                ),
    );
  }
} 