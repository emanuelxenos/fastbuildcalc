import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImagePickerH {
  static Future<Uint8List?> pickImageBytes() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return await pickedFile.readAsBytes();
    }

    return null;
  }
}
