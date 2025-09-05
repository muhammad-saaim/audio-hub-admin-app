import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> uploadToCloudinary(File imageFile) async {
  final cloudName = 'dukqqkg6d'; // 🔁 Replace with your Cloud Name
  final uploadPreset = 'unsigned_preset'; // 🔁 Replace with your Upload Preset

  final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  final response = await request.send();

  if (response.statusCode == 200) {
    final resData = await http.Response.fromStream(response);
    final data = jsonDecode(resData.body);
    return data['secure_url'];
  } else {
    print("❌ Upload failed: ${response.statusCode}");
    return null;
  }
}
