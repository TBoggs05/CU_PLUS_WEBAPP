import 'package:cu_plus_webapp/features/dashboard/course_content_view.dart';
import 'package:cu_plus_webapp/features/dashboard/manage_students_view.dart';
import 'package:cu_plus_webapp/features/dashboard/message_view.dart';
import 'package:cu_plus_webapp/features/dashboard/calender_view.dart';
import 'package:flutter/material.dart';
import './components/side_bar.dart';

class CourseContentPage extends StatefulWidget {
  const CourseContentPage({
    super.key,
    required this.email,
    this.initialItem = SidebarItem.courseContent,
  });

  final String email;
  final SidebarItem initialItem;

  @override
  State<CourseContentPage> createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContentPage> {
  bool _showSidebar = false;
  late SidebarItem _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialItem;
  }

  void _selectItem(SidebarItem item, {required bool isDesktop}) {
    setState(() {
      _selectedItem = item;
      if (!isDesktop) _showSidebar = false;
    });
  }

  String _titleFor(SidebarItem item) {
    switch (item) {
      case SidebarItem.courseContent:
        return "Course Content";
      case SidebarItem.manageStudents:
        return "Manage Students";
      case SidebarItem.message:
        return "Message";
      case SidebarItem.calendar:
        return "Calendar";
      case SidebarItem.support:
        return "Support";
      case SidebarItem.setting:
        return "Setting";
    }
  }

  int _indexFor(SidebarItem item) => SidebarItem.values.indexOf(item);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop && _showSidebar) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _showSidebar = false);
          });
        }

        final content = IndexedStack(
          index: _indexFor(_selectedItem),
          children: [
            CourseContentView(email: widget.email),
            MessageView(email: widget.email),
            CalenderView(email: widget.email),
            ManageStudentsView(email: widget.email),
            Center(child: Text("Support — Logged in as: ${widget.email}")),
            Center(child: Text("Setting — Logged in as: ${widget.email}")),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(_titleFor(_selectedItem)),
            leading: isDesktop
                ? null
                : IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => setState(() => _showSidebar = !_showSidebar),
                  ),
          ),
          body: isDesktop
              ? Row(
                  children: [
                    SizedBox(
                      width: 262,
                      child: Sidebar(
                        selectedItem: _selectedItem,
                        onSelect: (item) => _selectItem(item, isDesktop: true),
                        onLogout: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                        },
                      ),
                    ),
                    Expanded(child: content),
                  ],
                )
              : Stack(
                  children: [
                    Positioned.fill(child: content),

                    IgnorePointer(
                      ignoring: !_showSidebar,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _showSidebar ? 1 : 0,
                        child: GestureDetector(
                          onTap: () => setState(() => _showSidebar = false),
                          child: Container(color: Colors.black.withOpacity(0.35)),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        offset: _showSidebar ? Offset.zero : const Offset(-1, 0),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: _showSidebar ? 1 : 0,
                          child: SizedBox(
                            width: double.infinity,
                            child: Sidebar(
                              selectedItem: _selectedItem,
                              onSelect: (item) => _selectItem(item, isDesktop: false),
                              onLogout: () {
                                setState(() => _showSidebar = false);
                                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}