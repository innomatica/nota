import 'package:flutter/material.dart';
import 'package:notaapp/shared/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemInstruction extends StatefulWidget {
  const ItemInstruction({super.key});

  @override
  State<ItemInstruction> createState() => _ItemInstructionState();
}

class _ItemInstructionState extends State<ItemInstruction> {
  @override
  Widget build(BuildContext context) {
    final textStyle1 = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(fontWeight: FontWeight.w500);
    final textStyle2 = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.tertiary,
        );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Click ', style: textStyle1),
              Icon(Icons.edit_outlined,
                  color: Theme.of(context).colorScheme.primary),
              Text(' to take a note', style: textStyle1),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => launchUrl(Uri.parse(urlInstruction)),
            child: Text(
              'Give me instructions',
              style: textStyle2,
            ),
          )
        ],
      ),
    );
  }
}
