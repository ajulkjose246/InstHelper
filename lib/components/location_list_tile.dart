import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.location,
    required this.press,
  });

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12), // Border radius
            child: Container(
              color: Colors.white, // Background color
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                    horizontal:
                        16.0), // Optional: Adjust padding inside ListTile
                horizontalTitleGap: 0,
                leading: const Icon(Icons.location_on_outlined),
                title: Text(
                  location,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: press, // Ensure the onTap callback is used
              ),
            ),
          ),
        ),
        const Divider(
          height: 2,
          thickness: 2,
          color: Color.fromRGBO(236, 240, 245, 1),
        ),
      ],
    );
  }
}
