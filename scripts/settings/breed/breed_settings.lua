-- chunkname: @scripts/settings/breed/breed_settings.lua

local breed_settings = {}

breed_settings.types = table.enum("minion", "player", "living_prop", "objective_prop", "prop")

return settings("BreedSettings", breed_settings)
