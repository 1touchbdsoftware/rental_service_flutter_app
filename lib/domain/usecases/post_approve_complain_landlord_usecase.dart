import 'package:dartz/dartz.dart';
import '../../core/usecase/usecase.dart';

import '../../data/model/landlord_request/complain_aproval_request_post.dart';
import '../../domain/repository/complains_repository.dart';
import '../../service_locator.dart';

class ApproveComplaintsUseCase implements UseCase<Either<String, bool>, ComplainApprovalRequestModel> {
  @override
  Future<Either<String, bool>> call({ComplainApprovalRequestModel? param}) async {
    if (param == null) {
      return const Left('Approval parameters cannot be null');
    }

    if (param.complainsToApprove.isEmpty) {
      return const Left('No complaints provided for approval');
    }

    return sl<ComplainsRepository>().approveComplaints(param);
  }
}