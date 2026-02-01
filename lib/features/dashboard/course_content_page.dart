import 'package:flutter/material.dart';
import './components/side_bar.dart';

class CourseContentPage extends StatefulWidget {
  const CourseContentPage({super.key, required this.email});
  final String email;

  @override
  State<CourseContentPage> createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContentPage> {
  bool _showSidebar = false;
  SidebarItem _selectedItem = SidebarItem.course;

  void _selectItem(SidebarItem item, {required bool isDesktop}) {
    setState(() {
      _selectedItem = item;
      if (!isDesktop) _showSidebar = false; // close drawer on mobile
    });

    // TODO: navigate based on item
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        // If we switch to desktop while sidebar was open on mobile, close it
        if (isDesktop && _showSidebar) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _showSidebar = false);
          });
        }

        final pageContent = Center(
          child: Text("Logged in as: ${widget.email}"),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text("Dashboard"),
            // hide hamburger on desktop
            leading: isDesktop
                ? null
                : IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => setState(() => _showSidebar = !_showSidebar),
                  ),
          ),

          body: isDesktop
              // Desktop layout: sidebar always visible
              ? Row(
                  children: [
                    SizedBox(
                      width: 262,
                      child: Sidebar(
                        selectedItem: _selectedItem,
                        onSelect: (item) => _selectItem(item, isDesktop: true),
                        onLogout: () {
                          // TODO: clear token + navigate to login
                        },
                      ),
                    ),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(child: pageContent),
                  ],
                )

              // Mobile layout: overlay drawer
              : Stack(
                  children: [
                    pageContent,

                    if (_showSidebar) ...[
                      // tap outside to close
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => setState(() => _showSidebar = false),
                          child: Container(color: Colors.black.withOpacity(0.25)),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Material(
                            elevation: 8,
                            child: Sidebar(
                              selectedItem: _selectedItem,
                              onSelect: (item) => _selectItem(item, isDesktop: false),
                              onLogout: () {
                                setState(() => _showSidebar = false);
                                // TODO: clear token + navigate to login
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
        );
      },
    );
  }
}