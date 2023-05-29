import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/constants/app_image.dart';
import 'package:mobile_app/models/image_post_record_dto.dart';
import 'package:mobile_app/widgets/loading_progress.dart';

class SwipeImageGallery extends StatefulWidget {
  final List<ImagePostRecordDto> children;
  final Function(ImagePostRecordDto) onUpVote;
  final Function(ImagePostRecordDto) onDownVote;
  final Function(ImagePostRecordDto) onInfoClick;
  const SwipeImageGallery({
    Key? key,
    required this.children,
    required this.onUpVote,
    required this.onDownVote,
    required this.onInfoClick,
  }) : super(key: key);

  @override
  State<SwipeImageGallery> createState() => _SwipeImageGalleryState();
}

class _SwipeImageGalleryState extends State<SwipeImageGallery> {
  int _currentIndex = 0;

  double get votePercentage {
    if (widget.children[_currentIndex].positiveVotes == 0 &&
        widget.children[_currentIndex].negativeVotes == 0) return 0.0;
    return (widget.children[_currentIndex].positiveVotes /
            (widget.children[_currentIndex].positiveVotes +
                widget.children[_currentIndex].negativeVotes)) *
        100;
  }

  Color get choiceColor {
    var value = widget.children[_currentIndex].userVote;
    if (value != null) {
      return value ? Colors.green : Colors.red;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Double Tap To Like',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onDoubleTap: () {
              widget.onUpVote(widget.children[_currentIndex]);
            },
            child: PageView.builder(
              itemCount: widget.children.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.children[index].imageUrl,
                      placeholder: (context, url) => const LoadingProgress(),
                      errorWidget: (context, url, error) => Image.asset(
                        AppImage.empty2,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Positioned(
                      left: 8,
                      top: MediaQuery.of(context).size.height * 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_up),
                              color: Colors.white,
                              onPressed: () {
                                widget.onUpVote(widget.children[index]);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.thumb_down),
                              color: Colors.white,
                              onPressed: () {
                                widget.onDownVote(widget.children[index]);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.info_outline_rounded),
                              color: Colors.white,
                              onPressed: () {
                                widget.onInfoClick(widget.children[index]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: choiceColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${votePercentage.toStringAsFixed(2)}% Up-votes',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              onPageChanged: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              controller: PageController(initialPage: _currentIndex),
            ),
          ),
        ),
      ],
    );
  }
}
