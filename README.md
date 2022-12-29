# SGDKResCodeGen

## About

It's a small tool, which automaticly creates `.res` code for your SGDK project

## Quick Start

- Download latest exe from `Releases` on github
- Put it in `res` folder inside your sgdk project
- Create in `res` folder, new folders: `gfx`, `images`, `sounds`, `music`, `sprites`, `tilesets`
- Run `SGDKResCodeGen.exe` 

## How to use

> Every file name inside folders: `gfx`, `images`, `sounds`, `music`, `sprites`, `tilesets`, can affect on final code.
1. If first symbol is `_` (for example `_randomSpr.png`), then, file ignored.
2. In `sprites` folder, by renaming filename, you can change `tile_res_x`, `tile_res_y`, `time_to_play_on_frame`:

```
randomSpr-2_2_5.png
````

- tile_res_x = 2
- tile_res_y = 2
- time_to_play_on_frame = 5

So, you need to add a `-` to change attributes.

The remainder after `-`, ignored in sprite name in code

```
SPRITE spr_Debug_target "sprites/Debug/target-1_1_2.png" 1 1 FAST 2
```

3. If you don't specify attributes, then the sprite resolution in tiles, is calculated automatically 

## License

MIT
