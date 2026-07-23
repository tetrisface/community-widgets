local root = UNIT_NAVIGATOR_TEST_ROOT or (arg and arg[1]) or "./"
local T = dofile(root .. "tests/support.lua")
local CommandObserver = dofile(root .. "include/command_observer.lua")

local frame = 100
local selection = {1, 2, 3}
local queues = {[1] = {}, [2] = {}, [3] = {}}
local batches = {}
local observer = CommandObserver.New({
	getFrame = function() return frame end,
	getSelection = function() return selection end,
	getMyTeamID = function() return 7 end,
	getUnitTeam = function(unitID) return unitID == 99 and 8 or 7 end,
	getUnitCommands = function(unitID) return queues[unitID] or {} end,
	queueFingerprint = function(queue)
		local ids = {}
		for index, command in ipairs(queue) do ids[index] = tostring(command.id) end
		return table.concat(ids, ",")
	end,
	onBatch = function(batch) batches[#batches + 1] = batch end,
}, {snapshotDelayFrames = 2, formationBatchWindowFrames = 1})

T.falsy(observer:OnCommandNotify(10, {50, 0, 50}, {}), "observer consumed CommandNotify")
observer:OnUnitCommand(1, 11, 7, 10, {50, 0, 50}, {}, 1, 0, false, false)
observer:OnUnitCommand(2, 11, 7, 10, {50, 0, 50}, {}, 2, 0, false, false)
queues[1] = {{id = 10}}
queues[2] = {{id = 10}}
frame = 102
observer:Flush(frame)
T.equals(#batches, 1)
T.arrayEquals(batches[1].recipientUnitIDs, {1, 2})
T.arrayEquals(batches[1].skippedUnitIDs, {3})

frame = 200
selection = {1, 2}
observer:OnCommandNotify(10, {0, 0, 0}, {})
T.falsy(observer:OnUnitCommandNotify(1, 10, {10, 0, 10}, {}), "observer consumed UnitCommandNotify")
observer:OnUnitCommandNotify(2, 10, {90, 0, 90}, {})
frame = 202
observer:Flush(frame)
T.equals(#batches, 2)
local formation = batches[2]
T.equals(formation.commandContextByUnit[1].formationBatchID, formation.commandContextByUnit[2].formationBatchID)

frame = 300
selection = {1, 2, 3}
observer:OnUnitCommand(1, 11, 7, -101, {10, 0, 10}, {}, 1, 0, false, true)
observer:OnUnitCommand(2, 11, 7, -102, {20, 0, 20}, {}, 2, 0, false, true)
frame = 302
observer:Flush(frame)
T.equals(#batches, 3, "same-frame Lua orders were not kept in one dispatch")
T.arrayEquals(batches[3].recipientUnitIDs, {1, 2})
T.arrayEquals(batches[3].skippedUnitIDs, {3})

local ok, message = observer:RecordBatch({recipientUnitIDs = {}})
T.falsy(ok)
T.contains(message, "recipientUnitIDs")

frame = 400
ok = observer:RecordBatch({batchID = "producer-1", semanticKind = "formation", selectedUnitIDs = {1, 99}, recipientUnitIDs = {1, 99}, commandID = 10})
T.truthy(ok)
observer:OnUnitCommand(1, 11, 7, 10, {50, 0, 50}, {}, 9, 0, false, true)
frame = 402
observer:Flush(frame)
T.arrayEquals(batches[4].recipientUnitIDs, {1}, "producer seam admitted an enemy unit")
T.equals(#batches, 4, "producer batch duplicated its authoritative UnitCommand fallback")

ok, message = observer:RecordBatch({selectedUnitIDs = {99}, recipientUnitIDs = {99}, commandID = 10})
T.falsy(ok)
T.contains(message, "owned")

print("test_command_observer.lua: ok")
