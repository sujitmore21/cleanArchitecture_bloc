import 'package:blog_app/festures/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];

    try {
      for (int i = 0; i < box.length; i++) {
        var blogJson = box.get(i.toString());
        if (blogJson != null) {
          blogs.add(BlogModel.fromJson(blogJson));
        }
      }
    } catch (e) {
      print('Error reading from box: $e');
    }

    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) async {
    await box.clear();

    for (int i = 0; i < blogs.length; i++) {
      await box.put(i.toString(), blogs[i].toJson());
    }
  }
}
