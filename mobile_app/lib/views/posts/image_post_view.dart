import 'package:flutter/material.dart';
import 'package:mobile_app/views/posts/image_post_view_model.dart';
import 'package:mobile_app/widgets/app/app_container.dart';
import 'package:stacked/stacked.dart';

class ImagePostView extends StatefulWidget {
  const ImagePostView({Key? key}) : super(key: key);

  @override
  State<ImagePostView> createState() => _ImagePostViewState();
}

class _ImagePostViewState extends State<ImagePostView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImagePostViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => ImagePostViewModel(),
      builder: (context, model, child) => AppContainer(
        appBarTitle: 'Post Image',
        centerTitle: true,
        menuActions: model.menuActions(),
        containerBody: Placeholder(),
      ),
    );
  }
}
