import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_service/domain/entities/complain_entity.dart';
import '../../core/constants/app_colors.dart';

import '../../data/model/complain/complain_req_params/complain_edit_post_params.dart';
import '../../data/model/segment/get_segment_params.dart';
import '../../data/model/segment/segment_model.dart';
import '../../data/model/user/user_info_model.dart';
import '../../service_locator.dart';
import '../create_complain/bloc/complain_state.dart';

import '../dashboard/bloc/user_cubit.dart';
import '../segment/get_segment_state.dart';
import '../segment/get_segment_state_cubit.dart';
import '../widgets/center_loader.dart';
import '../widgets/complain_form/dropdown_selector.dart';
import '../widgets/complain_form/image_selector.dart';
import '../widgets/complain_form/multiline_text_input.dart';
import 'edit_complain_cubit.dart';


class EditComplainScreen extends StatelessWidget {
  final ComplainEntity existingComplain;

  const EditComplainScreen({super.key, required this.existingComplain});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetSegmentCubit()),
        BlocProvider(
          create: (_) =>
          UserInfoCubit(UserInfoModel.empty())..loadUserInfo(),
        ),
        BlocProvider(
          create: (_) => EditComplainCubit(),
        ),
      ],
      child: _EditComplainScreenContent(existingComplain: existingComplain),
    );
  }
}


class _EditComplainScreenContent extends StatefulWidget {
  final ComplainEntity existingComplain;

  const _EditComplainScreenContent({super.key, required this.existingComplain});

  @override
  State<_EditComplainScreenContent> createState() => _EditComplainScreenContentState();
}

class _EditComplainScreenContentState extends State<_EditComplainScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final int _maxImages = 50;

  SegmentModel? _selectedSegment;

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.existingComplain.complainName;
    _loadUserAndSegments();
    _loadExistingImages();
  }

  Future<void> _loadExistingImages() async {
    if (widget.existingComplain.images != null) {
      for (var image in widget.existingComplain.images!) {
        final bytes = base64Decode(image.file!);
        final tempDir = Directory.systemTemp;
        final tempFile = await File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png').create();
        await tempFile.writeAsBytes(bytes);
        setState(() {
          _selectedImages.add(XFile(tempFile.path));
        });
      }
    }
  }


  Future<void> _loadUserAndSegments() async {
    await context.read<UserInfoCubit>().loadUserInfo();
    final userInfo = context.read<UserInfoCubit>().state;
    final params = GetSegmentParams(
      agencyID: userInfo.agencyID,
      landlordID: userInfo.landlordID ?? '',
      propertyID: userInfo.propertyID ?? '',
      segmentID: '',
    );
    context.read<GetSegmentCubit>().fetchSegments(params: params);
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

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate() || _selectedSegment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    _submitEditForm(context);
  }

  Future<void> _submitEditForm(BuildContext context) async {
    final userInfo = context.read<UserInfoCubit>().state;

    try {
      // Print debug info
      print('Editing complainID: ${widget.existingComplain.complainID}');
      print('segmentID: ${_selectedSegment?.id}');
      print('tenantID (updatedBy): ${userInfo.tenantID}');

      // Create the edit params
      final editParams = ComplainEditPostParams(
        complainID: widget.existingComplain.complainID,
        propertyID: widget.existingComplain.propertyID!,
        agencyID: widget.existingComplain.agencyID!,
        segmentID: _selectedSegment!.id,
        complainName: _commentController.text.trim(),
        updatedBy: userInfo.tenantID ?? '',
        images: _selectedImages.map((e) => File(e.path)).toList(),
      );

      // Submit using the edit cubit
      context.read<EditComplainCubit>().editComplaint(editParams);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit update: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Edit Complaint'),
      ),
      body: BlocBuilder<GetSegmentCubit, GetSegmentState>(
        builder: (context, state) {
          if (state is GetSegmentLoadingState) {
            return const CenterLoaderWithText(text: "Hold on, bringing everything together...");
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  if (state is GetSegmentSuccessState)
                    GenericDropdown<SegmentModel>(
                      label: "Segment",
                      selectedValue: _selectedSegment ??
                          state.response.data.firstWhere(
                                (segment) => segment.id == widget.existingComplain.segmentID,
                            orElse: () => SegmentModel(id: '', text: 'Unknown'),
                          ),
                      items: state.response.data,
                      getLabel: (segment) => segment.text ?? "Unnamed Segment",
                      onChanged: (value) => setState(() => _selectedSegment = value),
                      validator: (value) =>
                      value == null ? "Please select a segment" : null,
                      emptyListMessage: "No segments available",
                    ),
                  const SizedBox(height: 24),
                  MultilineTextField(
                    label: "Description",
                    controller: _commentController,
                    validator: (value) =>
                    value?.isEmpty ?? true ? "Description is required" : null,
                    helperText: 'Update the issue clearly',
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
                  BlocConsumer<EditComplainCubit, ComplainState>(
                    listener: (context, state) {
                      if (state is ComplainSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Complaint updated successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context, true); // Return true to indicate successful update
                      } else if (state is ComplainError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Update failed: ${state.message}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return SubmitButton(
                        onPressed: () => _handleSubmit(context),
                        isLoading: state is ComplainLoading,
                        buttonText: "UPDATE COMPLAINT",
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
}