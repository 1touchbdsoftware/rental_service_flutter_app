import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/complain/complain_req_params/get_complain_req_params.dart';
import 'package:rental_service/data/source/api_service/complains_api_service.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';
import '../../domain/entities/complain_response_entity.dart';
import '../../service_locator.dart';
import '../model/api_failure.dart';
import '../model/budget/BudgetItem.dart';
import '../model/budget/budgetResponse.dart';
import '../model/budget/budget_post_model.dart';
import '../model/complain/complain_image_model.dart';
import '../model/complain/complain_req_params/complain_edit_post.dart';
import '../model/complain/complain_req_params/complain_post_req.dart';
import '../model/complain/complain_req_params/completed_post_req.dart';
import '../model/complain/complain_req_params/recomplain_post_req.dart';
import '../model/complain/complain_response_model.dart';
import '../model/landlord_request/complain_aproval_request_post.dart';

class ComplainsRepositoryImpl implements ComplainsRepository {

  // FETCH RESPONSE THEN FILTER
  @override
  Future<Either<String, ComplainResponseModel>> getTenantComplains(
      GetComplainsParams params
      ) async {
    Either<ApiFailure, Response> result =
    await sl<ComplainApiService>().getComplains(params);

    print('REPO: GET COMPLAINS PARAM: ${params.tab} PAGE: ${params.pageNumber} ');

    print("REPO: COMPLAINS CALLED");
    return result.fold(
          (error) => Left(error.message),
          (data) {
        try {
          final responseModel = ComplainResponseModel.fromJson(data.data);
          return Right(responseModel);
        } catch (e) {
          return Left('Failed to parse response: ${e.toString()}');
        }
      },
    );
  }


  @override
  Future<Either<String, List<ComplainImageModel>>> getComplainImages(
      String complainID, String agencyID) async {
    final result = await sl<ComplainApiService>().getComplainImages(
      complainID,
      agencyID,
    );

    print('REPO: getComplainImages called for complainID: $complainID, agencyID: $agencyID');

    return result.fold(
          (error) => Left(error.message), // Convert ApiFailure to String
          (images) => Right(images),      // Just forward the parsed list
    );
  }
  ///New method: accept budget
  @override
  Future<Either<String, bool>> postAcceptBudget({required BudgetPostModel budgetModel, required bool isReview}) async {
    final result = await sl<ComplainApiService>().postAcceptBudget(budgetModel, isReview);

    print('REPO: postAcceptBudget called for complainID: ${budgetModel.complainID}, '
        'tenantID: ${budgetModel.tenantID}');

    return result.fold(
          (error) => Left(error.message), // Convert ApiFailure to String
          (response) {
        // Check if the request was successful (status code 200-299)
        final success = response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300;

        return Right(success);
      },
    );
  }
  ///New method: Save complain
  @override
  Future<Either<String, bool>> saveComplain(ComplainPostModel model) async {
    final result = await sl<ComplainApiService>().saveComplain(model);

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          // You can adjust based on what your API returns.
          final success = response.statusCode == 200 || response.statusCode == 201;
          return Right(success);
        } catch (e) {
          return Left('Failed to save complain: ${e.toString()}');
        }
      },
    );
  }

  @override
  Future<Either<String, List<BudgetItem>>> getBudgetForComplain({
    required String complainID,
  }) async {
    final result = await sl<ComplainApiService>().getBudgetForComplain(
      complainID: complainID,
    );

    print('REPO: getBudgetForComplain called for complainID: $complainID');

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          // Parse the response data
          if (response.data is! Map<String, dynamic>) {
            return Left('Invalid response format');
          }

          final responseData = response.data as Map<String, dynamic>;

          if (responseData['data'] is! Map<String, dynamic> ||
              responseData['data']['list'] is! List) {
            return Left('Budget list not found in response');
          }

          final data = responseData['data'] as Map<String, dynamic>;
          final list = data['list'] as List;

          // Parse and keep only the required fields
          final budgetItems = list.map((item) => BudgetItem.fromJson(item)).toList();

          return Right(budgetItems);
        } catch (e) {
          return Left('Failed to parse budget items: ${e.toString()}');
        }
      },
    );
  }

  @override
  Future<Either<String, bool>> editComplain(ComplainEditPostParams model) async {
    Either<ApiFailure, Response> result =
    await sl<ComplainApiService>().editComplain(model);

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          // You can adjust based on what your API returns.
          final success = response.statusCode == 200 || response.statusCode == 201;
          return Right(success);
        } catch (e) {
          return Left('Failed to save complain: ${e.toString()}');
        }
      },
    );
  }

  @override
  Future<Either<String, bool>> reComplain(ReComplainParams model) async {
    Either<ApiFailure, Response> result =
    await sl<ComplainApiService>().reComplain(model);

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          // You can adjust based on what your API returns.
          final success = response.statusCode == 200 || response.statusCode == 201;
          return Right(success);
        } catch (e) {
          return Left('Failed to save complain: ${e.toString()}');
        }
      },
    );
  }

  @override
  Future<Either<String, bool>> markComplainAsCompleted(ComplainCompletedRequest model) async {
    Either<ApiFailure, Response> result =
    await sl<ComplainApiService>().markAsCompleted(model);

    print('REPO: MARK COMPLAIN COMPLETED - COMPLAIN ID: ${model.complainID}');

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          // Check if response indicates success
          final success = response.statusCode == 200 || response.statusCode == 201;
          if (success) {
            // You can add additional handling for specific response data if needed
            print('REPO: COMPLAIN MARKED AS COMPLETED SUCCESSFULLY');
          }
          return Right(success);
        } catch (e) {
          return Left('Failed to mark complain as completed: ${e.toString()}');
        }
      },
    );
  }

  @override
  Future<Either<String, bool>> approveComplaints(ComplainApprovalRequestModel model) async {
    Either<ApiFailure, Response> result =
    await sl<ComplainApiService>().approveComplaints(model);

    // Log the first complain ID for tracking (or all if needed)
    final firstComplainId = model.complainsToApprove.isNotEmpty
        ? model.complainsToApprove.first.complainID
        : 'NO_COMPLAINS';

    print('REPO: APPROVE COMPLAINTS REQUEST - FIRST COMPLAIN ID: $firstComplainId, FLAG: ${model.flag}');

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          // Check if response indicates success
          final success = response.statusCode == 200 || response.statusCode == 201;
          if (success) {
            // Optional: Parse response data if needed
            final responseData = response.data;
            print('REPO: COMPLAINTS APPROVED SUCCESSFULLY. RESPONSE: $responseData');

            // You could add additional validation here if your API returns specific success indicators
            // final apiSuccess = responseData['success'] as bool? ?? false;
            // return Right(apiSuccess);
          }
          return Right(success);
        } catch (e) {
          return Left('Failed to process complaints approval: ${e.toString()}');
        }
      },
    );
  }


}
