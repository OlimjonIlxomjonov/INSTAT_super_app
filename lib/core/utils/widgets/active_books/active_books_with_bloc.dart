import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';

import '../../../../features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';
import '../../../../features/online_library_app/features/home_lib/presentation/bloc/user_books/user_book_bloc.dart';
import '../../../../features/online_library_app/features/home_lib/presentation/bloc/user_books/user_book_state.dart';
import '../../../../features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';
import '../app_widgets.dart';
import 'active_books_wg.dart';

class ActiveBooksWithBloc extends StatelessWidget {
  final VoidCallback onTap;

  const ActiveBooksWithBloc({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBookBloc, UserBookState>(
      builder: (context, state) {
        if (state is UserBookLoaded) {
          final data = state.response.data;
          if (data.isEmpty) {
            return SizedBox(height: 20);
          }

          return Column(
            children: [
              const SizedBox(height: 20),
              ExtendSectionSeeAllWg(
                title: 'O’qilayotgan kitoblar',
                onTap: onTap,
              ),
              Column(
                children: List.generate(data.length.clamp(0, 2), (index) {
                  return CourseCategoryBuilder(
                    categoryId: data[index].category.id,
                    builder: (BuildContext context, String categoryName) {
                      return ActiveBooksWg(
                        onTap: () {
                          openMiniAppSheetFamily(
                            context,
                            showHandler: false,
                            child: DetailedOnlineBookComponent(
                              isBookBought: true,
                              data: data[index],
                            ),
                          );
                        },
                        data: data[index],
                        categoryName: categoryName,
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 18),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
