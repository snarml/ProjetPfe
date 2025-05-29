import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/contact.dart';
import '../screens/communication/conversation_detail_screen.dart';
class SuggestedContacts extends StatelessWidget {
  const SuggestedContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "مقترحات",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .color!
                      .withOpacity(0.6),
                ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(height: 16.0),
        ...List.generate(
          demoContacts.length,
          (index) => ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 16.0 / 2),
            trailing: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(demoContacts[index].imageUrl),
            ),
            title: Text(
              demoContacts[index].name,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            onTap: () {
              Get.to(
                () => ConversationDetailScreen(
                  contact: demoContacts[index],
                ),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
        ),
      ],
    );
  }
}