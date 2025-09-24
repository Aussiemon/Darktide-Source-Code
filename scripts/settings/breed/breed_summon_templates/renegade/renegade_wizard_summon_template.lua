-- chunkname: @scripts/settings/breed/breed_summon_templates/renegade/renegade_wizard_summon_template.lua

local summon_templates = {
	renegade_wizard = {
		requires_owner = false,
		wwise_event_probability = 0.25,
		wwise_on_death_events = {
			"wwise/events/minions/play_minion_captain__force_field_overload_vce",
		},
	},
}

return summon_templates
