local weapon_template = {
	action_inputs = {},
	action_input_hierarchy = {},
	actions = {
		action_wield = {
			uninterruptible = true,
			allowed_during_sprint = true,
			kind = "wield",
			total_time = 0,
			allowed_chain_actions = {}
		}
	},
	breed_anim_state_machine_3p = {
		human = "content/characters/player/human/third_person/animations/unarmed",
		ogryn = "content/characters/player/ogryn/third_person/animations/hub_ogryn"
	},
	breed_anim_state_machine_1p = {
		human = "content/characters/player/human/first_person/animations/unarmed",
		ogryn = "content/characters/player/ogryn/first_person/animations/unarmed"
	},
	keywords = {
		"unarmed"
	},
	uses_ammunition = false,
	uses_overheat = false,
	sprint_ready_up_time = 0,
	max_first_person_anim_movement_speed = 6.4,
	fx_sources = {},
	dodge_template = "ogryn",
	sprint_template = "ogryn_hub",
	stamina_template = "default",
	toughness_template = "default"
}

return weapon_template
