import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/statistics_edu/data/models/leader_board/leader_board_response_model.dart';
import 'package:my_template/features/education_app/features/statistics_edu/data/source/remote_data_source/leader_board_remote_data_source.dart';

class LeaderBoardRemoteDataSourceImpl implements LeaderBoardRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<LeaderBoardResponseModel> fetchLeaderBoard() async {
    try {
      final response = await _dioClient.get(ApiUrls.leaderBoard);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return LeaderBoardResponseModel.fromJson(response.data);
      } else {
        throw Exception('Exception: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Catch: $e');
      rethrow;
    }
  }
}
