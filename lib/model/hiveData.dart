import 'package:hive/hive.dart';
part 'hiveData.g.dart';

@HiveType(typeId: 0)
class MoviesData extends HiveObject {
  @HiveField(0)
  late String movie;
  @HiveField(1)
  late String director;
  @HiveField(2)
  late String duration;
  @HiveField(3)
  late String image;
}
/*const movies_data = [
  {
    "name": "Interstellar",
    "director": "Christopher Nolan",
    "image": "interstellar.jpg",
    "duration": "2 hours"
  },
  {
    "name": "Conjuring",
    "director": "James Wan",
    "image": "conjuring.jpg",
    "duration": "1.5 hours"
  }
];*/

