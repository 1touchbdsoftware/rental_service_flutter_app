import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/utils/image_convert_helper.dart';
import '../../core/constants/app_colors.dart';
import '../../data/model/complain/complain_req_params/complain_post_req_params.dart';
import '../../data/model/get_segment_params.dart';
import '../../data/model/segment_model.dart';
import '../../data/model/user/user_info_model.dart';
import '../../service_locator.dart'; // Import service locator


import '../widgets/center_loader.dart';
import 'bloc/complain_state.dart';
import 'bloc/complain_state_cubit.dart';
import '../dashboard/bloc/user_cubit.dart';
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
        // Add ComplainCubit provider
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
  final _imagePicker = ImagePicker();
  final List<XFile> _selectedImages = [];
  final int _maxImages = 5;

  SegmentModel? _selectedSegment;

  @override
  void initState() {
    super.initState();
    // First load user info, then load segments
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

  Future<void> _pickImages() async {
    if (_selectedImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 5 images allowed'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final pickedImages = await _imagePicker.pickMultiImage(
      imageQuality: 70,
      maxWidth: 1000,
    );

    if (pickedImages.isNotEmpty) {
      setState(() {
        // Add only up to the maximum allowed
        final remainingSlots = _maxImages - _selectedImages.length;
        final imagesToAdd =
        pickedImages.length > remainingSlots
            ? pickedImages.sublist(0, remainingSlots)
            : pickedImages;

        _selectedImages.addAll(imagesToAdd);

        if (pickedImages.length > remainingSlots) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Only added ${imagesToAdd.length} images. Maximum limit reached.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _clearImages() {
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
        title: const Text('Create Complaint'),
      ),
      body: BlocConsumer<GetSegmentCubit, GetSegmentState>(
        listener: (context, state) {
          if (state is GetSegmentFailureState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          if (state is GetSegmentLoadingState) {
            return CenterLoader();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Segment Dropdown
                  _buildSegmentDropdown(state),
                  const SizedBox(height: 24),

                  // Comment Field
                  _buildCommentField(),
                  const SizedBox(height: 24),

                  // Image Picker
                  _buildImagePicker(),
                  const SizedBox(height: 32),

                  // Submit Button - Wrapped with BlocConsumer for ComplainCubit
                  BlocConsumer<ComplainCubit, ComplainState>(
                    listener: (context, state) {
                      if (state is ComplainSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Complaint submitted successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      } else if (state is ComplainError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Submission failed: ${state.message}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return _buildSubmitButton(context, state);
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

  Widget _buildSegmentDropdown(GetSegmentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Segment",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (state is GetSegmentSuccessState)
          Stack(
            alignment: Alignment.center,
            children: [
              DropdownButtonFormField<SegmentModel>(
                value: _selectedSegment,
                dropdownColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.category,
                    color: Colors.black87,
                  ), // Darker icon
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black54,
                    ), // Darker border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  hintText: "Select a Segment",
                  hintStyle: const TextStyle(
                    color: Colors.black54,
                  ), // Darker hint text
                ),
                items:
                state.response.data.map((segment) {
                  return DropdownMenuItem(
                    value: segment,
                    child: Text(segment.text ?? "Unnamed Segment"),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedSegment = value),
                validator:
                    (value) => value == null ? "Please select a Segment" : null,
              ),
              if (state.response.data.isEmpty)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withOpacity(0.7),
                    child: const Center(
                      child: Text(
                        "No categories available",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
            ],
          )
        else if (state is! GetSegmentLoadingState)
          const Text(
            "Failed to load categories. Please try again.",
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget _buildCommentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _commentController,
          cursorColor: Colors.black,
          maxLines: 5,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: Icon(Icons.description, color: Colors.black87),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black54),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black54),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            hintText: "Please describe your complaint in detail...",
            hintStyle: const TextStyle(color: Colors.black54),
            contentPadding: const EdgeInsets.all(16),
          ),

          validator:
              (value) =>
          value?.isEmpty ?? true ? "Description is required" : null,
        ),
        const SizedBox(height: 8),
        const Text(
          'Be specific about the issue for faster resolution',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Attach Images",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Image Grid
              if (_selectedImages.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedImages[index].path),
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 12),

              // Add Image Button
              if (_selectedImages.length < _maxImages)
                InkWell(
                  onTap: _pickImages,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, size: 32),
                        SizedBox(height: 4),
                        Text('Add Photos'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedImages.length}/$_maxImages images',
              style: TextStyle(
                fontSize: 12,
                color:
                _selectedImages.length >= _maxImages
                    ? Colors.red
                    : Colors.black,
              ),
            ),
            if (_selectedImages.isNotEmpty)
              TextButton(
                onPressed: _clearImages,
                child: const Text('Clear all'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Updated submit button to show loading state
  Widget _buildSubmitButton(BuildContext context, ComplainState state) {
    final isLoading = state is ComplainLoading;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: isLoading ? null : () => _handleSubmit(context),
      child: isLoading
          ? const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(color: Colors.white),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.send),
          SizedBox(width: 8),
          Text("SUBMIT COMPLAINT"),
        ],
      ),
    );
  }

  // New method to handle submission
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
      // Prepare images


      // Create a single complain with the images included
      final complain = Complain(
        propertyID: userInfo.propertyID!,
        agencyID: userInfo.agencyID,
        tenantID: userInfo.tenantID!,
        segmentID: _selectedSegment!.id ?? '',
        complainName: _commentController.text.trim(),
        imageFiles: _selectedImages.map((e) => File(e.path)).toList(),
      );


      print("COMPLAIN MODEL: $complain");

      // Create the complete model with the complain inside the list
      final complainPostModel = ComplainPostModel(
        complainInfo: ComplainInfo(
          agencyID: userInfo.agencyID,
          propertyID: userInfo.propertyID!,
          tenantID: userInfo.tenantID!,
        ),
        complains: [complain], // List with the single complain
      );

      print("COMPLAIN POST MODEL: $complainPostModel");
      // Submit using ComplainCubit
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