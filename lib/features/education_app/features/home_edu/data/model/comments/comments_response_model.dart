import 'package:my_template/features/education_app/features/home_edu/data/model/comments/comments_model.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';

class CommentsResponseModel extends CommentsResponse {
  CommentsResponseModel({required super.reviews});

  factory CommentsResponseModel.fromJson(List<dynamic> json) {
    return CommentsResponseModel(
      reviews: json
          .map((item) => CommentsModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
