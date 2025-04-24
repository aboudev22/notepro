import 'package:flutter/material.dart';
import 'package:notepro/features/admin/presentation/section_dashboard.dart';
import 'package:notepro/features/admin/widgets/admin_appbar.dart';
import 'package:notepro/features/admin/widgets/siderbar_dashboard.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedSection = 'Dashboard';
  bool _sidebarVisible = false;

  void _selectSection(String section) {
    setState(() {
      _selectedSection = section;
      _sidebarVisible = false;
    });
  }

  Widget _buildSectionContent() {
    switch (_selectedSection) {
      case 'Dashboard':
        return const SectionDashboard(); // nouvelle section
      case 'articles':
        return const Center(
          child: Text('Page Articles', style: TextStyle(fontSize: 48)),
        );
      case 'notes':
        return const Center(
          child: Text('Page Notes', style: TextStyle(fontSize: 48)),
        );
      case 'stats':
        return const Center(
          child: Text('Page Stats', style: TextStyle(fontSize: 48)),
        );
      case 'marketing':
        return const Center(
          child: Text('Page Marketing', style: TextStyle(fontSize: 48)),
        );
      case 'viewers':
        return const Center(
          child: Text('Page Viewers', style: TextStyle(fontSize: 48)),
        );
      case 'commentaires':
        return const Center(
          child: Text('Page Commentaires', style: TextStyle(fontSize: 48)),
        );
      case 'aide':
        return const Center(
          child: Text('Page Aide', style: TextStyle(fontSize: 48)),
        );
      default:
        return const Center(
          child: Text('Section inconnue', style: TextStyle(fontSize: 48)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AdminAppBar(
        onRefresh: () => setState(() {}),
        onCreateArticle: () => Navigator.pushNamed(context, '/create-article'),
      ),
      drawer:
          isDesktop
              ? null
              : Drawer(
                child: DashboardSidebar(
                  onSectionSelected: _selectSection,
                  selectedSection: _selectedSection,
                  isCollapsed: true,
                  onClose: () => Navigator.pop(context),
                ),
              ),
      body: Row(
        children: [
          if (isDesktop)
            DashboardSidebar(
              onSectionSelected: _selectSection,
              selectedSection: _selectedSection,
              onClose: () {},
            ),
          Expanded(child: _buildSectionContent()),
        ],
      ),
    );
  }
}
