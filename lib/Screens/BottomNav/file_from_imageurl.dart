import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future fileFromImageUrl(imageURL) async {
  final file;
  try {
    final response = await http.get(Uri.parse(imageURL));

    final documentDirectory = await getApplicationDocumentsDirectory();

    file = File(join(documentDirectory.path,
        imageURL.toString().substring(imageURL.toString().length - 20)));

    file.writeAsBytesSync(response.bodyBytes);

    print(file.toString());

    return file;
  } catch (e) {
    print("efwefvwefvwefvwefvwfevwfv=======-=-=-=-=-=-" + e.toString());
  }
  return File;
}
