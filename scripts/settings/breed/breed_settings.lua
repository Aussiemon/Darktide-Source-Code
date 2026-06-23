-- chunkname: @scripts/settings/breed/breed_settings.lua

local breed_settings = {}

breed_settings.types = table.enum("companion", "living_prop", "minion", "objective_prop", "player", "prop")
breed_settings.base_player_body_size_heights = {
	human_sized = 1.65,
	ogryn_sized = 2.2,
}

return settings("BreedSettings", breed_settings)
