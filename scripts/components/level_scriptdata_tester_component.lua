-- chunkname: @scripts/components/level_scriptdata_tester_component.lua

local LevelScriptdataTesterComponent = component("LevelScriptdataTesterComponent")

LevelScriptdataTesterComponent.init = function (self, unit)
	self:enable(unit)
end

LevelScriptdataTesterComponent.editor_init = function (self, unit)
	self:enable(unit)
end

local function get_neighbour_data_as_table(level, ...)
	local i = 1
	local data = {}

	while Level.has_data(level, ..., i) do
		local d = {}

		d.level = Level.get_data(level, ..., i, "level")
		d.state = Level.get_data(level, ..., i, "state")
		data[i] = d
		i = i + 1
	end

	return data
end

LevelScriptdataTesterComponent.editor_validate = function (self, unit)
	return true, ""
end

LevelScriptdataTesterComponent.enable = function (self, unit)
	return
end

LevelScriptdataTesterComponent.disable = function (self, unit)
	return
end

LevelScriptdataTesterComponent.destroy = function (self, unit)
	return
end

LevelScriptdataTesterComponent.component_data = {}
