import 'package:flutter/material.dart';
import 'create_announcement_page.dart';

class AnnoucementsView extends StatefulWidget {
  const AnnoucementsView({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<AnnoucementsView> createState() => _AnnoucementsViewState();
}

class _AnnoucementsViewState extends State<AnnoucementsView> {
  final List<Map<String, String>> _announcements = [
    {
      "author": "Leslie",
      "date": "March 24, 2026",
      "audience": "To: everyone",
      "message":
          "Good morning everyone, please make sure to submit your work.",
    },
    {
      "author": "Leslie",
      "date": "March 20, 2026",
      "audience": "To: first, second, fourth year",
      "message":
          "Good morning everyone, please make sure to submit your work. Blah Blah Good morning everyone, please make sure to submit your work. Blah Blah Good morning everyone, please make sure to submit your work. Blah Blah\n\n"
          "Good morning everyone, please make sure to submit your work. Blah Blah\n"
          "Good morning everyone, please make sure to submit your work. Blah Blah\n"
          "Good morning everyone, please make sure to submit your work. Blah Blah",
    },
  ];

  String _getFormattedDate() {
    final now = DateTime.now();

    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  Future<void> _createPost() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAnnouncementPage(),
      ),
    );

    if (result != null) {
      setState(() {
        _announcements.insert(0, {
          "author": result["author"] ?? "Admin",
          "date": _getFormattedDate(),
          "audience": result["audience"] ?? "To: everyone",
          "message": result["message"] ?? "",
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Announcement created")),
      );
    }
  }

  void _editPost(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit post ${index + 1} clicked")),
    );
  }

  void _deletePost(int index) {
    setState(() {
      _announcements.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Announcement deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              "Announcement",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade300, thickness: 1),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Logged in as: ${widget.email}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _announcements.isEmpty
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "No announcements yet",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _announcements.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 18),
                            itemBuilder: (context, index) {
                              final announcement = _announcements[index];

                              return _AnnouncementCard(
                                author: announcement["author"] ?? "",
                                date: announcement["date"] ?? "",
                                audience: announcement["audience"] ?? "",
                                message: announcement["message"] ?? "",
                                onEdit: () => _editPost(index),
                                onDelete: () => _deletePost(index),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: OutlinedButton.icon(
                      onPressed: _createPost,
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text("Create new post"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey.shade300),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.author,
    required this.date,
    required this.audience,
    required this.message,
    required this.onEdit,
    required this.onDelete,
  });

  final String author;
  final String date;
  final String audience;
  final String message;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.orange.shade100,
            child: const Icon(
              Icons.person,
              size: 18,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$date ($audience)",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}