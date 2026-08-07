import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/general_widgets/custom_rating_star/custom_rating_star_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/short_book_details_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/add_comment/add_comment_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/add_comment/add_comments_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/add_comment/add_comments_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_comments/book_comments_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_comments/book_comments_event.dart';

class LeaveCommentSection extends StatefulWidget {
  final BookEntity data;

  const LeaveCommentSection({super.key, required this.data});

  @override
  State<LeaveCommentSection> createState() => _LeaveCommentSectionState();
}

class _LeaveCommentSectionState extends State<LeaveCommentSection> {
  double rating = 0;
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.isNotEmpty && rating != 0) {
      context.read<AddCommentsBloc>().add(
        AddCommentEvent(
          params: AddCommentParams(
            bookId: widget.data.id,
            stars: rating.toInt(),
            bookDesc: _commentController.text,
          ),
        ),
      );
    } else {
      errorFlushBar(context, 'Cannot be empty!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final thumbnail = widget.data.bookThumbnails.isNotEmpty
        ? '${ApiUrls.baseUrl.replaceAll('api/', 'media/')}${widget.data.bookThumbnails.first.file}'
        : '';
    return SafeArea(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          ShortBookDetailsWg(
            imagePath: thumbnail,
            bookName: widget.data.name,
            bookAuthor: widget.data.author.name,
            bookType: widget.data.category.displayName(
              Localizations.localeOf(context).languageCode,
            ),
          ),
          SizedBox(height: 16),
          Text(
            localization.assessment,
            style: AppTextStyles.source.medium(fontSize: 13),
          ),
          SizedBox(height: 4),
          CustomRatingStarWg(
            starRating: rating,
            starSize: 30,
            onRatingChanged: (newRating) {
              setState(() {
                rating = newRating;
              });
            },
          ),
          SizedBox(height: 16),
          EduCustomTextAreaWg(
            hintText: localization.writeTopicHint,
            controller: _commentController,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.transparent,
                    foregroundColor: AppColors.greyScale.grey600,
                    shape: RoundedRectangleBorder(
                      borderRadius: .circular(12),
                      side: BorderSide(color: AppColors.greyScale.grey200),
                    ),
                  ),
                  onPressed: () {
                    AppRoute.close();
                  },
                  child: Text(localization.cancel),
                ),
              ),
              SizedBox(width: 12),
              BlocConsumer<AddCommentsBloc, AddCommentsState>(
                listener: (context, state) {
                  if (state is AddCommentsLoaded) {
                    successFlushBar(context, 'Comment Added!');
                    context.read<BookCommentsBloc>().add(
                      BookCommentsEvent(
                        params: OnlineBookCommentsParams(
                          bookId: widget.data.id,
                        ),
                      ),
                    );
                    AppRoute.close();
                  }
                  if (state is AddCommentsError) {}
                },
                builder: (BuildContext context, AddCommentsState state) {
                  final isLoading = state is AddCommentsLoading;

                  return Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _addComment,
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text(localization.confirm),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
