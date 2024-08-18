
class Course{
  final int id;
  final int instructorId;
  final String title;
  final String category;
  final String description;
  final String createdAt;
  final String updatedAt;

  Course({
    required this.id,
    required this.instructorId,
    required this.title,
    required this.category,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      instructorId: json['instructor_id'],
      title: json['title'],
      category: json['category'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

}