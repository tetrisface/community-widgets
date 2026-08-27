**Raptor Stats Panel With Eco Attraction** — a replacement for the built-in Raptor Stats Panel that also shows *who* is attracting the raptors: each player's share of the team's eco attraction, so eco-heavy players know the wave pressure they generate.

**Why eco attraction?**
Raptor aggression scales with economy. The default panel tells you *when* the queen hatches; this one also tells you *why* — which players' eco is feeding the anger gain, as a multiplier (1.0X = average) and a percentage of the team total, with your own row always visible.
# 1. Install

### __Chobby plugin__
Install via the chobby included plugins downloader

### __Scripted Automatic__
On Windows with BAR installed in the default location open powershell and run:
```pwsh
$n="gui_raptor_panel_aggro"; $d="$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\LuaUI\Widgets\$n"; New-Item -ItemType Directory -Force $d | Out-Null; iwr "https://raw.githubusercontent.com/tetrisface/community-widgets/main/$n/$n.lua" -OutFile "$d\$n.lua"
```
### __Manual__
1. Open `%LOCALAPPDATA%\Programs\Beyond-All-Reason\data\LuaUI\Widgets`
2. Download the zip from https://github.com/tetrisface/community-widgets/archive/refs/heads/main.zip
3. Open the zip and the `community-widgets-main` folder inside it
4. Drag the `gui_raptor_panel_aggro` folder into `Widgets`
5. Verify this folder structure
```
LuaUI/
└─ Widgets/
   └─ gui_raptor_panel_aggro/
      └─ gui_raptor_panel_aggro.lua
```
# 2. Enable
Restart BAR or run `/luaui reload`, then enable **Raptor Stats Panel With Eco Attraction** in the widget list (F11). It only activates in Raptors and Scavengers games.
# Help / Troubleshooting
You can also ask for help here or in:
#❓｜how-to-install-mods


---------- MESSAGE LIMIT BREAK ----------


# **Core features**
- **Player Eco Attractions** ranking — per-player attraction multiplier and team share, color-coded by how far above average a player sits
- **Smooth queen ETA countdown** — interpolated between rule updates instead of jumping, with a green/red **delta indicator** showing how much your team's aggression and eco are pulling the hatch time earlier or later
- Queen anger % with tech anger, grace period countdown
- **Boss stage breakdown** (Ctrl+B expands): queen resistances, per-player queen damage (relative to boss health or absolute), and a per-queen health grid — hovering the panel spotlights each queen in the world with its grid color
- Multi-queen support: queens killed counter and per-queen health tracking
- Wave/queen marquee messages, Raptors and Scavengers both supported
- Drag to move, Ctrl+mouse wheel to rescale
- Auto-disables the built-in **Raptor Stats Panel** to take its place

# TROUBLESHOOTING / Problems installing or running

Assuming you are on windows, please run these commands in powershell, take the widget menu screenshot and post the results here or send directly to ChatGPT :slight_smile:
## 1.
```pwsh
Select-String -Path "$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\log\*.*","$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\infolog.txt" -Pattern 'gui_raptor_panel_aggro' -SimpleMatch -Context 0,3 -AllMatches
Get-ChildItem -Path "$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\LuaUI\Widgets"
Get-ChildItem -Path "$env:LOCALAPPDATA\Programs\Beyond-All-Reason\data\LuaUI\Widgets\gui_raptor_panel_aggro"
```
The infolog results will include your username and maybe your name if not removed.
## 2.
Take an image showing the widget in F11 widget menu

You can post the commands and their output directly to ChatGPT to get quite accurate approximations about what could be wrong.

The goal is to find errors with the install of the widget, the widget code, the BAR setup or BAR itself.
