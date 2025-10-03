import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int? count;
  final color;
  final VoidCallback? onTap;

  const ActivityTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.count,
    this.onTap,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // background transparent
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.black.withOpacity(0.2), // ripple color
        highlightColor: Colors.green.withOpacity(0.1), // pressed color
        child:
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: Icon(icon, color: color),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
            subtitle: Text(
                subtitle,
              style: TextStyle(
                fontSize: 13
              ),
            ),
            trailing: count != null
                ? CircleAvatar(
              radius: 12,
              backgroundColor: Colors.green.shade50,
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12
                ),
              ),
            )
                : null,
          ),
        ),
      ),
    );
  }
}
