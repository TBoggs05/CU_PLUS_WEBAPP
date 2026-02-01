import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => setState(() => _showSidebar = !_showSidebar),
        ),
      ),
      body: Stack(
        children: [
          Center(child: Text("Logged in as: ${widget.email}")),

          if (_showSidebar)
            Positioned.fill(
              child: Sidebar(
                selectedItem: _selectedItem,
                onSelect: (item) {
                  setState(() {
                    _selectedItem = item;
                    _showSidebar = false;
                  });

                  // TODO: navigate based on item
                  // if (item == SidebarItem.message) Navigator.push(...);
                },
                onLogout: () {
                  setState(() => _showSidebar = false);
                  // TODO: clear token + navigate to login
                },
              ),
            ),
        ],
      ),
    );
  }
}