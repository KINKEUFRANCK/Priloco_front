import 'package:file_picker/file_picker.dart';

Future<List<PlatformFile>> getFiles() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['png', 'jpg', 'jpeg'],
  );
  List<PlatformFile> files = [];

  if (result != null) {
    files = result.files.toList();
  }
  return files;
}
