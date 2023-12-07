import 'package:path_provider/path_provider.dart';

class DirectoryHelper {
  static Future<String> getApppDocumentsDicrectory() async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    return dir;
  }

  static Future<String> fileName() async {
    final String dir = await DirectoryHelper.getApppDocumentsDicrectory();
    final file = '$dir/pdfdocument${DateTime.now().toString()}.pdf';
    return file;
  }
}
