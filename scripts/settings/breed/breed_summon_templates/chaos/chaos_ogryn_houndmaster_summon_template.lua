-- chunkname: @scripts/settings/breed/breed_summon_templates/chaos/chaos_ogryn_houndmaster_summon_template.lua

local summon_templates = {
	chaos_ogryn_houndmaster = {
		initial_delay = 1,
		requires_owner = true,
		vo_event_death = "owner_call_dead",
		interval_til_next_summon = {
			10,
			20,
		},
	},
}

return summon_templates
