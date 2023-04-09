import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as Imagi;

final String curResFolder = path.current;

Future<List<int>> getImageResolution(String imgPath) async {
  File image = new File(imgPath);
  int height = Imagi.decodeImage(image.readAsBytesSync())!.height;
  int width = Imagi.decodeImage(image.readAsBytesSync())!.width;
  return [width, height];
}

resReplacer() async {
  //gfx.res replace
  final String gfx = await genGfxResCode();
  File("$curResFolder/gfx.res").writeAsStringSync(gfx);
  //sprites.res replace
  final String sprites = await genSpritesResCode();
  File("$curResFolder/sprites.res").writeAsStringSync(sprites);
  //images.res replace
  final String images = await genImagesResCode();
  File("$curResFolder/images.res").writeAsStringSync(images);
  //tilesets.res replace
  final String tilesets = await genTilesetsResCode();
  File("$curResFolder/tilesets.res").writeAsStringSync(tilesets);
  //music.res replace
  final String music = await genMusicResCode();
  File("$curResFolder/music.res").writeAsStringSync(music);
  //sounds.res replace
  final String sounds = await genSoundsResCode();
  File("$curResFolder/sounds.res").writeAsStringSync(sounds);
  //palette.res replace
  final String palette = await genPaletteResCode();
  File("$curResFolder/palette.res").writeAsStringSync(palette);
}

Future<String> genMusicResCode() async {
  print("Replacing music.res code");
  String result = "";
  final String tempRootPath = "$curResFolder/music";
  final dir = Directory(
    tempRootPath,
  );
  if (!(await dir.exists()))
    await Directory(tempRootPath).create(recursive: true);
  final files = dir.listSync(recursive: true);
  for (var fileOrDir in files) {
    if (fileOrDir is Directory) continue;
    String filePath =
        fileOrDir.path.substring(tempRootPath.length + 1).replaceAll("\\", "/");
    final String fileExt = filePath.split(".").last;
    if (fileExt != "vgm") continue;
    String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    //If image is "hidden", then ignore
    if (fileName[0] == "_") continue;

    String fileNameNoExt =
        filePath.split('.')[0].replaceAll("/", "_").replaceAll("\\", "_");
    result += 'XGM mus_$fileNameNoExt "music/$filePath"\n';
  }
  return result;
}

Future<String> genSoundsResCode() async {
  print("Replacing sounds.res code");
  String result = "";
  final String tempRootPath = "$curResFolder/sounds";
  final dir = Directory(
    tempRootPath,
  );
  if (!(await dir.exists()))
    await Directory(tempRootPath).create(recursive: true);
  final files = dir.listSync(recursive: true);
  for (var fileOrDir in files) {
    if (fileOrDir is Directory) continue;
    String filePath =
        fileOrDir.path.substring(tempRootPath.length + 1).replaceAll("\\", "/");
    final String fileExt = filePath.split(".").last;
    if (fileExt != "wav") continue;
    String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    //If image is "hidden", then ignore
    if (fileName[0] == "_") continue;

    String fileNameNoExt =
        filePath.split('.')[0].replaceAll("/", "_").replaceAll("\\", "_");

    result += 'WAV sfx_$fileNameNoExt "sounds/$filePath" XGM\n';
  }
  return result;
}

Future<String> genGfxResCode() async {
  print("Replacing gfx.res code");
  String result = "";
  final String tempRootPath = "$curResFolder/gfx";
  final dir = Directory(
    tempRootPath,
  );
  if (!(await dir.exists()))
    await Directory(tempRootPath).create(recursive: true);
  final files = dir.listSync(recursive: true);
  for (var fileOrDir in files) {
    if (fileOrDir is Directory) continue;
    String filePath =
        fileOrDir.path.substring(tempRootPath.length + 1).replaceAll("\\", "/");
    String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    //If image is "hidden", then ignore
    if (fileName[0] == "_") continue;
    final String fileExt = filePath.split(".").last;
    if (fileExt != "png") continue;

    String fileNameNoExt =
        filePath.split('.')[0].replaceAll("/", "_").replaceAll("\\", "_");
    result += """
PALETTE pal_${fileNameNoExt} "gfx/${filePath}"
TILESET tileset_${fileNameNoExt} "gfx/${filePath}" BEST ALL
MAP map_${fileNameNoExt} "gfx/${filePath}" tileset_${fileNameNoExt} BEST 0

""";
  }
  return result;
}

Future<String> genSpritesResCode() async {
  print("Replacing sprites.res code");
  String result = "";
  final String tempRootPath = "$curResFolder/sprites";
  // if(Directory.exists())
  final dir = Directory(
    tempRootPath,
  );
  if (!(await dir.exists()))
    await Directory(tempRootPath).create(recursive: true);
  final files = dir.listSync(recursive: true);
  for (var fileOrDir in files) {
    if (fileOrDir is Directory) continue;

    String filePath =
        fileOrDir.path.substring(tempRootPath.length + 1).replaceAll("\\", "/");
    String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    //If image is "hidden", then ignore
    if (fileName[0] == "_") continue;
    final String fileExt = filePath.split(".").last;
    if (fileExt != "png") continue;

    String fileNameNoExt =
        filePath.split('.')[0].replaceAll("/", "_").replaceAll("\\", "_");

    late String nameInCode;
    final String onlyFileName = fileNameNoExt.split("/").last;
    List<String> animValues = [];
    if (onlyFileName.contains("-")) {
      animValues = onlyFileName.split("-").last.split("_");
      nameInCode = onlyFileName.split("-")[0].replaceAll("-", "_");
      nameInCode = nameInCode.replaceAll(" ", "_");
      //animValues[0] - spriteWidth
      //animValues[1] - spriteHeight
      //animValues[2] - spriteAnimationSpeed
    } else {
      nameInCode = onlyFileName.replaceAll(" ", "_");
    }

    final List<int> imgRes =
        await getImageResolution("$tempRootPath/$filePath");
    if (animValues.isNotEmpty) {
      result +=
          'SPRITE spr_$nameInCode "sprites/$filePath" ${animValues[0]} ${animValues[1]} FAST ${animValues[2]}\n';
    } else {
      result +=
          'SPRITE spr_$nameInCode "sprites/$filePath" ${imgRes[0] >> 3} ${imgRes[1] >> 3} FAST 0\n';
    }
  }
  return result;
}

Future<String> genTilesetsResCode() async {
  print("Replacing tilesets.res code");
  String result = "";
  final String tempRootPath = "$curResFolder/tilesets";
  final dir = Directory(
    tempRootPath,
  );
  if (!(await dir.exists()))
    await Directory(tempRootPath).create(recursive: true);
  final files = dir.listSync(recursive: true);
  for (var fileOrDir in files) {
    if (fileOrDir is Directory) continue;

    String filePath =
        fileOrDir.path.substring(tempRootPath.length + 1).replaceAll("\\", "/");
    final String fileExt = filePath.split(".").last;
    if (fileExt != "png") continue;
    String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    //If image is "hidden", then ignore
    if (fileName[0] == "_") continue;

    String fileNameNoExt =
        filePath.split('.')[0].replaceAll("/", "_").replaceAll("\\", "_");
    late String nameInCode;
    final String onlyFileName = fileNameNoExt.split("/").last;
    List<String> additionValues = [];
    if (onlyFileName.contains("-")) {
      additionValues = onlyFileName.split("-").last.split("_");
      nameInCode = onlyFileName.split("-")[0].replaceAll("-", "_");
      nameInCode = nameInCode.replaceAll(" ", "_");
      //animValues[0] - spriteWidth
      //animValues[1] - spriteHeight
      //animValues[2] - spriteAnimationSpeed
    } else {
      nameInCode = onlyFileName.replaceAll(" ", "_");
    }
    String addString = "";
    for (String s in additionValues) {
      addString += " $s";
    }
    final List<int> imgRes =
        await getImageResolution("$tempRootPath/$filePath");
    result += 'TILESET ts_$nameInCode "tilesets/$filePath"$addString\n';
  }
  return result;
}

Future<String> genImagesResCode() async {
  print("Replacing images.res code");
  String result = "";
  final String tempRootPath = "$curResFolder/images";
  final dir = Directory(
    tempRootPath,
  );
  if (!(await dir.exists()))
    await Directory(tempRootPath).create(recursive: true);
  final files = dir.listSync(recursive: true);
  for (var fileOrDir in files) {
    if (fileOrDir is Directory) continue;

    String filePath =
        fileOrDir.path.substring(tempRootPath.length + 1).replaceAll("\\", "/");
    final String fileExt = filePath.split(".").last;
    if (fileExt != "png") continue;
    String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    //If image is "hidden", then ignore
    if (fileName[0] == "_") continue;

    String fileNameNoExt =
        filePath.split('.')[0].replaceAll("/", "_").replaceAll("\\", "_");
    late String nameInCode;
    final String onlyFileName = fileNameNoExt.split("/").last;
    String compressionType = "FAST";
    if (onlyFileName.contains("-")) {
      compressionType = onlyFileName.split("-").last;
      nameInCode = onlyFileName.split("-")[0].replaceAll("-", "_");
      nameInCode = nameInCode.replaceAll(" ", "_");
      //animValues[0] - spriteWidth
      //animValues[1] - spriteHeight
      //animValues[2] - spriteAnimationSpeed
    } else {
      nameInCode = onlyFileName.replaceAll(" ", "_");
    }

    final List<int> imgRes =
        await getImageResolution("$tempRootPath/$filePath");
    result += 'IMAGE img_$nameInCode "images/$filePath" $compressionType\n';
  }
  return result;
}

Future<String> genPaletteResCode() async {
  print("Replacing images.res code");
  String result = "";
  final String tempRootPath = "$curResFolder/palette";
  final dir = Directory(
    tempRootPath,
  );
  if (!(await dir.exists()))
    await Directory(tempRootPath).create(recursive: true);
  final files = dir.listSync(recursive: true);
  for (var fileOrDir in files) {
    if (fileOrDir is Directory) continue;

    String filePath =
        fileOrDir.path.substring(tempRootPath.length + 1).replaceAll("\\", "/");
    final String fileExt = filePath.split(".").last;
    if (fileExt != "png" && fileExt != "bmp" && fileExt != "pal") continue;
    String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    //If palette is "hidden", then ignore
    if (fileName[0] == "_") continue;

    String fileNameNoExt =
        filePath.split('.')[0].replaceAll("/", "_").replaceAll("\\", "_");
    late String nameInCode;
    final String onlyFileName = fileNameNoExt.split("/").last;
    if (onlyFileName.contains("-")) {
      nameInCode = onlyFileName.split("-")[0].replaceAll("-", "_");
      nameInCode = nameInCode.replaceAll(" ", "_");
    } else {
      nameInCode = onlyFileName.replaceAll(" ", "_");
    }
    result += 'PALETTE pal_$nameInCode "palette/$filePath"\n';
  }
  return result;
}

void main() {
  resReplacer();
}
