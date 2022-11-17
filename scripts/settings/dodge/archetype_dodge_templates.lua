local archetype_dodge_templates = {
	default = {
		consecutive_dodges_reset = 0.85,
		stop_threshold = 0.25,
		base_distance = 2.5,
		dodge_cooldown = 0.15,
		minimum_dodge_input = 0.25,
		dodge_jump_override_timer = 0.5,
		dodge_linger_time = 0.25,
		dodge_speed_at_times = {
			{
				time_in_dodge = 0,
				speed = 2
			},
			{
				time_in_dodge = 0.05,
				speed = 4
			},
			{
				time_in_dodge = 0.1,
				speed = 8
			},
			{
				time_in_dodge = 0.25,
				speed = 12
			},
			{
				time_in_dodge = 0.4,
				speed = 10
			},
			{
				time_in_dodge = 0.5,
				speed = 5
			},
			{
				time_in_dodge = 0.7,
				speed = 3
			},
			{
				time_in_dodge = 1,
				speed = 4
			}
		}
	},
	zealot = {
		consecutive_dodges_reset = 0.85,
		stop_threshold = 0.25,
		base_distance = 2.75,
		dodge_cooldown = 0.15,
		minimum_dodge_input = 0.25,
		dodge_jump_override_timer = 0.5,
		dodge_linger_time = 0.25,
		dodge_speed_at_times = {
			{
				time_in_dodge = 0,
				speed = 4
			},
			{
				time_in_dodge = 0.05,
				speed = 5
			},
			{
				time_in_dodge = 0.1,
				speed = 8
			},
			{
				time_in_dodge = 0.25,
				speed = 12
			},
			{
				time_in_dodge = 0.4,
				speed = 10
			},
			{
				time_in_dodge = 0.5,
				speed = 5
			},
			{
				time_in_dodge = 0.7,
				speed = 3
			},
			{
				time_in_dodge = 1,
				speed = 4
			}
		}
	},
	psyker = {
		consecutive_dodges_reset = 0.85,
		stop_threshold = 0.25,
		base_distance = 2,
		dodge_cooldown = 0.15,
		minimum_dodge_input = 0.25,
		dodge_jump_override_timer = 0.3,
		dodge_linger_time = 0.2,
		dodge_speed_at_times = {
			{
				time_in_dodge = 0,
				speed = 5
			},
			{
				time_in_dodge = 0.05,
				speed = 4
			},
			{
				time_in_dodge = 0.1,
				speed = 8
			},
			{
				time_in_dodge = 0.25,
				speed = 10
			},
			{
				time_in_dodge = 0.4,
				speed = 8
			},
			{
				time_in_dodge = 0.5,
				speed = 5
			},
			{
				time_in_dodge = 0.7,
				speed = 4
			},
			{
				time_in_dodge = 1,
				speed = 4
			}
		}
	},
	ogryn = {
		consecutive_dodges_reset = 1,
		stop_threshold = 0.25,
		base_distance = 3,
		dodge_cooldown = 0.25,
		minimum_dodge_input = 0.25,
		dodge_jump_override_timer = 0.25,
		dodge_linger_time = 0,
		dodge_speed_at_times = {
			{
				time_in_dodge = 0,
				speed = 4
			},
			{
				time_in_dodge = 0.05,
				speed = 6
			},
			{
				time_in_dodge = 0.1,
				speed = 8
			},
			{
				time_in_dodge = 0.15,
				speed = 10
			},
			{
				time_in_dodge = 0.35,
				speed = 8
			},
			{
				time_in_dodge = 0.4,
				speed = 5
			},
			{
				time_in_dodge = 0.7,
				speed = 3
			},
			{
				time_in_dodge = 1,
				speed = 2
			}
		}
	}
}

return settings("ArchetypeDodgeTemplates", archetype_dodge_templates)
