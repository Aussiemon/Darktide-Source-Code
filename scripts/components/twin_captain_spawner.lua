-- chunkname: @scripts/components/twin_captain_spawner.lua

local TwinCaptainSpawner = component("TwinCaptainSpawner")

TwinCaptainSpawner.init = function (self, unit, is_server, nav_world)
	self._unit = unit

	local run_update = false

	return run_update
end

TwinCaptainSpawner.destroy = function (self, unit)
	return
end

TwinCaptainSpawner.enable = function (self, unit)
	return
end

TwinCaptainSpawner.disable = function (self, unit)
	return
end

TwinCaptainSpawner.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	return true
end

TwinCaptainSpawner.editor_validate = function (self, unit)
	return true, ""
end

TwinCaptainSpawner.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end
end

TwinCaptainSpawner.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	return true
end

TwinCaptainSpawner.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end
end

TwinCaptainSpawner._editor_debug_draw = function (self, unit)
	return
end

TwinCaptainSpawner.component_data = {
	id = {
		category = "Circumstance Gameplay Data",
		max = 100,
		min = 1,
		step = 1,
		ui_name = "ID",
		ui_type = "number",
		value = 1,
	},
	section = {
		category = "Circumstance Gameplay Data",
		max = 50,
		min = 1,
		step = 1,
		ui_name = "Section ID",
		ui_type = "number",
		value = 1,
	},
	twin_id = {
		category = "Circumstance Gameplay Data",
		max = 2,
		min = 1,
		step = 1,
		ui_name = "Twin ID",
		ui_type = "number",
		value = 1,
	},
}

return TwinCaptainSpawner
