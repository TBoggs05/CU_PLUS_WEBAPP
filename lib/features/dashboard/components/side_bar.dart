import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SidebarItem { course, message, calendar, support, setting }

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.selectedItem,
    required this.onSelect,
    required this.onLogout,
  });

  final SidebarItem selectedItem;
  final void Function(SidebarItem item) onSelect;
  final VoidCallback onLogout;

  Widget _item({
    required BuildContext context,
    required SidebarItem item,
    required String title,
    required String iconPath,
    double iconSize = 22, // default size
  }) {
    final isActive = selectedItem == item;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: SizedBox(
            width: 28, // fixed space so text aligns
            height: 28,
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: iconSize,
                height: iconSize,
              ),
            ),
          ),
          title: Text(title),
          onTap: () => onSelect(item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFFFD971),
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          _item(
            context: context,
            item: SidebarItem.course,
            title: "Course Content",
            iconPath: 'assets/images/side-bar/book-icon.svg',
            iconSize: 20,
          ),
          _item(
            context: context,
            item: SidebarItem.message,
            title: "Message",
            iconPath: 'assets/images/side-bar/message-icon.svg',
            iconSize: 22,
          ),
          _item(
            context: context,
            item: SidebarItem.calendar,
            title: "Calendar",
            iconPath: 'assets/images/side-bar/calender-icon.svg',
            iconSize: 28,
          ),

          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: Color(0xFF99C199), thickness:1),
          ),

          _item(
            context: context,
            item: SidebarItem.support,
            title: "Support",
            iconPath: 'assets/images/side-bar/support-icon.svg',
            iconSize: 26,
          ),
          _item(
            context: context,
            item: SidebarItem.setting,
            title: "Setting",
            iconPath: 'assets/images/side-bar/setting-icon.svg',
            iconSize: 26,
          ),

          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFBD5D5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: SvgPicture.asset(
                  'assets/images/side-bar/logout-icon.svg',
                  width: 20,
                  height: 20,
                ),
                title: const Text(
                  "Log out",
                  style: TextStyle(color: Color(0xFF9B1C1C)),
                ),
                onTap: onLogout,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
