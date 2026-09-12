##############################################################
#       Raptor Grid Draw 12 players (Full Metal Plate)       #
##############################################################
Draws a fairly distributed build areas for every player in 12 player Raptors/Scavengers games on Full Metal Plate, so nobody has to argue about who builds where.

##############################################################
#                            Why?                            #
##############################################################
Full Metal Plate has no natural lanes or start boxes worth the name in PvE. The grid splits the plate into 12 equal build areas with a shared central zone and corridors, drawn as map lines that your whole team sees.

##############################################################
#                       Core features                        #
##############################################################
- Draws the full build grid as **map line markers**, visible to allies — one player running the widget is enough
- **Survives BAR's auto map mark eraser**: every line is re-drawn just after the default 60 second erase, for as long as the grid is needed
- Stops maintaining the grid after **13 minutes** of game time, once the placement phase is over
- Sends lines in small batches to stay under the engine's marker spam protection
- Posts a one-time chat hint on how to keep the lines for the whole match (disable *Auto erase map marks* in settings)
- Only activates when it should: as a player (not spectating), in Raptors/Scavengers games, on Full Metal Plate with a matching map size
