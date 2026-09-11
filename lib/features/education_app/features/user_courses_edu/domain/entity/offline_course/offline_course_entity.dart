import 'package:my_template/core/utils/localization/localized_text.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_category_entity.dart';

class OfflineCourseEntity {
  final int id;
  final String name;
  final String? nameUz;
  final String? nameRu;
  final String? nameEn;
  final String? descriptionEn;
  final String price;
  final bool isActive;
  final String? thumbnail;
  final bool isOnline;
  final BookCategoryEntity? category;

  OfflineCourseEntity({
    required this.id,
    required this.name,
    this.nameUz,
    this.nameRu,
    this.nameEn,
    this.descriptionEn,
    required this.price,
    required this.isActive,
    this.thumbnail,
    required this.isOnline,
    this.category,
  });

  String displayName(String localeCode) => localizedText(
    localeCode: localeCode,
    fallback: name,
    uz: nameUz,
    ru: nameRu,
    en: nameEn,
  );
}
