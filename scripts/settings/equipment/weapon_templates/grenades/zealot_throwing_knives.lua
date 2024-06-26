-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/zealot_throwing_knives.lua

local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local weapon_template = {}

local function _select_throw_anim(action_settings, condition_func_params)
	local ability_extension = condition_func_params.ability_extension
	local ability_type = action_settings.ability_type
	local charges_left = ability_extension:remaining_ability_charges(ability_type)
	local has_charges_left = charges_left > 1
	local anim_option_1 = action_settings.anim_event_non_last
	local anim_option_2 = action_settings.anim_event_last

	return has_charges_left and anim_option_1 or anim_option_2
end

weapon_template.action_inputs = {
	throw_pressed = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "grenade_ability_pressed",
				value = true,
			},
		},
	},
	quick_throw = {
		buffer_time = 0,
		dont_queue = true,
	},
	unwield_to_previous = {
		buffer_time = 0,
		dont_queue = true,
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	combat_ability = "stay",
	quick_throw = "stay",
	throw_pressed = "stay",
	unwield_to_previous = "stay",
}

table.add_missing(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

weapon_template.actions = {
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip_noammo",
		kind = "wield",
		sprint_requires_press_to_interrupt = false,
		total_time = 0,
		uninterruptible = true,
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "quick_throw",
			},
		},
		allowed_chain_actions = {
			quick_throw = {
				action_name = "throw",
			},
		},
	},
	action_unwield_to_previous = {
		allowed_during_sprint = true,
		kind = "unwield_to_previous",
		total_time = 0,
		uninterruptible = true,
		unwield_to_weapon = true,
		allowed_chain_actions = {},
	},
	throw = {
		ability_type = "grenade_ability",
		allowed_during_sprint = true,
		anim_event_last = "attack_shoot_last",
		anim_event_non_last = "attack_shoot_right",
		anim_noammo_event = "to_noammo",
		anim_time_scale = 1.5,
		fire_time = 0.1,
		kind = "spawn_projectile",
		override_origin_slot = "slot_grenade_ability",
		sprint_requires_press_to_interrupt = false,
		total_time = 0.5,
		uninterruptible = true,
		use_ability_charge = true,
		action_movement_curve = {
			{
				modifier = 0.5,
				t = 0.2,
			},
			{
				modifier = 0.4,
				t = 0.3,
			},
			{
				modifier = 1,
				t = 0.5,
			},
			start_modifier = 0.8,
		},
		allowed_chain_actions = {
			throw_pressed = {
				action_name = "throw",
				chain_time = 0.3,
			},
			combat_ability = {
				action_name = "combat_ability",
			},
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
		},
		conditional_state_to_action_input = {
			auto_chain = {
				input_name = "unwield_to_previous",
			},
		},
		fx = {
			shoot_sfx_alias = "ranged_single_shot",
		},
		anim_event_func = _select_throw_anim,
		projectile_template = ProjectileTemplates.zealot_throwing_knives,
	},
	combat_ability = {
		kind = "unwield_to_specific",
		slot_to_wield = "slot_combat_ability",
		start_input = "combat_ability",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
}
weapon_template.keywords = {
	"zealot",
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/psyker_smite"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/throwing_knives"
weapon_template.alternate_fire_settings = {
	spread_template = "no_spread",
	start_anim_event = "to_ironsight",
	stop_anim_event = "to_unaim_ironsight",
	crosshair = {
		crosshair_type = "dot",
	},
	action_movement_curve = {
		{
			modifier = 0.3,
			t = 0.1,
		},
		{
			modifier = 0.3,
			t = 0.15,
		},
		{
			modifier = 0.6,
			t = 0.25,
		},
		{
			modifier = 0.6,
			t = 0.5,
		},
		{
			modifier = 0.4,
			t = 1,
		},
		{
			modifier = 0.3,
			t = 2,
		},
		start_modifier = 1,
	},
	camera = {
		custom_vertical_fov = 45,
		near_range = 0.025,
		vertical_fov = 45,
	},
}
weapon_template.spread_template = "no_spread"
weapon_template.ammo_template = "no_ammo"
weapon_template.uses_ammunition = true
weapon_template.uses_overheat = false
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.fx_sources = {
	_muzzle = "fx_right",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/throwing_knife"

return weapon_template
