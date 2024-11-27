-- chunkname: @scripts/settings/equipment/weapon_templates/devices/scanner_equip.lua

local ActionInputHierarchyUtils = require("scripts/utilities/weapon/action_input_hierarchy")
local BaseTemplateSettings = require("scripts/settings/equipment/weapon_templates/base_template_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local damage_types = DamageSettings.damage_types
local wield_inputs = PlayerCharacterConstants.wield_inputs
local weapon_template = {}

weapon_template.action_inputs = {
	scan_start = {
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "action_two_hold",
				value = true,
			},
		},
	},
	scan_cancel = {
		buffer_time = 0.02,
		input_sequence = {
			{
				input = "action_two_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	scan_confirm = {
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "action_one_pressed",
				value = true,
			},
		},
	},
	scan_confirm_cancel = {
		buffer_time = 0.02,
		input_sequence = {
			{
				input = "action_one_hold",
				value = false,
				time_window = math.huge,
			},
		},
	},
	push = {
		buffer_time = 0.4,
		input_sequence = {
			{
				input = "action_one_pressed",
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
	unwield = {
		buffer_time = 0,
		clear_input_queue = true,
	},
}

table.add_missing(weapon_template.action_inputs, BaseTemplateSettings.action_inputs)

weapon_template.action_input_hierarchy = {
	{
		input = "scan_start",
		transition = {
			{
				input = "scan_cancel",
				transition = "base",
			},
			{
				input = "scan_confirm",
				transition = {
					{
						input = "scan_cancel",
						transition = "base",
					},
					{
						input = "scan_confirm_cancel",
						transition = "previous",
					},
					{
						input = "wield",
						transition = "base",
					},
					{
						input = "unwield",
						transition = "base",
					},
				},
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "unwield",
				transition = "base",
			},
		},
	},
	{
		input = "inspect_start",
		transition = {
			{
				input = "inspect_stop",
				transition = "base",
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "unwield",
				transition = "base",
			},
		},
	},
	{
		input = "push",
		transition = "stay",
	},
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "unwield",
		transition = "stay",
	},
}

ActionInputHierarchyUtils.add_missing_ordered(weapon_template.action_input_hierarchy, BaseTemplateSettings.action_input_hierarchy)

local scan_settings = {
	confirm_time = 1,
	fail_time_time = 0.6,
	outline_time = 0.5,
	distance = {
		far = 20,
		near = 6,
	},
	angle = {
		outer = 1.57075,
		inner = {
			far = 0.174533,
			near = 0.01,
		},
		line_of_sight_check = {
			horizontal = 0.174533,
			vertical = 0.698132,
		},
	},
	score_distribution = {
		angle = 0.2,
		distance = 0.8,
	},
}

weapon_template.actions = {
	action_unwield_to_previous_and_unequip = {
		allowed_during_sprint = true,
		kind = "unwield_to_previous",
		start_input = "unwield",
		total_time = 0,
		unequip_slot = true,
		uninterruptible = true,
		unwield_to_weapon = true,
		allowed_chain_actions = {},
	},
	action_unwield = {
		allowed_during_sprint = true,
		kind = "unwield",
		start_input = "wield",
		total_time = 0,
		uninterruptible = true,
		allowed_chain_actions = {},
	},
	action_wield = {
		allowed_during_sprint = true,
		anim_event = "equip_scanner",
		kind = "wield",
		total_time = 0,
		uninterruptible = true,
	},
	action_push = {
		anim_end_event = "attack_finished",
		anim_event = "attack_push",
		block_duration = 0.4,
		kind = "push",
		push_radius = 2.5,
		start_input = "push",
		total_time = 0.67,
		action_movement_curve = {
			{
				modifier = 1.2,
				t = 0.1,
			},
			{
				modifier = 1.15,
				t = 0.25,
			},
			{
				modifier = 0.5,
				t = 0.4,
			},
			{
				modifier = 1,
				t = 0.67,
			},
			start_modifier = 1,
		},
		inner_push_rad = math.pi * 0.25,
		outer_push_rad = math.pi * 1,
		inner_damage_profile = DamageProfileTemplates.default_push,
		inner_damage_type = damage_types.physical,
		outer_damage_profile = DamageProfileTemplates.light_push,
		outer_damage_type = damage_types.physical,
		allowed_chain_actions = {
			wield = {
				action_name = "action_unwield",
			},
			push = {
				action_name = "action_push",
				chain_time = 0.4,
			},
		},
	},
	action_scan = {
		abort_sprint = true,
		allowed_during_sprint = true,
		kind = "scan",
		prevent_sprint = true,
		sensitivity_modifier = 0.8,
		skip_3p_anims = true,
		start_input = "scan_start",
		stop_input = "scan_cancel",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "dot",
		},
		allowed_chain_actions = {
			scan_confirm = {
				action_name = "action_scan_confirm",
			},
			scan_cancel = {
				action_name = "action_scan_cancel",
			},
			wield = {
				action_name = "action_unwield",
			},
			unwield = {
				action_name = "action_unwield_to_previous_and_unequip",
			},
		},
		running_action_state_to_action_input = {
			no_mission_zone = {
				input_name = "unwield",
			},
		},
		scan_settings = scan_settings,
	},
	action_scan_confirm = {
		abort_sprint = true,
		allowed_during_sprint = true,
		anim_end_event = "scan_end",
		anim_event = "scan_start",
		kind = "scan_confirm",
		prevent_sprint = true,
		sensitivity_modifier = 0.8,
		skip_3p_anims = true,
		start_input = "scan_confirm",
		stop_input = "scan_cancel",
		total_time = math.huge,
		allowed_chain_actions = {
			scan_confirm_cancel = {
				action_name = "action_scan",
			},
			scan_cancel = {
				action_name = "action_scan_cancel",
			},
			wield = {
				action_name = "action_unwield",
			},
			unwield = {
				action_name = "action_unwield_to_previous_and_unequip",
			},
		},
		running_action_state_to_action_input = {
			stop_scanning = {
				input_name = "scan_confirm_cancel",
			},
			no_mission_zone = {
				input_name = "unwield",
			},
		},
		scan_settings = scan_settings,
	},
	action_scan_cancel = {
		kind = "unaim",
		start_input = "scan_cancel",
		total_time = 0.2,
		allowed_chain_actions = {
			scan_start = {
				action_name = "action_scan",
			},
			wield = {
				action_name = "action_unwield",
			},
		},
	},
	action_inspect = {
		anim_end_event = "inspect_end",
		anim_event = "inspect_start",
		kind = "inspect",
		lock_view = true,
		skip_3p_anims = false,
		start_input = "inspect_start",
		stop_input = "inspect_stop",
		total_time = math.huge,
		crosshair = {
			crosshair_type = "inspect",
		},
	},
}

table.add_missing(weapon_template.actions, BaseTemplateSettings.actions)

weapon_template.conditional_state_to_action_input = {
	{
		conditional_state = "no_mission_zone",
		input_name = "unwield",
	},
}
weapon_template.alternate_fire_settings = {
	always_interupt = true,
	start_anim_event = "aim_start",
	stop_anim_event = "aim_end",
	movement_speed_modifier = {
		{
			modifier = 0.4,
			t = 0,
		},
		start_modifier = 0.4,
	},
}
weapon_template.crosshair = {
	crosshair_type = "ironsight",
}
weapon_template.keywords = {
	"pocketable",
}
weapon_template.ammo_template = "no_ammo"
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/pocketables_2h",
	ogryn = "content/characters/player/ogryn/third_person/animations/pocketables_2h",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/scanner_equip",
	ogryn = "content/characters/player/ogryn/first_person/animations/scanner_equip",
}
weapon_template.smart_targeting_template = SmartTargetingTemplates.default_melee
weapon_template.fx_sources = {
	_speaker = "fx_speaker",
}
weapon_template.dodge_template = "default"
weapon_template.sprint_template = "default"
weapon_template.stamina_template = "default"
weapon_template.toughness_template = "default"
weapon_template.hud_icon = "content/ui/materials/icons/pocketables/hud/auspex_scanner"
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
weapon_template.footstep_intervals = FootstepIntervalsTemplates.default

weapon_template.action_scan_on_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

weapon_template.action_scan_confirm_on_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	local correct_action = current_action_name == "action_scan"

	if not correct_action then
		return false
	end

	local player_unit = player.player_unit
	local visual_loadout_extension = ScriptUnit.has_extension(player_unit, "visual_loadout_system")
	local wieldable_slot_scripts = visual_loadout_extension:wieldable_slot_scripts_from_slot(wielded_slot_id)

	for i = 1, #wieldable_slot_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[i]

		if wieldable_slot_script.has_outline_unit and wieldable_slot_script:has_outline_unit() then
			return true
		end
	end

	return false
end

weapon_template.action_push_on_screen_ui_validation = function (wielded_slot_id, item, current_action, current_action_name, player)
	return not current_action_name or current_action_name == "none"
end

return weapon_template
