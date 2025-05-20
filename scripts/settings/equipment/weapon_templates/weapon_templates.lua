-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_templates.lua

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

local template_groups = {
	{
		"chain_swords_2h",
		"chainsword_2h_p1_m1",
		"chainsword_2h_p1_m2",
	},
	{
		"chain_swords",
		"chainsword_p1_m1",
		"chainsword_p1_m2",
	},
	{
		"chain_axes",
		"chainaxe_p1_m1",
		"chainaxe_p1_m2",
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
		"combataxe_p3_m3",
	},
	{
		"combat_blades",
		"ogryn_combatblade_p1_m1",
		"ogryn_combatblade_p1_m2",
		"ogryn_combatblade_p1_m3",
	},
	{
		"combat_knives",
		"combatknife_p1_m1",
		"combatknife_p1_m2",
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
		"combatsword_p3_m3",
	},
	{
		"force_swords_2h",
		"forcesword_2h_p1_m1",
		"forcesword_2h_p1_m2",
	},
	{
		"force_swords",
		"forcesword_p1_m1",
		"forcesword_p1_m2",
		"forcesword_p1_m3",
	},
	{
		"ogryn_clubs",
		"ogryn_club_p1_m1",
		"ogryn_club_p1_m2",
		"ogryn_club_p1_m3",
		"ogryn_club_p2_m1",
		"ogryn_club_p2_m2",
		"ogryn_club_p2_m3",
	},
	{
		"ogryn_power_mauls",
		"ogryn_powermaul_p1_m1",
	},
	{
		"ogryn_powermaul_slabshield",
		"ogryn_powermaul_slabshield_p1_m1",
	},
	{
		"ogryn_pickaxes_2h",
		"ogryn_pickaxe_2h_p1_m1",
		"ogryn_pickaxe_2h_p1_m2",
		"ogryn_pickaxe_2h_p1_m3",
	},
	{
		"power_mauls_2h",
		"powermaul_2h_p1_m1",
	},
	{
		"power_mauls",
		"powermaul_p1_m1",
		"powermaul_p1_m2",
	},
	{
		"power_swords_2h",
		"powersword_2h_p1_m1",
		"powersword_2h_p1_m2",
	},
	{
		"power_swords",
		"powersword_p1_m1",
		"powersword_p1_m2",
		"powersword_p2_m1",
		"powersword_p2_m2",
	},
	{
		"thunder_hammers_2h",
		"thunderhammer_2h_p1_m1",
		"thunderhammer_2h_p1_m2",
	},
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
		"autogun_p3_m3",
	},
	{
		"autopistols",
		"autopistol_p1_m1",
	},
	{
		"bolters",
		"bolter_p1_m1",
	},
	{
		"bolt_pistols",
		"boltpistol_p1_m1",
	},
	{
		"flamers",
		"flamer_p1_m1",
	},
	{
		"force_staffs",
		"forcestaff_p1_m1",
		"forcestaff_p2_m1",
		"forcestaff_p3_m1",
		"forcestaff_p4_m1",
	},
	{
		"grenadier_gauntlets",
		"ogryn_gauntlet_p1_m1",
	},
	{
		"lasguns",
		"lasgun_p1_m1",
		"lasgun_p1_m2",
		"lasgun_p1_m3",
		"lasgun_p2_m1",
		"lasgun_p2_m2",
		"lasgun_p2_m3",
		"lasgun_p3_m1",
		"lasgun_p3_m2",
		"lasgun_p3_m3",
	},
	{
		"laspistols",
		"laspistol_p1_m1",
		"laspistol_p1_m3",
	},
	{
		"ogryn_heavystubbers",
		"ogryn_heavystubber_p1_m1",
		"ogryn_heavystubber_p1_m2",
		"ogryn_heavystubber_p1_m3",
		"ogryn_heavystubber_p2_m1",
		"ogryn_heavystubber_p2_m2",
		"ogryn_heavystubber_p2_m3",
	},
	{
		"plasma_rifles",
		"plasmagun_p1_m1",
	},
	{
		"ripperguns",
		"ogryn_rippergun_p1_m1",
		"ogryn_rippergun_p1_m2",
		"ogryn_rippergun_p1_m3",
	},
	{
		"thumpers",
		"ogryn_thumper_p1_m1",
		"ogryn_thumper_p1_m2",
	},
	{
		"shotguns",
		"shotgun_p1_m1",
		"shotgun_p1_m2",
		"shotgun_p1_m3",
		"shotgun_p2_m1",
	},
	{
		"stub_pistols",
		"stubrevolver_p1_m1",
		"stubrevolver_p1_m2",
	},
	{
		"bot_weapons",
		"bot_autogun_killshot",
		"bot_combataxe_linesman",
		"bot_combatsword_linesman_p1",
		"bot_combatsword_linesman_p2",
		"bot_lasgun_killshot",
		"bot_laspistol_killshot",
		"bot_zola_laspistol",
		"high_bot_autogun_killshot",
		"high_bot_lasgun_killshot",
	},
	{
		"combat_abilities",
		"psyker_force_field",
		"psyker_force_field_dome",
		"zealot_relic",
	},
	{
		"devices",
		"auspex_scanner",
		"breach_charge",
		"scanner_equip",
		"servo_skull",
		"skull_decoder",
		"skull_decoder_02",
	},
	{
		"grenades",
		"ogryn_grenade_box",
		"ogryn_grenade_box_cluster",
		"ogryn_grenade_frag",
		"ogryn_grenade_friend_rock",
		"psyker_smite",
		"psyker_chain_lightning",
		"psyker_throwing_knives",
		"frag_grenade",
		"krak_grenade",
		"smoke_grenade",
		"shock_grenade",
		"fire_grenade",
		"zealot_throwing_knives",
	},
	{
		"luggables",
		"luggable_mission",
		"luggable",
	},
	{
		"pocketables",
		"ammo_cache_pocketable",
		"breach_charge_pocketable",
		"communications_hack_device_pocketable",
		"grimoire_pocketable",
		"medical_crate_pocketable",
		"syringe_ability_boost_pocketable",
		"syringe_corruption_pocketable",
		"syringe_power_boost_pocketable",
		"syringe_speed_boost_pocketable",
		"tome_pocketable",
	},
	{
		"unarmed",
		"unarmed_hub_ogryn",
		"unarmed_hub_psyker",
		"unarmed_hub_veteran",
		"unarmed_hub_zealot",
		"unarmed_training_grounds",
		"unarmed",
	},
}
local template_names = {}
local path_prefix = "scripts/settings/equipment/weapon_templates/%s"

_require_weapon_templates(path_prefix, template_groups, template_names)

local _DEBUG = false

local function dprint(str)
	if _DEBUG then
		Log.info("WeaponStats", str)
	end
end

local chain_attack_actions = {
	{
		"light_attack",
		"shoot_pressed",
		"shoot",
		"shoot_release_charged",
		"shoot_charged",
		"shoot_release",
		"charged_enough",
	},
	{
		"heavy_attack",
		"zoom",
		"charge",
		"charge_flame",
		"charge_explosion",
		"brace",
	},
}
local action_names = {
	{
		"loc_weapon_action_title_primary",
		"loc_tg_input_description_melee_light_attack",
	},
	{
		"loc_weapon_action_title_secondary",
		"loc_tg_input_description_melee_heavy_attack",
	},
	{
		"loc_weapon_action_title_primary",
		"loc_tg_input_description_melee_heavy_attack",
	},
}

local function _generate_ui_stats_template(weapon_template, combos)
	local is_ranged = weapon_template.keywords and table.find(weapon_template.keywords, "ranged")
	local settings = WeaponUIStatsTemplates.settings
	local default_stats = settings.default_stats
	local default_attack_settings = settings.default_attack_settings
	local default_ranged_damage_profile_stats = settings.default_ranged_damage_profile_stats
	local default_ranged_per_action_stats = settings.default_ranged_per_action_stats
	local stats = default_stats
	local power_stats = {}

	for i = 1, #combos do
		local action_name = combos[i][1]

		power_stats[#power_stats + 1] = {
			charge_level = 1,
			dropoff_scalar = 0,
			target_index = 1,
			display_name = is_ranged and action_names[i][1] or action_names[i][2],
			action_name = action_name,
		}
	end

	local damage = {}

	for i = 1, #combos do
		local combo_table = {}
		local combo = combos[i]

		for j = 1, #combo do
			local action_name = combo[j]

			combo_table[#combo_table + 1] = {
				charge_level = 1,
				dropoff_scalar = 0,
				target_index = 1,
				action_name = action_name,
				display_name = action_name,
				attack = default_attack_settings,
				damage_profile_stats = is_ranged and default_ranged_damage_profile_stats or {},
				per_action_stats = is_ranged and default_ranged_per_action_stats or {},
			}
		end

		damage[#damage + 1] = combo_table
	end

	weapon_template.displayed_weapon_stats_table = {
		stats = stats,
		power_stats = power_stats,
		damage = damage,
	}
end

local function _generate_special_ui_stats_action_template(weapon_template, special_action_name, use_special_damage_profile)
	local is_ranged = weapon_template.keywords and table.find(weapon_template.keywords, "ranged")
	local settings = WeaponUIStatsTemplates.settings
	local default_attack_settings = settings.default_attack_settings
	local default_ranged_damage_profile_stats = settings.default_ranged_damage_profile_stats
	local default_ranged_per_action_stats = settings.default_ranged_per_action_stats
	local data = {
		charge_level = 1,
		dropoff_scalar = 0,
		target_index = 1,
		action_name = special_action_name,
		display_name = special_action_name,
		attack = default_attack_settings,
		damage_profile_stats = is_ranged and default_ranged_damage_profile_stats or {},
		per_action_stats = is_ranged and default_ranged_per_action_stats or {},
		use_special_damage_profile = use_special_damage_profile,
	}

	return data
end

local function _generate_special_ui_stats_template(weapon_template)
	local displayed_weapon_stats_table = weapon_template.displayed_weapon_stats_table
	local damage = displayed_weapon_stats_table.damage
	local special_action_name = weapon_template.special_action_name

	if special_action_name then
		local special_action_entry = _generate_special_ui_stats_action_template(weapon_template, special_action_name, false)
		local damage_entry = {
			special_action_entry,
		}

		damage[#damage + 1] = damage_entry
	end

	local special_actions = weapon_template.special_actions

	if special_actions then
		local damage_entry = {}

		for i = 1, #special_actions do
			local special_action = special_actions[i]
			local special_action_entry = _generate_special_ui_stats_action_template(weapon_template, special_action.action_name, special_action.use_special_damage)

			damage_entry[#damage_entry + 1] = special_action_entry
		end

		damage[#damage + 1] = damage_entry
	end
end

local start_input_templates = {
	{
		input = "action_one_pressed",
		value = true,
	},
	{
		input = "action_one_hold",
		value = true,
	},
}
local charge_input_templates = {
	{
		hold_input = "action_two_hold",
		input = "action_one_pressed",
		value = true,
	},
	{
		hold_input = "action_two_hold",
		input = "action_one_hold",
		value = true,
	},
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

	local start_action
	local name = weapon_template.name
	local actions = weapon_template.actions
	local start_action_name

	for _, start_input_template in ipairs(start_input_templates) do
		start_action_name = _find_action_based_on_input(weapon_template.action_inputs, start_input_template)

		if start_action_name then
			break
		end
	end

	for action_name, action in pairs(actions) do
		local start_input = action.start_input
		local invalid_start_action_for_stat_calculation = action.invalid_start_action_for_stat_calculation

		if start_input == start_action_name and not invalid_start_action_for_stat_calculation then
			start_action = action

			break
		end
	end

	local chain_actions = start_action and start_action.allowed_chain_actions

	if not chain_actions then
		-- Nothing
	else
		for i = 1, #chain_attack_actions do
			local attack_actions = chain_attack_actions[i]
			local combo = {}
			local action_name

			for j = 1, #attack_actions do
				local action = attack_actions[j]

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

				local action_chain_actions = actions[attack_name].allowed_chain_actions
				local start_attack_name = action_chain_actions.start_attack and action_chain_actions.start_attack.action_name or nil

				if start_attack_name then
					local start_attack = actions[start_attack_name]

					action_chain_actions = start_attack.allowed_chain_actions
					attack_name = action_chain_actions[action_name] and action_chain_actions[action_name].action_name or nil
				elseif not actions[attack_name].fire_configuration and not actions[attack_name].fire_configurations and not actions[attack_name].damage_profile then
					for j = 1, #charge_input_templates do
						local input_template = charge_input_templates[j]

						action_name = _find_action_based_on_input(weapon_template.action_inputs, input_template)
						attack_name = action_chain_actions[action_name] and action_chain_actions[action_name].action_name

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
			local active_combo = weapon_template.explicit_combo or COMBOS

			_generate_ui_stats_template(weapon_template, active_combo)
			_generate_special_ui_stats_template(weapon_template)
		end
	end
end

local unwield_action_kinds = {
	unwield = true,
	unwield_to_previous = true,
	unwield_to_specific = true,
}
local failed_templates = {}
local working_templates = {}

for name, weapon_template in pairs(weapon_templates) do
	local weapon_template_sprint_ready_up_time = weapon_template.sprint_ready_up_time

	for _, action_settings in pairs(weapon_template.actions) do
		if not action_settings.sprint_ready_up_time and not unwield_action_kinds[action_settings.kind] and not action_settings.allowed_during_sprint then
			action_settings.sprint_ready_up_time = weapon_template_sprint_ready_up_time
		end
	end

	WeaponTweakTemplates.preparse_weapon_template(weapon_template)
	_generate_chain_attack_info(weapon_template, working_templates, failed_templates)
end

return settings("WeaponTemplates", weapon_templates)
