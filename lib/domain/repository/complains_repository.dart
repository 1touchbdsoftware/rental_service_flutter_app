import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../data/model/budget/BudgetItem.dart';
import '../../data/model/budget/budget_post_model.dart';
import '../../data/model/complain/agency_info_model.dart';
import '../../data/model/complain/complain_image_model.dart';
import '../../data/model/complain/complain_req_params/complain_edit_post.dart';
import '../../data/model/complain/complain_req_params/complain_post_req.dart';
import '../../data/model/complain/complain_req_params/completed_post_req.dart';
import '../../data/model/complain/complain_req_params/recomplain_post_req.dart';
import '../../data/model/complain/complain_response_model.dart';
import '../../data/model/complain/complain_req_params/get_complain_req_params.dart';
import '../../data/model/landlord_request/complain_aproval_request_post.dart';

abstract class ComplainsRepository {
  Future<Either<String, ComplainResponseModel>> getTenantComplains(GetComplainsParams params);

  // Future<Either<String, ComplainResponseModel>> getTenantCompletedComplains(GetComplainsParams params);

  Future<Either<String, bool>> saveComplain(ComplainPostModel model);
  Future<Either<String, bool>> editComplain(ComplainEditPostParams model);
  Future<Either<String, bool>> reComplain(ReComplainParams model);
  Future<Either<String, bool>> markComplainAsCompleted(ComplainCompletedRequest model);
  Future<Either<String, List<ComplainImageModel>>> getComplainImages(String complainID, String agencyID);
  Future<Either<String, bool>> approveComplaints(ComplainApprovalRequestModel model);
  Future<Either<String, List<BudgetItem>>> getBudgetForComplain({required String complainID});
  Future<Either<String, bool>> postAcceptBudget({required BudgetPostModel budgetModel, required bool isReview});
  Future<Either<String, AgencyInfoModel>> getAgencyInfo();

}
