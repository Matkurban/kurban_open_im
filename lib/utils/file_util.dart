import 'dart:io';

import 'package:kurban_open_im/constant/constants.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

enum FileType { none, image, video }

sealed class FileUtil {
  ///获取文件类型
  static FileType getFileType(String path) {
    var mimeType = lookupMimeType(path);
    if (mimeType != null) {
      var fromMime = extensionFromMime(mimeType);
      if (fromMime != null) {
        if (fromMime == "png" ||
            fromMime == "jpg" ||
            fromMime == "jpeg" ||
            fromMime == "jpe" ||
            fromMime == "jpgv") {
          return FileType.image;
        } else if (fromMime == "mp4" ||
            fromMime == "m4a" ||
            fromMime == "m4b" ||
            fromMime == "mp4a" ||
            fromMime == "mpg" ||
            fromMime == "mov" ||
            fromMime == "mkv") {
          return FileType.video;
        } else {
          return FileType.none;
        }
      } else {
        return FileType.none;
      }
    } else {
      return FileType.none;
    }
  }

  static Future<int> getVideoDurationFromFile(String filePath) async {
    final File videoFile = File(filePath);
    if (!await videoFile.exists()) {
      info('文件不存在: $filePath');
      return 0;
    }
    VideoPlayerController controller = VideoPlayerController.file(videoFile);
    try {
      await controller.initialize();
      final Duration duration = controller.value.duration;
      await controller.dispose();
      return duration.inSeconds;
    } catch (e) {
      info('获取视频时长失败: $e');
      await controller.dispose();
      return 0;
    }
  }
}
