class Contact {
  final String id;
  final String name;
  final String imageUrl;

  const Contact({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

final List<Contact> demoContacts = [
  Contact(
    id: "user2",
    name: "جيني ويلسون 1",
    imageUrl: "https://i.postimg.cc/g25VYN7X/user-1.png",
  ),
  Contact(
    id: "user3",
    name: "جيني ويلسون 2",
    imageUrl: "https://i.postimg.cc/cCsYDjvj/user-2.png",
  ),
];