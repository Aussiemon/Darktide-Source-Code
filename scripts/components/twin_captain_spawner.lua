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
		ui_type = "number",
		min = 1,
		step = 1,
		category = "Circumstance Gameplay Data",
		value = 1,
		ui_name = "ID",
		max = 100
	},
	section = {
		ui_type = "number",
		min = 1,
		step = 1,
		category = "Circumstance Gameplay Data",
		value = 1,
		ui_name = "Section ID",
		max = 50
	},
	twin_id = {
		ui_type = "number",
		min = 1,
		step = 1,
		category = "Circumstance Gameplay Data",
		value = 1,
		ui_name = "Twin ID",
		max = 2
	}
}

return TwinCaptainSpawner
