// get_complain_images_usecase.dart
import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';
import '../../data/model/complain/complain_image_model.dart';
import '../../data/model/complain/complain_req_params/complain_images_param.dart';
import '../../service_locator.dart';
import '../repository/complains_repository.dart';


class GetComplainImagesUseCase
    implements UseCase<Either<String, List<ComplainImageModel>>, GetImagesParams> {

  @override
  Future<Either<String, List<ComplainImageModel>>> call({
    GetImagesParams? param,
  }) async {
    try {
      if (param == null) {
        return const Left('Parameters cannot be null');
      }

      return await sl<ComplainsRepository>().getComplainImages(
        param.complainID,
        param.agencyID,
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}