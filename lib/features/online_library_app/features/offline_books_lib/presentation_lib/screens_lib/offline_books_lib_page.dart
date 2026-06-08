import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/presentation_lib/bloc/offline_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/presentation_lib/bloc/offline_books_event.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/presentation_lib/bloc/offline_books_state.dart';

class OfflineBooksLibPage extends StatefulWidget {
  const OfflineBooksLibPage({super.key});

  @override
  State<OfflineBooksLibPage> createState() => _OfflineBooksLibPageState();
}

class _OfflineBooksLibPageState extends State<OfflineBooksLibPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late final OfflineBooksBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<OfflineBooksBloc>();
    _bloc.add(const FetchOfflineBooks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _bloc.add(FetchOfflineBooks(search: query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWg(myTitle: 'Kutubxona'),
        body: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverAppBar(
              primary: false,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              titleSpacing: 20,
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.greyScale.grey200,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.greyScale.grey600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        style: AppTextStyles.source.regular(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Kitob qidiring...',
                          hintStyle: AppTextStyles.source.regular(
                            fontSize: 14,
                            color: AppColors.greyScale.grey500,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              toolbarHeight: 80,
            ),

            /// CATEGORIES
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              sliver: SliverToBoxAdapter(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 20, bottom: 20),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(5, (index) {
                      return const EduCategoriesWg();
                    }),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 20),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Kitoblar',
                  style: AppTextStyles.source.semiBold(fontSize: 17),
                ),
              ),
            ),

            /// BODY
            BlocBuilder<OfflineBooksBloc, OfflineBooksState>(
              builder: (context, state) {
                if (state is OfflineBooksLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is OfflineBooksLoaded) {
                  final data = state.response.data;
                  if (data.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('Kitoblar topilmadi')),
                    );
                  }
                  return SliverPadding(
                    padding: AppPadding.hAndV20x20(),
                    sliver: SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.51,
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
                          type: BookCardType.library,
                          title: book.name,
                          author: book.author.name,
                          shelfNumber: 1,
                          rowNumber: 12,
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
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
