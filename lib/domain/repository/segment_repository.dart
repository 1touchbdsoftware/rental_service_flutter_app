import 'package:dartz/dartz.dart';
import 'package:rental_service/data/model/get_segment_params.dart';
import 'package:rental_service/data/model/segment_response_model.dart';


abstract class SegmentRepository{
  Future<Either<String, SegmentResponseModel>>
  getSegmentList(GetSegmentParams params);
}
