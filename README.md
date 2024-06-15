# Usage

    print('make a new directory');
    print('Create a CSV file named "files_and_names.csv" with the following columns');
    print('Old filename.mp3, Artist Name, Year, Album Name, Image name');
    print('Ex: Jim Gaffigan Beyond The Pale.mp3, Jim Gaffigan, 2006, Beyond The Pale, K8MzgUPu8U.png');
    print(
        'The directory should contain a minimum of 1 mp3-file, 1 image file for cover art and 1 csv-file named "files_and_names.csv"');
    print('Run the executable with the directory name as an argument');
    print('Ex: .\\mp3_to_dir_with_names_and_cover_art.exe example');

## Compile with

dart compile exe .\bin\mp3_to_dir_with_names_and_cover_art.dart
