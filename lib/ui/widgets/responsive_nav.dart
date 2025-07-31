// File: lib/ui/widgets/responsive_nav.dart
import 'package:flutter/material.dart';
import 'package:adeyinka_recipe_book_app/utils/constants.dart';

class ResponsiveNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onThemeToggle;
  final Widget child;

  const ResponsiveNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onThemeToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < AppConstants.tabletBreakpoint;
        final isTablet = constraints.maxWidth >= AppConstants.tabletBreakpoint &&
            constraints.maxWidth < AppConstants.desktopBreakpoint;

        if (isMobile) {
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: onDestinationSelected,
              backgroundColor: Colors.red, // Red background for mobile
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Recipes'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Shopping'),
              ],
            ),
          );
        } else if (isTablet) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.restaurant), label: Text('Recipes')),
                    NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
                    NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
                    NavigationRailDestination(icon: Icon(Icons.list), label: Text('Shopping')),
                  ],
                  trailing: IconButton(
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.light
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    onPressed: onThemeToggle,
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                NavigationDrawer(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Text(
                        AppConstants.appName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const NavigationDrawerDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    const NavigationDrawerDestination(
                      icon: Icon(Icons.restaurant),
                      label: Text('Recipes'),
                    ),
                    const NavigationDrawerDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    const NavigationDrawerDestination(
                      icon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                    const NavigationDrawerDestination(
                      icon: Icon(Icons.list),
                      label: Text('Shopping'),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: IconButton(
                        icon: Icon(
                          Theme.of(context).brightness == Brightness.light
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        onPressed: onThemeToggle,
                      ),
                    ),
                  ],
                ),
                Expanded(child: child),
              ],
            ),
          );
        }
      },
    );
  }
}