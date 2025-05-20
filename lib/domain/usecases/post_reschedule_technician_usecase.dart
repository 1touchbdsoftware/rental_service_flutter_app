import 'package:dartz/dartz.dart';
import 'package:rental_service/domain/repository/technician_repository.dart';
import '../../core/usecase/usecase.dart';
import '../../data/model/technician/post_reschedule_technician_params.dart';
import '../../service_locator.dart';

class RescheduleTechnicianUseCase implements UseCase<Either<String, bool>, TechnicianRescheduleParams> {
  @override
  Future<Either<String, bool>> call({TechnicianRescheduleParams? param}) async {
    if (param == null) {
      return Left('Reschedule technician parameters cannot be null');
    }

    return sl<TechnicianRepository>().rescheduleTechnician(param);
  }
}