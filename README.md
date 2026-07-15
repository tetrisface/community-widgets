**Time Weighted Team Stats** — team statistics adjusted for eco growth ("inflation"), so a player who dominated early game gets proper credit even when late-game numbers dwarf everything.

**Why time-weighting?**
Raw totals lie. In a long game the last 5 minutes of eco output can make the first 20 irrelevant by numbers alone. This widget deflates each stat window-by-window using that stat's own per-window team total as the divisor — so early damage, early metal production, and early support all count at fair weight relative to when they happened.

# **Core features**
- **Graph** with three modes — stacked absolute (bar height = raw activity, splits = time-weighted shares), stacked normalized (always 100%), and overlay (independent player lines)
- Graph time-weight toggle: raw per-window values vs time-weighted per-window values
- **Table** showing Kills, Damage, Metal, Energy, Metal excess, Energy excess, M sent, Damage efficiency, Damage efficiency per resource cost
- Three table views: **Raw** totals / **Share / %** / **Time Weighted** (inflation-adjusted)
- Ally team selector to isolate one team in the graph; separator between ally groups in grouped table mode
- Drag to move, resizable panel, configurable window aggregation (1x/2x/4x/8x — higher options only appear when there is enough data)

# TROUBLESHOOTING / Problems installing or running

Try discord: #❓｜how-to-install-mods

Assuming you are on windows, please run these commands in powershell, take the widget menu screenshot and post the results here or send directly to ChatGPT
## 1.
Select-String -Path "$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\log\*.*","$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\infolog.txt" -Pattern 'time_weighted_team_stats' -SimpleMatch -Context 0,3 -AllMatches
Get-ChildItem -Path "$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\LuaUI\Widgets"
Get-ChildItem -Path "$env:USERPROFILE\AppData\Local\Programs\Beyond-All-Reason\data\LuaUI\Widgets\time_weighted_team_stats"

The infolog results will include your username and maybe your name if not removed.

## 2.
Take an image showing the widget in F11 widget menu

You can post the commands and their output directly to ChatGPT to get quite accurate approximations about what could be wrong.

The goal is to find errors with the install of the widget, the widget code, the BAR setup or BAR itself.
