-- chunkname: @scripts/settings/circumstance/mission_overrides/stat_overrides.lua

local StatOverrides = {}

local function add_override(name)
	StatOverrides["stats_" .. name] = {
		stat_settings = {
			[name] = true,
		},
	}
end

add_override("saints")
add_override("default")
add_override("story")

return StatOverrides
