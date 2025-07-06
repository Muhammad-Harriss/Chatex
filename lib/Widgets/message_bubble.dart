import 'package:timeago/timeago.dart' as timeago;
import 'package:chat_app/models/Chat_message_model.dart';
import 'package:flutter/material.dart';

class TextMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const TextMessageBubble({
    super.key,
    required this.isOwnMessage,
    required this.message,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? [const Color.fromRGBO(0, 136, 249, 1.0), const Color.fromRGBO(0, 82, 218, 1.0)]
        : [const Color.fromRGBO(51, 49, 68, 1.0), const Color.fromRGBO(51, 49, 68, 1.0)];

    return Container(
      height: height + (message.content.length / 20 * 6.0),
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: const [0.30, 0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.content, style: const TextStyle(color: Colors.white)),
          Text(
            timeago.format(message.sentTime),
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const ImageMessageBubble({
    super.key,
    required this.isOwnMessage,
    required this.message,
    required this.height,
    required this.width,
  });

  bool _isValidUrl(String url) {
    return url.isNotEmpty &&
        Uri.tryParse(url)?.hasAbsolutePath == true &&
        (url.endsWith('.png') || url.endsWith('.jpg') || url.endsWith('.jpeg') || url.endsWith('.webp'));
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> _colorScheme = isOwnMessage
        ? [const Color.fromRGBO(0, 136, 249, 1.0), const Color.fromRGBO(0, 82, 218, 1.0)]
        : [const Color.fromRGBO(51, 49, 68, 1.0), const Color.fromRGBO(51, 49, 68, 1.0)];

    final String imageUrl = message.content;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: const [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: height,
              width: width,
              child: _isValidUrl(imageUrl)
                  ? FadeInImage.assetNetwork(
                      placeholder: 'assets/images/logo1.png',
                      image: imageUrl,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/logo1.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/images/logo1.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(height: height * 0.02),
          Text(
            timeago.format(message.sentTime),
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
