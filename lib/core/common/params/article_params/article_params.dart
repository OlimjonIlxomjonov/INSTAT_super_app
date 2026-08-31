import 'dart:convert';
import 'dart:io';

class ArticleProcessParams {
  final int articleId;

  ArticleProcessParams({required this.articleId});
}

class CreateArticleOrderParams {
  final int reviewId;
  final String paymentMethod;

  CreateArticleOrderParams({
    required this.reviewId,
    required this.paymentMethod,
  });
}

class ArticleEditionsParams {
  final String status;

  ArticleEditionsParams({required this.status});
}

class UdkParams {
  final String udkCode;

  UdkParams({required this.udkCode});
}

class ReviewParams {
  final int? id;
  final String title;
  final int articleType;
  final int journalSection;
  final String? annotationUz;
  final String? annotationRu;
  final String? annotationEn;
  final String udkCode;
  final String status;
  final String language;
  final List<String>? keywords;

  ReviewParams({
    this.id,
    required this.title,
    required this.articleType,
    required this.journalSection,
    this.annotationUz,
    this.annotationRu,
    this.annotationEn,
    required this.udkCode,
    required this.status,
    required this.language,
    this.keywords,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'article_type': articleType,
      'journal_section': journalSection,
      'annotation_uz': annotationUz,
      'annotation_ru': annotationRu,
      'annotation_en': annotationEn,
      'udk_code': udkCode,
      'status': status,
      'language': language,
      'keywords': keywords != null ? jsonEncode(keywords) : null,
    };
  }
}

class ReviewAuthorParams {
  final int? id;
  final String firstName;
  final String lastName;
  final int review;
  final int academicDegree;
  final String address;
  final String organization;
  final String email;
  final String phoneNumber;
  final String? orcidCode;

  ReviewAuthorParams({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.review,
    required this.academicDegree,
    required this.address,
    required this.organization,
    required this.email,
    required this.phoneNumber,
    this.orcidCode,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'review': review,
      'academic_degree': academicDegree,
      'address': address,
      'organization': organization,
      'email': email,
      'phone_number': phoneNumber,
      'orcid_code': orcidCode,
    };
  }
}

class AddMainFileParams {
  final int reviewId;
  final File mainFile;

  AddMainFileParams({required this.mainFile, required this.reviewId});
}

class AddAntiplagiatFileParams {
  final int reviewId;
  final File file;

  AddAntiplagiatFileParams({required this.file, required this.reviewId});
}

class AddReviewFileParams {
  final int reviewId;
  final File file;
  final String type;

  AddReviewFileParams({
    required this.file,
    required this.reviewId,
    required this.type,
  });
}

class ReviewFileType {
  ReviewFileType._();

  static const image = 'image';
  static const excel = 'excel';
}

class ReviewProcessParams {
  final String processType;

  ReviewProcessParams({required this.processType});
}
