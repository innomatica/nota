import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/notalogic.dart';

class TagInstruction extends StatefulWidget {
  const TagInstruction({super.key});

  @override
  State<TagInstruction> createState() => _TagInstructionState();
}

class _TagInstructionState extends State<TagInstruction> {
  @override
  Widget build(BuildContext context) {
    final logic = context.read<NotaLogic>();
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
              Icon(
                Icons.new_label_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(' to create a tag, or', style: textStyle1),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
              onPressed: () => logic.generateSampleTags(),
              child: Text('Start with sample tags', style: textStyle2)),
        ],
      ),
    );
  }
}
