


import 'package:dartz/dartz.dart';
import 'package:rental_service/data/model/segment/get_segment_params.dart';
import 'package:rental_service/data/model/segment/segment_response_model.dart';
import 'package:rental_service/domain/repository/segment_repository.dart';

import '../../core/usecase/usecase.dart';
import '../../data/model/complain/complain_req_params/get_complain_req_params.dart';
import '../../service_locator.dart';

class GetSegmentUseCase implements UseCase<Either<String, SegmentResponseModel>, GetSegmentParams> {
  @override
  Future<Either<String, SegmentResponseModel>> call({
    GetSegmentParams? param,
  }) async {
    try {
      if (param == null) {
        return const Left('Parameters cannot be null');
      }
      // Directly return the result from repository - don't wrap in another try/catch
      return await sl<SegmentRepository>().getSegmentList(param);
    } catch (e) {
      print("USECASE: CATCH CALLED");
      // This catch block should only handle exceptions from the service locator
      return Left(e.toString());
    }
  }

}
