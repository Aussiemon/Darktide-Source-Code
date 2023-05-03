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
	}
}

return mutator_templates
