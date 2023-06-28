local ToughnessDepleted = require("scripts/utilities/toughness/toughness_depleted")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local replenish_types = ToughnessSettings.replenish_types
local template_types = ToughnessSettings.template_types
local archetype_toughness_templates = {
	veteran = {
		regeneration_delay = 3,
		max = 200,
		template_type = template_types.player,
		regeneration_speed = {
			still = 5,
			moving = 5
		},
		state_damage_modifiers = {
			sliding = 0.5,
			dodging = 1,
			sprinting = 2
		},
		on_depleted_function = ToughnessDepleted.spill_over,
		recovery_percentages = {
			[replenish_types.melee_kill] = 0.075
		}
	},
	psyker = {
		regeneration_delay = 3,
		max = 100,
		template_type = template_types.player,
		regeneration_speed = {
			still = 5,
			moving = 5
		},
		state_damage_modifiers = {
			sliding = 0.5,
			dodging = 0.5,
			sprinting = 1.25
		},
		on_depleted_function = ToughnessDepleted.spill_over,
		recovery_percentages = {
			[replenish_types.melee_kill] = 0.05
		}
	},
	zealot = {
		regeneration_delay = 3,
		max = 100,
		template_type = template_types.player,
		regeneration_speed = {
			still = 5,
			moving = 5
		},
		state_damage_modifiers = {
			sliding = 0,
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
		max = 100,
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
			[replenish_types.bonebreaker_heavy_hit] = 0.05
		}
	}
}

for name, settings in pairs(archetype_toughness_templates) do
	settings.name = name
end

return settings("ArchetypeToughnessTemplates", archetype_toughness_templates)
