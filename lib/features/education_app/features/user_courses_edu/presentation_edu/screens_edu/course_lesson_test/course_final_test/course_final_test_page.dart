import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_layout.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/shared_widgets/test_option_list_wg.dart';

class CourseFinalTestPage extends StatefulWidget {
  final int courseId;

  const CourseFinalTestPage({super.key, required this.courseId});

  @override
  State<CourseFinalTestPage> createState() => _CourseFinalTestPageState();
}

class _CourseFinalTestPageState extends State<CourseFinalTestPage> {
  int _currentQuestionIndex = 0;
  int? _selectedOptionId;
  bool _isAnswered = false;
  bool _isCorrect = false;

  // Dummy data for the final test
  final List<Map<String, dynamic>> _dummyQuestions = [
    {
      'question':
          'Flutterda "StatelessWidget" va "StatefulWidget" o\'rtasidagi asosiy farq nima?',
      'options': [
        {
          'id': 1,
          'text':
              'StatelessWidget holatni saqlamaydi, StatefulWidget esa saqlaydi',
        },
        {'id': 2, 'text': 'StatelessWidget tezroq ishlaydi'},
        {'id': 3, 'text': 'StatefulWidget faqat Android uchun'},
        {'id': 4, 'text': 'Hech qanday farqi yo\'q'},
      ],
      'correctId': 1,
    },
    {
      'question': 'Dart tilida "async" kalit so\'zi nima uchun ishlatiladi?',
      'options': [
        {'id': 5, 'text': 'Dasturni to\'xtatish uchun'},
        {'id': 6, 'text': 'Asinxron funktsiyani e\'lon qilish uchun'},
        {'id': 7, 'text': 'O\'zgaruvchini e\'lon qilish uchun'},
        {'id': 8, 'text': 'Loop yaratish uchun'},
      ],
      'correctId': 6,
    },
  ];

  void _onSelectOption(int id) {
    if (_isAnswered) return;
    setState(() {
      _selectedOptionId = id;
    });
  }

  void _onSubmit() {
    if (_selectedOptionId == null) return;
    setState(() {
      _isAnswered = true;
      _isCorrect =
          _selectedOptionId ==
          _dummyQuestions[_currentQuestionIndex]['correctId'];
    });
  }

  void _onNext() {
    if (_currentQuestionIndex < _dummyQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionId = null;
        _isAnswered = false;
        _isCorrect = false;
      });
    } else {
      // Loop back for demo purposes
      setState(() {
        _currentQuestionIndex = 0;
        _selectedOptionId = null;
        _isAnswered = false;
        _isCorrect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _dummyQuestions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _dummyQuestions.length;

    final options = (currentQuestion['options'] as List).map((opt) {
      return LessonTestOptionEntity(
        id: opt['id'],
        text: opt['text'],
        textUz: opt['text'],
        textRu: opt['text'],
        textEn: opt['text'],
        lessonTest: 0,
        createdAt: '',
      );
    }).toList();

    return TestLayout(
      progress: progress,
      questionTitle: '${_currentQuestionIndex + 1}-Savol',
      questionText: currentQuestion['question'],
      optionList: TestOptionListWg(
        options: options,
        selectedOptionId: _selectedOptionId,
        isAnswered: _isAnswered,
        isCorrect: _isCorrect,
        onSelectOption: _onSelectOption,
      ),
      buttonText: _isAnswered ? "Keyingi savol" : "Tasdiqlash",
      onButtonTap: _isAnswered
          ? _onNext
          : (_selectedOptionId != null ? _onSubmit : null),
      banner: _isAnswered ? buildTestResultBanner(isCorrect: _isCorrect) : null,
    );
  }
}
