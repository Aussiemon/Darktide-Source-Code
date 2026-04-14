-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/expeditions_big_grenade.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")

local function _in_expedition_safe_zone()
	local game_mode_manager = Managers.state.game_mode
	local game_mode = game_mode_manager:game_mode()

	if game_mode.in_safe_zone then
		return game_mode:in_safe_zone()
	end

	return false
end

local grenade_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/grenade_weapon_template_generator")
local weapon_template = grenade_weapon_template_generator(nil)

weapon_template.anim_state_machine_3p = nil
weapon_template.anim_state_machine_1p = nil
weapon_template.action_input_hierarchy = {
	{
		input = "aim_hold",
		transition = {
			{
				input = "aim_released",
				transition = "previous",
			},
			{
				input = "block_cancel",
				transition = {
					{
						input = "block_cancel_release",
						transition = "base",
					},
					{
						input = "wield",
						transition = "base",
					},
					{
						input = "unwield_to_previous",
						transition = "base",
					},
					{
						input = "combat_ability",
						transition = "base",
					},
					{
						input = "grenade_ability",
						transition = "base",
					},
				},
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "unwield_to_previous",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
			{
				input = "grenade_ability",
				transition = "base",
			},
		},
	},
	{
		input = "short_hand_aim_hold",
		transition = {
			{
				input = "short_hand_aim_released",
				transition = "previous",
			},
			{
				input = "short_hand_throw",
				transition = {
					{
						input = "short_hand_throw_release",
						transition = "base",
					},
					{
						input = "wield",
						transition = "base",
					},
					{
						input = "unwield_to_previous",
						transition = "base",
					},
					{
						input = "combat_ability",
						transition = "base",
					},
					{
						input = "grenade_ability",
						transition = "base",
					},
				},
			},
			{
				input = "wield",
				transition = "base",
			},
			{
				input = "unwield_to_previous",
				transition = "base",
			},
			{
				input = "combat_ability",
				transition = "base",
			},
			{
				input = "grenade_ability",
				transition = "base",
			},
		},
	},
	{
		input = "block_cancel",
		transition = "stay",
	},
	{
		input = "wield",
		transition = "stay",
	},
	{
		input = "unwield_to_previous",
		transition = "base",
	},
	{
		input = "combat_ability",
		transition = "base",
	},
	{
		input = "grenade_ability",
		transition = "base",
	},
	{
		input = "inspect_start",
		transition = {
			{
				input = "inspect_stop",
				transition = "base",
			},
		},
	},
}
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/big_fing_grenade",
	ogryn = "content/characters/player/ogryn/third_person/animations/big_fing_grenade",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/big_fing_grenade",
	ogryn = "content/characters/player/ogryn/first_person/animations/big_fing_grenade",
}
weapon_template.actions.action_wield.total_time = 1
weapon_template.actions.action_aim.allowed_chain_actions.aim_released.chain_time = 0.6
weapon_template.actions.action_aim_underhand.allowed_chain_actions.short_hand_throw.chain_time = 0.6

local AMMUNITION_USAGE = 1
local REMOVE_ITEM_FROM_INVENTORY = true

weapon_template.actions.action_throw_grenade.ammunition_usage = AMMUNITION_USAGE
weapon_template.actions.action_underhand_throw_grenade.ammunition_usage = AMMUNITION_USAGE
weapon_template.actions.action_throw_grenade.remove_item_from_inventory = REMOVE_ITEM_FROM_INVENTORY
weapon_template.actions.action_underhand_throw_grenade.remove_item_from_inventory = REMOVE_ITEM_FROM_INVENTORY

weapon_template.actions.action_aim.action_condition_func = function (action_settings, condition_func_params, used_input)
	return not _in_expedition_safe_zone()
end

weapon_template.actions.action_throw_grenade.action_condition_func = function (action_settings, condition_func_params, used_input)
	return not _in_expedition_safe_zone()
end

weapon_template.actions.action_aim_underhand.action_condition_func = function (action_settings, condition_func_params, used_input)
	return not _in_expedition_safe_zone()
end

weapon_template.actions.action_underhand_throw_grenade.action_condition_func = function (action_settings, condition_func_params, used_input)
	return not _in_expedition_safe_zone()
end

weapon_template.ammo_template = "expeditions_big_grenade"
weapon_template.ammo_template_static = "expeditions_big_grenade"
weapon_template.swap_pickup_name = "expedition_grenade_big_pocketable"
weapon_template.projectile_template = ProjectileTemplates.expeditions_big_grenade
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_combat_blade
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/big_fn_grenade"
weapon_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/big_fn_grenade"

return weapon_template
