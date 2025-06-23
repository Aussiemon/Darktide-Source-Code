-- chunkname: @scripts/managers/pacing/templates/terror_events_only_template.lua

local DefaultPacingTemplate = require("scripts/managers/pacing/templates/default_pacing_template")
local ALLOWED_SPAWN_TYPES = {
	monsters = false,
	terror_events = true,
	specials = false,
	roamers = false,
	hordes = false,
	trickle_hordes = false
}
local pacing_template = table.clone_instance(DefaultPacingTemplate)

pacing_template.name = "terror_events_only"

local state_settings = pacing_template.state_settings

for i = 1, #state_settings do
	local challenge_settings = state_settings[i]

	for _, settings in pairs(challenge_settings) do
		settings.allowed_spawn_types = ALLOWED_SPAWN_TYPES
	end
end

return pacing_template
