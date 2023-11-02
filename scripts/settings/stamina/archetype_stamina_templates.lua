local archetype_stamina_templates = {
	default = {
		base_stamina = 2,
		regeneration_delay = 1.5,
		no_stamina_sprint_speed_multiplier = 0.5,
		regeneration_per_second = 1,
		no_stamina_sprint_speed_deceleration_time = 1
	},
	veteran = {
		base_stamina = 2,
		regeneration_delay = 1,
		no_stamina_sprint_speed_multiplier = 0.5,
		regeneration_per_second = 1,
		no_stamina_sprint_speed_deceleration_time = 1
	},
	zealot = {
		base_stamina = 3,
		regeneration_delay = 0.75,
		no_stamina_sprint_speed_multiplier = 0.75,
		regeneration_per_second = 1.5,
		no_stamina_sprint_speed_deceleration_time = 1
	},
	ogryn = {
		base_stamina = 4,
		regeneration_delay = 1,
		no_stamina_sprint_speed_multiplier = 0.75,
		regeneration_per_second = 1,
		no_stamina_sprint_speed_deceleration_time = 1
	},
	psyker = {
		base_stamina = 1,
		regeneration_delay = 0.5,
		no_stamina_sprint_speed_multiplier = 0.5,
		regeneration_per_second = 1,
		no_stamina_sprint_speed_deceleration_time = 1
	}
}

return settings("ArchetypeStaminaTemplates", archetype_stamina_templates)
