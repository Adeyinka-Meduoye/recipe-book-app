import 'package:flutter/material.dart';
import 'package:adeyinka_recipe_book_app/data/models/recipe.dart';
import 'package:adeyinka_recipe_book_app/utils/constants.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final bool isGridView;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.isGridView = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
        final isTablet = constraints.maxWidth >= AppConstants.tabletBreakpoint &&
            constraints.maxWidth < AppConstants.desktopBreakpoint;

        return Card(
          child: InkWell(
            onTap: onTap,
            child: isGridView
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppConstants.cardBorderRadius)),
                        child: Image.asset(
                          recipe.imageUrl,
                          height: isDesktop ? 200 : isTablet ? 150 : 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.title,
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${recipe.cookingTime} min | ${recipe.difficulty}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListTile(
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppConstants.cardBorderRadius),
                      child: Image.asset(
                        recipe.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      '${recipe.cookingTime} min | ${recipe.difficulty}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: onTap,
                  ),
          ),
        );
      },
    );
  }
}