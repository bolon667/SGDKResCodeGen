# SGDKResCodeGen

![SGDKResCodeGen_logo](https://github.com/bolon667/SGDKResCodeGen/blob/main/gitPics/SGDKResCodeGen_logo.jpg)

## About

It's a small tool, which automaticly creates `.res` code for your SGDK project

## Quick Start

- Download latest exe from `Releases` on github
- Put it in `res` folder inside your sgdk project
- Run program once, it will create folders `gfx`, `images`, `sounds`, `music`, `sprites`, `tilesets`, `palette`, and `.res` files.

## How to use

> Every file name inside folders: `gfx`, `images`, `sounds`, `music`, `sprites`, `tilesets`, `palette`, can affect on final code.
1. If first symbol is `_` (for example `_randomSpr.png`), then, file ignored.
2. In `sprites` folder, by renaming filename, you can change `tile_res_x`, `tile_res_y`, `time_to_play_1_frame`:

```
randomSpr-2_2_5.png
````
which translates into

```
SPRITE spr_randomSpr "sprites/randomSpr-2_2_5.png" 2 2 FAST 5
```

So, you need to add a `-` to change attributes.

The remainder after `-`, ignored in sprite name in code

```
SPRITE spr_Debug_target "sprites/Debug/target-1_1_2.png" 1 1 FAST 2
```

3. If you don't specify attributes, then the sprite resolution in tiles, is calculated automatically 

## Differences between v0.1 and last versions.
In v0.1 **gfx.res** code looks like this
```
PALETTE Room01_pal "gfx/Room01.png"
TILESET Room01_tileset "gfx/Room01.png" BEST ALL
MAP Room01_map "gfx/Room01.png" Room01_tileset BEST 0
```
In last versions looks like this
```
PALETTE pal_Room01 "gfx/Room01.png"
TILESET tileset_Room01 "gfx/Room01.png" BEST ALL
MAP map_Room01 "gfx/Room01.png" tileset_Room01 BEST 0
```
In last versions you can use 1.png like pic names, in v0.1 you can't

## License

MIT
