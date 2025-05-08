

import 'package:dartz/dartz.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/data/source/get_complains_api_service.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';

import '../../service_locator.dart';
import '../model/complain_response_model.dart';
import '../source/auth_api_service.dart';

class ComplainsRepositoryImpl extends ComplainsRepository {
  final ComplainApiService _complainApiService = sl<ComplainApiService>();

  @override
  Future<Either<String, ComplainResponseModel>> getTenantComplains(
      GetComplainsParams params,
      ) async {
    final result = await _complainApiService.getComplains(params);
    return result; // Just pass through the Either
  }
}