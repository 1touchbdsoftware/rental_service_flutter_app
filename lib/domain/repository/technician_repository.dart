

import 'package:dartz/dartz.dart';

import '../../data/model/technician/technician_get_params.dart';
import '../../data/model/technician/technician_response_model.dart';

abstract class TechnicianRepository {
  Future<Either<String, TechnicianResponse>> getAssignedTechnician(TechnicianRequestParams params);
}

