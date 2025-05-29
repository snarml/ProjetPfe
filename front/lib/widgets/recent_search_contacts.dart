import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/contact.dart';
import '../screens/communication/conversation_detail_screen.dart';
class RecentSearchContacts extends StatelessWidget {
  const RecentSearchContacts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "بحث حديث",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .color!
                      .withOpacity(0.6),
                ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Stack(
              children: [
                ...List.generate(
                  demoContacts.length + 1,
                  (index) => Positioned(
                    right: index * 48,
                    child: GestureDetector(
                      onTap: () {
                        if (index < demoContacts.length) {
                          Get.to(
                            () => ConversationDetailScreen(
                              contact: demoContacts[index],
                            ),
                            transition: Transition.rightToLeft,
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          shape: BoxShape.circle,
                        ),
                        child: index < demoContacts.length
                            ? CircleAvatar(
                                radius: 26,
                                backgroundImage:
                                    NetworkImage(demoContacts[index].imageUrl),
                              )
                            : const RoundedCounter(total: 35),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RoundedCounter extends StatelessWidget {
  final int total;

  const RoundedCounter({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2E2F45)
            : const Color(0xFFEBFAF3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          "$total+",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}