import 'package:url_launcher/url_launcher.dart';

void sendWhatsApp(String message) async {
  String phone = "94750979908"; // oyage number
  String url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  }
}