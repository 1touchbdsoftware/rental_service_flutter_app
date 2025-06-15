import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../data/model/complain/complain_req_params/complain_post_req.dart';
import '../../data/model/segment/get_segment_params.dart';
import '../../data/model/segment/segment_model.dart';
import '../../data/model/user/user_info_model.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../service_locator.dart';
import '../widgets/center_loader.dart';
import '../widgets/complain_form/dropdown_selector.dart';
import '../widgets/complain_form/image_selector.dart';
import '../widgets/complain_form/multiline_text_input.dart';
import 'bloc/complain_state.dart';
import 'bloc/complain_state_cubit.dart';
import '../dashboard/bloc/user_info_cubit.dart';
import '../segment/get_segment_state.dart';
import '../segment/get_segment_state_cubit.dart';

class CreateComplainScreen extends StatelessWidget {
  const CreateComplainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetSegmentCubit()),
        BlocProvider(
          create: (context) =>
          UserInfoCubit(UserInfoModel.empty())..loadUserInfo(),
        ),
        BlocProvider(
          create: (context) => ComplainCubit(sl()),
        ),
      ],
      child: const _CreateComplainScreenContent(),
    );
  }
}

class _CreateComplainScreenContent extends StatefulWidget {
  const _CreateComplainScreenContent();

  @override
  State<_CreateComplainScreenContent> createState() =>
      _CreateComplainScreenState();
}

class _CreateComplainScreenState extends State<_CreateComplainScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  final List<XFile> _selectedImages = [];
  final int _maxImages = 15;

  SegmentModel? _selectedSegment;

  @override
  void initState() {
    super.initState();
    context.read<UserInfoCubit>().loadUserInfo().then((_) {
      _loadSegments();
    });
  }

  Future<void> _loadSegments() async {
    final userInfo = context.read<UserInfoCubit>().state;
    final params = _prepareSegmentParams(userInfo);
    context.read<GetSegmentCubit>().fetchSegments(params: params);
  }

  GetSegmentParams _prepareSegmentParams(UserInfoModel userInfo) {
    return GetSegmentParams(
      agencyID: userInfo.agencyID,
      landlordID: userInfo.landlordID ?? '',
      propertyID: userInfo.propertyID ?? '',
      segmentID: '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleImageAdded(XFile image) {
    setState(() {
      _selectedImages.add(image);
    });
  }

  void _handleImageRemoved(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _handleClearImages() {
    setState(() {
      _selectedImages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title:  Text(S.of(context).createComplaint),
      ),
      body: BlocConsumer<GetSegmentCubit, GetSegmentState>(
        listener: (context, state) {
          if (state is GetSegmentFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          if (state is GetSegmentLoadingState) {
            return CenterLoaderWithText(
                text: S.of(context).holdOnBringingEverythingTogether);
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  if (state is GetSegmentSuccessState)
                    GenericDropdown<SegmentModel>(
                      label: S.of(context).segment,
                      selectedValue: _selectedSegment,
                      items: state.response.data,
                      hintText: S.of(context).selectAnOption,
                      getLabel: (segment) => segment.text,
                      onChanged: (value) =>
                          setState(() => _selectedSegment = value),
                      validator: (value) =>
                      value == null ? S.of(context).pleaseSelectASegment : null,
                      emptyListMessage: S.of(context).noSegmentsAvailable,
                    ),
                  const SizedBox(height: 24),
                  MultilineTextField(
                    label: S.of(context).description,
                    controller: _commentController,
                    hintText: S.of(context).enterTextHere,
                    validator: (value) =>
                    value?.isEmpty ?? true ? S.of(context).descriptionIsRequired : null,
                    helperText:
                    S.of(context).beSpecificAboutTheIssueForFasterResolution
                  ),
                  const SizedBox(height: 24),
                  ImagePickerWidget(
                    selectedImages: _selectedImages,
                    maxImages: _maxImages,
                    onImageAdded: _handleImageAdded,
                    onImageRemoved: _handleImageRemoved,
                    onClearImages: _handleClearImages,
                  ),
                  const SizedBox(height: 24),
                  BlocConsumer<ComplainCubit, ComplainState>(
                    listener: (context, state) {
                      if (state is ComplainSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            content: Text(S.of(context).complaintSubmittedSuccessfully),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      } else if (state is ComplainError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text(S.of(context).submissionFailed),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return SubmitButton(
                        onPressed: () => _handleSubmit(context),
                        isLoading: state is ComplainLoading,
                        buttonText: S.of(context).submitComplaint,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate() || _selectedSegment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(S.of(context).pleaseFillAllRequiredFields),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _submitForm(context);
  }

  Future<void> _submitForm(BuildContext context) async {
    final userInfo = context.read<UserInfoCubit>().state;
    if (userInfo.agencyID.isEmpty || userInfo.propertyID!.isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User info not loaded. Try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final complain = Complain(
        propertyID: userInfo.propertyID!,
        agencyID: userInfo.agencyID,
        tenantID: userInfo.tenantID!,
        segmentID: _selectedSegment!.id ?? '',
        complainName: _commentController.text.trim(),
        imageFiles: _selectedImages.map((e) => File(e.path)).toList(),
      );

      final complainPostModel = ComplainPostModel(
        complainInfo: ComplainInfo(
          agencyID: userInfo.agencyID,
          propertyID: userInfo.propertyID!,
          tenantID: userInfo.tenantID!,
        ),
        complains: [complain],
      );

      context.read<ComplainCubit>().submitComplaint(complainPostModel);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to prepare submission: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}