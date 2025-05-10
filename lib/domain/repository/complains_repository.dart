import 'package:dartz/dartz.dart';

import '../../data/model/complain_response_model.dart';
import '../../data/model/get_complain_req_params.dart';

abstract class ComplainsRepository {
  Future<Either<String, ComplainResponseModel>> getTenantComplains(GetComplainsParams params);
}
