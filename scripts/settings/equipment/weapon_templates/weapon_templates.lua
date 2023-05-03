local WeaponTweakTemplates = require("scripts/extension_systems/weapon/utilities/weapon_tweak_templates")
local WeaponUIStatsTemplates = require("scripts/settings/equipment/weapon_ui_stats_templates")
local weapon_templates = {}

local function _require_template(path_prefix, template_name)
	local full_path = string.format(path_prefix, template_name)
	local template_data = require(full_path)

	if not template_data.sprint_ready_up_time then
		template_data.sprint_ready_up_time = 0
	end

	for action_name, action_settings in pairs(template_data.actions) do
		action_settings.name = action_name
	end

	template_data.name = template_name
	weapon_templates[template_name] = template_data
end

local function _require_group(path_prefix, group_name, ...)
	local new_prefix = string.format(path_prefix, string.format("%s/%s", group_name, "%s"))

	for ii = 1, select("#", ...) do
		_require_template(new_prefix, select(ii, ...))
	end
end

local function _require_weapon_templates(path_prefix, template_groups, template_names)
	for ii = 1, #template_groups do
		local group = template_groups[ii]

		_require_group(path_prefix, unpack(group))
	end

	for ii = 1, #template_names do
		local template_name = template_names[ii]

		_require_template(path_prefix, template_name)
	end
end

local path_prefix = "scripts/settings/equipment/weapon_templates/%s"
local template_groups = {
	{
		"autoguns",
		"autogun_p1_m1",
		"autogun_p1_m2",
		"autogun_p1_m3",
		"autogun_p2_m1",
		"autogun_p2_m2",
		"autogun_p2_m3",
		"autogun_p3_m1",
		"autogun_p3_m2",
		"autogun_p3_m3"
	},
	{
		"autopistols",
		"autopistol_p1_m1",
		"autopistol_p1_m2",
		"autopistol_p1_m3"
	},
	{
		"bolters",
		"bolter_p1_m1",
		"bolter_p1_m2",
		"bolter_p1_m3"
	},
	{
		"chain_swords",
		"chainsword_p1_m1",
		"chainsword_p1_m2",
		"chainsword_p1_m3",
		"chainsword_2h_p1_m1",
		"chainsword_2h_p1_m2",
		"chainsword_2h_p1_m3"
	},
	{
		"chain_axes",
		"chainaxe_p1_m1",
		"chainaxe_p1_m2",
		"chainaxe_p1_m3"
	},
	{
		"combat_abilities",
		"psyker_force_field",
		"psyker_force_field_dome",
		"preacher_relic"
	},
	{
		"combat_axes",
		"combataxe_p1_m1",
		"combataxe_p1_m2",
		"combataxe_p1_m3",
		"combataxe_p2_m1",
		"combataxe_p2_m2",
		"combataxe_p2_m3",
		"combataxe_p3_m1",
		"combataxe_p3_m2",
		"combataxe_p3_m3"
	},
	{
		"combat_blades",
		"ogryn_combatblade_p1_m1",
		"ogryn_combatblade_p1_m2",
		"ogryn_combatblade_p1_m3"
	},
	{
		"combat_knives",
		"combatknife_p1_m1",
		"combatknife_p1_m2",
		"combatknife_p1_m3"
	},
	{
		"combat_swords",
		"combatsword_p1_m1",
		"combatsword_p1_m2",
		"combatsword_p1_m3",
		"combatsword_p2_m1",
		"combatsword_p2_m2",
		"combatsword_p2_m3",
		"combatsword_p3_m1",
		"combatsword_p3_m2",
		"combatsword_p3_m3"
	},
	{
		"devices",
		"auspex_scanner",
		"skull_decoder",
		"servo_skull"
	},
	{
		"flamers",
		"flamer_p1_m1"
	},
	{
		"force_staffs",
		"forcestaff_p1_m1",
		"forcestaff_p1_m2",
		"forcestaff_p1_m3",
		"forcestaff_p2_m1",
		"forcestaff_p2_m2",
		"forcestaff_p3_m1",
		"forcestaff_p4_m1"
	},
	{
		"force_swords",
		"forcesword_p1_m1",
		"forcesword_p1_m2",
		"forcesword_p1_m3"
	},
	{
		"grenades",
		"fire_grenade",
		"frag_grenade",
		"krak_grenade",
		"ogryn_grenade",
		"ogryn_grenade_box",
		"psyker_smite",
		"psyker_throwing_knives",
		"psyker_chain_lightning",
		"shock_grenade"
	},
	{
		"grenadier_gauntlets",
		"ogryn_gauntlet_p1_m1"
	},
	{
		"lasguns",
		"lasgun_p1_m1",
		"lasgun_p1_m2",
		"lasgun_p1_m3",
		"lasgun_p1_m1_ironsight",
		"lasgun_p1_m2_ironsight",
		"lasgun_p1_m3_ironsight",
		"lasgun_p2_m1",
		"lasgun_p2_m2",
		"lasgun_p2_m3",
		"lasgun_p3_m1",
		"lasgun_p3_m2",
		"lasgun_p3_m3"
	},
	{
		"laspistols",
		"laspistol_p1_m1",
		"laspistol_p1_m2",
		"laspistol_p1_m3"
	},
	{
		"luggables",
		"luggable_mission",
		"luggable"
	},
	{
		"ogryn_clubs",
		"ogryn_club_p1_m1",
		"ogryn_club_p1_m2",
		"ogryn_club_p1_m3",
		"ogryn_club_p2_m1",
		"ogryn_club_p2_m2",
		"ogryn_club_p2_m3"
	},
	{
		"ogryn_power_mauls",
		"ogryn_powermaul_p1_m1",
		"ogryn_powermaul_p1_m2",
		"ogryn_powermaul_p1_m3"
	},
	{
		"ogryn_powermaul_slabshield",
		"ogryn_powermaul_slabshield_p1_m1"
	},
	{
		"ogryn_heavystubbers",
		"ogryn_heavystubber_p1_m1",
		"ogryn_heavystubber_p1_m2",
		"ogryn_heavystubber_p1_m3"
	},
	{
		"plasma_rifles",
		"plasmagun_p1_m1",
		"plasmagun_p2_m1"
	},
	{
		"pocketables",
		"ammo_cache_pocketable",
		"grimoire_pocketable",
		"medical_crate_pocketable",
		"tome_pocketable"
	},
	{
		"power_mauls",
		"powermaul_p1_m1",
		"powermaul_p1_m2",
		"powermaul_p1_m3"
	},
	{
		"power_mauls_2h",
		"powermaul_2h_p1_m1",
		"powermaul_2h_p1_m2",
		"powermaul_2h_p1_m3"
	},
	{
		"power_swords",
		"powersword_p1_m1",
		"powersword_p1_m2",
		"powersword_p1_m3"
	},
	{
		"ripperguns",
		"ogryn_rippergun_p1_m1",
		"ogryn_rippergun_p1_m2",
		"ogryn_rippergun_p1_m3"
	},
	{
		"scanner",
		"scanner_equip"
	},
	{
		"thumpers",
		"ogryn_thumper_p1_m1",
		"ogryn_thumper_p1_m2",
		"ogryn_thumper_p1_m3"
	},
	{
		"shotguns",
		"shotgun_p1_m1",
		"shotgun_p1_m2",
		"shotgun_p1_m3",
		"shotgun_p2_m1",
		"shotgun_p3_m1"
	},
	{
		"stub_pistols",
		"stubrevolver_p1_m1",
		"stubrevolver_p1_m2",
		"stubrevolver_p1_m3"
	},
	{
		"stub_rifles",
		"stubrifle_p1_m1"
	},
	{
		"thunder_hammers",
		"thunderhammer_2h_p1_m1",
		"thunderhammer_2h_p1_m2",
		"thunderhammer_2h_p1_m3"
	},
	{
		"debug",
		"debug_forcestaff_p1_base",
		"debug_forcestaff_p2_base",
		"debug_forcestaff_p3_base"
	}
}
local template_names = {
	"unarmed_hub_ogryn",
	"unarmed_hub_psyker",
	"unarmed_hub_veteran",
	"unarmed_hub_zealot",
	"unarmed",
	"unarmed_training_grounds",
	"bot_lasgun_killshot",
	"bot_autogun_killshot",
	"bot_laspistol_killshot",
	"bot_zola_laspistol",
	"bot_combatsword_linesman_p1",
	"bot_combatsword_linesman_p2",
	"bot_combataxe_linesman"
}

_require_weapon_templates(path_prefix, template_groups, template_names)

local _DEBUG = false

local function dprint(str)
	if _DEBUG then
		Log.info("WeaponStats", str)
	end
end

local start_actions = {
	"start_attack",
	"shoot",
	"shoot_charge",
	"shoot_pressed"
}
local fallback_to_start_action = {
	true,
	false
}
local chain_attack_actions = {
	{
		"light_attack",
		"shoot_pressed",
		"shoot",
		"shoot_release_charged",
		"shoot_charged",
		"shoot_release",
		"charged_enough"
	},
	{
		"heavy_attack",
		"zoom",
		"charge",
		"charge_flame",
		"charge_explosion",
		"brace"
	}
}
local action_names = {
	{
		"loc_weapon_action_title_primary",
		"loc_tg_input_description_melee_light_attack"
	},
	{
		"loc_weapon_action_title_secondary",
		"loc_tg_input_description_melee_heavy_attack"
	}
}

local function _generate_ui_stats_template(weapon_template, combos)
	local is_ranged = weapon_template.keywords and table.find(weapon_template.keywords, "ranged")
	local settings = WeaponUIStatsTemplates.settings
	local default_stats = settings.default_stats
	local default_attack_settings = settings.default_attack_settings
	local default_ranged_damage_profile_stats = settings.default_ranged_damage_profile_stats
	local default_ranged_per_action_stats = settings.default_ranged_per_action_stats
	local actions = weapon_template.actions
	local stats = default_stats
	local power_stats = {}

	for i = 1, #combos do
		local action_name = combos[i][1]
		power_stats[#power_stats + 1] = {
			charge_level = 1,
			dropoff_scalar = 0,
			target_index = 1,
			display_name = is_ranged and action_names[i][1] or action_names[i][2],
			action_name = action_name
		}
	end

	local damage = {}

	for i = 1, #combos do
		local combo_table = {}
		local combo = combos[i]

		for j = 1, #combo do
			local action_name = combo[j]
			combo_table[#combo_table + 1] = {
				dropoff_scalar = 0,
				charge_level = 1,
				target_index = 1,
				action_name = action_name,
				display_name = action_name,
				attack = default_attack_settings,
				damage_profile_stats = is_ranged and default_ranged_damage_profile_stats or {},
				per_action_stats = is_ranged and default_ranged_per_action_stats or {}
			}
		end

		damage[#damage + 1] = combo_table
	end

	weapon_template.displayed_weapon_stats_table = {
		stats = stats,
		power_stats = power_stats,
		damage = damage
	}
end

local function _generate_special_ui_stats_template(weapon_template)
	local special_action_name = weapon_template.special_action_name

	if not special_action_name then
		return
	end

	local is_ranged = weapon_template.keywords and table.find(weapon_template.keywords, "ranged")
	local settings = WeaponUIStatsTemplates.settings
	local default_stats = settings.default_stats
	local default_attack_settings = settings.default_attack_settings
	local default_ranged_damage_profile_stats = settings.default_ranged_damage_profile_stats
	local default_ranged_per_action_stats = settings.default_ranged_per_action_stats
	local displayed_weapon_stats_table = weapon_template.displayed_weapon_stats_table
	local damage = displayed_weapon_stats_table.damage
	damage[#damage + 1] = {
		{
			dropoff_scalar = 0,
			charge_level = 1,
			target_index = 1,
			action_name = special_action_name,
			display_name = special_action_name,
			attack = default_attack_settings,
			damage_profile_stats = is_ranged and default_ranged_damage_profile_stats or {},
			per_action_stats = is_ranged and default_ranged_per_action_stats or {}
		}
	}
end

local start_input_templates = {
	{
		value = true,
		input = "action_one_pressed"
	},
	{
		value = true,
		input = "action_one_hold"
	}
}
local charge_input_templates = {
	{
		value = true,
		hold_input = "action_two_hold",
		input = "action_one_pressed"
	},
	{
		value = true,
		hold_input = "action_two_hold",
		input = "action_one_hold"
	}
}

local function _find_action_based_on_input(action_inputs, inputs_to_check)
	for name, data in pairs(action_inputs) do
		local input_sequence = data.input_sequence

		if input_sequence and #input_sequence == 1 then
			local found = true
			local inputs = input_sequence[1]

			if table.size(inputs) == table.size(inputs_to_check) then
				for id, value in pairs(inputs) do
					if inputs_to_check[id] ~= value then
						found = false

						break
					end
				end

				if found then
					return name
				end
			end
		end
	end
end

local COMBOS = {}

local function _generate_chain_attack_info(weapon_template, working_templates, failed_templates)
	table.clear(COMBOS)

	local name = weapon_template.name
	local start_action = nil
	local actions = weapon_template.actions
	local start_action_name = nil

	for _, start_input_template in ipairs(start_input_templates) do
		start_action_name = _find_action_based_on_input(weapon_template.action_inputs, start_input_template)

		if start_action_name then
			break
		end
	end

	for action_name, action in pairs(actions) do
		local start_input = action.start_input

		if start_input == start_action_name then
			start_action = action

			break
		end
	end

	local chain_actions = start_action and start_action.allowed_chain_actions

	if chain_actions then
		for i = 1, #chain_attack_actions do
			local attack_actions = chain_attack_actions[i]
			local combo = {}
			local action_name = nil

			for i = 1, #attack_actions do
				local action = attack_actions[i]

				if chain_actions[action] then
					action_name = action

					break
				end
			end

			local attack_name = chain_actions[action_name] and chain_actions[action_name].action_name
			attack_name = attack_name or start_action.name

			while attack_name do
				if table.find(combo, attack_name) then
					break
				end

				combo[#combo + 1] = attack_name
				local chain_actions = actions[attack_name].allowed_chain_actions
				local start_attack_name = chain_actions.start_attack and chain_actions.start_attack.action_name or nil

				if start_attack_name then
					attack_name = nil
					local start_attack = actions[start_attack_name]
					chain_actions = start_attack.allowed_chain_actions
					attack_name = chain_actions[action_name] and chain_actions[action_name].action_name or nil
				elseif not actions[attack_name].fire_configuration and not actions[attack_name].damage_profile then
					for i = 1, #charge_input_templates do
						local input_template = charge_input_templates[i]
						action_name = _find_action_based_on_input(weapon_template.action_inputs, input_template)
						attack_name = chain_actions[action_name] and chain_actions[action_name].action_name

						if attack_name then
							combo[#combo] = attack_name

							break
						end
					end
				end
			end

			COMBOS[#COMBOS + 1] = combo
		end

		if not table.find(failed_templates, name) then
			_generate_ui_stats_template(weapon_template, COMBOS)
			_generate_special_ui_stats_template(weapon_template)
		end
	end
end

local unwield_action_kinds = {
	unwield_to_specific = true,
	unwield = true,
	unwield_to_previous = true
}
local failed_templates = {}
local working_templates = {}

for name, weapon_template in pairs(weapon_templates) do
	local weapon_template_sprint_ready_up_time = weapon_template.sprint_ready_up_time

	for _, action_settings in pairs(weapon_template.actions) do
		if not action_settings.sprint_ready_up_time and not unwield_action_kinds[action_settings.kind] then
			action_settings.sprint_ready_up_time = weapon_template_sprint_ready_up_time
		end
	end

	WeaponTweakTemplates.preparse_weapon_template(weapon_template)
	_generate_chain_attack_info(weapon_template, working_templates, failed_templates)
end

return settings("WeaponTemplates", weapon_templates)
