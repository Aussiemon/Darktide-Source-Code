-- chunkname: @scripts/settings/level_object_sets/level_object_sets_settings.lua

local level_object_sets_settings = {
	object_set_types = table.enum("controllable", "static"),
}

return settings("LevelObjectSetsSettings", level_object_sets_settings)
