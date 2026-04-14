-- chunkname: @scripts/settings/equipment/weapon_templates/pocketables/expedition_grenade_valkyrie_hover_pocketable.lua

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

weapon_template.projectile_template = ProjectileTemplates.valkyrie_hover_smoke_grenade
weapon_template.swap_pickup_name = "expedition_grenade_valkyrie_hover_pocketable"
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/valkyrie_hover"
weapon_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/valkyrie_hover"
weapon_template.hud_configuration = {
	uses_ammunition = false,
	uses_overheat = false,
}
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

local actions = weapon_template.actions

actions.action_aim.action_condition_func = function (action_settings, condition_func_params, used_input)
	return not _in_expedition_safe_zone()
end

actions.action_throw_grenade.action_condition_func = function (action_settings, condition_func_params, used_input)
	return not _in_expedition_safe_zone()
end

actions.action_aim_underhand.action_condition_func = function (action_settings, condition_func_params, used_input)
	return not _in_expedition_safe_zone()
end

actions.action_underhand_throw_grenade.action_condition_func = function (action_settings, condition_func_params, used_input)
	return not _in_expedition_safe_zone()
end

weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/grenade",
	ogryn = "content/characters/player/ogryn/third_person/animations/valkyrie_flare",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/grenade_equipable",
	ogryn = "content/characters/player/ogryn/first_person/animations/valkyrie_flare",
}
weapon_template.breed_footstep_intervals = {
	human = FootstepIntervalsTemplates.pocketable_human,
	ogryn = FootstepIntervalsTemplates.pocketable_ogryn,
}

return weapon_template
