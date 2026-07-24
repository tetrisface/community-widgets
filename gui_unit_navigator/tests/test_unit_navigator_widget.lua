local root = UNIT_NAVIGATOR_TEST_ROOT or (arg and arg[1]) or "./"
local T = dofile(root .. "tests/support.lua")

local function InstallEnvironment(options)
	options = options or {}
	local environment = {
		frame = 10,
		selection = {101, 102, 103},
		selectedByWidget = nil,
		queues = {[101] = {}, [102] = {}, [103] = {}},
		removedModels = 0,
	}
	_G.widget = {}
	_G.WG = {}
	_G.widgetHandler = {
		OwnText = function()
			environment.ownTextCalls = (environment.ownTextCalls or 0) + 1
			if options.ownTextFails then return false end
			environment.textOwned = true
			return true
		end,
		DisownText = function()
			environment.disownTextCalls = (environment.disownTextCalls or 0) + 1
			environment.textOwned = false
			return true
		end,
	}
	_G.Game = {mapSizeX = 1024, mapSizeZ = 1024}
	_G.CMD = {MOVE = 10, ATTACK = 20, PATROL = 30, INSERT = 1}
	local canonicalKeysyms = {CAPSLOCK = 301, ESCAPE = 27, F10 = 291, Q = 113, W = 119, E = 101, A = 97, S = 115, D = 100}
	if options.keysyms == false then
		_G.KEYSYMS = nil
	else
		_G.KEYSYMS = canonicalKeysyms
	end
	_G.UnitDefs = {
		[11] = {name = "builder", humanName = "Builder", canMove = true, speed = 60, weapons = {}},
		[12] = {name = "tank", humanName = "Tank", canMove = true, speed = 45, weapons = {{weaponDef = 1}}},
	}
	_G.Spring = {
		-- Recoil returns an additional frame-offset value. This must not leak
		-- into tonumber's optional numeric-base argument.
		GetGameFrame = function() return environment.frame, 0 end,
		GetSelectedUnits = function() return environment.selection end,
		GetMyTeamID = function() return 7 end,
		GetTeamUnits = function() return {101, 102, 103} end,
		GetUnitTeam = function() return 7 end,
		GetUnitDefID = function(unitID) return unitID == 103 and 12 or 11 end,
		GetUnitCommands = function(unitID) return environment.queues[unitID] or {} end,
		GetUnitPosition = function(unitID) return unitID, 0, unitID * 2 end,
		GetCameraState = function() return {name = "ta", px = 20, pz = 30} end,
		SetCameraState = function(camera, duration) environment.restoredCamera = camera environment.restoreDuration = duration end,
		SetCameraTarget = function(x, y, z, duration) environment.cameraTarget = {x, y, z, duration} end,
		SelectUnitArray = function(units) environment.selectedByWidget = units end,
		GetViewGeometry = function() return 1920, 1080 end,
		GetMouseState = function() return 960, 540 end,
		GetKeyCode = function(name)
			environment.lastRequestedKeyName = name
			if options.getKeyCode then return options.getKeyCode(name) end
			return 0
		end,
		GetKeySymbol = function(code) return tostring(code) end,
	}
	_G.VFS = {
		Include = function(path)
			if string.lower(path) == "luaui/headers/keysym.h.lua" and options.loadKeysymHeader then
				environment.keysymHeaderLoaded = true
				_G.KEYSYMS = canonicalKeysyms
				return canonicalKeysyms
			end
			local prefix = "LuaUI/Widgets/gui_unit_navigator/"
			if string.sub(path, 1, #prefix) == prefix then return dofile(root .. string.sub(path, #prefix + 1)) end
			error("unexpected include: " .. tostring(path))
		end,
	}

	local grid = {absolute_left = 220, absolute_top = 110, offset_width = 1480, offset_height = 790}
	local settings = {absolute_left = 260, absolute_top = 100, offset_width = 1400, offset_height = 850}
	local rootElement = {absolute_left = 0, absolute_top = 0, offset_width = 1920, offset_height = 1080}
	local document = {
		shown = false,
		hidden = false,
		closed = false,
		ReloadStyleSheet = function(self)
			if options.reloadFails then error("reload failed") end
			self.reloaded = true
		end,
		Show = function(self) self.shown = true self.hidden = false end,
		Hide = function(self) self.hidden = true end,
		Close = function(self) self.closed = true end,
		GetElementById = function(_, id)
			if id == "unit-navigator-grid-shell" then return grid end
			if id == "unit-navigator-settings" then return settings end
			if id == "unit-navigator-root" then return rootElement end
			return nil
		end,
	}
	local context = {
		OpenDataModel = function(_, name, model, controller)
			environment.modelName = name
			environment.controller = controller
			if options.modelFails then return nil end
			local declared = {}
			for key in pairs(model) do declared[key] = true end
			setmetatable(model, {__newindex = function(target, key, value)
				if not declared[key] then error("new DataModel root key: " .. tostring(key)) end
				rawset(target, key, value)
			end})
			environment.model = model
			return model
		end,
		LoadDocument = function(_, path)
			environment.documentPath = path
			if options.documentFails then return nil end
			return document
		end,
		RemoveDataModel = function(_, name) environment.removedModels = environment.removedModels + 1 environment.removedModelName = name end,
	}
	_G.RmlUi = {
		key_identifier = {F10 = 121},
		GetContext = function()
			if options.contextFails then return nil end
			return context
		end,
	}
	environment.document = document
	return environment
end

local function LoadWidget(options)
	local environment = InstallEnvironment(options)
	dofile(root .. "gui_unit_navigator.lua")
	return _G.widget, environment
end

local loadedWidget, environment = LoadWidget()
T.truthy(loadedWidget:Initialize())
T.equals(environment.modelName, "unit_navigator_model")
T.equals(environment.documentPath, "LuaUI/Widgets/gui_unit_navigator/gui_unit_navigator.rml")
T.truthy(environment.document.reloaded)
T.truthy(environment.document.shown)
T.falsy(environment.document.hidden)
T.truthy(environment.model.settingsVisible, "first run did not open settings")
T.truthy(_G.WG.UnitNavigator)
T.equals(loadedWidget:GetConfigData().config.activationKeyCode, 301)
T.truthy(loadedWidget:KeyPress(27, {}, false, "escape"))
T.truthy(environment.document.hidden)
T.truthy(loadedWidget:GetConfigData().onboardingComplete)
T.falsy(loadedWidget:IsAbove(960, 540), "inactive navigator claimed the map")
T.falsy(loadedWidget:MousePress(960, 540, 3), "inactive navigator consumed a move click")

T.falsy(loadedWidget:CommandNotify(10, {400, 0, 400}, {}))
loadedWidget:UnitCommand(101, 11, 7, 10, {400, 0, 400}, {}, 1, 0, false, false)
loadedWidget:UnitCommand(102, 11, 7, 10, {400, 0, 400}, {}, 2, 0, false, false)
environment.queues[101] = {{id = 10, params = {400, 0, 400}}}
environment.queues[102] = {{id = 10, params = {400, 0, 400}}}
environment.frame = 12
loadedWidget:Update(0.1)
local slot = assert(_G.WG.UnitNavigator.GetSlots()[1])
T.arrayEquals(slot.unitIDs, {101, 102})
T.arrayEquals(slot.skippedUnitIDs, {103})

T.truthy(loadedWidget:KeyPress(301, {}, false, "capslock"))
T.truthy(environment.document.shown)
T.truthy(loadedWidget:IsAbove(960, 540), "active grid did not claim its visible area")
T.truthy(loadedWidget:KeyPress(113, {}, false, "q"))
T.truthy(environment.cameraTarget, "first grid key did not preview camera")
T.truthy(loadedWidget:KeyRelease(301))
T.arrayEquals(environment.selectedByWidget, {101, 102})

loadedWidget:KeyPress(301, {}, false, "capslock")
loadedWidget:KeyPress(113, {}, false, "q")
T.truthy(loadedWidget:MousePress(10, 10, 3))
T.truthy(environment.restoredCamera, "cancel did not restore original camera")
T.falsy(loadedWidget:KeyRelease(301), "release selected after right-click cancel")

T.truthy(_G.WG.UnitNavigator.OpenSettings())
T.truthy(environment.model.settingsVisible)
loadedWidget:KeyRelease(301)
T.truthy(environment.model.settingsVisible, "Caps release closed persistent settings")
loadedWidget:CloseSettings()

local configData = loadedWidget:GetConfigData()
T.equals(configData.version, 3)
T.truthy(configData.onboardingComplete)
T.equals(configData.config.activationKeyName, "CapsLock")
T.equals(configData.config.activationKeyCode, 301)
loadedWidget:Shutdown()
T.equals(_G.WG.UnitNavigator, nil)
T.truthy(environment.document.closed)
T.equals(environment.removedModels, 1)

local reloadedWidget, reloadedEnvironment = LoadWidget()
reloadedWidget:SetConfigData(configData)
T.truthy(reloadedWidget:Initialize())
T.truthy(reloadedEnvironment.document.hidden)
T.falsy(reloadedEnvironment.model.settingsVisible, "completed onboarding reopened settings")
reloadedWidget:Shutdown()

local legacyWidget, legacyEnvironment = LoadWidget({
	keysyms = false,
	getKeyCode = function() return 0 end,
})
legacyWidget:SetConfigData({
	version = 1,
	config = {activationKeyName = "CapsLock", activationKeyCode = 0},
})
T.truthy(legacyWidget:Initialize())
T.equals(legacyWidget:GetConfigData().config.activationKeyCode, 301)
T.truthy(legacyEnvironment.model.settingsVisible, "legacy config did not receive first-run settings")
legacyWidget:CloseSettings()
T.truthy(legacyWidget:KeyPress(301, {}, false, "capslock"), "CapsLock fallback did not activate")
legacyWidget:Shutdown()

local headerWidget, headerEnvironment = LoadWidget({
	keysyms = false,
	loadKeysymHeader = true,
	getKeyCode = function() return 0 end,
})
headerWidget:SetConfigData({
	version = 2,
	onboardingComplete = true,
	config = {activationKeyName = "CapsLock", activationKeyCode = 999},
})
T.truthy(headerWidget:Initialize())
T.truthy(headerEnvironment.keysymHeaderLoaded)
T.equals(headerWidget:GetConfigData().config.activationKeyCode, 301)
headerWidget:Shutdown()

local remappedWidget = LoadWidget({keysyms = false})
remappedWidget:SetConfigData({
	version = 2,
	onboardingComplete = true,
	config = {activationKeyName = "F8", activationKeyCode = 289},
})
T.truthy(remappedWidget:Initialize())
T.equals(remappedWidget:GetConfigData().config.activationKeyCode, 289)
remappedWidget:Shutdown()

local rapidConfig = {
	version = 3,
	onboardingComplete = true,
	rapidStartTimestamps = {},
	config = {
		activationKeyBound = true,
		activationKeyName = "F8",
		activationKeyCode = 289,
		cameraPreview = false,
		glassOpacity = 0.55,
	},
}
local rapidWidget
local rapidEnvironment
for start = 1, 5 do
	rapidWidget, rapidEnvironment = LoadWidget({keysyms = false})
	rapidWidget:SetConfigData(rapidConfig)
	T.truthy(rapidWidget:Initialize())
	rapidConfig = rapidWidget:GetConfigData()
	if start < 5 then
		T.truthy(rapidConfig.config.activationKeyBound)
		T.equals(rapidConfig.config.activationKeyCode, 289)
		T.falsy(rapidEnvironment.model.settingsVisible, "rapid restart recovery triggered too early")
		rapidWidget:Shutdown()
	end
end
T.falsy(rapidConfig.config.activationKeyBound, "fifth rapid start did not clear activation")
T.equals(rapidConfig.config.activationKeyName, nil)
T.equals(rapidConfig.config.activationKeyCode, nil)
T.falsy(rapidConfig.onboardingComplete)
T.arrayEquals(rapidConfig.rapidStartTimestamps, {}, "recovery did not consume restart history")
T.falsy(rapidConfig.config.cameraPreview, "recovery reset an unrelated setting")
T.equals(rapidConfig.config.glassOpacity, 0.55)
T.truthy(rapidEnvironment.model.settingsVisible, "recovery did not reopen onboarding")
T.truthy(rapidEnvironment.model.settingsNoticeVisible)
T.equals(rapidEnvironment.model.activationKeyLabel, "SET KEY")
T.falsy(rapidWidget:KeyPress(289, {}, false, "f8"), "cleared activation key still opened the overlay")
T.truthy(rapidWidget:CloseSettings())
local unboundConfig = rapidWidget:GetConfigData()
T.falsy(unboundConfig.onboardingComplete, "unbound onboarding was acknowledged")
rapidWidget:Shutdown()

rapidWidget, rapidEnvironment = LoadWidget({keysyms = false})
rapidWidget:SetConfigData(unboundConfig)
T.truthy(rapidWidget:Initialize())
T.truthy(rapidEnvironment.model.settingsVisible, "unbound onboarding did not reopen after restart")
T.equals(rapidEnvironment.model.activationKeyLabel, "SET KEY")
rapidWidget:BeginShortcutCapture({
	current_element = {
		GetAttribute = function(_, name)
			if name == "data-target" then return "activation" end
			if name == "data-label" then return "activation" end
			return nil
		end,
	},
})
T.truthy(rapidEnvironment.textOwned, "shortcut capture did not take text ownership")
T.truthy(rapidWidget:KeyPress(290, {}, false, "f9"))
T.truthy(rapidEnvironment.textOwned, "shortcut capture released text ownership before key-up")
T.truthy(rapidWidget:KeyRelease(290))
T.falsy(rapidEnvironment.textOwned, "shortcut capture did not release text ownership on key-up")
T.truthy(rapidWidget:GetConfigData().config.activationKeyBound)
T.falsy(rapidEnvironment.model.settingsNoticeVisible)
T.truthy(rapidWidget:CloseSettings())
T.truthy(rapidWidget:GetConfigData().onboardingComplete)
T.falsy(rapidEnvironment.model.settingsVisible)
T.truthy(rapidWidget:KeyPress(290, {}, false, "f9"))
T.truthy(rapidEnvironment.model.overlayVisible)
T.falsy(rapidEnvironment.model.settingsVisible, "activation reopened settings after onboarding")
T.truthy(rapidWidget:KeyRelease(290))
rapidWidget:Shutdown()

local rmlCaptureWidget, rmlCaptureEnvironment = LoadWidget({ownTextFails = true})
rmlCaptureWidget:SetConfigData({
	version = 3,
	onboardingComplete = false,
	config = {activationKeyBound = false},
})
T.truthy(rmlCaptureWidget:Initialize())
rmlCaptureWidget:BeginShortcutCapture({
	current_element = {
		GetAttribute = function(_, name)
			if name == "data-target" then return "activation" end
			if name == "data-label" then return "activation" end
			return nil
		end,
	},
})
T.falsy(rmlCaptureEnvironment.textOwned, "failed text ownership was reported as acquired")
local rmlEventStopped = false
T.truthy(rmlCaptureWidget:CaptureRmlKey({
	parameters = {key_identifier = 121},
	StopPropagation = function() rmlEventStopped = true end,
}))
T.truthy(rmlEventStopped)
local rmlCapturedConfig = rmlCaptureWidget:GetConfigData().config
T.truthy(rmlCapturedConfig.activationKeyBound)
T.equals(rmlCapturedConfig.activationKeyCode, 291)
T.equals(rmlCapturedConfig.activationKeyName, "F10")
T.falsy(rmlCaptureEnvironment.model.captureVisible)
rmlCaptureWidget:Shutdown()

local rmlReleaseWidget, rmlReleaseEnvironment = LoadWidget()
rmlReleaseWidget:SetConfigData({
	version = 3,
	onboardingComplete = false,
	config = {activationKeyBound = false},
})
T.truthy(rmlReleaseWidget:Initialize())
rmlReleaseWidget:BeginShortcutCapture({
	current_element = {
		GetAttribute = function(_, name)
			if name == "data-target" then return "activation" end
			return nil
		end,
	},
})
T.truthy(rmlReleaseEnvironment.textOwned)
T.truthy(rmlReleaseWidget:CaptureRmlKey({parameters = {key_identifier = 121}}))
T.truthy(rmlReleaseEnvironment.textOwned)
T.truthy(rmlReleaseWidget:ReleaseRmlKey({parameters = {key_identifier = 121}}))
T.falsy(rmlReleaseEnvironment.textOwned, "RML key-up did not release text ownership")
rmlReleaseWidget:Shutdown()

loadedWidget, environment = LoadWidget({documentFails = true})
T.equals(loadedWidget:Initialize(), false)
T.equals(environment.removedModels, 1)
T.equals(_G.WG.UnitNavigator, nil)

loadedWidget, environment = LoadWidget({modelFails = true})
T.equals(loadedWidget:Initialize(), false)
T.equals(environment.removedModels, 0)

loadedWidget, environment = LoadWidget({reloadFails = true})
T.equals(loadedWidget:Initialize(), false)
T.equals(environment.removedModels, 1)
T.truthy(environment.document.closed)

loadedWidget, environment = LoadWidget({contextFails = true})
T.equals(loadedWidget:Initialize(), false)
T.equals(environment.removedModels, 0)

for _, path in ipairs({
	"include/config.lua",
	"include/restart_guard.lua",
	"include/rml_key_mapper.lua",
	"include/queue_semantics.lua",
	"include/group_store.lua",
	"include/command_observer.lua",
	"include/interaction_controller.lua",
	"include/camera_adapter.lua",
	"include/view_model.lua",
}) do
	local source = T.read(root .. path)
	for _, globalName in ipairs({"Spring.", "Game.", "RmlUi", "VFS.", "WG."}) do
		T.falsy(string.find(source, globalName, 1, true), path .. " accesses engine global " .. globalName)
	end
end

local rmlSource = T.read(root .. "gui_unit_navigator.rml")
T.contains(rmlSource, 'onkeydowncapture="widget:CaptureRmlKey(event)"', "settings do not route focused key-down events")
T.contains(rmlSource, 'onkeyupcapture="widget:ReleaseRmlKey(event)"', "settings do not route focused key-up events")
local rcssSource = T.read(root .. "gui_unit_navigator.rcss")
local function CssRuleContains(selector, declaration)
	local selectorStart = assert(string.find(rcssSource, selector, 1, true), "missing CSS selector: " .. selector)
	local blockStart = assert(string.find(rcssSource, "{", selectorStart, true), "missing CSS block: " .. selector)
	local blockEnd = assert(string.find(rcssSource, "}", blockStart, true), "unterminated CSS block: " .. selector)
	return string.find(string.sub(rcssSource, blockStart, blockEnd), declaration, 1, true) ~= nil
end
T.contains(rcssSource, ".overlay.hidden", "overlay display rule can override its hidden state")
T.contains(rcssSource, ".settings-backdrop.hidden", "settings display rule can override its hidden state")
T.contains(rcssSource, ".subgroup-tile.hidden", "subgroup display rule can override its hidden state")
T.truthy(CssRuleContains("body, #unit-navigator-root", "pointer-events: none;"), "full-screen RmlUi root can intercept map commands")
T.truthy(CssRuleContains(".gear", "pointer-events: auto;"), "settings gear is not interactive")
T.truthy(CssRuleContains(".grid-shell", "pointer-events: auto;"), "visible navigator grid is not interactive")
T.truthy(CssRuleContains(".settings-panel", "pointer-events: auto;"), "visible settings panel is not interactive")

print("test_unit_navigator_widget.lua: ok")
