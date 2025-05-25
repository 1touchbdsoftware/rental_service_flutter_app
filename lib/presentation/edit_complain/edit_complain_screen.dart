import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_service/domain/entities/complain_entity.dart';
import '../../core/constants/app_colors.dart';

import '../../data/model/complain/complain_req_params/complain_edit_post.dart';
import '../../data/model/segment/get_segment_params.dart';
import '../../data/model/segment/segment_model.dart';
import '../../data/model/user/user_info_model.dart';
import '../../service_locator.dart';
import '../create_complain/bloc/complain_state.dart';

import '../dashboard/bloc/user_info_cubit.dart';
import '../image_gallery/get_image_state.dart';
import '../image_gallery/get_image_state_cubit.dart';
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
        // Add the GetComplainImagesCubit
        BlocProvider(
          create: (_) => GetComplainImagesCubit(),
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
  bool _isLoadingImages = true;
  bool _hasLoadedExistingImages = false;

  SegmentModel? _selectedSegment;

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.existingComplain.complainName;
    _loadUserAndSegments();
    _fetchExistingImages();
  }

  Future<void> _fetchExistingImages() async {
    setState(() {
      _isLoadingImages = true;
    });

    // Fetch images from server using the cubit
    context.read<GetComplainImagesCubit>().fetchComplainImages(
      complainID: widget.existingComplain.complainID,
      agencyID: widget.existingComplain.agencyID!,
    );
  }

  Future<void> _convertBase64ImagesToXFiles(List<String> base64Images) async {
    try {
      final List<XFile> convertedImages = [];

      for (int i = 0; i < base64Images.length; i++) {
        final bytes = base64Decode(base64Images[i]);
        final tempDir = Directory.systemTemp;
        final tempFile = await File('${tempDir.path}/existing_image_${i}_${DateTime.now().millisecondsSinceEpoch}.png').create();
        await tempFile.writeAsBytes(bytes);
        convertedImages.add(XFile(tempFile.path));
      }

      setState(() {
        _selectedImages.clear();
        _selectedImages.addAll(convertedImages);
        _hasLoadedExistingImages = true;
        _isLoadingImages = false;
      });
    } catch (e) {
      print('Error converting base64 images: $e');
      setState(() {
        _isLoadingImages = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading existing images: $e'),
            backgroundColor: Colors.orange,
          ),
        );
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
      _hasLoadedExistingImages = false;
    });

    // Show confirmation dialog for clearing existing images
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Images'),
          content: const Text('This will remove all existing images. You can add new ones if needed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Images are already cleared above
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
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
      _selectedSegment ??= SegmentModel(id: widget.existingComplain.segmentID ?? '', text: '');

      print('Editing complainID: ${widget.existingComplain.complainID}');
      print('segmentID: ${_selectedSegment?.id}');
      print('tenantID (updatedBy): ${userInfo.tenantID}');
      print('Total images: ${_selectedImages.length}');

      final editParams = ComplainEditPostParams(
        complainID: widget.existingComplain.complainID,
        propertyID: widget.existingComplain.propertyID!,
        agencyID: widget.existingComplain.agencyID!,
        segmentID: _selectedSegment!.id,
        complainName: _commentController.text.trim(),
        updatedBy: userInfo.tenantID ?? '',
        images: _selectedImages.map((e) => File(e.path)).toList(),
      );

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

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Images',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            if (_isLoadingImages) ...[
              const SizedBox(width: 12),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Loading existing images...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ] else if (_hasLoadedExistingImages && _selectedImages.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  '${_selectedImages.length} loaded',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        ImagePickerWidget(
          selectedImages: _selectedImages,
          maxImages: _maxImages,
          onImageAdded: _handleImageAdded,
          onImageRemoved: _handleImageRemoved,
          onClearImages: _handleClearImages,
        ),
      ],
    );
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
      body: MultiBlocListener(
        listeners: [
          // Listen to GetComplainImagesCubit for image loading
          BlocListener<GetComplainImagesCubit, GetComplainImagesState>(
            listener: (context, state) {
              if (state is GetComplainImagesSuccessState) {
                final imageList = state.images
                    .where((img) => img.file != null)
                    .map((img) => img.file!)
                    .toList();
                _convertBase64ImagesToXFiles(imageList);
              }else if (state is GetComplainImagesFailureState) {
                setState(() {
                  _isLoadingImages = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to load existing images: ${state.errorMessage}'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          ),
          // Listen to EditComplainCubit for form submission
          BlocListener<EditComplainCubit, ComplainState>(
            listener: (context, state) {
              if (state is ComplainSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Complaint updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context, true);
              } else if (state is ComplainError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Update failed: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<GetSegmentCubit, GetSegmentState>(
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
                    _buildImageSection(),
                    const SizedBox(height: 24),
                    BlocBuilder<EditComplainCubit, ComplainState>(
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
      ),
    );
  }
}