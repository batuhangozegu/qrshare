import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreenCardInfo extends StatelessWidget {
  final String title;
  final String data;
  final VoidCallback? onCopy;
  final VoidCallback? onTap;
  final bool showData;

  const HomeScreenCardInfo({
    super.key,
    required this.title,
    required this.data,
    this.onCopy,
    this.onTap,
    this.showData = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE1E1E1),
              ),
            ),
            if (showData) ...[
              const SizedBox(height: 4),
              Text(
                data,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
              ),
            ],
            if (onCopy != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: data));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('İçerik kopyalandı'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  if (onCopy != null) onCopy!();
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Kopyala'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}