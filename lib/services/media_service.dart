// lib/services/media_service.dart

import 'package:file_picker/file_picker.dart';

class MediaService {
  Future<PlatformFile?> pickImageFromLibrary() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // Needed for web upload (to get bytes)
    );
    if (result != null && result.files.isNotEmpty) {
      return result.files[0];
    }
    return null;
  }
}
