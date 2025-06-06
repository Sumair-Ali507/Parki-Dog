import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar(this.photoUrl, {super.key, this.radius = 32, this.hasStatus = true});

  final double radius;
  final String? photoUrl;
  final bool hasStatus;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipOval(
            clipBehavior: Clip.hardEdge,
            child: CachedNetworkImage(
              imageUrl: photoUrl ?? '',
              height: radius * 2,
              width: radius * 2,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Image.asset('assets/images/dog placeholder.png'),
            ),
          ),
          hasStatus
              ? const CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.circle,
                    size: 12,
                    color: Color(0xff3A9304),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
// Image.network(
// photoUrl ?? '',
// height: radius * 2,
// width: radius * 2,
// fit: BoxFit.cover,
// errorBuilder: (context, error, stackTrace) =>
// Image.asset('assets/images/dog placeholder.png'),
// ),
