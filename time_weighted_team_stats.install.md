**Time Weighted Team Stats** — team statistics adjusted for eco growth ("inflation"), so a player who dominated early game gets proper credit even when late-game numbers dwarf everything.

**Why time-weighting?**
Raw totals lie. In a long game the last 5 minutes of eco output can make the first 20 irrelevant by numbers alone. This widget deflates each stat window-by-window using that stat's own per-window team total as the divisor — so early damage, early metal production, and early support all count at fair weight relative to when they happened.
# 1. Install
### __Automatic__
On Windows with BAR installed in the default location open powershell and run:
```pwsh
$n="time_weighted_team_stats"; $d="$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\LuaUI\rmlwidgets\$n"; $u="https://raw.githubusercontent.com/tetrisface/time_weighted_team_stats/main/$n"; New-Item -ItemType Directory -Force $d | Out-Null; 'lua','rml','rcss'|%{iwr "$u.$_" -OutFile "$d\$n.$_"}
```
### __Manual__
1. Create a folder called `rmlwidgets` in `%homepath%\AppData\Local\Programs\Beyond-All-Reason\data\LuaUI` if you dont already have it
2. Download the zip from https://github.com/tetrisface/time_weighted_team_stats/archive/refs/heads/main.zip
3. Open the zip and the `time_weighted_team_stats-main` folder inside it
4. Open file explorer and go to the path `%homepath%\AppData\Local\Programs\Beyond-All-Reason\data\LuaUI\rmlwidgets`
5. Drag the `time_weighted_team_stats-main` folder into `rmlwidgets`
6. Verify this folder structure
```
LuaUI/
└─ rmlwidgets/
   └─ time_weighted_team_stats-main/
      ├─ time_weighted_team_stats.lua
      ├─ time_weighted_team_stats.rml
      └─ time_weighted_team_stats.rcss
```
# 2. Enable
Restart BAR or run `/luaui reload`, then enable **Time Weighted Team Stats** in the widget list (F11).
# Help / Troubleshooting
You can ask in here also but the instructions apply to regular widgets, not rmlwidgets yet: 
#❓｜how-to-install-mods


---------- MESSAGE LIMIT BREAK ----------


**Core features**
- Three table views: **Raw** totals / **Share%** / **Time Weighted** (inflation-adjusted)
- **Graph** with three modes — stacked absolute (bar height = raw activity, splits = time-weighted shares), stacked normalized (always 100%), and overlay (independent player lines)
- Graph time-weight toggle: raw per-window values vs time-weighted per-window values
- Players who leave mid-game **keep their stats visible**
- Ally team selector to isolate one team in the graph; separator between ally groups in grouped table mode
- Drag to move, resizable panel, configurable window aggregation (1x/2x/4x/8x — higher options only appear when there is enough data)

**Niche**
- Most useful in longer or uneven games where eco scaling makes raw numbers misleading
- Share / % view: who did what fraction of the team's work
- Time Weighted view: who punched above their weight considering *when* they did it

# TROUBLESHOOTING / Problems installing or running

Assuming you are on windows, please run these commands in powershell, take the widget menu screenshot and post the results here or send directly to ChatGPT :slight_smile:
## 1. 
```pwsh
Select-String -Path "$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\log\*.*","$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\infolog.txt" -Pattern 'time_weighted_team_stats' -SimpleMatch -Context 0,3 -AllMatches
Get-ChildItem -Path "$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\LuaUI\rmlwidgets"
Get-ChildItem -Path "$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\LuaUI\rmlwidgets\time_weighted_team_stats"
```
The infolog results will include your username and maybe your name if not removed.
## 2.
Take an image showing the widget in F11 widget menu

You can post the commands and their output directly to ChatGPT to get quite accurate approximations about what could be wrong.

The goal is to find errors with the install of the widget, the widget code, the BAR setup or BAR itself.
