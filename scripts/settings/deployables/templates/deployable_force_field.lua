-- chunkname: @scripts/settings/deployables/templates/deployable_force_field.lua

local deployable_force_field = {
	duration = 60,
	max_health = nil,
	unit_name = "content/pickups/pocketables/void_shield/void_shell_sphere_expeditions",
	unit_template = "psyker_force_field",
	particles_sphere = {
		start = "content/fx/particles/pocketables/void_shell_expeditions_spawn",
		stop = "content/fx/particles/pocketables/void_shell_expeditions_despawn",
		stop_flow_event = "lua_start_despawn",
	},
	sound_events_sphere = {
		start = "wwise/events/player/play_void_shell_start",
		stop = "wwise/events/player/play_void_shell_stop",
	},
	spawn_params = function (owner_unit, deployable_settings)
		local husk_name = deployable_settings.unit_name
		local placed_on_unit = false
		local shape_override = "sphere"
		local ability_type

		return husk_name, placed_on_unit, owner_unit, shape_override, ability_type, deployable_settings
	end,
	proximity_init_data = {},
	mission_info_vo = {
		selected_voice = "tech_priest_a",
		trigger_id = "expeditions_shield_deployed_a",
		voice_selection = "selected_voice",
	},
}

return deployable_force_field
