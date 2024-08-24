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
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: theme.colorScheme.surface,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                horizontalTitleGap: 0,
                leading: Icon(Icons.location_on_outlined,
                    color: theme.colorScheme.primary),
                title: Text(
                  location,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: press,
              ),
            ),
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
          color: theme.dividerColor,
        ),
      ],
    );
  }
}
