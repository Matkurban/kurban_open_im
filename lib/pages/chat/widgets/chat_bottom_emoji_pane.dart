import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kurban_open_im/extension/context_extension.dart';
import 'package:kurban_open_im/utils/im_emoji_data.dart';

class ChatBottomEmojiPane extends StatelessWidget {
  const ChatBottomEmojiPane({super.key, this.onEmojiClick});

  final void Function(String emoji)? onEmojiClick;

  @override
  Widget build(BuildContext context) {
    var viewPadding = context.getViewPadding;
    return SizedBox(
      height: 280.h,
      width: double.infinity,
      child: GridView.builder(
        padding: EdgeInsets.only(right: 16.w, left: 16.w, bottom: viewPadding.bottom + 16.w),
        itemCount: ImEmojiData.listSize,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 36.w,
          mainAxisSpacing: 18.h,
          crossAxisSpacing: 12.w,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            customBorder: CircleBorder(),
            onTap: () => onEmojiClick?.call(ImEmojiData.emojiList[index]),
            child: Image(image: AssetImage(ImEmojiData.emojiImagePaths[index])),
          );
        },
      ),
    );
  }
}
