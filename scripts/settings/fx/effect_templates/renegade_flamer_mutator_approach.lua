local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionPerception = require("scripts/utilities/minion_perception")
local APPROACH_SOUND_EVENT = "wwise/events/minions/play_cultist_flamer_proximity_warning"
local TARGET_NODE_NAME = "j_spine"
local TRIGGER_DISTANCE = 25
local RESTART_TRIGGER_DISTANCE = 28
local TIME_BETWEEN_TRIGGERS = 10
local resources = {
	approach_sound_event = APPROACH_SOUND_EVENT
}
local _trigger_sound = nil
local effect_template = {
	name = "renegade_flamer_mutator_approach",
	resources = resources,
	start = function (template_data, template_context)
		template_data.next_trigger_t = 0
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		return
	end
}

return effect_template
