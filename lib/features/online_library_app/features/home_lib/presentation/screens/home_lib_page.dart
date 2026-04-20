import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/see_all_online_books_component.dart';

class HomeLibPage extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onProfileTap;

  const HomeLibPage({
    super.key,
    required this.onTap,
    required this.onProfileTap,
  });

  @override
  State<HomeLibPage> createState() => _HomeLibPageState();
}

class _HomeLibPageState extends State<HomeLibPage> {
  void activeCourseOpener() {
    // openMiniAppSheetFamily(
    //   context,
    //   child: DetailedOnlineBookComponent(isBookBought: true),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DraggableAppBarWg(onProfileTap: widget.onProfileTap),
      body: CustomScrollView(
        slivers: [
          /// search
          SliverAppBar(
            toolbarHeight: 56 + 24,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(),
          ),
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: 184,
                    color: AppColors.greyScale.grey400,
                    child: Center(child: Text('Placeholder')),
                  ),
                  SizedBox(height: appH(15)),
                  // ExtendSectionSeeAllWg(
                  //   title: 'O’qilayotgan kitoblar',
                  //   onTap: widget.onTap,
                  // ),
                  // ActiveCoursesWg(
                  //   showCircularProgBar: false,
                  //   onTap: activeCourseOpener,
                  // ),
                  // ActiveCoursesWg(
                  //   showCircularProgBar: false,
                  //   onTap: activeCourseOpener,
                  // ),
                  SizedBox(height: appH(18)),
                ],
              ),
            ),
          ),

          /// CATEGORIES
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 20, bottom: 20),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) {
                  return EduCategoriesWg();
                }),
              ),
            ),
          ),

          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: ExtendSectionSeeAllWg(
                title: 'Kitoblar',
                onTap: () {
                  openMiniAppSheetFamily(
                    showHandler: false,
                    context,
                    child: SeeAllOnlineBooksComponent(),
                  );
                },
              ),
            ),
          ),

          /// BODY
          BlocBuilder<PopularBooksBloc, PopularBooksState>(
            builder: (context, state) {
              if (state is PopularBooksLoaded) {
                final data = state.response.data;
                return SliverPadding(
                  padding: AppPadding.horizontal20x(),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.52,
                        ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final book = data[index];
                      final thumbnail = book.bookThumbnails.isNotEmpty
                          ? '${ApiUrls.baseUrl.replaceAll('api/', 'media/')}${book.bookThumbnails.first.file}'
                          : '';
                      return BookGridItem(
                        id: book.id,
                        isSaved: book.isSaved,
                        type: BookCardType.market,
                        title: book.name,
                        author: book.author.name,
                        price: "\u{00A0}${book.price} UZS",
                        imagePath: thumbnail.isNotEmpty
                            ? thumbnail
                            : 'assets/images/temp_book.jpg',
                        onTap: () {
                          openMiniAppSheetFamily(
                            context,
                            showHandler: false,
                            child: DetailedOnlineBookComponent(data: book),
                          );
                        },
                      );
                    },
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
