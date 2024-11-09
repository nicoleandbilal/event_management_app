import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer_app/create_event/event_cover_image/event_image_upload_service.dart';
import 'package:shared/models/event_mapper.dart';
import 'create_event_form_event.dart';
import 'create_event_form_state.dart';
import 'package:shared/models/event_model.dart';
import 'package:shared/repositories/event_repository.dart';

class CreateEventFormBloc extends Bloc<CreateEventFormEvent, CreateEventFormState> {
  final ImageUploadService imageUploadService;
  final EventRepository eventRepository;
  Event? draftEvent;

  CreateEventFormBloc({
    required this.imageUploadService,
    required this.eventRepository,
  }) : super(FormInitial()) {
    on<InitializeDraftEvent>(_onInitializeDraftEvent);
    on<UpdateFormPageData>(_onUpdateFormPageData); // Use a single event for both save and next
    on<SubmitForm>(_onSubmitForm);
    on<UpdateImageUrls>(_onUpdateImageUrls);
    on<DeleteImageUrls>(_onDeleteImageUrls);
    on<ToggleTicketTypeEvent>(_onToggleTicketType);
  }

  // Initializes a new draft event in Firebase and emits the event ID
  Future<void> _onInitializeDraftEvent(
      InitializeDraftEvent event, Emitter<CreateEventFormState> emit) async {
    try {
      draftEvent = Event(
        eventId: '', // temporary; will be set by Firestore on save
        brandId: event.brandId,
        createdByUserId: event.createdByUserId,
        eventName: '',
        description: '',
        category: 'Other',
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now().add(const Duration(hours: 1)),
        venue: '',
        status: 'form-draft',
        createdAt: DateTime.now(),
      );
      final eventId = await eventRepository.createFormDraftEvent(draftEvent!);
      draftEvent = draftEvent!.copyWith(eventId: eventId);
      emit(FormDraftInitialized(eventId));
    } catch (e) {
      emit(FormFailure('Failed to initialize draft event: $e'));
    }
  }

  // Unified function to update form data and save to Firebase
  Future<void> _onUpdateFormPageData(
      UpdateFormPageData event, Emitter<CreateEventFormState> emit) async {
    if (draftEvent != null) {
      draftEvent = draftEvent!.copyWith(
        eventName: event.pageData['eventName'],
        description: event.pageData['description'],
        category: event.pageData['category'],
        venue: event.pageData['venue'],
        startDateTime: event.pageData['startDateTime'],
        endDateTime: event.pageData['endDateTime'],
      );

      try {
        await eventRepository.updateDraftEvent(draftEvent!.eventId, TomaEventMapper.toFirestore(draftEvent!));
        emit(FormDraftUpdated(draftEvent!));
      } catch (e) {
        emit(FormFailure("Failed to update form: $e"));
      }
    } else {
      emit(const FormFailure("Draft event is not initialized."));
    }
  }

  // Final submission of the form
  Future<void> _onSubmitForm(SubmitForm event, Emitter<CreateEventFormState> emit) async {
    if (draftEvent != null) {
      try {
        await eventRepository.submitEvent(draftEvent!.copyWith(status: 'live'));
        emit(FormSuccess());
      } catch (e) {
        emit(FormFailure('Failed to submit event: $e'));
      }
    } else {
      emit(const FormFailure("Cannot submit: draft event is not initialized."));
    }
  }
}

  // Updates image URLs with a loading state, simulating async upload
  Future<void> _onUpdateImageUrls(UpdateImageUrls event, Emitter<CreateEventFormState> emit) async {
    emit(FormImageUploading()); // Emit loading state before URL update
    try {
      // Mock delay for image upload (use actual upload logic as needed)
      await Future.delayed(const Duration(milliseconds: 300)); 
      emit(FormImageUrlsUpdated(
          fullImageUrl: event.fullImageUrl, croppedImageUrl: event.croppedImageUrl));
    } catch (error) {
      emit(FormFailure("Image upload failed: ${error.toString()}"));
    }
  }

  // Clears or deletes image URLs from the state
  void _onDeleteImageUrls(DeleteImageUrls event, Emitter<CreateEventFormState> emit) {
    emit(const FormImageUrlsUpdated()); // Set URLs to null to remove them
  }

  // Toggles ticket type between paid and free
  void _onToggleTicketType(ToggleTicketTypeEvent event, Emitter<CreateEventFormState> emit) {
    emit(TicketTypeToggled(event.isPaidTicket));
  }
