-- chunkname: @scripts/managers/pacing/auto_event/templates/live_event_endless_hordes_auto_event_template.lua

local auto_events = {
	live_event_endless_hordes_auto_event_template = {
		minimum_amount_of_enemies_required = 45,
		minimum_time_before_forced_spawn = 5,
		name = "live_event_endless_hordes_auto_event_template",
		spawn_on_terror_events = true,
		should_update_event_position = {
			should_be_offset_from_main_path = 25,
			wanted_direction = "fwd",
		},
		inital_cooldown_types = {
			default = 1,
		},
		num_waves_by_resistance = {
			1,
			1,
			2,
			2,
			2,
		},
		cooldown = {
			{
				10,
				14,
			},
			{
				8,
				12,
			},
			{
				6,
				10,
			},
			{
				4,
				6,
			},
			{
				2,
				4,
			},
		},
		waves_cooldown = {
			{
				10,
				14,
			},
			{
				8,
				12,
			},
			{
				6,
				10,
			},
			{
				5,
				8,
			},
			{
				3,
				6,
			},
		},
		resistance_multiplier = {
			0.45,
			0.5,
			0.55,
			0.6,
			0.65,
		},
		points_base = {
			22,
			26,
			30,
			34,
			38,
		},
		size_multipliers = {
			default = 1,
		},
		composition = {
			default = {
				breeds = {
					{
						points = 0,
						breed_tags = {
							{
								"horde",
							},
						},
						weights = {
							{
								0.7,
								0.9,
								1.1,
								1.3,
								1.5,
							},
							{
								0.7,
								0.9,
								1.1,
								1.3,
								1.5,
							},
							{
								0.7,
								0.9,
								1.1,
								1.3,
								1.5,
							},
							{
								0.7,
								0.9,
								1.1,
								1.3,
								1.5,
							},
							{
								0.7,
								0.9,
								1.1,
								1.3,
								1.5,
							},
						},
					},
				},
			},
		},
		conditional_function = function (t)
			if Managers.state.terror_event:num_active_events() > 0 then
				return t[1]
			end

			local path_completed = Managers.state.main_path:furthest_travel_percentage(1)
			local max_threat = 5
			local normalized_threat_progression = 1 / max_threat
			local current_threat_by_path_completion = math.clamp(math.floor(path_completed / normalized_threat_progression) + 1, 1, max_threat)

			return t[current_threat_by_path_completion]
		end,
	},
}

return auto_events
