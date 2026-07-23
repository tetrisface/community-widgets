local Config = {}

local DEFAULTS = {
	activationKeyBound = true,
	activationKeyName = "CapsLock",
	activationKeyCode = 301,
	gridKeyNames = {"Q", "W", "E", "A", "S", "D"},
	gridKeyCodes = {113, 119, 101, 97, 115, 100},
	cancelKeyName = "Escape",
	cancelKeyCode = 27,
	cameraPreview = true,
	cameraTransitionSeconds = 0.12,
	mouseLeaveGuardDp = 24,
	mouseLeaveDelaySeconds = 0.15,
	glassOpacity = 0.82,
	terrainOpacity = 0.72,
	nonGroupUnitOpacity = 0.28,
	formationBatchWindowFrames = 1,
	buildPositionTolerance = 8,
	queueEquivalencePolicy = "semantic",
	commandFamilyFilters = {
		build = true,
		move = true,
		attack = true,
		patrol = true,
		other = true,
	},
}

local function Copy(value)
	if type(value) ~= "table" then return value end
	local copy = {}
	for key, child in pairs(value) do copy[key] = Copy(child) end
	return copy
end

local function Clamp(value, minimum, maximum, fallback)
	value = tonumber(value)
	if not value then return fallback end
	return math.max(minimum, math.min(maximum, value))
end

local function KeyCode(value, fallback)
	value = tonumber(value)
	if not value or value < 1 or value > 65535 then return fallback end
	return math.floor(value)
end

function Config.Defaults()
	return Copy(DEFAULTS)
end

function Config.Normalize(saved)
	local result = Config.Defaults()
	if type(saved) ~= "table" then return result end

	if saved.activationKeyBound == false then
		result.activationKeyBound = false
		result.activationKeyName = nil
		result.activationKeyCode = nil
	else
		if type(saved.activationKeyName) == "string" then result.activationKeyName = saved.activationKeyName end
		result.activationKeyCode = KeyCode(saved.activationKeyCode, result.activationKeyCode)
	end
	if type(saved.cancelKeyName) == "string" then result.cancelKeyName = saved.cancelKeyName end
	result.cancelKeyCode = KeyCode(saved.cancelKeyCode, result.cancelKeyCode)

	if type(saved.gridKeyNames) == "table" and type(saved.gridKeyCodes) == "table" then
		for index = 1, 6 do
			if type(saved.gridKeyNames[index]) == "string" then result.gridKeyNames[index] = saved.gridKeyNames[index] end
			result.gridKeyCodes[index] = KeyCode(saved.gridKeyCodes[index], result.gridKeyCodes[index])
		end
	end

	if type(saved.cameraPreview) == "boolean" then result.cameraPreview = saved.cameraPreview end
	result.cameraTransitionSeconds = Clamp(saved.cameraTransitionSeconds, 0, 1.5, result.cameraTransitionSeconds)
	result.mouseLeaveGuardDp = Clamp(saved.mouseLeaveGuardDp, 0, 96, result.mouseLeaveGuardDp)
	result.mouseLeaveDelaySeconds = Clamp(saved.mouseLeaveDelaySeconds, 0, 1, result.mouseLeaveDelaySeconds)
	result.glassOpacity = Clamp(saved.glassOpacity, 0.2, 1, result.glassOpacity)
	result.terrainOpacity = Clamp(saved.terrainOpacity, 0, 1, result.terrainOpacity)
	result.nonGroupUnitOpacity = Clamp(saved.nonGroupUnitOpacity, 0, 1, result.nonGroupUnitOpacity)
	result.formationBatchWindowFrames = math.floor(Clamp(saved.formationBatchWindowFrames, 0, 30, result.formationBatchWindowFrames))
	result.buildPositionTolerance = Clamp(saved.buildPositionTolerance, 0, 128, result.buildPositionTolerance)
	if saved.queueEquivalencePolicy == "semantic" or saved.queueEquivalencePolicy == "strict" then
		result.queueEquivalencePolicy = saved.queueEquivalencePolicy
	end
	if type(saved.commandFamilyFilters) == "table" then
		for family in pairs(result.commandFamilyFilters) do
			if type(saved.commandFamilyFilters[family]) == "boolean" then
				result.commandFamilyFilters[family] = saved.commandFamilyFilters[family]
			end
		end
	end
	return result
end

function Config.WithoutActivation(source)
	local result = Config.Normalize(source)
	result.activationKeyBound = false
	result.activationKeyName = nil
	result.activationKeyCode = nil
	return result
end

function Config.Copy(value)
	return Copy(value)
end

return Config
