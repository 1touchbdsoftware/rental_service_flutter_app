import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';

import '../../data/model/complain/complain_req_params/complain_post_req_params.dart';
import '../../data/model/user/user_info_model.dart';
import '../../domain/entities/complain_entity.dart';
import '../../service_locator.dart';
import '../create_complain/bloc/complain_state.dart';
import '../create_complain/bloc/complain_state_cubit.dart';
import '../widgets/center_loader.dart';
import '../widgets/complain_form/image_selector.dart';
import '../widgets/complain_form/multiline_text_input.dart';
import '../dashboard/bloc/user_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ResubmitFormScreen extends StatefulWidget {
  final ComplainEntity complaint;

  const ResubmitFormScreen({super.key, required this.complaint});

  @override
  State<ResubmitFormScreen> createState() => _ResubmitFormScreenState();
}

class _ResubmitFormScreenState extends State<ResubmitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final int _maxImages = 15;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleImageAdded(XFile image) {
    setState(() => _selectedImages.add(image));
  }

  void _handleImageRemoved(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _handleClearImages() {
    setState(() => _selectedImages.clear());
  }

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide your feedback'),
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
        segmentID: widget.complaint.segmentID ?? '',
        complainName: _feedbackController.text.trim(),
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
          content: Text('Submission failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserInfoCubit(UserInfoModel.empty())..loadUserInfo()),
        BlocProvider(create: (context) => ComplainCubit(sl())),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('Resubmit Complaint'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text('Segment:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.complaint.segmentName ?? 'N/A'),
                const SizedBox(height: 16),
                Text('Original Comment:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.complaint.complainName ?? 'N/A'),
                const SizedBox(height: 24),
                MultilineTextField(
                  label: "Your Feedback",
                  controller: _feedbackController,
                  validator: (value) => value?.isEmpty ?? true ? "Feedback is required" : null,
                  helperText: 'Mention what was missing or unclear in your last complaint',
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
                        const SnackBar(
                          content: Text('Resubmitted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else if (state is ComplainError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Resubmission failed: ${state.message}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SubmitButton(
                      onPressed: () => _handleSubmit(context),
                      isLoading: state is ComplainLoading,
                      buttonText: "SUBMIT FEEDBACK",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
