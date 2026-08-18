-- chunkname: @scripts/settings/equipment/weapon_templates/transonic_claw/transonic_claw_p1_m1.lua

local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local HapticTriggerTemplates = require("scripts/settings/equipment/haptic_trigger_templates")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local HitZone = require("scripts/utilities/attack/hit_zone")
local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local MeleeActionInputSetupFast = require("scripts/settings/equipment/weapon_templates/melee_action_input_setup_fast")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local WeaponTraitsBespokeTransonicClawP1 = require("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_transonic_claw_p1")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local armor_types = ArmorSettings.types
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local damage_types = DamageSettings.damage_types
local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
local hit_zone_names = HitZone.hit_zone_names
local template_types = WeaponTweakTemplateSettings.template_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local wounds_shapes = WoundsSettings.shapes
local damage_trait_templates = WeaponTraitTemplates[template_types.damage]
local dodge_trait_templates = WeaponTraitTemplates[template_types.dodge]
local recoil_trait_templates = WeaponTraitTemplates[template_types.recoil]
local spread_trait_templates = WeaponTraitTemplates[template_types.spread]
local sprint_trait_templates = WeaponTraitTemplates[template_types.sprint]
local stamina_trait_templates = WeaponTraitTemplates[template_types.stamina]
local ammo_trait_templates = WeaponTraitTemplates[template_types.ammo]
local sway_trait_templates = WeaponTraitTemplates[template_types.sway]
local toughness_trait_templates = WeaponTraitTemplates[template_types.toughness]
local weapon_handling_trait_templates = WeaponTraitTemplates[template_types.weapon_handling]
local movement_curve_modifier_trait_templates = WeaponTraitTemplates[template_types.movement_curve_modifier]
local weapon_template = {}
local action_inputs = {
	combat_ability = {
		buffer_time = 0,
		input_sequence = nil,
	},
	lunge_aim_start = {
		buffer_time = 0,
		input_sequence = nil,
	},
	instant_ability_use = {
		buffer_time = 0.1,
		input_sequence = {
			{
				input = "combat_ability_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	lunge_aim_end = {
		buffer_time = 0.6,
		input_sequence = {
			{
				input = "combat_ability_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	lunge_start = {
		buffer_time = 0,
		input_sequence = nil,
	},
	lunge_attack_start = {
		buffer_time = 0,
		input_sequence = nil,
	},
	lunge_attack_start_big_stab = {
		buffer_time = 0,
		input_sequence = nil,
	},
	lunge_attack_start_chained_stab = {
		buffer_time = 0,
		input_sequence = nil,
	},
	lunge_attack_start_horizontal_swipe = {
		buffer_time = 0,
		input_sequence = nil,
	},
	cancel = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				input = "action_two_pressed",
				value = true,
			},
		},
	},
	wield = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = {
			{
				inputs = wield_inputs,
			},
		},
	},
	unwield_to_previous = {
		buffer_time = 0,
		input_sequence = nil,
	},
	no_running_action_unwield_prievious = {
		buffer_time = 0,
		input_sequence = nil,
	},
	attack_chain_end = {
		buffer_time = 0,
		input_sequence = nil,
	},
	grenade_ability = {
		buffer_time = 0,
		clear_input_queue = true,
		input_sequence = nil,
	},
}
local action_input_hierarchy = {
	{
		input = "unwield_to_previous",
		transition = "base",
	},
	{
		input = "no_running_action_unwield_prievious",
		transition = "base",
	},
	{
		input = "lunge_aim_start",
		transition = {
			{
				input = "lunge_aim_end",
				transition = {
					{
						input = "lunge_start",
						transition = {
							{
								input = "cancel",
								transition = "base",
							},
							{
								input = "lunge_attack_start",
								transition = "base",
							},
						},
					},
					{
						input = "lunge_attack_start",
						transition = "base",
					},
				},
			},
			{
				input = "unwield_to_previous",
				transition = "base",
			},
			{
				input = "cancel",
				transition = "base",
			},
		},
	},
	{
		input = "instant_ability_use",
		transition = {
			{
				input = "instant_ability_use",
				transition = "stay",
			},
			{
				input = "lunge_start",
				transition = {
					{
						input = "cancel",
						transition = "base",
					},
					{
						input = "lunge_attack_start",
						transition = "base",
					},
					{
						input = "unwield_to_previous",
						transition = "base",
					},
				},
			},
			{
				input = "lunge_attack_start",
				transition = "base",
			},
		},
	},
	{
		input = "lunge_attack_start_big_stab",
		transition = {
			{
				input = "attack_chain_end",
				transition = "base",
			},
		},
	},
	{
		input = "lunge_attack_start_chained_stab",
		transition = {
			{
				input = "lunge_attack_start_chained_stab",
				transition = "stay",
			},
			{
				input = "attack_chain_end",
				transition = "base",
			},
			{
				input = "unwield_to_previous",
				transition = "base",
			},
		},
	},
	{
		input = "lunge_attack_start_horizontal_swipe",
		transition = {
			{
				input = "attack_chain_end",
				transition = "base",
			},
		},
	},
	{
		input = "attack_chain_end",
		transition = "base",
	},
	{
		input = "wield",
		transition = "base",
	},
	{
		input = "cancel",
		transition = "base",
	},
}

weapon_template.action_inputs = action_inputs
weapon_template.action_input_hierarchy = action_input_hierarchy

local melee_sticky_disallowed_hit_zones = {
	hit_zone_names.shield,
}
local melee_sticky_force_abort_breed_tags = {
	"elite",
	"special",
	"monster",
	"captain",
}
local heavy_hit_stickyness_settings = {
	always_sticky = true,
	disable_vertical_force_view = true,
	disallow_chain_actions = true,
	disallow_dodging = false,
	dodge_stamina_drain_percentage = 0.2,
	duration = 0.45,
	min_sticky_time = 0.2,
	sensitivity_modifier = 0,
	start_anim_event = "attack_hit_stick",
	start_anim_event_3p = "attack_hit_stick",
	stop_anim_event = "yank_out",
	stop_anim_event_3p = "yank_out",
	damage = {
		instances = 1,
		damage_profile = DamageProfileTemplates.chordclaw_sticky,
		damage_type = damage_types.transonic_claw_rip,
		dodge_damage_profile = DamageProfileTemplates.chordclaw_sticky_dodge,
	},
	disallowed_hit_zones = melee_sticky_disallowed_hit_zones,
	movement_curve = {
		{
			modifier = 0.3,
			t = 0.5,
		},
		{
			modifier = 0.45,
			t = 0.55,
		},
		{
			modifier = 0.5,
			t = 0.6,
		},
		{
			modifier = 0.6,
			t = 1,
		},
		{
			modifier = 0.5,
			t = 1.3,
		},
		start_modifier = 0.1,
	},
}
local short_weapon_box = {
	0.1,
	0.075,
	0.9,
}
local default_weapon_box = {
	0.15,
	0.15,
	1.1,
}
local long_weapon_box = {
	0.2,
	0.2,
	1.2,
}
local large_weapon_box = {
	0.3,
	0.3,
	1.2,
}

weapon_template.actions = {
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		skip_ability_chain_action_check = true,
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_unwield_to_previous = {
		allowed_during_sprint = true,
		kind = "unwield_to_previous",
		skip_ability_chain_action_check = true,
		start_input = "no_running_action_unwield_prievious",
		total_time = 0,
		uninterruptible = true,
		unwield_to_weapon = true,
		allowed_chain_actions = {},
	},
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip",
		kind = "wield",
		skip_ability_chain_action_check = true,
		sprint_ready_up_time = 0,
		total_time = 0.21,
		uninterruptible = true,
		conditional_state_to_action_input = {
			action_end = {
				input_name = "lunge_aim_start",
			},
		},
		finish_reason_to_action_input = {
			ledge_vaulting = {
				input_name = "unwield_to_previous",
			},
			stunned = {
				input_name = "unwield_to_previous",
			},
			push = {
				input_name = "unwield_to_previous",
			},
		},
		allowed_chain_actions = {
			instant_ability_use = {
				action_name = "action_instant_use",
			},
			lunge_aim_start = {
				action_name = "action_lunge_aim",
				chain_time = 0.2,
			},
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
			cancel = {
				action_name = "action_lunge_aim_cancel",
			},
		},
	},
	action_lunge_aim = {
		allowed_during_sprint = true,
		anim_event = "heavy_charge_stab_sticky",
		anim_event_3p = "heavy_charge",
		charge_template = "cryptic_chordclaw",
		kind = "charge",
		skip_ability_chain_action_check = true,
		start_input = nil,
		stop_input = "lunge_aim_end",
		uninterruptible = true,
		total_time = math.huge,
		finish_reason_to_action_input = {
			ledge_vaulting = {
				input_name = "unwield_to_previous",
			},
			stunned = {
				input_name = "unwield_to_previous",
			},
			push = {
				input_name = "unwield_to_previous",
			},
		},
		charge_effects = {
			is_2d = true,
			looping_sound_alias = "melee_charging",
			sfx_source_name = "_charge",
		},
		allowed_chain_actions = {
			lunge_aim_end = {
				action_name = "action_lunge_aim_transition_from_charge",
			},
			cancel = {
				action_name = "action_lunge_aim_cancel",
			},
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
		},
	},
	action_lunge_aim_cancel = {
		allowed_during_sprint = true,
		anim_event = "ability_unwield",
		anim_event_3p = "attack_finished",
		anim_time_scale = 1,
		kind = "dummy",
		skip_ability_chain_action_check = true,
		start_input = nil,
		total_time = 0.22,
		uninterruptible = true,
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
		conditional_state_to_action_input = {
			action_end = {
				input_name = "unwield_to_previous",
			},
		},
		finish_reason_to_action_input = {
			ledge_vaulting = {
				input_name = "unwield_to_previous",
			},
			stunned = {
				input_name = "unwield_to_previous",
			},
			push = {
				input_name = "unwield_to_previous",
			},
		},
		allowed_chain_actions = {
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
		},
	},
	action_instant_use = {
		allowed_during_sprint = true,
		charge_template = "cryptic_chordclaw_instant",
		kind = "charge",
		skip_ability_chain_action_check = true,
		start_input = nil,
		total_time = 0.1,
		uninterruptible = true,
		conditional_state_to_action_input = {
			action_end = {
				input_name = "instant_ability_use",
			},
		},
		allowed_chain_actions = {
			instant_ability_use = {
				action_name = "action_lunge_aim_transition_from_instant",
			},
		},
	},
	action_lunge_aim_transition_from_instant = {
		allowed_during_sprint = true,
		kind = "cryptic_chordclaw_activation",
		skip_ability_chain_action_check = true,
		start_input = nil,
		total_time = 0.1,
		uninterruptible = true,
		conditional_state_to_action_input = {
			can_do_lunge = {
				input_name = "lunge_start",
			},
			cannot_do_lunge = {
				input_name = "lunge_attack_start",
			},
		},
		allowed_chain_actions = {
			lunge_start = {
				action_name = "action_lunge_start_from_instant",
			},
			lunge_attack_start = {
				action_name = "action_lunge_attack_start_from_instant",
			},
		},
	},
	action_lunge_start_from_instant = {
		allowed_during_sprint = true,
		kind = "lunge_start_and_wait_for_end",
		skip_ability_chain_action_check = true,
		start_input = nil,
		uninterruptible = true,
		total_time = math.huge,
		lunge_state_params = {
			lunge_template_name = LungeTemplates.zealot_dash.name,
		},
		running_action_state_to_action_input = {
			lunge_ended = {
				input_name = "lunge_attack_start",
			},
			cancel = {
				input_name = "cancel",
			},
		},
		finish_reason_to_action_input = {
			ledge_vaulting = {
				input_name = "unwield_to_previous",
			},
			stunned = {
				input_name = "unwield_to_previous",
			},
			push = {
				input_name = "unwield_to_previous",
			},
		},
		allowed_chain_actions = {
			cancel = {
				action_name = "action_lunge_aim_cancel",
			},
			lunge_attack_start = {
				action_name = "action_lunge_attack_start_from_instant",
			},
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
		},
	},
	action_lunge_attack_start_from_instant = {
		allowed_during_sprint = true,
		kind = "dummy",
		skip_ability_chain_action_check = true,
		start_input = nil,
		uninterruptible = true,
		total_time = math.huge,
		conditional_state_to_action_input = {
			cryptic_chordclaw_do_big_sticky_attack = {
				input_name = "lunge_attack_start_big_stab",
			},
			cryptic_chordclaw_do_quick_stab_combo = {
				input_name = "lunge_attack_start_chained_stab",
			},
			cryptic_chordclaw_do_horizonal_swipe = {
				input_name = "lunge_attack_start_horizontal_swipe",
			},
		},
		allowed_chain_actions = {
			lunge_attack_start_big_stab = {
				action_name = "action_heavy_sticky_attack_1",
			},
			lunge_attack_start_chained_stab = {
				action_name = "action_stab_1",
			},
			lunge_attack_start_horizontal_swipe = {
				action_name = "action_horizontal_attack_1",
			},
		},
	},
	action_heavy_sticky_attack_1 = {
		allowed_during_sprint = true,
		anim_event = "heavy_attack_stab_sticky",
		anim_event_3p = "heavy_attack_sticky",
		attack_direction_override = "pull",
		damage_window_end = 0.26666666666666666,
		damage_window_start = 0.075,
		first_person_hit_stop_anim = "attack_hit",
		guaranteed_crit = true,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.25,
		skip_ability_chain_action_check = true,
		start_input = nil,
		total_time = 0.9,
		uninterruptible = true,
		use_charge = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 2.5,
				t = 0.15,
			},
			{
				modifier = 2,
				t = 0.35,
			},
			{
				modifier = 1.5,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 0.75,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "attack_chain_end",
			},
		},
		finish_reason_to_action_input = {
			ledge_vaulting = {
				input_name = "attack_chain_end",
			},
			stunned = {
				input_name = "attack_chain_end",
			},
			push = {
				input_name = "attack_chain_end",
			},
		},
		allowed_chain_actions = {
			attack_chain_end = {
				action_name = "action_unwield_to_previous",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = long_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/transonic_claw/attack_heavy_stab",
				anchor_point_offset = {
					0,
					0,
					0,
				},
			},
		},
		damage_profile = DamageProfileTemplates.chordclaw_main,
		damage_type = damage_types.transonic_claw_stick,
		force_abort_breed_tags = melee_sticky_force_abort_breed_tags,
		hit_stickyness_settings = heavy_hit_stickyness_settings,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.default,
	},
	action_horizontal_attack_1 = {
		allowed_during_sprint = true,
		anim_event = "heavy_attack_left_horizontal_swipe",
		anim_event_3p = "heavy_attack_left_horizontal_swipe",
		damage_window_end = 0.24166666666666667,
		damage_window_start = 0.11666666666666667,
		first_person_hit_stop_anim = "attack_hit",
		guaranteed_crit = true,
		hit_armor_anim = "attack_hit_shield",
		ignore_armor_aborts_attack = true,
		kind = "sweep",
		range_mod = 1.25,
		skip_ability_chain_action_check = true,
		start_input = nil,
		total_time = 0.7,
		uninterruptible = true,
		use_charge = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 2.5,
				t = 0.15,
			},
			{
				modifier = 2,
				t = 0.35,
			},
			{
				modifier = 1.5,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 0.75,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "attack_chain_end",
			},
		},
		finish_reason_to_action_input = {
			ledge_vaulting = {
				input_name = "attack_chain_end",
			},
			stunned = {
				input_name = "attack_chain_end",
			},
			push = {
				input_name = "attack_chain_end",
			},
		},
		allowed_chain_actions = {
			attack_chain_end = {
				action_name = "action_unwield_to_previous",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = large_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/transonic_claw/attack_heavy_left_diagonal",
				anchor_point_offset = {
					0,
					0.1,
					-0.15,
				},
			},
		},
		herding_template = HerdingTemplates.linesman_left_heavy,
		damage_profile = DamageProfileTemplates.chordclaw_horizontal,
		damage_type = damage_types.transonic_claw,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.default,
	},
	action_stab_1 = {
		allowed_during_sprint = true,
		anim_event = "attack_stab_01",
		anim_event_3p = "attack_stab_01",
		damage_window_end = 0.16666666666666666,
		damage_window_start = 0.075,
		first_person_hit_stop_anim = "attack_hit",
		guaranteed_crit = true,
		hit_armor_anim = "attack_hit_shield",
		keep_charge = true,
		kind = "sweep",
		range_mod = 1.3,
		skip_ability_chain_action_check = true,
		start_input = nil,
		total_time = 0.4,
		uninterruptible = true,
		use_charge = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 2.5,
				t = 0.15,
			},
			{
				modifier = 2,
				t = 0.35,
			},
			{
				modifier = 1.5,
				t = 0.5,
			},
			{
				modifier = 1,
				t = 0.75,
			},
			{
				modifier = 1,
				t = 1,
			},
			start_modifier = 1.5,
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "lunge_attack_start_chained_stab",
			},
		},
		finish_reason_to_action_input = {
			ledge_vaulting = {
				input_name = "unwield_to_previous",
			},
			stunned = {
				input_name = "unwield_to_previous",
			},
			push = {
				input_name = "unwield_to_previous",
			},
		},
		allowed_chain_actions = {
			lunge_attack_start_chained_stab = {
				action_name = "action_stab_2",
			},
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/transonic_claw/attack_heavy_stab",
				anchor_point_offset = {
					-0.1,
					0,
					0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.chordclaw_stab_bleed,
		damage_type = damage_types.transonic_claw,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.default,
	},
	action_stab_2 = {
		allowed_during_sprint = true,
		anim_event = "attack_stab_02",
		anim_event_3p = "attack_stab_02",
		damage_window_end = 0.11666666666666667,
		damage_window_start = 0.075,
		first_person_hit_stop_anim = "attack_hit",
		guaranteed_crit = true,
		hit_armor_anim = "attack_hit_shield",
		keep_charge = true,
		kind = "sweep",
		range_mod = 1.3,
		skip_ability_chain_action_check = true,
		start_input = nil,
		total_time = 0.35,
		uninterruptible = true,
		use_charge = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.1,
			},
			{
				modifier = 1.15,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 0.8,
				t = 0.25,
			},
			{
				modifier = 1,
				t = 0.55,
			},
			start_modifier = 0.9,
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "lunge_attack_start_chained_stab",
			},
		},
		finish_reason_to_action_input = {
			ledge_vaulting = {
				input_name = "unwield_to_previous",
			},
			stunned = {
				input_name = "unwield_to_previous",
			},
			push = {
				input_name = "unwield_to_previous",
			},
		},
		allowed_chain_actions = {
			lunge_attack_start_chained_stab = {
				action_name = "action_stab_3",
			},
			unwield_to_previous = {
				action_name = "action_unwield_to_previous",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/transonic_claw/attack_heavy_stab",
				anchor_point_offset = {
					-0.1,
					0,
					0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.chordclaw_stab_bleed,
		damage_type = damage_types.transonic_claw,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.default,
	},
	action_stab_3 = {
		allowed_during_sprint = true,
		anim_event = "attack_stab_03",
		anim_event_3p = "attack_stab_03",
		damage_window_end = 0.11666666666666667,
		damage_window_start = 0.075,
		first_person_hit_stop_anim = "attack_hit",
		guaranteed_crit = true,
		hit_armor_anim = "attack_hit_shield",
		kind = "sweep",
		range_mod = 1.3,
		skip_ability_chain_action_check = true,
		start_input = nil,
		total_time = 0.55,
		uninterruptible = true,
		use_charge = true,
		weapon_handling_template = "time_scale_1",
		action_movement_curve = {
			{
				modifier = 1.25,
				t = 0.1,
			},
			{
				modifier = 1.15,
				t = 0.15,
			},
			{
				modifier = 0.8,
				t = 0.2,
			},
			{
				modifier = 0.8,
				t = 0.25,
			},
			{
				modifier = 1,
				t = 0.55,
			},
			start_modifier = 0.9,
		},
		conditional_state_to_action_input = {
			action_end = {
				input_name = "attack_chain_end",
			},
		},
		finish_reason_to_action_input = {
			ledge_vaulting = {
				input_name = "attack_chain_end",
			},
			stunned = {
				input_name = "attack_chain_end",
			},
			push = {
				input_name = "attack_chain_end",
			},
		},
		allowed_chain_actions = {
			attack_chain_end = {
				action_name = "action_unwield_to_previous",
			},
		},
		anim_end_event_condition_func = function (unit, data, end_reason)
			return end_reason ~= "new_interrupting_action" and end_reason ~= "action_complete"
		end,
		weapon_box = default_weapon_box,
		sweeps = {
			{
				matrices_data_location = "content/characters/player/human/first_person/animations/transonic_claw/attack_heavy_stab",
				anchor_point_offset = {
					-0.1,
					0,
					0.1,
				},
			},
		},
		damage_profile = DamageProfileTemplates.chordclaw_stab_bleed,
		damage_type = damage_types.transonic_claw,
		time_scale_stat_buffs = {
			buff_stat_buffs.attack_speed,
			buff_stat_buffs.melee_attack_speed,
		},
		wounds_shape = wounds_shapes.default,
	},
}
weapon_template.actions.action_lunge_aim_transition_from_charge = table.clone(weapon_template.actions.action_lunge_aim_transition_from_instant)
weapon_template.actions.action_lunge_aim_transition_from_charge.allowed_chain_actions = {
	lunge_start = {
		action_name = "action_lunge_start_from_charge",
	},
	lunge_attack_start = {
		action_name = "action_lunge_attack_start_from_charge",
	},
}
weapon_template.actions.action_lunge_start_from_charge = table.clone(weapon_template.actions.action_lunge_start_from_instant)
weapon_template.actions.action_lunge_start_from_charge.allowed_chain_actions = {
	cancel = {
		action_name = "action_lunge_aim_cancel",
	},
	lunge_attack_start = {
		action_name = "action_lunge_attack_start_from_charge",
	},
	unwield_to_previous = {
		action_name = "action_unwield_to_previous",
	},
}
weapon_template.actions.action_lunge_attack_start_from_charge = table.clone(weapon_template.actions.action_lunge_attack_start_from_instant)
weapon_template.actions.action_lunge_attack_start_from_charge.total_time = 0.05
weapon_template.actions.action_lunge_attack_start_from_charge.conditional_state_to_action_input = {
	action_end = {
		input_name = "lunge_attack_start_big_stab",
	},
}
weapon_template.actions.action_lunge_attack_start_from_charge.allowed_chain_actions = {
	lunge_attack_start_big_stab = {
		action_name = "action_heavy_sticky_attack_1",
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_running_action",
		input_name = "no_running_action_unwield_prievious",
	},
}
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/transonic_claw"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/transonic_claw"
weapon_template.weapon_box = {
	0.15,
	0.65,
	0.15,
}
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.sprint_ready_up_time = 0.1
weapon_template.max_first_person_anim_movement_speed = 5.8
weapon_template.damage_window_start_sweep_trail_offset = -0.45
weapon_template.damage_window_end_sweep_trail_offset = 0.15
weapon_template.ammo_template = "no_ammo"
weapon_template.fx_sources = {
	_block = "fx_block",
	_charge = "fx_charge",
	_sweep = "fx_sweep",
}
weapon_template.crosshair = {
	crosshair_type = "dot",
}
weapon_template.hit_marker_type = "center"
weapon_template.keywords = {
	"melee",
	"transonic_claw",
	"p1",
}
weapon_template.dodge_template = "ninja_knife"
weapon_template.sprint_template = "ninja_l"
weapon_template.stamina_template = "combat_knife_p1"
weapon_template.toughness_template = "assault"
weapon_template.movement_curve_modifier_template = "default"
weapon_template.footstep_intervals = FootstepIntervalsTemplates.combat_knife
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.haptic_trigger_template = HapticTriggerTemplates.melee.light
weapon_template.overclocks = {
	armor_pierce_up_dps_down = {
		combatknife_p1_m1_armor_pierce_stat = 0.1,
		combatknife_p1_m1_dps_stat = -0.1,
	},
	finesse_up_armor_pierce_down = {
		combatknife_p1_m1_armor_pierce_stat = -0.2,
		combatknife_p1_m1_finesse_stat = 0.2,
	},
	first_target_up_armor_pierce_down = {
		combatknife_p1_m1_armor_pierce_stat = -0.1,
		combatknife_p1_m1_first_target_stat = 0.1,
	},
	mobility_up_first_target_down = {
		combatknife_p1_m1_first_target_stat = -0.1,
		combatknife_p1_m1_mobility_stat = 0.1,
	},
	dps_up_mobility_down = {
		combatknife_p1_m1_dps_stat = 0.1,
		combatknife_p1_m1_mobility_stat = -0.1,
	},
}

local WeaponBarUIDescriptionTemplates = require("scripts/settings/equipment/weapon_bar_ui_description_templates")

weapon_template.base_stats = {
	combatknife_p1_m1_dps_stat = {
		display_name = "loc_stats_display_damage_stat",
		is_stat_trait = true,
		damage = {
			action_heavy_sticky_attack_1 = {
				damage_trait_templates.default_melee_dps_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_distribution = {
									attack = {
										display_name = "loc_weapon_stats_display_power",
									},
								},
							},
						},
					},
				},
			},
		},
	},
	combatknife_p1_m1_armor_pierce_stat = {
		display_name = "loc_stats_display_ap_stat",
		is_stat_trait = true,
		damage = {
			action_heavy_sticky_attack_1 = {
				damage_trait_templates.default_armor_pierce_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								armor_damage_modifier = {
									attack = WeaponBarUIDescriptionTemplates.armor_damage_modifiers,
								},
							},
						},
					},
				},
			},
		},
	},
	combatknife_p1_m1_finesse_stat = {
		display_name = "loc_stats_display_finesse_stat",
		is_stat_trait = true,
		damage = {
			action_heavy_sticky_attack_1 = {
				damage_trait_templates.default_melee_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								boost_curve_multiplier_finesse = {},
							},
						},
					},
				},
			},
		},
		weapon_handling = {
			action_heavy_sticky_attack_1 = {
				weapon_handling_trait_templates.default_finesse_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						__all_basic_stats = true,
					},
				},
			},
		},
	},
	combatknife_p1_m1_first_target_stat = {
		display_name = "loc_stats_display_first_target_stat",
		is_stat_trait = true,
		damage = {
			action_heavy_sticky_attack_1 = {
				damage_trait_templates.default_first_target_stat,
				display_data = {
					prefix = "loc_weapon_action_title_heavy",
					display_stats = {
						targets = {
							{
								power_level_multiplier = {},
							},
						},
					},
				},
			},
		},
	},
	combatknife_p1_m1_mobility_stat = {
		display_name = "loc_stats_display_mobility_stat",
		is_stat_trait = true,
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat,
				display_data = WeaponBarUIDescriptionTemplates.all_basic_stats,
			},
		},
	},
}
weapon_template.traits = {}

local weapon_traits_bespoke_transonic_claw_p1_traits = table.ukeys(WeaponTraitsBespokeTransonicClawP1)

table.append(weapon_template.traits, weapon_traits_bespoke_transonic_claw_p1_traits)

weapon_template.perks = {
	combatknife_p1_m1_dps_perk = {
		display_name = "loc_trait_display_combatknife_p1_m1_dps_perk",
		damage = {
			action_heavy_sticky_attack_1 = {
				damage_trait_templates.default_melee_dps_perk,
			},
		},
	},
	combatknife_p1_m1_armor_pierce_perk = {
		display_name = "loc_trait_display_combatknife_p1_m1_armor_pierce_perk",
		damage = {
			action_heavy_sticky_attack_1 = {
				damage_trait_templates.default_armor_pierce_perk,
			},
		},
	},
	combatknife_p1_m1_finesse_perk = {
		display_name = "loc_trait_display_combatknife_p1_m1_finesse_perk",
		damage = {
			action_heavy_sticky_attack_1 = {
				damage_trait_templates.default_melee_finesse_perk,
			},
		},
		weapon_handling = {
			action_heavy_sticky_attack_1 = {
				weapon_handling_trait_templates.default_finesse_perk,
			},
		},
	},
	combatknife_p1_m1_first_target_perk = {
		display_name = "loc_trait_display_combatknife_p1_m1_first_target_perk",
		damage = {
			action_heavy_sticky_attack_1 = {
				damage_trait_templates.default_melee_first_target_perk,
			},
		},
	},
	combatknife_p1_m1_mobility_perk = {
		display_name = "loc_trait_display_combatknife_p1_m1_mobility_perk",
		dodge = {
			base = {
				dodge_trait_templates.default_dodge_perk,
			},
		},
		sprint = {
			base = {
				sprint_trait_templates.default_sprint_perk,
			},
		},
		movement_curve_modifier = {
			base = {
				movement_curve_modifier_trait_templates.default_movement_curve_modifier_perk,
			},
		},
	},
}
weapon_template.displayed_keywords = {
	{
		description = "loc_weapon_stats_display_very_fast_attack_desc",
		display_name = "loc_weapon_keyword_very_fast_attack",
	},
	{
		description = "loc_weapon_stats_display_ninja_fencer_desc",
		display_name = "loc_weapon_keyword_ninja_fencer",
	},
}
weapon_template.displayed_attacks = {
	primary = {
		display_name = "loc_gestalt_ninja_fencer",
		type = "ninja_fencer",
		attack_chain = {
			"ninja_fencer",
			"ninja_fencer",
			"ninja_fencer",
			"ninja_fencer",
		},
	},
	secondary = {
		display_name = "loc_gestalt_smiter",
		type = "smiter",
		attack_chain = {
			"smiter",
			"smiter",
		},
	},
	special = {
		desc = "loc_stats_special_action_special_attack_combatknife_p1m1_desc",
		display_name = "loc_weapon_special_fist_attack",
		type = "melee_hand",
	},
}
weapon_template.weapon_card_data = {
	main = {
		{
			header = "light",
			icon = "ninja_fencer",
			value_func = "primary_attack",
		},
		{
			header = "heavy",
			icon = "smiter",
			value_func = "secondary_attack",
		},
	},
	weapon_special = {
		header = "weapon_bash",
		icon = "melee_hand",
	},
}

weapon_template.action_inspect_3p_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect_3p"
end

weapon_template.action_inspect_3p_base_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return current_action_name == "action_inspect"
end

return weapon_template
