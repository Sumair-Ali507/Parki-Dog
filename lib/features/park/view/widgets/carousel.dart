import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Carousel extends StatelessWidget {
  Carousel({super.key, required this.photoUrls});

  final List<String?> photoUrls;
  final PageController _controller = PageController(viewportFraction: 0.92);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            itemCount: photoUrls.length,
            itemBuilder: (_, index) => Container(
              margin: EdgeInsets.symmetric(
                  horizontal: photoUrls.length > 1 ? 8 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                photoUrls[index] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/dog placeholder.png'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _controller,
          count: photoUrls.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            dotColor: Color(0xffB0B2B0),
            activeDotColor: Color(0xffB0B2B0),
          ),
        ),
      ],
    );
  }
}
