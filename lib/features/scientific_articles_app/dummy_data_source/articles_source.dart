import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/artciles_model.dart';

final dummyArticles = [
  ArticlesModel(
    title: 'Sun’iy intellekt yordamida ilmiy tadqiqot samaradorligini oshirish',
    id: '#6783',
    date: '19.02.2025',
    status: ArticleStatus.confirmed,
  ),
  ArticlesModel(
    title:
        'Raqamli transformatsiya sharoitida oliy ta’lim tizimini rivojlantirish',
    id: '#6783',
    date: '19.02.2025',
    status: ArticleStatus.pending,
  ),
  ArticlesModel(
    title: 'Ma’lumotlar tahlili asosida iqtisodiy prognozlash usullari',
    id: '#6783',
    date: '19.02.2025',
    status: ArticleStatus.rejected,
  ),
];
