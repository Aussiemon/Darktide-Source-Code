local Loader = require("scripts/loading/loader")
local Missions = require("scripts/settings/mission/mission_templates")
local HudLoader = class("HudLoader")

HudLoader.init = function (self)
	self._load_done = false
end

HudLoader.destroy = function (self)
	self:cleanup()
end

HudLoader.start_loading = function (self, mission_name, level_editor_level, circumstance_name)
	local ui_manager = Managers.ui

	if ui_manager then
		local mission_settings = Missions[mission_name]
		local hud_elements = require(mission_settings.hud_elements or "scripts/ui/hud/hud_elements_player")

		local function callback()
			self:_load_done_callback()
		end

		ui_manager:load_hud_packages(hud_elements, callback)
	else
		self:_load_done_callback()
	end
end

HudLoader.is_loading_done = function (self)
	return self._load_done
end

HudLoader.cleanup = function (self)
	local ui_manager = Managers.ui

	if ui_manager and (ui_manager:hud_loaded() or ui_manager:hud_loading()) then
		ui_manager:unload_hud()
	end

	self._load_done = false
end

HudLoader._load_done_callback = function (self)
	self._load_done = true
end

implements(HudLoader, Loader)

return HudLoader
