

import 'package:dartz/dartz.dart';

import '../../data/model/technician/post_accept_technician_params.dart';
import '../../data/model/technician/post_reschedule_technician_params.dart';
import '../../data/model/technician/technician_get_params.dart';
import '../../data/model/technician/technician_response_model.dart';
import '../../data/model/technician/assigned_task_params.dart';
import '../../data/model/technician/assigned_task_model.dart';

abstract class TechnicianRepository {
  Future<Either<String, TechnicianResponse>> getAssignedTechnician(TechnicianRequestParams params);
  Future<Either<String, AssignedTaskResponseModel>> getAssignedTechnicianComplaint(AssignedTaskParams params);
  Future<Either<String, bool>> acceptTechnician(AcceptTechnicianParams params);
  Future<Either<String, bool>> rescheduleTechnician(TechnicianRescheduleParams params);

}

