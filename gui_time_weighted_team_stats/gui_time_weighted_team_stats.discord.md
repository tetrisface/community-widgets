**Time Weighted Team Stats** — team statistics adjusted for eco growth ("inflation"), so a player who dominated early game gets proper credit even when late-game numbers dwarf everything.

**Why time-weighting?**
Raw totals lie. In a long game the last 5 minutes of eco output can make the first 20 irrelevant by numbers alone. This widget deflates each stat window-by-window using that stat's own per-window team total as the divisor — so early damage, early metal production, and early support all count at fair weight relative to when they happened.
# 1. Install
### __Automatic__
On Windows with BAR installed in the default location open powershell and run:
```pwsh
$n="gui_time_weighted_team_stats"; $d="$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\LuaUI\Widgets\$n"; $u="https://raw.githubusercontent.com/tetrisface/time_weighted_team_stats/main/$n/$n"; New-Item -ItemType Directory -Force $d | Out-Null; 'lua','rml','rcss'|%{iwr "$u.$_" -OutFile "$d\$n.$_"}
```
### __Manual__
1. Open `%homepath%\AppData\Local\Programs\Beyond-All-Reason\data\LuaUI\Widgets`
2. Download the zip from https://github.com/tetrisface/time_weighted_team_stats/archive/refs/heads/main.zip
3. Open the zip and the `time_weighted_team_stats-main` folder inside it
4. Drag the `gui_time_weighted_team_stats` folder into `Widgets`
5. Verify this folder structure
```
LuaUI/
└─ Widgets/
   └─ gui_time_weighted_team_stats/
      ├─ gui_time_weighted_team_stats.lua
      ├─ gui_time_weighted_team_stats.rml
      └─ gui_time_weighted_team_stats.rcss
```
# 2. Enable
Restart BAR or run `/luaui reload`, then enable **Time Weighted Team Stats** in the widget list (F11).
# Help / Troubleshooting
You can also ask for help here or in:
#❓｜how-to-install-mods


---------- MESSAGE LIMIT BREAK ----------


# **Core features**
- Three table views: **Raw** totals / **Share / %** / **Time Weighted** (inflation-adjusted)
- **Graph** with three modes — stacked absolute (bar height = raw activity, splits = time-weighted shares), stacked normalized (always 100%), and overlay (independent player lines)
- Graph time-weight toggle: raw per-window values vs time-weighted per-window values
- Players who leave mid-game **keep their stats visible**
- Ally team selector to isolate one team in the graph; separator between ally groups in grouped table mode
- Drag to move, resizable panel, configurable window aggregation (1x/2x/4x/8x — higher options only appear when there is enough data)

# TROUBLESHOOTING / Problems installing or running

Assuming you are on windows, please run these commands in powershell, take the widget menu screenshot and post the results here or send directly to ChatGPT :slight_smile:
## 1. 
```pwsh
Select-String -Path "$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\log\*.*","$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\infolog.txt" -Pattern 'gui_time_weighted_team_stats' -SimpleMatch -Context 0,3 -AllMatches
Get-ChildItem -Path "$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\LuaUI\Widgets"
Get-ChildItem -Path "$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\LuaUI\Widgets\gui_time_weighted_team_stats"
```
The infolog results will include your username and maybe your name if not removed.
## 2.
Take an image showing the widget in F11 widget menu

You can post the commands and their output directly to ChatGPT to get quite accurate approximations about what could be wrong.

The goal is to find errors with the install of the widget, the widget code, the BAR setup or BAR itself.
