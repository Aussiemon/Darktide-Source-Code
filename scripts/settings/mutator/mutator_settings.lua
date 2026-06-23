-- chunkname: @scripts/settings/mutator/mutator_settings.lua

local MutatorSettings = {}

MutatorSettings.dark_mutators = {
	"mutator_darkness_los",
	"mutator_ventilation_purge_los",
}
MutatorSettings.dark_themes = {
	"darkness",
	"ventilation_purge",
}
MutatorSettings.half_dark_themes = {
	"dawn",
}

return settings("MutatorSettings", MutatorSettings)
