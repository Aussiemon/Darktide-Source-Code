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

return settings("MutatorSettings", MutatorSettings)
