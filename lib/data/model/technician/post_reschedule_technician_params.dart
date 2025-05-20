// lib/data/model/technician/technician_reschedule_params.dart

class TechnicianRescheduleParams {
  final String technicianID;
  final String technicianCategoryID;
  final String technicianAssignID;
  final String tenantID;
  final String complainID;
  final String agencyID;
  final String currentComments;
  final String rescheduleDate; // format: 'yyyy-MM-dd'
  final String rescheduleTime; // format: 'HH:mm'
  final String formattedRescheduleTime; // format: 'hh:mm a'
  final String scheduleDate; // original date format: 'yyyy-MM-dd'
  final String scheduleTime; // original time
  final String formattedScheduleTime; // original formatted time

  TechnicianRescheduleParams({
    required this.technicianID,
    required this.technicianCategoryID,
    required this.technicianAssignID,
    required this.tenantID,
    required this.complainID,
    required this.agencyID,
    required this.currentComments,
    required this.rescheduleDate,
    required this.rescheduleTime,
    required this.formattedRescheduleTime,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.formattedScheduleTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'TechnicianID': technicianID,
      'TechnicianCategoryID': technicianCategoryID,
      'TechnicianAssignID': technicianAssignID,
      'TenantID': tenantID,
      'ComplainID': complainID,
      'AgencyID': agencyID,
      'currentComments': currentComments,
      'rescheduleDate': rescheduleDate,
      'rescheduleTime': rescheduleTime,
      'formattedRescheduleTime': formattedRescheduleTime,
      'scheduleDate': scheduleDate,
      'scheduleTime': scheduleTime,
      'formattedScheduleTime': formattedScheduleTime,
    };
  }
}