

import 'package:dartz/dartz.dart';

import '../../data/model/technician/post_accept_technician_params.dart';
import '../../data/model/technician/technician_get_params.dart';
import '../../data/model/technician/technician_response_model.dart';

abstract class TechnicianRepository {
  Future<Either<String, TechnicianResponse>> getAssignedTechnician(TechnicianRequestParams params);
  Future<Either<String, bool>> acceptTechnician(AcceptTechnicianParams params);

}

