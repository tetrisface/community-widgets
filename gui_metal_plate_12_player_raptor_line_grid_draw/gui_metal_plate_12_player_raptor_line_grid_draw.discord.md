**Raptor Grid Draw 12 players (Full Metal Plate)** — draws a fairly distributed build border for every player in 12 player Raptors/Scavengers games on Full Metal Plate, so nobody has to argue about who builds where.
# 1. Install

### __Chobby plugin__
Install via the chobby included plugins downloader

### __Scripted Automatic__
On Windows with BAR installed in the default location open powershell and run:
```pwsh
$n="gui_metal_plate_12_player_raptor_line_grid_draw"; $d="$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\LuaUI\Widgets\$n"; $u="https://raw.githubusercontent.com/tetrisface/community-widgets/main/$n/$n"; New-Item -ItemType Directory -Force $d | Out-Null; iwr "$u.lua" -OutFile "$d\$n.lua"
```
### __Manual__
1. Open `%LOCALAPPDATA%\Programs\Beyond-All-Reason\data\LuaUI\Widgets`
2. Download the zip from https://github.com/tetrisface/community-widgets/archive/refs/heads/main.zip
3. Open the zip and the `community-widgets-main` folder inside it
4. Drag the `gui_metal_plate_12_player_raptor_line_grid_draw` folder into `Widgets`
5. Verify this folder structure
```
LuaUI/
└─ Widgets/
   └─ gui_metal_plate_12_player_raptor_line_grid_draw/
      └─ gui_metal_plate_12_player_raptor_line_grid_draw.lua
```
# 2. Enable
Restart BAR or run `/luaui reload`, then enable **Raptor Grid Draw 12 players (Full Metal Plate)** in the widget list (F11).
# Help / Troubleshooting
You can also ask for help here or in:
#❓｜how-to-install-mods


---------- MESSAGE LIMIT BREAK ----------


# **Core features**
- Draws the full build grid as **map line markers**, visible to allies — one player running the widget is enough
- **Survives BAR's auto map mark eraser**: every line is re-drawn just after the default 60 second erase, for as long as the grid is needed
- Stops maintaining the grid after **13 minutes** of game time, once the placement phase is over
- Posts a one-time chat hint on how to keep the lines for the whole match (disable *Auto erase map marks* in settings)
- Only activates as a player (not spectating), in Raptors/Scavengers games, on Full Metal Plate

# TROUBLESHOOTING / Problems installing or running

Assuming you are on windows, please run these commands in powershell, take the widget menu screenshot and post the results here or send directly to ChatGPT :slight_smile:
## 1. 
```pwsh
Select-String -Path "$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\log\*.*","$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\infolog.txt" -Pattern 'Raptor Grid Draw' -SimpleMatch -Context 0,3 -AllMatches
Get-ChildItem -Path "$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\LuaUI\Widgets"
Get-ChildItem -Path "$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\LuaUI\Widgets\gui_metal_plate_12_player_raptor_line_grid_draw"
```
The infolog results will include your username and maybe your name if not removed.
## 2.
Take an image showing the widget in F11 widget menu

You can post the commands and their output directly to ChatGPT to get quite accurate approximations about what could be wrong.

The goal is to find errors with the install of the widget, the widget code, the BAR setup or BAR itself.
