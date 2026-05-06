import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/search_books/search_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/search_books/search_books_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/search_books/search_books_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';

class SearchBooksPage extends StatefulWidget {
  const SearchBooksPage({super.key});

  @override
  State<SearchBooksPage> createState() => _SearchBooksPageState();
}

class _SearchBooksPageState extends State<SearchBooksPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Auto-focus keyboard when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
    // Fire initial blank search to load all books
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<SearchBooksBloc>().add(
        SearchBooksEvent(params: SearchBooksParams(search: query)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Search Bar ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appW(16),
                vertical: appH(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appW(14),
                    vertical: appH(4),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.greyScale.grey200,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconlyLight.search,
                        color: AppColors.greyScale.grey600,
                      ),
                      SizedBox(width: appW(8)),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          onChanged: _search,
                          style: AppTextStyles.source.regular(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Kitob qidiring...',
                            hintStyle: AppTextStyles.source.regular(
                              fontSize: 14,
                              color: AppColors.greyScale.grey500,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: appH(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: appW(4)),
                      GestureDetector(
                        onTap: () => FamilyNavigation.familyClose(context),
                        child: Text(
                          'Bekor',
                          style: AppTextStyles.source.medium(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Results ──────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<SearchBooksBloc, SearchBooksState>(
                builder: (context, state) {
                  if (state is SearchBooksLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is SearchBooksLoaded) {
                    final books = state.response.data;
                    if (books.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              IconlyLight.search,
                              size: 56,
                              color: AppColors.greyScale.grey400,
                            ),
                            SizedBox(height: appH(16)),
                            Text(
                              'Hech narsa topilmadi',
                              style: AppTextStyles.source.medium(
                                fontSize: 16,
                                color: AppColors.greyScale.grey600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: appW(16),
                        vertical: appH(16),
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.52,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
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
                    );
                  }

                  if (state is SearchBooksError) {
                    return Center(
                      child: Text(
                        state.isConnectionError
                            ? 'Internet aloqasi yo\'q'
                            : 'Xatolik yuz berdi',
                        style: AppTextStyles.source.regular(
                          fontSize: 14,
                          color: AppColors.greyScale.grey700,
                        ),
                      ),
                    );
                  }

                  // SearchBooksInitial
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
