class CertificateObject {
  final double x; // percentage position from left
  final double y; // percentage position from top
  final String id; // 'user_name' | 'course_name' | 'date' | 'id' | 'qr_code'
  final String size;
  final String color;
  final String label;
  final String content; // placeholder, replace with real value

  CertificateObject({
    required this.x,
    required this.y,
    required this.id,
    required this.size,
    required this.color,
    required this.label,
    required this.content,
  });


}
