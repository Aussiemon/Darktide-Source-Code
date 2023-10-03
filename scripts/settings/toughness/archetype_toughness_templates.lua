local ToughnessDepleted = require("scripts/utilities/toughness/toughness_depleted")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings_new")
local replenish_types = ToughnessSettings.replenish_types
local template_types = ToughnessSettings.template_types
local gunlugger_talent_settings = TalentSettings.ogryn_1
local archetype_toughness_templates = {
	veteran = {
		regeneration_delay = 3,
		max = 100,
		template_type = template_types.player,
		regeneration_speed = {
			still = 5,
			moving = 5
		},
		state_damage_modifiers = {
			sliding = 0.5,
			dodging = 1,
			sprinting = 1
		},
		on_depleted_function = ToughnessDepleted.spill_over,
		recovery_percentages = {
			[replenish_types.melee_kill] = 0.05
		}
	},
	psyker = {
		regeneration_delay = 3,
		max = 60,
		template_type = template_types.player,
		regeneration_speed = {
			still = 5,
			moving = 5
		},
		state_damage_modifiers = {
			sliding = 0.5,
			dodging = 0.5,
			sprinting = 1
		},
		on_depleted_function = ToughnessDepleted.spill_over,
		recovery_percentages = {
			[replenish_types.melee_kill] = 0.05,
			[replenish_types.gunslinger_crit_regen] = 0.15
		}
	},
	zealot = {
		regeneration_delay = 3,
		max = 70,
		template_type = template_types.player,
		regeneration_speed = {
			still = 5,
			moving = 5
		},
		state_damage_modifiers = {
			sliding = 0.5,
			dodging = 0.5,
			sprinting = 0.5
		},
		on_depleted_function = ToughnessDepleted.spill_over,
		recovery_percentages = {
			[replenish_types.melee_kill] = 0.05
		}
	},
	ogryn = {
		regeneration_delay = 3,
		max = 50,
		template_type = template_types.player,
		regeneration_speed = {
			still = 5,
			moving = 5
		},
		state_damage_modifiers = {
			sliding = 1,
			dodging = 1,
			sprinting = 1
		},
		on_depleted_function = ToughnessDepleted.spill_over,
		recovery_percentages = {
			[replenish_types.melee_kill] = 0.05,
			[replenish_types.ogryn_braced_regen] = gunlugger_talent_settings.defensive_3.braced_toughness_regen,
			[replenish_types.bonebreaker_heavy_hit] = 0.05
		}
	}
}

for name, settings in pairs(archetype_toughness_templates) do
	settings.name = name
end

return settings("ArchetypeToughnessTemplates", archetype_toughness_templates)
