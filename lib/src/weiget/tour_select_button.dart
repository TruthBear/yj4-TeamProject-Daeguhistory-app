import 'package:flutter/material.dart';
import 'package:project/src/utils/colors.dart';
import 'package:project/src/utils/provider_state.dart';
import 'package:provider/provider.dart';

import '../utils/secure_storage.dart';

class TourSelectButton extends StatefulWidget {
  final String? title;
  final String? category;
  final String? tourDescription;
  final String? image;
  final String? latlng;
  final VoidCallback? onChanged;

  const TourSelectButton(
      {super.key,
        required this.title,
        this.onChanged,
        required this.category,
        required this.tourDescription,
        required this.image, this.latlng});

  @override
  State<TourSelectButton> createState() => _TourSelectButtonState();
}

class _TourSelectButtonState extends State<TourSelectButton> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Ink(
              color: Colors.red,
              child: InkWell(
                onTap: () async {
                  await storage.write(
                      key: SELETED_TOUR_KEY, value: "${widget.title}");
                  context.read<TourTitle>().setTitle = "${widget.title}";
                  final list = widget.latlng!.split(',');
                  context.read<TourLatLng>().setLatitude = double.parse(list[0]);
                  context.read<TourLatLng>().setLongitude = double.parse(list[1]);
                },
                child: Column(
                  children: [
                    Image.network("${widget.image}"),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.title}",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text("${widget.tourDescription}"),
                              ],
                            ),
                            Icon(
                              widget.title == context.watch<TourTitle>().title
                                  ? Icons.check_box_outlined
                                  : Icons.check_box_outline_blank,
                              color: PRIMARY_COLOR,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
