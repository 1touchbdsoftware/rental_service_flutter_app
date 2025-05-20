
// Base class for all technician post states
abstract class TechnicianPostState {}

// Initial state when the feature is first loaded
class TechnicianPostInitial extends TechnicianPostState {}

// State during API request processing
class TechnicianPostLoading extends TechnicianPostState {}

// State when API request is successful
class TechnicianPostSuccess extends TechnicianPostState {
  // You could include the response data here if needed
  // final TechnicianResponse response;
  // TechnicianPostSuccess(this.response);
}

// State when API request fails
class TechnicianPostError extends TechnicianPostState {
  final String message;

  TechnicianPostError(this.message);
}