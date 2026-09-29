-- chunkname: @scripts/settings/difficulty/difficulty_settings.lua

local difficulty_settings = {}

difficulty_settings.difficulty_mapping = table.mirror_array_inplace({
	"uprising",
	"malice",
	"heresy",
	"damnation",
	"auric",
})

return settings("DifficultySettings", difficulty_settings)
