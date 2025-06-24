-- chunkname: @scripts/settings/breed/breed_settings.lua

local breed_settings = {}

breed_settings.types = table.enum("companion", "living_prop", "minion", "objective_prop", "player", "prop")

return settings("BreedSettings", breed_settings)
