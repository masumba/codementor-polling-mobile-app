import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_app/utils/screen_util.dart';
import 'package:mobile_app/views/posts/image_post_view_model.dart';
import 'package:mobile_app/widgets/app/app_container.dart';
import 'package:mobile_app/widgets/busy_button.dart';
import 'package:mobile_app/widgets/form_field.dart';
import 'package:mobile_app/widgets/image_selector/multi_image_card_selector.dart';
import 'package:mobile_app/widgets/input_field.dart';
import 'package:stacked/stacked.dart';

class ImagePostView extends StatefulWidget {
  const ImagePostView({Key? key}) : super(key: key);

  @override
  State<ImagePostView> createState() => _ImagePostViewState();
}

class _ImagePostViewState extends State<ImagePostView> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImagePostViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => ImagePostViewModel(),
      builder: (context, model, child) => AppContainer(
        appBarTitle: 'Post Image',
        centerTitle: true,
        menuActions: model.menuActions(),
        containerBody: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtil.screenHeightFraction(context, dividedBy: 3),
                child: MultiImageCardSelector(
                  imageFile: model.selectedImage,
                  allowCameraOrGallery: true,
                  onClick: (File? file) {
                    model.selectedImage = file;
                    model.refreshListeners();
                  },
                  title: 'Post image',
                ),
              ),
              ScreenUtil.verticalSpaceNormal,
              FormFieldBlock(
                children: [
                  FormFieldWidget(
                    title: 'Description',
                    child: InputField(
                      controller: _descriptionController,
                      placeholder: 'Description',
                      maxLines: 10,
                      inputFieldHeight: 150.0,
                    ),
                  ),
                  FormFieldWidget(
                    overrideWidget: true,
                    title: 'Submit',
                    child: BusyButton(
                      title: 'Submit Image',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
