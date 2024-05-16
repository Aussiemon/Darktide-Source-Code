-- chunkname: @scripts/settings/stamina/archetype_stamina_templates.lua

local archetype_stamina_templates = {}

archetype_stamina_templates.default = {
	base_stamina = 2,
	no_stamina_sprint_speed_deceleration_time = 1,
	no_stamina_sprint_speed_multiplier = 0.5,
	regeneration_delay = 1.5,
	regeneration_per_second = 1,
}
archetype_stamina_templates.veteran = {
	base_stamina = 2,
	no_stamina_sprint_speed_deceleration_time = 1,
	no_stamina_sprint_speed_multiplier = 0.5,
	regeneration_delay = 1,
	regeneration_per_second = 1,
}
archetype_stamina_templates.zealot = {
	base_stamina = 3,
	no_stamina_sprint_speed_deceleration_time = 1,
	no_stamina_sprint_speed_multiplier = 0.75,
	regeneration_delay = 0.75,
	regeneration_per_second = 1.5,
}
archetype_stamina_templates.ogryn = {
	base_stamina = 4,
	no_stamina_sprint_speed_deceleration_time = 1,
	no_stamina_sprint_speed_multiplier = 0.75,
	regeneration_delay = 1,
	regeneration_per_second = 1,
}
archetype_stamina_templates.psyker = {
	base_stamina = 1,
	no_stamina_sprint_speed_deceleration_time = 1,
	no_stamina_sprint_speed_multiplier = 0.5,
	regeneration_delay = 0.5,
	regeneration_per_second = 1,
}

return settings("ArchetypeStaminaTemplates", archetype_stamina_templates)
