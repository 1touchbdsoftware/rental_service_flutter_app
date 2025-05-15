import 'package:dartz/dartz.dart';

import '../../data/model/complain/complain_req_params/complain_post_req_params.dart';
import '../../data/model/complain/complain_response_model.dart';
import '../../data/model/get_complain_req_params.dart';

abstract class ComplainsRepository {
  Future<Either<String, ComplainResponseModel>> getTenantPendingComplains(GetComplainsParams params);

  Future<Either<String, ComplainResponseModel>> getTenantCompletedComplains(GetComplainsParams params);

  Future<Either<String, bool>> saveComplain(ComplainPostModel model);
}
