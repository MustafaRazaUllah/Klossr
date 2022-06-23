import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<File> fileFromImageUrl(imageURL) async {
  print("<<<<<<<<<<<<<<<<<<<<<<object>>>>>>>>>>>>>>>>>>>>>>>>");
  final response = await http.get(Uri.parse(imageURL));

  final documentDirectory = await getApplicationDocumentsDirectory();

  final file = File(join(documentDirectory.path,
      imageURL.toString().substring(imageURL.toString().length - 20)));

  file.writeAsBytesSync(response.bodyBytes);
  print(
      "<<<<<<<<<<<<<<<<<<<<<<vallsdnfgjwke fjkwe vw evhow efv>>>>>>>>>>>>>>>>>>>>>>>>");
  print(file.toString());

  return file;
}
