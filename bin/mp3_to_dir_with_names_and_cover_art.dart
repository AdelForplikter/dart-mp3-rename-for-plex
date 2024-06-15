import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage:');
    print('make a new directory');
    print('Create a CSV file named "files_and_names.csv" with the following columns');
    print('Old filename.mp3, Artist Name, Year, Album Name, Image name');
    print('Ex: Jim Gaffigan Beyond The Pale.mp3, Jim Gaffigan, 2006, Beyond The Pale, K8MzgUPu8U.png');
    print(
        'The directory should contain a minimum of 1 mp3-file, 1 image file for cover art and 1 csv-file named "files_and_names.csv"');
    print('Run the executable with the directory name as an argument');
    print('Ex: .\\mp3_to_dir_with_names_and_cover_art.exe example');
    exit(1);
  }
  final path = arguments[0];

  File oldMetadata = File('$path\\sorted\\addMetadataToAllMp3s.ps1');
  if (oldMetadata.existsSync()) {
    oldMetadata.deleteSync();
  }

  final lines = readCsvSync('$path\\files_and_names.csv');
  lines?.forEach((line) {
    List<String> csvLine = line.split(',');
    // [0] = Old name
    // [1] = Artist Name
    // [2] = Year
    // [3] = Album Name
    // [4] = Image name
    String oldName = csvLine[0];
    String artistName = csvLine[1];
    artistName = artistName.trim();
    artistName = artistName.replaceAll(RegExp(r'(\w-)'), '');
    String albumName = csvLine[3];
    albumName = albumName.trim();
    albumName = albumName.replaceAll(RegExp(r'(\w-)'), '');
    String year = csvLine[2];
    year = year.trim();
    String imageName = csvLine[4];
    imageName = imageName.trim();
    print(oldName);
    print("$artistName-$year-$albumName");
    print(' ');
    File file = File('$path\\$oldName');
    if (file.existsSync()) {
      Directory("$path\\sorted\\$artistName\\$albumName").createSync(recursive: true);
      String artistNameUnderscore = artistName.replaceAll(' ', '_');
      String albumNameUnderscore = albumName.replaceAll(' ', '_');
      file.copySync("$path\\sorted\\$artistName\\$albumName\\$artistNameUnderscore-$year-$albumNameUnderscore.mp3");
      if (imageName.isNotEmpty) {
        File imageFile = File('$path\\$imageName');
        if (imageFile.existsSync()) {
          imageFile
              .copySync('$path\\sorted\\$artistName\\$albumName\\album.${imageName.substring(imageName.length - 3)}');
        }
      }
      File ps1File = File('$path\\sorted\\addMetadataToAllMp3s.ps1');
      if (!ps1File.existsSync()) {
        ps1File.createSync();
      }

      ps1File.writeAsStringSync(
          'ffmpeg -i ".\\$artistName\\$albumName\\$artistNameUnderscore-$year-$albumNameUnderscore.mp3" -c copy -metadata title="$albumName" -metadata album="$albumName" -metadata artist="$artistName" -metadata album_artist="$artistName"  -metadata genre="Stand-up Comedy" -metadata date="$year"  ".\\$artistName\\$albumName\\$artistNameUnderscore-$year-${albumNameUnderscore}2.mp3"\n',
          mode: FileMode.append);

      ps1File.writeAsStringSync(
          'Move-Item ".\\$artistName\\$albumName\\$artistNameUnderscore-$year-${albumNameUnderscore}2.mp3" ".\\$artistName\\$albumName\\$artistNameUnderscore-$year-$albumNameUnderscore.mp3" -Force\n',
          mode: FileMode.append);
    }
  });
}

List<String>? readCsvSync(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    return null;
  }
  return File(path).readAsLinesSync();
}
