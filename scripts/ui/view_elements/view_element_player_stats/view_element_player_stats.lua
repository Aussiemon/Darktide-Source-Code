-- chunkname: @scripts/ui/view_elements/view_element_player_stats/view_element_player_stats.lua

local Definitions = require("scripts/ui/view_elements/view_element_player_stats/view_element_player_stats_definitions")
local ViewElementPlayerStatsBlueprints = require("scripts/ui/view_elements/view_element_player_stats/view_element_player_stats_blueprints")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Text = require("scripts/utilities/ui/text")
local InputDevice = require("scripts/managers/input/input_device")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local MasterItems = require("scripts/backend/master_items")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_traits/weapon_trait_templates")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local WeaponTweakTemplates = require("scripts/extension_systems/weapon/utilities/weapon_tweak_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local ViewElementPlayerStats = class("ViewElementPlayerStats", "ViewElementBase")
local EMPTY_TABLE = {}
local template_types = WeaponTweakTemplateSettings.template_types
local STAT_MARGIN = 5
local RELEVANT_BUFF_STATS = {
	critical_strike_chance = true,
	critical_strike_chance_to_damage_convert = true,
	critical_strike_damage = true,
	dodge_distance_modifier = true,
	extra_consecutive_dodges = true,
	extra_max_amount_of_wounds = true,
	max_health_modifier = true,
	max_health_multiplier = true,
	melee_critical_strike_chance = true,
	melee_critical_strike_damage = true,
	movement_speed = true,
	ranged_critical_strike_chance = true,
	ranged_critical_strike_damage = true,
	sprint_movement_speed = true,
	sprinting_cost_multiplier = true,
	stamina_modifier = true,
	stamina_regeneration_delay = true,
	stamina_regeneration_modifier = true,
	stamina_regeneration_multiplier = true,
	toughness = true,
	toughness_bonus = true,
	toughness_bonus_flat = true,
	toughness_damage_taken_modifier = true,
	toughness_melee_replenish = true,
	toughness_regen_delay_modifier = true,
	toughness_regen_delay_multiplier = true,
	toughness_regen_rate_modifier = true,
	toughness_regen_rate_multiplier = true,
	toughness_replenish_modifier = true,
	toughness_replenish_multiplier = true,
}
local PRIMARY_ATTACK_ACTION_FALLBACKS = {
	"action_shoot",
	"action_shoot_braced",
	"action_left_light",
	"action_right_light",
}

local function _get_wield_context(loadout, wield_slot_name)
	local melee_weapon = loadout.slot_primary
	local ranged_weapon = loadout.slot_secondary
	local melee_template = WeaponTemplate.weapon_template_from_item(melee_weapon)
	local ranged_template = WeaponTemplate.weapon_template_from_item(ranged_weapon)
	local wield_item, wield_template

	if wield_slot_name == "slot_primary" then
		wield_item, wield_template = melee_weapon, melee_template
	elseif wield_slot_name == "slot_secondary" then
		wield_item, wield_template = ranged_weapon, ranged_template
	end

	local is_melee = wield_template and WeaponTemplate.is_melee(wield_template)
	local is_ranged = wield_template and WeaponTemplate.is_ranged(wield_template)

	return wield_item, wield_template, is_melee, is_ranged
end

local function _get_weapon_tweak_templates(wield_item, wield_template)
	if not wield_item or not wield_template then
		return nil
	end

	local lerp_values = WeaponTweakTemplates.calculate_lerp_values(wield_template, wield_item.base_stats or EMPTY_TABLE, wield_item.overclocks or EMPTY_TABLE, wield_item.perks or EMPTY_TABLE, EMPTY_TABLE, nil)

	return WeaponTweakTemplates.create(lerp_values, wield_template)
end

local function _get_tweak_sub_template(tweak_templates, template_type, template_name)
	if not tweak_templates or not template_name or template_name == "none" then
		return nil
	end

	local templates = tweak_templates[template_type]

	return templates and templates[template_name]
end

local function _resolve_primary_attack_action_name(wield_template)
	local entry_actions = wield_template.entry_actions

	if entry_actions then
		if entry_actions.primary_action then
			return entry_actions.primary_action
		end

		for i = 1, #entry_actions do
			local action_name = entry_actions[i]

			if action_name then
				return action_name
			end
		end
	end

	for i = 1, #PRIMARY_ATTACK_ACTION_FALLBACKS do
		local action_name = PRIMARY_ATTACK_ACTION_FALLBACKS[i]

		if wield_template.actions[action_name] then
			return action_name
		end
	end

	return wield_template.special_action_name
end

local function _get_weapon_handling_template(wield_template, tweak_templates)
	if not wield_template or not tweak_templates then
		return EMPTY_TABLE
	end

	local handling_templates = tweak_templates[template_types.weapon_handling]

	if not handling_templates then
		return EMPTY_TABLE
	end

	local action_name = _resolve_primary_attack_action_name(wield_template)
	local action = action_name and wield_template.actions[action_name]

	if not action then
		return EMPTY_TABLE
	end

	local template_name = action.weapon_handling_template

	if not template_name or template_name == "none" then
		return EMPTY_TABLE
	end

	return handling_templates[template_name] or EMPTY_TABLE
end

local NON_PASSIVE_WEAPON_TRAIT_BUFF_CLASSES = {
	proc_buff = true,
	weapon_trait_activated_parent_proc_buff = true,
	weapon_trait_parent_proc_buff = true,
}

local function _is_passive_weapon_trait_buff(buff_template)
	if not buff_template then
		return false
	end

	local class_name = buff_template.class_name

	if class_name and NON_PASSIVE_WEAPON_TRAIT_BUFF_CLASSES[class_name] then
		return false
	end

	if buff_template.proc_events then
		return false
	end

	if buff_template.child_buff_template then
		return false
	end

	return true
end

local function _lerp_stepped_stat_value(range, lerp_value)
	local min_index = 1
	local max_index = #range
	local lerped_index = math.lerp(min_index, max_index, lerp_value)
	local index = math.round(lerped_index)

	return range[index]
end

local function _get_value_from_buff_data(buff_template, value, lerp_value)
	local new_value = value

	if type(value) == "table" and value.min and value.max then
		local lerp_value_func = value.lerp_value_func or math.lerp

		new_value = lerp_value_func(value.min, value.max, lerp_value)
	elseif buff_template.meta_buff and type(value) == "table" then
		new_value = buff_template.lerp_function(value, lerp_value)
	elseif buff_template.class_name == "stepped_range_buff" and type(value) == "table" then
		new_value = _lerp_stepped_stat_value(value, lerp_value)
	end

	return new_value
end

local function _calculate_value_to_stat_buff(key, value, stat_buffs)
	local stat_buff_type = BuffSettings.stat_buff_types[key]
	local current_value = stat_buffs[key]

	if stat_buff_type == "multiplicative_multiplier" then
		current_value = current_value * value
	elseif stat_buff_type == "max_value" then
		current_value = math.max(current_value, value)
	else
		current_value = current_value + value
	end

	return current_value
end

local function _stat_buff_allowed_for_wield(key, is_melee, is_ranged)
	if not RELEVANT_BUFF_STATS[key] then
		return false
	end

	if not is_melee and string.find(key, "melee", 1, true) then
		return false
	end

	if not is_ranged and string.find(key, "ranged", 1, true) then
		return false
	end

	return true
end

local function _talent_override_def(buff_template, talent_tier)
	local talent_overrides = buff_template and buff_template.talent_overrides

	if not talent_overrides or not talent_tier then
		return nil
	end

	local num_talent_overrides = #talent_overrides

	if num_talent_overrides == 0 then
		return nil
	end

	local override_index = math.clamp(talent_tier, 1, num_talent_overrides)

	return talent_overrides[override_index]
end

local function _talent_tier_from_selection(selection_data)
	if type(selection_data) == "table" then
		return selection_data.tier or 1
	elseif type(selection_data) == "number" then
		return selection_data
	end

	return 1
end

local function _apply_buff_template_stat_buffs(buff_template, lerp_value, stat_buffs, optional_talent_tier, is_melee, is_ranged)
	if not buff_template then
		return
	end

	local talent_override_def = _talent_override_def(buff_template, optional_talent_tier)
	local stat_buff_overrides = talent_override_def and talent_override_def.stat_buffs
	local lerped_stat_buff_overrides = talent_override_def and talent_override_def.lerped_stat_buffs
	local meta_stat_buff_overrides = talent_override_def and talent_override_def.meta_stat_buffs
	local is_stepped = buff_template.class_name == "stepped_range_buff"

	for key, value in pairs(buff_template.stat_buffs or EMPTY_TABLE) do
		if _stat_buff_allowed_for_wield(key, is_melee, is_ranged) then
			value = stat_buff_overrides and stat_buff_overrides[key] or value

			if is_stepped and type(value) == "table" then
				local stat_value = _get_value_from_buff_data(buff_template, value, lerp_value)

				stat_buffs[key] = _calculate_value_to_stat_buff(key, stat_value, stat_buffs)
			elseif type(value) == "number" then
				stat_buffs[key] = _calculate_value_to_stat_buff(key, value, stat_buffs)
			end
		end
	end

	for key, value in pairs(buff_template.lerped_stat_buffs or EMPTY_TABLE) do
		if _stat_buff_allowed_for_wield(key, is_melee, is_ranged) then
			value = lerped_stat_buff_overrides and lerped_stat_buff_overrides[key] or value

			local stat_value = _get_value_from_buff_data(buff_template, value, lerp_value)

			stat_buffs[key] = _calculate_value_to_stat_buff(key, stat_value, stat_buffs)
		end
	end

	for key, value in pairs(buff_template.meta_stat_buffs or EMPTY_TABLE) do
		if _stat_buff_allowed_for_wield(key, is_melee, is_ranged) then
			value = meta_stat_buff_overrides and meta_stat_buff_overrides[key] or value

			local stat_value = type(value) == "table" and _get_value_from_buff_data(buff_template, value, lerp_value) or value

			stat_buffs[key] = _calculate_value_to_stat_buff(key, stat_value, stat_buffs)
		end
	end
end

local function _apply_talent_buff_templates(buff_source, talent_tier, stat_buffs, is_melee, is_ranged)
	local buff_template_names = buff_source.buff_template_name

	if type(buff_template_names) == "table" then
		for ii = 1, #buff_template_names do
			local buff_template_name = buff_template_names[ii]

			if buff_template_name then
				local buff_template = BuffTemplates[buff_template_name]

				_apply_buff_template_stat_buffs(buff_template, 1, stat_buffs, talent_tier, is_melee, is_ranged)
			end
		end
	elseif buff_template_names then
		local buff_template = BuffTemplates[buff_template_names]

		_apply_buff_template_stat_buffs(buff_template, 1, stat_buffs, talent_tier, is_melee, is_ranged)
	end
end

local function _apply_passive_trait_entry(trait_data, stat_buffs, is_melee, is_ranged)
	if not trait_data or not trait_data.id then
		return
	end

	if not MasterItems.item_exists(trait_data.id) then
		return
	end

	local trait_item = MasterItems.get_item(trait_data.id)
	local trait_id = trait_item.trait

	if not trait_id then
		return
	end

	local lerp_value = trait_data.value or 0
	local trait_rarity = trait_data.rarity
	local trait_template_data = WeaponTraitTemplates[trait_id]

	if trait_template_data and trait_template_data.buffs then
		for buff_name, stat_data in pairs(trait_template_data.buffs) do
			local buff_template = rawget(BuffTemplates, buff_name) or rawget(BuffTemplates, trait_id)

			if _is_passive_weapon_trait_buff(buff_template) then
				local rarity_data = trait_rarity and stat_data[trait_rarity]
				local rarity_stat_buffs = rarity_data and rarity_data.stat_buffs

				if rarity_stat_buffs then
					for key, value in pairs(rarity_stat_buffs) do
						if _stat_buff_allowed_for_wield(key, is_melee, is_ranged) then
							local stat_value = _get_value_from_buff_data(buff_template, value, lerp_value)

							stat_buffs[key] = _calculate_value_to_stat_buff(key, stat_value, stat_buffs)
						end
					end
				else
					_apply_buff_template_stat_buffs(buff_template, lerp_value, stat_buffs, nil, is_melee, is_ranged)
				end
			end
		end
	else
		local buff_template = BuffTemplates[trait_id]

		if _is_passive_weapon_trait_buff(buff_template) then
			_apply_buff_template_stat_buffs(buff_template, lerp_value, stat_buffs, nil, is_melee, is_ranged)
		end
	end
end

local function _collect_passive_equipment_stat_buffs(all_trait_lists, stat_buffs, is_melee, is_ranged)
	for i = 1, #all_trait_lists do
		local traits = all_trait_lists[i]

		if traits then
			for j = 1, #traits do
				_apply_passive_trait_entry(traits[j], stat_buffs, is_melee, is_ranged)
			end
		end
	end
end

local function _calculate_widget_height(widget)
	return widget.content.size[2] + STAT_MARGIN
end

local function _can_stat_be_navigated(widget)
	return widget and widget.alpha_multiplier == 1 and widget.content.hotspot and not widget.content.hotspot.disabled and widget.content.hotspot.pressed_callback
end

local function _get_wounds_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	local extra_wounds = stat_buffs.extra_max_amount_of_wounds or 0
	local wounds = archetype.name and Managers.state and Managers.state.difficulty and Managers.state.difficulty:player_wounds(archetype.name) + extra_wounds or 1

	stats_data[#stats_data + 1] = {
		data_type = "num",
		id = "wounds",
		title = "loc_player_stats_element_stat_title_wounds",
		data = wounds,
	}
end

local function _get_health_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	local base_health = archetype.health or 100
	local max_health_multiplier = stat_buffs.max_health_multiplier
	local max_health_modifier = stat_buffs.max_health_modifier
	local health = base_health * (max_health_multiplier * max_health_modifier)

	stats_data[#stats_data + 1] = {
		id = "health",
		title = "loc_player_stats_element_stat_title_health",
		data = health,
	}
	stats_data[#stats_data + 1] = {
		data_type = "num",
		id = "base_health",
		is_parent_breakdown = true,
		parent = "health",
		title = "loc_player_stats_element_stat_title_base_health",
		data = base_health,
	}
	stats_data[#stats_data + 1] = {
		data_type = "num",
		id = "talents_health",
		is_parent_breakdown = true,
		parent = "health",
		title = "loc_player_stats_element_stat_title_modifiers",
		data = health - base_health,
	}
end

local function _get_toughness_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	local base_toughness_template = archetype and archetype.toughness or EMPTY_TABLE
	local weapon_toughness_template = wield_template and wield_template.toughness_template and _get_tweak_sub_template(tweak_templates, template_types.toughness, wield_template.toughness_template)
	local base_toughness = base_toughness_template and base_toughness_template.max or 1
	local buff_extra_toughness = stat_buffs.toughness or 0
	local buff_toughness_bonus_flat = stat_buffs and stat_buffs.toughness_bonus_flat or 0
	local toughness_bonus = stat_buffs.toughness_bonus or 1
	local max_toughness = (base_toughness + buff_extra_toughness) * toughness_bonus
	local toughness = math.ceil(max_toughness) + buff_toughness_bonus_flat

	stats_data[#stats_data + 1] = {
		data_type = "num",
		id = "toughness",
		title = "loc_player_stats_element_stat_title_thoughness",
		data = toughness,
	}

	local weapon_toughness_delay_mod = weapon_toughness_template and weapon_toughness_template.regeneration_delay_modifier or 1
	local toughness_regen_delay_buff_mod = (stat_buffs.toughness_regen_delay_modifier or 1) * (stat_buffs.toughness_regen_delay_multiplier or 1)
	local toughness_regen_delay = (base_toughness_template and base_toughness_template.regeneration_delay or 1) * weapon_toughness_delay_mod * toughness_regen_delay_buff_mod

	stats_data[#stats_data + 1] = {
		data_type = "format_to_seconds",
		id = "toughness_regen_delay",
		parent = "toughness",
		title = "loc_player_stats_element_stat_title_toughness_regen_delay",
		data = toughness_regen_delay,
	}

	local base_toughness_regen_still = base_toughness_template and base_toughness_template.regeneration_speed and base_toughness_template.regeneration_speed.still or 1
	local weapon_toughness_regen_mod = weapon_toughness_template and weapon_toughness_template.regeneration_speed_modifier and weapon_toughness_template.regeneration_speed_modifier.still or 1
	local toughness_regen_buff_mod = (stat_buffs.toughness_regen_rate_modifier or 1) * (stat_buffs.toughness_regen_rate_multiplier or 1)
	local toughness_regen_speed = base_toughness_regen_still * weapon_toughness_regen_mod * toughness_regen_buff_mod

	stats_data[#stats_data + 1] = {
		data_type = "format_to_num_per_seconds",
		id = "toughness_regen_rate",
		parent = "toughness",
		title = "loc_player_stats_element_stat_title_toughness_regen_rate",
		data = toughness_regen_speed,
	}

	if is_melee then
		local replenish_types = ToughnessSettings.replenish_types
		local melee_kill = replenish_types.melee_kill
		local base_kill_percentage = base_toughness_template.recovery_percentages and melee_kill and base_toughness_template.recovery_percentages[melee_kill] or 0
		local weapon_kill_mod = weapon_toughness_template and weapon_toughness_template.recovery_percentage_modifiers and weapon_toughness_template.recovery_percentage_modifiers[melee_kill] or 1
		local replenish_stat_multiplier = ((stat_buffs.toughness_melee_replenish or 1) + (stat_buffs.toughness_replenish_modifier or 1) - 1) * (stat_buffs.toughness_replenish_multiplier or 1)
		local toughness_regen_per_kill = math.floor(base_kill_percentage * replenish_stat_multiplier * weapon_kill_mod * max_toughness)

		stats_data[#stats_data + 1] = {
			data_type = "num",
			id = "toughness_regen_per_kill",
			parent = "toughness",
			title = "loc_player_stats_element_stat_title_toughness_regen_per_kill",
			data = toughness_regen_per_kill,
		}
	end
end

local function _get_stamina_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	local base_sprint_template = archetype and archetype.sprint or EMPTY_TABLE
	local base_stamina_template = archetype and archetype.stamina or EMPTY_TABLE
	local weapon_stamina_template = wield_template and _get_tweak_sub_template(tweak_templates, template_types.stamina, wield_template.stamina_template)
	local weapon_sprint_template = wield_template and _get_tweak_sub_template(tweak_templates, template_types.sprint, wield_template.sprint_template or "default")
	local weapon_stamina_mod = weapon_stamina_template and weapon_stamina_template.stamina_modifier or 0
	local max_stamina = base_stamina_template.base_stamina and base_stamina_template.base_stamina + weapon_stamina_mod + (stat_buffs.stamina_modifier or 0) or 1

	stats_data[#stats_data + 1] = {
		data_type = "num",
		id = "stamina",
		title = "loc_player_stats_element_stat_title_stamina",
		data = max_stamina,
	}

	local stamina_regen_per_second = (base_stamina_template.regeneration_per_second or 0) * (stat_buffs.stamina_regeneration_modifier or 1) * (stat_buffs.stamina_regeneration_multiplier or 1)

	stats_data[#stats_data + 1] = {
		data_type = "format_to_num_per_seconds",
		id = "stamina_regen_rate",
		parent = "stamina",
		title = "loc_player_stats_element_stat_title_stamina_regen",
		data = stamina_regen_per_second,
	}

	local sprint_speed_mod = weapon_sprint_template and weapon_sprint_template.sprint_speed_mod or 0
	local move_speed = (base_sprint_template.sprint_move_speed or 0) + sprint_speed_mod

	move_speed = move_speed * (stat_buffs.sprint_movement_speed or 1) * (stat_buffs.movement_speed or 1)
	stats_data[#stats_data + 1] = {
		data_type = "format_to_meters_per_second",
		id = "sprint_speed",
		parent = "stamina",
		title = "loc_player_stats_element_stat_title_sprint_speed",
		data = move_speed,
	}

	local base_cost_per_second = weapon_stamina_template and weapon_stamina_template.sprint_cost_per_second or math.huge
	local sprinting_cost_multiplier = stat_buffs.sprinting_cost_multiplier or 1
	local cost_per_second = base_cost_per_second * sprinting_cost_multiplier
	local total_sprint_time = cost_per_second > 0 and max_stamina / cost_per_second or 0

	stats_data[#stats_data + 1] = {
		data_type = "format_to_seconds",
		id = "sprint_time",
		parent = "stamina",
		title = "loc_player_stats_element_stat_title_sprint_time",
		data = total_sprint_time,
	}
end

local function _get_dodges_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	local base_dodge_template = archetype and archetype.dodge or EMPTY_TABLE
	local weapon_dodge_template = wield_template and _get_tweak_sub_template(tweak_templates, template_types.dodge, wield_template.dodge_template)
	local extra_consecutive_dodges = math.round(stat_buffs.extra_consecutive_dodges or 0)
	local num_effective_dodges = math.floor((weapon_dodge_template and weapon_dodge_template.diminishing_return_start or 2) + extra_consecutive_dodges)

	stats_data[#stats_data + 1] = {
		data_type = "num",
		id = "dodges",
		title = "loc_player_stats_element_stat_title_dodges",
		data = num_effective_dodges,
	}

	local base_distance = weapon_dodge_template and weapon_dodge_template.base_distance or base_dodge_template.base_distance or 1
	local distance_scale = weapon_dodge_template and weapon_dodge_template.distance_scale or 1
	local dodge_distance = base_distance * distance_scale * (stat_buffs.dodge_distance_modifier or 1)

	stats_data[#stats_data + 1] = {
		data_type = "format_to_meters",
		id = "dodges_distance",
		parent = "dodges",
		title = "loc_player_stats_element_stat_title_dodges_distance",
		data = dodge_distance,
	}
end

local function _calculate_critical_chance(stat_buffs, archetype, weapon_handling_template, is_melee, is_ranged)
	local additional_chance = stat_buffs.critical_strike_chance or 0

	if is_melee then
		additional_chance = additional_chance + (stat_buffs.melee_critical_strike_chance or 0)
	elseif is_ranged then
		additional_chance = additional_chance + (stat_buffs.ranged_critical_strike_chance or 0)
	end

	local critical_strike = weapon_handling_template.critical_strike

	if critical_strike and critical_strike.chance_modifier then
		additional_chance = additional_chance + critical_strike.chance_modifier
	end

	local base_chance = archetype.base_critical_strike_chance or 0
	local critical_chance = math.clamp(base_chance + additional_chance, 0, 1)

	return critical_chance * (1 - (stat_buffs.critical_strike_chance_to_damage_convert or 0))
end

local function _get_critical_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	local weapon_handling_template = _get_weapon_handling_template(wield_template, tweak_templates)
	local critical_chance = _calculate_critical_chance(stat_buffs, archetype, weapon_handling_template, is_melee, is_ranged)

	stats_data[#stats_data + 1] = {
		data_type = "format_to_percentage",
		id = "crit_chance",
		title = "loc_player_stats_element_stat_title_crit_chance",
		data = critical_chance,
	}
end

ViewElementPlayerStats.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	ViewElementPlayerStats.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._max_active = 1
	self._active_categories_per_level = {}
	self._active_categories_by_id = {}
	self._show_stats = false
	self._navigating_in_stats = false
	self._draw_stats = true
end

ViewElementPlayerStats.assign_profile = function (self, profile, player, wield_slot_name)
	self._profile = profile
	self._player = player
	self._wield_slot_name = wield_slot_name
	self._refresh = true
end

ViewElementPlayerStats._update_stats = function (self, ui_renderer)
	local first_generation = not self._stat_widgets
	local stats_data, stats_data_by_id = self:_generate_stats()

	self._stats_data = stats_data
	self._stats_data_by_id = stats_data_by_id

	local layout_changed, added_stat_ids = self:_sync_stat_widgets(stats_data, ui_renderer)

	for i = 1, #self._stat_widgets do
		local widget = self._stat_widgets[i]
		local stat_id = widget.content.element.id
		local stat_data = stats_data_by_id[stat_id]

		if stat_data then
			local template_name = "category"

			if not stat_data.childs and stat_data.level > 1 then
				template_name = "sub_category"
			end

			local blueprint = ViewElementPlayerStatsBlueprints[template_name]

			if blueprint and blueprint.update then
				blueprint.update(self, widget, {
					data = stat_data.data,
					data_type = stat_data.data_type,
				}, ui_renderer)
			end
		end
	end

	if first_generation then
		self:_set_initial_stats_state()
	elseif self._show_stats and layout_changed then
		self:_update_active_categories({}, added_stat_ids)
	end
end

ViewElementPlayerStats._generate_shortcut_keys = function (self)
	local scenegraph_id = "stats_key_shortcuts"
	local pass_template = ButtonPassTemplates.input_legend_button
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id)
	local toggle_stats_widget = self:_create_widget("toggle_stats", widget_definition)
	local inspect_stats_widget = self:_create_widget("inspect_stats", widget_definition)

	toggle_stats_widget.content.hotspot.pressed_callback = function ()
		self:_toggle_stats()
	end

	inspect_stats_widget.content.hotspot.pressed_callback = function ()
		self:_toggle_focus_stats()
	end

	self._shortcut_keys_widget_by_name = {
		toggle_stats = toggle_stats_widget,
		inspect_stats = inspect_stats_widget,
	}
	self._update_shortcut_keys = true
end

local _get_level

function _get_level(id, level, stats_data_by_id)
	if stats_data_by_id[id] and stats_data_by_id[id].parent then
		return _get_level(stats_data_by_id[id].parent, level + 1, stats_data_by_id)
	else
		return level
	end
end

local _get_childs

function _get_childs(parent_id, stats_data_by_id)
	local result = {}
	local has_child = false

	for id, stat_data in pairs(stats_data_by_id) do
		if stat_data.parent == parent_id then
			result[#result + 1] = id
			has_child = true
		end
	end

	return has_child and result or nil
end

local _order_stats

function _order_stats(stats_id, stats_data_by_id, result)
	for i = 1, #stats_id do
		local stat_id = stats_id[i]
		local stat_data = stats_data_by_id[stat_id]

		result[#result + 1] = stat_data

		if stat_data.childs then
			_order_stats(stat_data.childs, stats_data_by_id, result)
		end
	end
end

local stats_data = {}
local stats_data_by_id = {}
local stat_buffs = {}
local equipment_trait_lists = {}
local ordered_stats = {}

ViewElementPlayerStats._generate_stats = function (self)
	table.clear(stats_data)
	table.clear(stats_data_by_id)
	table.clear(stat_buffs)
	table.clear(equipment_trait_lists)

	local profile = self._profile or {}
	local archetype = profile.archetype or {}
	local stat_buff_types = BuffSettings.stat_buff_types
	local base_values = BuffSettings.stat_buff_base_values

	for key, type in pairs(stat_buff_types) do
		if RELEVANT_BUFF_STATS[key] then
			stat_buffs[key] = base_values[type]
		end
	end

	local loadout = profile.loadout or {}
	local melee_weapon = loadout.slot_primary
	local ranged_weapon = loadout.slot_secondary
	local attachment_1 = loadout.slot_attachment_1
	local attachment_2 = loadout.slot_attachment_2
	local attachment_3 = loadout.slot_attachment_3
	local melee_traits = melee_weapon and melee_weapon.traits
	local melee_perks = melee_weapon and melee_weapon.perks
	local ranged_traits = ranged_weapon and ranged_weapon.traits
	local ranged_perks = ranged_weapon and ranged_weapon.perks
	local attachment_1_traits = attachment_1 and attachment_1.traits
	local attachment_1_perks = attachment_1 and attachment_1.perks
	local attachment_2_traits = attachment_2 and attachment_2.traits
	local attachment_2_perks = attachment_2 and attachment_2.perks
	local attachment_3_traits = attachment_3 and attachment_3.traits
	local attachment_3_perks = attachment_3 and attachment_3.perks

	equipment_trait_lists[#equipment_trait_lists + 1] = attachment_1_traits
	equipment_trait_lists[#equipment_trait_lists + 1] = attachment_1_perks
	equipment_trait_lists[#equipment_trait_lists + 1] = attachment_2_traits
	equipment_trait_lists[#equipment_trait_lists + 1] = attachment_2_perks
	equipment_trait_lists[#equipment_trait_lists + 1] = attachment_3_traits
	equipment_trait_lists[#equipment_trait_lists + 1] = attachment_3_perks

	local wield_slot_name = self._wield_slot_name or "slot_primary"

	if wield_slot_name == "slot_primary" then
		equipment_trait_lists[#equipment_trait_lists + 1] = melee_traits
		equipment_trait_lists[#equipment_trait_lists + 1] = melee_perks
	elseif wield_slot_name == "slot_secondary" then
		equipment_trait_lists[#equipment_trait_lists + 1] = ranged_traits
		equipment_trait_lists[#equipment_trait_lists + 1] = ranged_perks
	end

	local wield_item, wield_template, is_melee, is_ranged = _get_wield_context(loadout, wield_slot_name)

	_collect_passive_equipment_stat_buffs(equipment_trait_lists, stat_buffs, is_melee, is_ranged)

	local talents = profile.talents or {}
	local archetype_talents = archetype.talents or EMPTY_TABLE

	for talent_name, selection_data in pairs(talents) do
		local talent_definition = archetype_talents[talent_name]

		if talent_definition then
			local talent_tier = _talent_tier_from_selection(selection_data)
			local passive = talent_definition.passive
			local coherency = talent_definition.coherency

			if passive then
				_apply_talent_buff_templates(passive, talent_tier, stat_buffs, is_melee, is_ranged)
			end

			if coherency then
				_apply_talent_buff_templates(coherency, talent_tier, stat_buffs, is_melee, is_ranged)
			end
		end
	end

	local tweak_templates = _get_weapon_tweak_templates(wield_item, wield_template)

	_get_wounds_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	_get_health_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	_get_toughness_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	_get_stamina_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	_get_dodges_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)
	_get_critical_category_data(stats_data, stat_buffs, archetype, tweak_templates, wield_template, is_melee, is_ranged)

	for i = 1, #stats_data do
		local stat_data = stats_data[i]
		local id = stat_data.id

		stats_data_by_id[id] = stat_data
	end

	local first_level_stats = {}

	for i = 1, #stats_data do
		local stat_data = stats_data[i]
		local id = stat_data.id

		stat_data.childs = _get_childs(id, stats_data_by_id)
		stat_data.level = _get_level(id, 1, stats_data_by_id)

		if stat_data.level == 1 then
			first_level_stats[#first_level_stats + 1] = id
		end
	end

	table.clear(ordered_stats)
	_order_stats(first_level_stats, stats_data_by_id, ordered_stats)

	return ordered_stats, stats_data_by_id
end

ViewElementPlayerStats._generate_stat_widget = function (self, stat_data, ui_renderer)
	local template_name = "category"

	if not stat_data.childs and stat_data.level > 1 then
		template_name = "sub_category"
	end

	local blueprint = ViewElementPlayerStatsBlueprints[template_name]

	if blueprint then
		local passes = blueprint.passes
		local definition = UIWidget.create_definition(passes, "stats")
		local widget = self:_create_widget("stat_" .. stat_data.id, definition)

		if blueprint.init then
			local on_pressed_callback = "_on_category_pressed"

			blueprint.init(self, widget, stat_data, on_pressed_callback, ui_renderer)
		end

		return widget
	end
end

local synced_added_ids = {}

ViewElementPlayerStats._sync_stat_widgets = function (self, stats_data, ui_renderer)
	local old_widgets_by_id = self._stat_widgets_by_id or EMPTY_TABLE
	local new_widgets = {}
	local new_widgets_by_id = {}
	local layout_changed = false

	table.clear(synced_added_ids)

	for i = 1, #stats_data do
		local stat_data = stats_data[i]
		local widget = old_widgets_by_id[stat_data.id]
		local is_new_widget = not widget

		if widget then
			widget.content.element = stat_data
			widget.content.has_childs = not not stat_data.childs
		else
			widget = self:_generate_stat_widget(stat_data, ui_renderer)

			if widget then
				widget.alpha_multiplier = 0

				local previous_widget = new_widgets[#new_widgets]

				widget.offset[2] = previous_widget and previous_widget.offset[2] or 0
			end

			layout_changed = true
		end

		if widget then
			if stat_data.parent and self._active_categories_by_id[stat_data.parent] then
				self._active_categories_by_id[stat_data.id] = true

				if is_new_widget then
					synced_added_ids[#synced_added_ids + 1] = stat_data.id
				end
			end

			new_widgets[#new_widgets + 1] = widget
			new_widgets_by_id[stat_data.id] = widget
		end
	end

	for id, widget in pairs(old_widgets_by_id) do
		if not new_widgets_by_id[id] then
			if self:has_widget(widget.name) then
				self:_unregister_widget_name(widget.name)
			end

			self._active_categories_by_id[id] = nil
			layout_changed = true
		end
	end

	self._stat_widgets = new_widgets
	self._stat_widgets_by_id = new_widgets_by_id

	return layout_changed, synced_added_ids
end

ViewElementPlayerStats._on_category_pressed = function (self, widget, element)
	local id = element.id

	self:_update_active_categories({
		id,
	})
end

ViewElementPlayerStats._toggle_stats = function (self, force_state)
	if force_state ~= nil then
		self._show_stats = force_state
	else
		self._show_stats = not self._show_stats
	end

	local animations = {}
	local end_height = 0
	local last_active_offset = 0

	for i = 1, #self._stat_widgets do
		local stat_widget = self._stat_widgets[i]
		local content = stat_widget.content
		local element = content.element
		local id = element.id
		local level = element.level
		local state

		state = (self._active_categories_by_id[id] or level == 1) and "active" or "inactive"

		local start_offset = stat_widget.offset[2]
		local end_offset = 0
		local start_alpha = 0
		local end_alpha = 0

		if self._show_stats then
			if state == "active" then
				end_offset = end_height
				end_alpha = 1
			else
				end_offset = last_active_offset
			end
		elseif state == "active" then
			start_alpha = 1
		end

		animations[#animations + 1] = {
			start_alpha = start_alpha,
			end_alpha = end_alpha,
			start_offset = start_offset,
			end_offset = end_offset,
			widget = stat_widget,
			update = function (animation_data, progress)
				local start_offset = animation_data.start_offset
				local end_offset = animation_data.end_offset
				local start_alpha = animation_data.start_alpha
				local end_alpha = animation_data.end_alpha
				local widget = animation_data.widget
				local current_alpha = math.lerp(start_alpha, end_alpha, progress)
				local current_offset = math.lerp(start_offset, end_offset, progress)

				widget.alpha_multiplier = current_alpha
				widget.offset[2] = current_offset
			end,
		}

		if self._show_stats and state == "active" then
			last_active_offset = end_height
			end_height = end_height + _calculate_widget_height(stat_widget)
		end
	end

	local _, start_height = self:_scenegraph_size("stats")

	animations[#animations + 1] = {
		start_value = start_height,
		end_value = end_height,
		update = function (animation_data, progress)
			local start_value = animation_data.start_value
			local end_value = animation_data.end_value
			local stats_background_position = self:scenegraph_position("stats_background")
			local background_added_size = self._show_stats and stats_background_position[2] or 0
			local current_height = math.lerp(start_value, end_value, progress)

			self:_set_scenegraph_size("stats_background", nil, current_height + background_added_size)
			self:_set_scenegraph_size("stats", nil, current_height)
			self:_force_update_scenegraph()
		end,
	}

	if not self._show_stats and self._navigating_in_stats then
		self:_toggle_focus_stats(false)
	end

	self._stats_animations = animations
	self._update_shortcut_keys = true
end

ViewElementPlayerStats._toggle_focus_stats = function (self, force_state)
	local current_navigating_in_stats = self._navigating_in_stats

	if force_state ~= nil then
		self._navigating_in_stats = force_state
	else
		self._navigating_in_stats = not self._navigating_in_stats
	end

	local gamepad_active = InputDevice.gamepad_active

	if not gamepad_active then
		self._navigating_in_stats = false
	end

	if current_navigating_in_stats == self._navigating_in_stats then
		return
	end

	if self._stat_widgets then
		local found_index

		for i = 1, #self._stat_widgets do
			local widget = self._stat_widgets[i]

			if _can_stat_be_navigated(widget) and not found_index and self._navigating_in_stats then
				found_index = i
			end
		end

		for i = 1, #self._stat_widgets do
			local widget = self._stat_widgets[i]

			if widget.content.hotspot then
				widget.content.hotspot.is_selected = false
			end
		end

		if found_index then
			local found_widget = self._stat_widgets[found_index]

			found_widget.content.hotspot.is_selected = true
			self._selected_stat_widget_index = found_index
		end
	end

	self._update_shortcut_keys = true
end

ViewElementPlayerStats._select_next_stat = function (self)
	local start_index = self._selected_stat_widget_index or 1

	if self._stat_widgets then
		local found_index

		for i = 1, #self._stat_widgets do
			local widget = self._stat_widgets[i]

			if _can_stat_be_navigated(widget) and not found_index and start_index < i then
				found_index = i

				break
			end
		end

		if found_index then
			for i = 1, #self._stat_widgets do
				local widget = self._stat_widgets[i]

				if widget.content.hotspot then
					widget.content.hotspot.is_selected = false
				end
			end

			local found_widget = self._stat_widgets[found_index]

			found_widget.content.hotspot.is_selected = true
			self._selected_stat_widget_index = found_index
		end
	end
end

ViewElementPlayerStats._select_previous_stat = function (self)
	local start_index = self._selected_stat_widget_index or 1

	if self._stat_widgets then
		local found_index

		for i = #self._stat_widgets, 1, -1 do
			local widget = self._stat_widgets[i]

			if _can_stat_be_navigated(widget) and not found_index and i < start_index then
				found_index = i

				break
			end
		end

		if found_index then
			for i = 1, #self._stat_widgets do
				local widget = self._stat_widgets[i]

				if widget.content.hotspot then
					widget.content.hotspot.is_selected = false
				end
			end

			local found_widget = self._stat_widgets[found_index]

			found_widget.content.hotspot.is_selected = true
			self._selected_stat_widget_index = found_index
		end
	end
end

local added_ids_by_id = {}
local removed_ids_by_id = {}
local animations = {}

ViewElementPlayerStats._find_all_dependent_ids_to_add = function (self, id, ids)
	ids = ids or {}

	local stat_data = self._stats_data_by_id[id]

	if stat_data then
		if stat_data.parent then
			local parent_stat_data = self._stats_data_by_id[stat_data.parent]

			for i = 1, #parent_stat_data.childs do
				local child_id = stat_data.childs[i]

				ids[child_id] = true
			end

			local parent_id = parent_stat_data.id

			self:_find_all_dependent_ids_to_add(parent_id, ids)
		else
			ids[id] = true

			if stat_data.childs then
				for i = 1, #stat_data.childs do
					local child_id = stat_data.childs[i]

					ids[child_id] = true
				end
			end
		end
	end

	return ids
end

ViewElementPlayerStats._find_all_dependent_ids_to_remove = function (self, id, ids)
	ids = ids or {}

	local stat_data = self._stats_data_by_id[id]

	if stat_data then
		ids[id] = true

		if stat_data.childs then
			for i = 1, #stat_data.childs do
				local child_id = stat_data.childs[i]

				self:_find_all_dependent_ids_to_remove(child_id, ids)
			end
		end
	end

	return ids
end

ViewElementPlayerStats._update_active_categories = function (self, modified_ids, forced_added_ids)
	if not modified_ids then
		return
	end

	table.clear(added_ids_by_id)
	table.clear(removed_ids_by_id)
	table.clear(animations)

	if forced_added_ids then
		for i = 1, #forced_added_ids do
			added_ids_by_id[forced_added_ids[i]] = true
		end
	end

	for i = 1, #modified_ids do
		local id = modified_ids[i]

		if not self._active_categories_by_id[id] then
			local ids = self:_find_all_dependent_ids_to_add(id)

			for added_id, _ in pairs(ids) do
				if not self._active_categories_by_id[added_id] then
					added_ids_by_id[added_id] = true
					self._active_categories_by_id[added_id] = true

					local stat_data = self._stats_data_by_id[added_id]
					local stat_level = stat_data.level

					self._active_categories_per_level[stat_level] = self._active_categories_per_level[stat_level] or {}

					table.insert(self._active_categories_per_level[stat_level], 1, added_id)
				end
			end
		else
			local ids = self:_find_all_dependent_ids_to_remove(id)

			for removed_id, _ in pairs(ids) do
				if self._active_categories_by_id[removed_id] then
					removed_ids_by_id[removed_id] = true
					self._active_categories_by_id[removed_id] = nil

					local stat_data = self._stats_data_by_id[removed_id]
					local stat_level = stat_data.level

					self._active_categories_per_level[stat_level] = self._active_categories_per_level[stat_level] or {}

					table.remove(self._active_categories_per_level[stat_level], 1)
				end
			end
		end
	end

	local active_ids = self._active_categories_per_level[1]
	local num_ids = active_ids and #active_ids or 0

	if num_ids > self._max_active then
		local num_removed = num_ids - self._max_active

		for i = 1, num_removed do
			local id = table.remove(active_ids, #active_ids)
			local removed_ids = self:_find_all_dependent_ids_to_remove(id)

			for removed_id, _ in pairs(removed_ids) do
				if self._active_categories_by_id[removed_id] then
					removed_ids_by_id[removed_id] = true
					self._active_categories_by_id[removed_id] = nil
				end
			end
		end
	end

	local end_height = 0
	local last_active_offset = 0

	for i = 1, #self._stat_widgets do
		local stat_widget = self._stat_widgets[i]
		local content = stat_widget.content
		local element = content.element
		local id = element.id
		local level = element.level
		local state

		state = added_ids_by_id[id] and level > 1 and "added" or removed_ids_by_id[id] and level > 1 and "removed" or (self._active_categories_by_id[id] or level == 1) and "active" or "inactive"

		local start_offset = stat_widget.offset[2]
		local end_offset

		if state == "active" or state == "added" then
			end_offset = end_height
		else
			end_offset = last_active_offset
		end

		animations[#animations + 1] = {
			start_offset = start_offset,
			end_offset = end_offset,
			start_alpha = state == "added" and 0 or state == "removed" and 1 or state == "active" and 1 or 0,
			end_alpha = state == "added" and 1 or state == "removed" and 0 or state == "active" and 1 or 0,
			widget = stat_widget,
			update = function (animation_data, progress)
				local start_offset = animation_data.start_offset
				local end_offset = animation_data.end_offset
				local start_alpha = animation_data.start_alpha
				local end_alpha = animation_data.end_alpha
				local widget = animation_data.widget
				local current_offset = math.lerp(start_offset, end_offset, progress)
				local current_alpha = math.lerp(start_alpha, end_alpha, progress)

				widget.offset[2] = current_offset
				widget.alpha_multiplier = current_alpha
			end,
		}

		if state == "active" or state == "added" then
			last_active_offset = end_height
			end_height = end_height + _calculate_widget_height(stat_widget)
		end

		stat_widget.content.active = not not self._active_categories_by_id[id]
	end

	local _, start_height = self:_scenegraph_size("stats")

	if start_height ~= end_height then
		animations[#animations + 1] = {
			start_value = start_height,
			end_value = end_height,
			update = function (animation_data, progress)
				local start_value = animation_data.start_value
				local end_value = animation_data.end_value
				local stats_background_position = self:scenegraph_position("stats_background")
				local current_height = math.lerp(start_value, end_value, progress)

				self:_set_scenegraph_size("stats_background", nil, current_height + stats_background_position[2])
				self:_set_scenegraph_size("stats", nil, current_height)
				self:_force_update_scenegraph()
			end,
		}
	end

	self._stats_animations = animations
end

ViewElementPlayerStats._set_initial_stats_state = function (self)
	for i = 1, #self._stat_widgets do
		local stat_widget = self._stat_widgets[i]
		local content = stat_widget.content

		stat_widget.alpha_multiplier = 0
		stat_widget.offset[2] = 0
	end

	self:_set_scenegraph_size("stats_background", nil, 0)
	self:_set_scenegraph_size("stats", nil, 0)
	self:_force_update_scenegraph()
end

ViewElementPlayerStats._on_navigation_input_changed = function (self)
	self._update_shortcut_keys = true

	local gamepad_active = InputDevice.gamepad_active
	local first_avaiable_index

	for i = #self._stat_widgets, 1, -1 do
		local widget = self._stat_widgets[i]

		if _can_stat_be_navigated(widget) then
			first_avaiable_index = first_avaiable_index or i
		end

		if widget.content.hotspot then
			widget.content.hotspot.is_selected = false
		end
	end

	if gamepad_active and self._navigating_in_stats then
		local selected_widget = self._selected_stat_widget_index and self._stat_widgets[self._selected_stat_widget_index] and _can_stat_be_navigated(self._stat_widgets[self._selected_stat_widget_index]) and self._stat_widgets[self._selected_stat_widget_index]

		if not selected_widget then
			selected_widget = self._stat_widgets[first_avaiable_index]
			self._selected_stat_widget_index = selected_widget and first_avaiable_index or nil
		end

		if selected_widget then
			selected_widget.content.hotspot.is_selected = true
		end
	end

	ViewElementPlayerStats.super._on_navigation_input_changed(self)
end

ViewElementPlayerStats.set_pivot_offset = function (self, x, y)
	self._pivot_offset[1] = x or self._pivot_offset[1]
	self._pivot_offset[2] = y or self._pivot_offset[2]

	self:_set_scenegraph_position("entry_pivot", x, y)
end

ViewElementPlayerStats.on_resolution_modified = function (self, scale)
	ViewElementPlayerStats.super.on_resolution_modified(self, scale)
end

ViewElementPlayerStats.update = function (self, dt, t, input_service, ui_renderer)
	local disable_input = not not self._stats_animations

	if self._stat_widgets then
		for i = 1, #self._stat_widgets do
			local widget = self._stat_widgets[i]

			if widget.content.hotspot then
				widget.content.hotspot.disabled = disable_input or not self._show_stats
			end
		end
	end

	if self._shortcut_keys_widget_by_name then
		local toggle_stats_widget = self._shortcut_keys_widget_by_name.toggle_stats

		toggle_stats_widget.content.hotspot.disabled = disable_input

		local inspect_stats_widget = self._shortcut_keys_widget_by_name.inspect_stats

		inspect_stats_widget.content.hotspot.disabled = disable_input
	end

	if disable_input then
		input_service = input_service:null_service()
	end

	self:_update_animations(dt)
	self:_handle_input(input_service, dt, t)

	return ViewElementPlayerStats.super.update(self, dt, t, input_service)
end

ViewElementPlayerStats._handle_input = function (self, input_service, dt, t)
	local gamepad_active = InputDevice.gamepad_active
	local handled_input = false

	if self._draw_stats then
		if gamepad_active and self._navigating_in_stats then
			if input_service:get("navigate_up_continuous") then
				self:_select_previous_stat()

				handled_input = true
			elseif input_service:get("navigate_down_continuous") then
				self:_select_next_stat()

				handled_input = true
			end
		end

		if not self._stats_animations and not handled_input then
			local toggle_stats_widget = self._shortcut_keys_widget_by_name and self._shortcut_keys_widget_by_name.toggle_stats
			local inspect_stats_widget = self._shortcut_keys_widget_by_name and self._shortcut_keys_widget_by_name.inspect_stats

			if input_service:get("toggle_player_stats_inventory") and toggle_stats_widget then
				self._shortcut_keys_widget_by_name.toggle_stats.content.hotspot.pressed_callback()

				handled_input = true
			elseif input_service:get("toggle_player_navigation_inventory") and inspect_stats_widget and inspect_stats_widget.content.visible then
				self._shortcut_keys_widget_by_name.inspect_stats.content.hotspot.pressed_callback()

				handled_input = true
			elseif input_service:get("back") and inspect_stats_widget and inspect_stats_widget.content.visible and self._navigating_in_stats then
				self._shortcut_keys_widget_by_name.inspect_stats.content.hotspot.pressed_callback()

				handled_input = true
			end
		end
	end

	self._is_using_input = self._draw_stats and (handled_input or self._navigating_in_stats)
end

ViewElementPlayerStats._update_animations = function (self, dt)
	local animation_time = 0.5

	if self._stats_animations then
		self._progress_timer = self._progress_timer and self._progress_timer + dt or 0

		local animation_progress = math.ilerp(0, animation_time, self._progress_timer)

		for i = 1, #self._stats_animations do
			local stats_animation = self._stats_animations[i]
			local update_func = stats_animation.update

			if update_func then
				update_func(stats_animation, animation_progress)
			end
		end

		if animation_progress == 1 then
			self._stats_animations = nil
			self._progress_timer = nil
			self._update_shortcut_keys = true
		end
	end
end

ViewElementPlayerStats.show = function (self, show)
	self._draw_stats = show
end

ViewElementPlayerStats.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if self._profile and self._refresh then
		self:_update_stats(ui_renderer)

		self._refresh = false

		if not self._initialized then
			self:_generate_shortcut_keys()

			self._initialized = true
		end
	end

	if self._update_shortcut_keys then
		self._update_shortcut_keys = nil

		local toggle_stats_widget = self._shortcut_keys_widget_by_name.toggle_stats
		local inspect_stats_widget = self._shortcut_keys_widget_by_name.inspect_stats
		local toggle_stats_text = self._show_stats and Localize("loc_player_stats_element_interaction_hide") or Localize("loc_player_stats_element_interaction_show")
		local inspect_stats_text = self._navigating_in_stats and Localize("loc_player_stats_element_interaction_leave") or Localize("loc_player_stats_element_interaction_inspect")

		toggle_stats_widget.content.text = Text.add_button_hint("toggle_player_stats_inventory", toggle_stats_text, nil, nil, Localize("loc_input_legend_text_template"), true)
		inspect_stats_widget.content.text = Text.add_button_hint("toggle_player_navigation_inventory", inspect_stats_text, nil, nil, Localize("loc_input_legend_text_template"), true)

		local toggle_stats_widget_width, toggle_stats_widget_height = Text.text_size(ui_renderer, toggle_stats_widget.content.text, toggle_stats_widget.style.text)

		toggle_stats_widget.content.size = {
			toggle_stats_widget_width + 5,
			toggle_stats_widget_height,
		}

		local inspect_stats_width, inspect_stats_height = Text.text_size(ui_renderer, inspect_stats_widget.content.text, inspect_stats_widget.style.text)

		inspect_stats_widget.content.size = {
			inspect_stats_width + 5,
			inspect_stats_height,
		}
		inspect_stats_widget.offset[2] = toggle_stats_widget.offset[2] + toggle_stats_widget_height + 10

		local gamepad_active = InputDevice.gamepad_active

		inspect_stats_widget.content.visible = gamepad_active and self._show_stats and not self._stats_animations
	end

	if not self._draw_stats or not self._stat_widgets then
		return
	end

	ViewElementPlayerStats.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	local ui_scenegraph = self._ui_scenegraph
	local previous_layer = render_settings.start_layer

	render_settings.start_layer = (previous_layer or 0) + self._draw_layer

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if self._stat_widgets then
		for i = 1, #self._stat_widgets do
			local widget = self._stat_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._shortcut_keys_widget_by_name then
		for name, widget in pairs(self._shortcut_keys_widget_by_name) do
			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)

	render_settings.start_layer = previous_layer
end

ViewElementPlayerStats.destroy = function (self, ui_renderer)
	ViewElementPlayerStats.super.destroy(self, ui_renderer)
end

ViewElementPlayerStats.is_using_input = function (self)
	return self._is_using_input
end

return ViewElementPlayerStats
