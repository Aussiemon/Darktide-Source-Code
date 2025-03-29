-- chunkname: @scripts/settings/toughness/archetype_toughness_templates.lua

local ToughnessDepleted = require("scripts/utilities/toughness/toughness_depleted")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local replenish_types = ToughnessSettings.replenish_types
local template_types = ToughnessSettings.template_types
local gunlugger_talent_settings = TalentSettings.ogryn_1
local archetype_toughness_templates = {}

archetype_toughness_templates.veteran = {
	max = 100,
	regeneration_delay = 3,
	template_type = template_types.player,
	regeneration_speed = {
		moving = 5,
		still = 5,
	},
	state_damage_modifiers = {
		dodging = 1,
		sliding = 0.5,
		sprinting = 1,
	},
	on_depleted_function = ToughnessDepleted.spill_over,
	recovery_percentages = {
		[replenish_types.melee_kill] = 0.05,
	},
}
archetype_toughness_templates.psyker = {
	max = 75,
	regeneration_delay = 3,
	template_type = template_types.player,
	regeneration_speed = {
		moving = 5,
		still = 5,
	},
	state_damage_modifiers = {
		dodging = 0.5,
		sliding = 0.5,
		sprinting = 1,
	},
	on_depleted_function = ToughnessDepleted.spill_over,
	recovery_percentages = {
		[replenish_types.melee_kill] = 0.05,
		[replenish_types.gunslinger_crit_regen] = 0.15,
	},
}
archetype_toughness_templates.zealot = {
	max = 70,
	regeneration_delay = 3,
	template_type = template_types.player,
	regeneration_speed = {
		moving = 5,
		still = 5,
	},
	state_damage_modifiers = {
		dodging = 0.5,
		sliding = 0.5,
		sprinting = 0.5,
	},
	on_depleted_function = ToughnessDepleted.spill_over,
	recovery_percentages = {
		[replenish_types.melee_kill] = 0.05,
	},
}
archetype_toughness_templates.ogryn = {
	max = 75,
	regeneration_delay = 3,
	template_type = template_types.player,
	regeneration_speed = {
		moving = 5,
		still = 5,
	},
	state_damage_modifiers = {
		dodging = 1,
		sliding = 1,
		sprinting = 1,
	},
	on_depleted_function = ToughnessDepleted.spill_over,
	recovery_percentages = {
		[replenish_types.melee_kill] = 0.05,
		[replenish_types.ogryn_braced_regen] = gunlugger_talent_settings.defensive_3.braced_toughness_regen,
		[replenish_types.bonebreaker_heavy_hit] = 0.05,
	},
}

for name, settings in pairs(archetype_toughness_templates) do
	settings.name = name
end

return settings("ArchetypeToughnessTemplates", archetype_toughness_templates)
