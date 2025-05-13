import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/story_add_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/screen/add/location_form_field.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/static/snack_bar_utils.dart';
import 'package:story_app/style/typography/story_text_styles.dart';
import 'package:story_app/widget/description_form_field.dart';
import 'package:story_app/widget/flex_scroll_layout.dart';
import 'package:story_app/widget/loading_button.dart';
import 'package:story_app/widget/story_image.dart';
import 'package:story_app/widget/validation_exception.dart';
import '/l10n/app_localizations.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> with SnackBarUtils {
  late StoryAddProvider _addProvider;
  final descriptionController = TextEditingController();
  final descriptionFocusNode = FocusNode();
  final locationController = TextEditingController();
  final locationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _addProvider = context.read<StoryAddProvider>();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    locationController.dispose();
    descriptionFocusNode.dispose();
    locationFocusNode.dispose();
    super.dispose();
  }

  AppLocalizations get appLocalizations =>
      AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(appLocalizations.titleAdd)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FlexScrollLayout(
          spacing: 16,
          children: [buildImagePicker(), buildFormField()],
        ),
      ),
    );
  }

  void handleGalleryView() async {
    final isMacOs = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOs || isLinux) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _addProvider.imageFile = pickedFile;
    }
  }

  void handleCameraView() async {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    if (!(isAndroid || isiOS)) return;

    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _addProvider.imageFile = pickedFile;
    }
  }

  Widget buildImagePicker() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          StoryImage(image: buildImage()),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.filledTonal(
                  onPressed: handleGalleryView,
                  icon: Icon(Icons.image_outlined),
                ),
                IconButton.filledTonal(
                  onPressed: handleCameraView,
                  icon: Icon(Icons.camera_alt_outlined),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final imagePath = _addProvider.imageFile?.path;
    if (imagePath != null) {
      return kIsWeb
          ? Image.network(imagePath.toString(), fit: BoxFit.contain)
          : Image.file(File(imagePath.toString()), fit: BoxFit.contain);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background_stars.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          appLocalizations.messageSelectImage,
          style: StoryTextStyles.titleLarge.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  void handleLocationButtonTap() {
    _addProvider.location = locationController.text;
  }

  void handlePost() async {
    await _addProvider.addStory();
    switch (_addProvider.result) {
      case ResultSuccess(message: final message):
        if (!mounted) return;
        showSnackBar(context, message);
        context.read<StoryListProvider>().getAllStories();
        context.read<AppRoute>().go("/app/home");

      case ResultError(message: final message):
        if (!mounted) return;
        showSnackBar(context, message);

      default:
    }
  }

  void clearError<V extends ValidationException>() {
    final result = _addProvider.result;
    final isError = result is ResultError && result.error is V;
    if (isError) _addProvider.reset();
  }

  String? buildErrorText<V extends ValidationException>() {
    final result = _addProvider.result;
    final isError = result is ResultError && result.error is V;
    if (isError) return result.message;
    return null;
  }

  void handleMapButtonTap() {
    // final completer = Completer<String>();
    // context.read<AppRoute>().go("/app/add/map");
  }

  Widget buildFormField() {
    final result = context.watch<StoryAddProvider>().result;
    final isLoading = result is ResultLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 16,
      children: [
        LocationFormField(
          controller: locationController..text = _addProvider.location ?? "",
          onChanged: (value) => _addProvider.location = value,
          focusNode: locationFocusNode,
          onFocus: clearError<LocationValidationException>,
          errorText: buildErrorText<LocationValidationException>(),
          onLocationButtonTap: handleLocationButtonTap,
          onMapButtonTap: () {},
        ),
        DescriptionFormField(
          controller: descriptionController,
          focusNode: descriptionFocusNode,
          onFocus: clearError<DescriptionValidationException>,
          errorText: buildErrorText<DescriptionValidationException>(),
          onChanged: (value) => _addProvider.description = value,
        ),
        LoadingButton(
          isLoading: isLoading,
          onPressed: handlePost,
          child: Text(appLocalizations.addButtonText),
        ),
      ],
    );
  }
}
