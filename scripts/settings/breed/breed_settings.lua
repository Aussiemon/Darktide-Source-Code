-- chunkname: @scripts/settings/breed/breed_settings.lua

local breed_settings = {}

breed_settings.types = table.enum("companion", "living_prop", "minion", "objective_prop", "player", "prop")
breed_settings.tags = table.enum_from_array({
	"bomber",
	"bulwark",
	"captain",
	"close",
	"companion",
	"cryptic",
	"cultist_captain",
	"disabler",
	"elite",
	"exclude_for_havoc_speed_buff",
	"far",
	"horde",
	"human",
	"interrupter",
	"melee",
	"minion",
	"monster",
	"mutator",
	"ogryn",
	"poxwalker",
	"ritualist",
	"roamer",
	"scrambler",
	"sniper",
	"special",
	"vanguard",
	"witch",
	"lord",
})
breed_settings.base_player_body_size_heights = {
	human_sized = 1.65,
	ogryn_sized = 2.2,
}

return settings("BreedSettings", breed_settings)
