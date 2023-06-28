local mutator_templates = {
	mutator_enchanced_grenade_ability = {
		class = "scripts/managers/mutator/mutators/mutator_positive",
		buff_templates = {
			"mutator_player_enhanced_grenade_abilities"
		}
	},
	mutator_ability_cooldown_reduction = {
		class = "scripts/managers/mutator/mutators/mutator_positive",
		buff_templates = {
			"mutator_player_cooldown_reduction"
		}
	},
	mutator_movement_speed_on_spawn = {
		internally_controlled_buffs = true,
		class = "scripts/managers/mutator/mutators/mutator_positive",
		buff_templates = {
			"mutator_movement_speed_on_spawn"
		}
	}
}

return mutator_templates
