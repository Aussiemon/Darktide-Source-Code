-- chunkname: @scripts/extension_systems/weapon/utilities/weapon_tweak_templates.lua

local MasterItems = require("scripts/backend/master_items")
local RecoilTemplates = require("scripts/settings/equipment/recoil_templates")
local SpreadTemplates = require("scripts/settings/equipment/spread_templates")
local SuppressionTemplates = require("scripts/settings/equipment/suppression_templates")
local SwayTemplates = require("scripts/settings/equipment/sway_templates")
local WeaponAmmoTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_ammo_templates")
local WeaponBurninatingTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_burninating_templates")
local WeaponChargeTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_charge_templates")
local WeaponDodgeTemplates = require("scripts/settings/dodge/weapon_dodge_templates")
local WeaponHandlingTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_handling_templates")
local WeaponMovementCurveModifierTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_movement_curve_modifier_templates")
local WeaponShoutTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_shout_templates")
local WeaponSizeOfFlameTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_size_of_flame_templates")
local WeaponSprintTemplates = require("scripts/settings/sprint/weapon_sprint_templates")
local WeaponStaminaTemplates = require("scripts/settings/stamina/weapon_stamina_templates")
local WeaponToughnessTemplates = require("scripts/settings/toughness/weapon_toughness_templates")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_traits/weapon_trait_templates")
local WeaponTweakStatsUiData = require("scripts/settings/equipment/weapon_tweak_stats_ui_data")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WeaponWarpChargeTemplates = require("scripts/settings/warp_charge/weapon_warp_charge_templates")
local template_types = WeaponTweakTemplateSettings.template_types
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local DEFAULT_STAT_TRAIT_VALUE = WeaponTweakTemplateSettings.DEFAULT_STAT_TRAIT_VALUE
local DEFALT_FALLBACK_LERP_VALUE = WeaponTweakTemplateSettings.DEFALT_FALLBACK_LERP_VALUE
local WeaponTweakStatsUiDataStats = WeaponTweakStatsUiData.stats
local WeaponTweakTemplates = {}
local math_lerp = math.lerp
local math_clamp = math.clamp
local _preparse_templates, _preparse_damage_templates, _preparse_explosion_templates, _lookup_entry, _add_tweak_stats, _build_templates, _lerp_array, _verify_base_templates, _add_tweak_modifiers, _add_lerped_tweak_modifiers, _resolve_template

WeaponTweakTemplates.preparse_weapon_template = function (weapon_template)
	local base_template_lookup = {}

	base_template_lookup[template_types.recoil] = _preparse_templates(weapon_template, template_types.recoil)
	base_template_lookup[template_types.sway] = _preparse_templates(weapon_template, template_types.sway)
	base_template_lookup[template_types.suppression] = _preparse_templates(weapon_template, template_types.suppression)
	base_template_lookup[template_types.spread] = _preparse_templates(weapon_template, template_types.spread)
	base_template_lookup[template_types.weapon_handling] = _preparse_templates(weapon_template, template_types.weapon_handling)
	base_template_lookup[template_types.weapon_shout] = _preparse_templates(weapon_template, template_types.weapon_shout)
	base_template_lookup[template_types.dodge] = _preparse_templates(weapon_template, template_types.dodge)
	base_template_lookup[template_types.sprint] = _preparse_templates(weapon_template, template_types.sprint)
	base_template_lookup[template_types.stamina] = _preparse_templates(weapon_template, template_types.stamina)
	base_template_lookup[template_types.toughness] = _preparse_templates(weapon_template, template_types.toughness)
	base_template_lookup[template_types.ammo] = _preparse_templates(weapon_template, template_types.ammo)
	base_template_lookup[template_types.burninating] = _preparse_templates(weapon_template, template_types.burninating)
	base_template_lookup[template_types.size_of_flame] = _preparse_templates(weapon_template, template_types.size_of_flame)
	base_template_lookup[template_types.movement_curve_modifier] = _preparse_templates(weapon_template, template_types.movement_curve_modifier)
	base_template_lookup[template_types.charge] = _preparse_templates(weapon_template, template_types.charge)
	base_template_lookup[template_types.warp_charge] = _preparse_templates(weapon_template, template_types.warp_charge)
	base_template_lookup[template_types.damage] = _preparse_damage_templates(weapon_template)
	base_template_lookup[template_types.explosion] = _preparse_explosion_templates(weapon_template)
	weapon_template.__base_template_lookup = base_template_lookup
end

WeaponTweakTemplates.create = function (lerp_values, weapon_template, override_lerp_value_or_nil)
	local templates = {}
	local base_template_lookup = weapon_template.__base_template_lookup

	templates[template_types.recoil] = _build_templates(RecoilTemplates, base_template_lookup[template_types.recoil], lerp_values[template_types.recoil], override_lerp_value_or_nil)
	templates[template_types.sway] = _build_templates(SwayTemplates, base_template_lookup[template_types.sway], lerp_values[template_types.sway], override_lerp_value_or_nil)
	templates[template_types.spread] = _build_templates(SpreadTemplates, base_template_lookup[template_types.spread], lerp_values[template_types.spread], override_lerp_value_or_nil)
	templates[template_types.suppression] = _build_templates(SuppressionTemplates, base_template_lookup[template_types.suppression], lerp_values[template_types.suppression], override_lerp_value_or_nil)
	templates[template_types.weapon_handling] = _build_templates(WeaponHandlingTemplates, base_template_lookup[template_types.weapon_handling], lerp_values[template_types.weapon_handling], override_lerp_value_or_nil)
	templates[template_types.weapon_shout] = _build_templates(WeaponShoutTemplates, base_template_lookup[template_types.weapon_shout], lerp_values[template_types.weapon_shout], override_lerp_value_or_nil)
	templates[template_types.dodge] = _build_templates(WeaponDodgeTemplates, base_template_lookup[template_types.dodge], lerp_values[template_types.dodge], override_lerp_value_or_nil)
	templates[template_types.sprint] = _build_templates(WeaponSprintTemplates, base_template_lookup[template_types.sprint], lerp_values[template_types.sprint], override_lerp_value_or_nil)
	templates[template_types.stamina] = _build_templates(WeaponStaminaTemplates, base_template_lookup[template_types.stamina], lerp_values[template_types.stamina], override_lerp_value_or_nil)
	templates[template_types.toughness] = _build_templates(WeaponToughnessTemplates, base_template_lookup[template_types.toughness], lerp_values[template_types.toughness], override_lerp_value_or_nil)
	templates[template_types.ammo] = _build_templates(WeaponAmmoTemplates, base_template_lookup[template_types.ammo], lerp_values[template_types.ammo], override_lerp_value_or_nil)
	templates[template_types.burninating] = _build_templates(WeaponBurninatingTemplates, base_template_lookup[template_types.burninating], lerp_values[template_types.burninating], override_lerp_value_or_nil)
	templates[template_types.size_of_flame] = _build_templates(WeaponSizeOfFlameTemplates, base_template_lookup[template_types.size_of_flame], lerp_values[template_types.size_of_flame], override_lerp_value_or_nil)
	templates[template_types.movement_curve_modifier] = _build_templates(WeaponMovementCurveModifierTemplates, base_template_lookup[template_types.movement_curve_modifier], lerp_values[template_types.movement_curve_modifier], override_lerp_value_or_nil)
	templates[template_types.charge] = _build_templates(WeaponChargeTemplates, base_template_lookup[template_types.charge], lerp_values[template_types.charge], override_lerp_value_or_nil)
	templates[template_types.warp_charge] = _build_templates(WeaponWarpChargeTemplates, base_template_lookup[template_types.warp_charge], lerp_values[template_types.warp_charge], override_lerp_value_or_nil)

	return templates
end

WeaponTweakTemplates.calculate_lerp_values = function (weapon_template, base_stats, overclocks, perks, traits, override_lerp_value)
	local weapon_tweaks = {}
	local base_template_lookup = weapon_template.__base_template_lookup

	for template_type, _ in pairs(template_types) do
		local tweak_targets = {}
		local lookup = base_template_lookup[template_type]
		local iterator = pairs

		for target_template, _ in iterator(lookup) do
			tweak_targets[target_template] = {}
		end

		weapon_tweaks[template_type] = tweak_targets
	end

	local weapon_name = weapon_template.name
	local overclock_definitions = weapon_template.overclocks
	local overclock_modifiers = {}

	if overclock_definitions then
		for i = 1, #overclocks do
			local overclock_data = overclocks[i]
			local overclock_name = overclock_data.name
			local overclock_definition = overclock_definitions[overclock_name]

			if overclock_definition then
				for base_stat_name, value in pairs(overclock_definition) do
					overclock_modifiers[base_stat_name] = (overclock_modifiers[base_stat_name] or 0) + value
				end
			else
				Log.warning("WeaponTweakTemplates", "Could not find overclock definition %s for weapon %s when fetching weapon overclocks", overclock_name, weapon_name)
			end
		end
	end

	local base_stat_values = {}

	for i = 1, #base_stats do
		local base_stat_data = base_stats[i]
		local base_stat_name = base_stat_data.name
		local base_stat_value = base_stat_data.value

		base_stat_values[base_stat_name] = base_stat_value
	end

	local base_stat_definitions = weapon_template.base_stats

	if base_stat_definitions then
		for base_stat_name, base_stat_definition in pairs(base_stat_definitions) do
			local base_stat_value = base_stat_values[base_stat_name] or DEFAULT_STAT_TRAIT_VALUE
			local overclock_modifier = overclock_modifiers[base_stat_name] or 0

			base_stat_value = base_stat_value + overclock_modifier

			_add_lerped_tweak_modifiers(weapon_tweaks, base_stat_definition, base_stat_value)
		end
	end

	return weapon_tweaks
end

WeaponTweakTemplates.extract_buffs = function (weapon_template)
	local buffs = {
		[buff_targets.on_equip] = {},
		[buff_targets.on_wield] = {},
		[buff_targets.on_unwield] = {},
	}
	local weapon_buffs = weapon_template.buffs

	if weapon_buffs and weapon_buffs.on_equip then
		table.merge(buffs.on_equip, weapon_buffs.on_equip)
	end

	if weapon_buffs and weapon_buffs.on_wield then
		table.merge(buffs.on_wield, weapon_buffs.on_wield)
	end

	if weapon_buffs and weapon_buffs.on_unwield then
		table.merge(buffs.on_unwield, weapon_buffs.on_unwield)
	end

	return buffs
end

local function _add_trait(trait_name, rarity, buffs, weapon_name)
	local trait_definition = WeaponTraitTemplates[trait_name]

	if trait_definition then
		local buff_target = buff_targets.on_equip
		local weapon_buff_list = buffs[buff_target]
		local trait_buffs = trait_definition.buffs

		for buff_template_name, data in pairs(trait_buffs) do
			for i = rarity, 1, -1 do
				local override_data = data[i]

				if override_data then
					weapon_buff_list[#weapon_buff_list + 1] = buff_template_name

					break
				end
			end
		end
	else
		Log.warning("WeaponTweakTemplates", "Could not find modifier definition %s for weapon %s when extracting buffs", trait_name, weapon_name)
	end
end

WeaponTweakTemplates.extract_trait_buffs = function (weapon_template, buffs, traits)
	local weapon_name = weapon_template.name
	local item_definitions = MasterItems.get_cached()

	for i = 1, #traits do
		local trait = traits[i]
		local trait_item_id = trait.id
		local rarity = trait.rarity or 1
		local valid_id = trait_item_id and MasterItems.item_exists(trait_item_id)
		local trait_item = valid_id and item_definitions[trait_item_id]

		if trait_item then
			local trait_name = trait_item.trait

			_add_trait(trait_name, rarity, buffs, weapon_name)
		else
			Log.warning("WeaponTweakTemplates", "Could not find item for trait %s for weapon %s when extracting buffs", trait_item_id, weapon_name)
		end
	end
end

function _preparse_templates(weapon_template, template_type)
	local key = template_type .. "_template"
	local special_key = "special_" .. template_type .. "_template"
	local lookup = {}
	local base_template = weapon_template[key]

	if base_template then
		local base_template_name = string.format("base_%s", base_template)
		local lookup_entry = _lookup_entry(base_template_name, base_template)

		lookup.base = lookup_entry
		weapon_template[key] = base_template_name
	end

	local base_special_template = weapon_template[special_key]

	if base_special_template then
		local base_special_template_name = string.format("base_special_%s", base_special_template)
		local lookup_entry = _lookup_entry(base_special_template_name, base_special_template)

		lookup.base_special = lookup_entry
		weapon_template[special_key] = base_special_template_name
	end

	local alternate_fire_settings = weapon_template.alternate_fire_settings
	local alternate_fire_template = alternate_fire_settings and alternate_fire_settings[key]

	if alternate_fire_template then
		local alternate_fire_template_name = string.format("alternate_fire_%s", alternate_fire_template)
		local lookup_entry = _lookup_entry(alternate_fire_template_name, alternate_fire_template)

		lookup.alternate_fire = lookup_entry
		alternate_fire_settings[key] = alternate_fire_template_name
	end

	local alternate_fire_special_template = alternate_fire_settings and alternate_fire_settings[special_key]

	if alternate_fire_special_template then
		local alternate_fire_special_template_name = string.format("alternate_fire_special_%s", alternate_fire_special_template)
		local lookup_entry = _lookup_entry(alternate_fire_special_template_name, alternate_fire_special_template)

		lookup.alternate_fire_special = lookup_entry
		alternate_fire_settings[special_key] = alternate_fire_special_template_name
	end

	local actions = weapon_template.actions

	for action_name, action_settings in pairs(actions) do
		local action_template = action_settings[key]

		if action_template then
			local action_template_name = string.format("%s_%s", action_name, action_template)
			local lookup_entry = _lookup_entry(action_template_name, action_template)

			lookup[action_name] = lookup_entry
			action_settings[key] = action_template_name
		end

		local action_special_template = action_settings[special_key]

		if action_special_template then
			local action_special_template_name = string.format("%s_special_%s", action_name, action_special_template)
			local lookup_entry = _lookup_entry(action_special_template_name, action_special_template)
			local action_special_name = string.format("%s_special", action_name)

			lookup[action_special_name] = lookup_entry
			action_settings[special_key] = action_special_template_name
		end
	end

	return lookup
end

function _preparse_damage_templates(weapon_template)
	local lookup = {}
	local actions = weapon_template.actions

	for action_name, action_settings in pairs(actions) do
		lookup[action_name] = {}
	end

	return lookup
end

function _preparse_explosion_templates(weapon_template)
	local lookup = {}
	local actions = weapon_template.actions

	for action_name, action_settings in pairs(actions) do
		lookup[action_name] = {}
	end

	return lookup
end

function _lookup_entry(new_identifier, base_identifier)
	return {
		new_identifier = new_identifier,
		base_identifier = base_identifier,
	}
end

function _add_tweak_stats(start_table, tweak, tweak_value)
	local path = start_table
	local entry = tweak
	local depth = #entry

	for j = 1, depth - 2 do
		local key = entry[j]
		local existing_path = path[key]

		if existing_path then
			path = existing_path
		else
			local new_path = {}

			path[key] = new_path
			path = new_path
		end
	end

	local key = entry[depth - 1]
	local existing_value = path[key]

	if existing_value then
		path[key] = math_clamp(existing_value + tweak_value, 0, 1)
	else
		path[key] = math_clamp(tweak_value, 0, 1)
	end
end

function _lerp_array(array_min, array_max, t)
	local num_entries = #array_min
	local array = Script.new_array(num_entries)

	for i = 1, num_entries do
		local min, max = array_min[i], array_max[i]

		array[i] = math.lerp(min, max, t)
	end

	return array
end

function _verify_base_templates(base_templates, verify_function)
	local iterator = pairs

	for name, template in iterator(base_templates) do
		local copied_template = table.clone(template)

		_resolve_template(copied_template, template)
		verify_function(name, copied_template)
	end
end

function _resolve_template(out_template, base_template, lerp_values_or_nil, default_lerp_value_or_nil, override_lerp_value_or_nil)
	for key, template in pairs(base_template) do
		if type(template) == "table" then
			local lerp_basic, lerp_perfect = template.lerp_basic, template.lerp_perfect
			local lerpable_value = lerp_basic and lerp_perfect
			local current_lerp_values = lerp_values_or_nil and lerp_values_or_nil[key]

			if lerpable_value then
				local t = current_lerp_values or default_lerp_value_or_nil or DEFALT_FALLBACK_LERP_VALUE

				if type(lerp_basic) == "table" then
					out_template[key] = _lerp_array(lerp_basic, lerp_perfect, t)
				else
					local lerped_value = math.lerp(lerp_basic, lerp_perfect, t)

					out_template[key] = lerped_value
				end
			else
				local sub_template = {}

				out_template[key] = sub_template

				_resolve_template(sub_template, template, current_lerp_values, default_lerp_value_or_nil, override_lerp_value_or_nil)
			end
		else
			out_template[key] = template
		end
	end
end

function _add_tweak_modifiers(out_tweaks, modifier_definition)
	for template_type, targets in pairs(modifier_definition) do
		if rawget(template_types, template_type) then
			local out_tweak = out_tweaks[template_type] or {}

			for target_template, tweak_groups in pairs(targets) do
				local out_tweak_target = out_tweak[target_template] or {}

				for tweak_group_idx = 1, #tweak_groups do
					local tweak_group = tweak_groups[tweak_group_idx]

					for tweak_row_idx = 1, #tweak_group do
						local tweak_row = tweak_group[tweak_row_idx]
						local tweak_value = tweak_row[#tweak_row]

						_add_tweak_stats(out_tweak_target, tweak_row, tweak_value)
					end
				end

				out_tweak[target_template] = out_tweak_target
			end

			out_tweaks[template_type] = out_tweak
		end
	end
end

local function _add_lerped_tweak_modifiers_helper(tweak_groups, lerp_t, out_tweak_target)
	for tweak_group_idx = 1, #tweak_groups do
		local tweak_group = tweak_groups[tweak_group_idx]

		for tweak_row_idx = 1, #tweak_group do
			local tweak_row = tweak_group[tweak_row_idx]
			local tweak_value = tweak_row[#tweak_row]

			if type(tweak_value) == "table" then
				local lerp_min = tweak_value.min
				local lerp_max = tweak_value.max

				tweak_value = math_lerp(lerp_min, lerp_max, lerp_t)
			end

			_add_tweak_stats(out_tweak_target, tweak_row, tweak_value)
		end
	end
end

function _add_lerped_tweak_modifiers(out_tweaks, modifier_definition, lerp_t)
	for template_type, targets in pairs(modifier_definition) do
		if rawget(template_types, template_type) then
			local out_tweak = out_tweaks[template_type] or {}

			for target_template, tweak_groups in pairs(targets) do
				local out_tweak_target = out_tweak[target_template] or {}

				_add_lerped_tweak_modifiers_helper(tweak_groups, lerp_t, out_tweak_target)

				if tweak_groups.overrides then
					for sub_tweak_groups_id, sub_tweak_groups in pairs(tweak_groups.overrides) do
						local sub_out_tweak_target = out_tweak_target[sub_tweak_groups_id] or {}

						_add_lerped_tweak_modifiers_helper(sub_tweak_groups, lerp_t, sub_out_tweak_target)

						out_tweak_target[sub_tweak_groups_id] = sub_out_tweak_target
					end

					out_tweak[target_template] = out_tweak_target
				end
			end

			out_tweaks[template_type] = out_tweak
		end
	end
end

function _build_templates(source_templates, base_template_lookup, lerp_values, override_lerp_value_or_nil)
	local templates = {}
	local iterator = pairs

	for lookup_type, lookup_entry in iterator(base_template_lookup) do
		local new_identifier, base_identifier = lookup_entry.new_identifier, lookup_entry.base_identifier
		local base_template = source_templates[base_identifier]
		local new_template = {}
		local template_lerp_values = lerp_values and lerp_values[lookup_type]
		local default_lerp_value_or_nil = template_lerp_values and template_lerp_values[DEFAULT_LERP_VALUE]

		_resolve_template(new_template, base_template, template_lerp_values, default_lerp_value_or_nil or DEFALT_FALLBACK_LERP_VALUE, override_lerp_value_or_nil)

		templates[new_identifier] = new_template
	end

	return templates
end

local BASE_TEMPLATES = {
	[template_types.ammo] = WeaponAmmoTemplates,
	[template_types.burninating] = WeaponBurninatingTemplates,
	[template_types.charge] = WeaponChargeTemplates,
	[template_types.dodge] = WeaponDodgeTemplates,
	[template_types.movement_curve_modifier] = WeaponMovementCurveModifierTemplates,
	[template_types.recoil] = RecoilTemplates,
	[template_types.size_of_flame] = WeaponSizeOfFlameTemplates,
	[template_types.spread] = SpreadTemplates,
	[template_types.sprint] = WeaponSprintTemplates,
	[template_types.stamina] = WeaponStaminaTemplates,
	[template_types.suppression] = SuppressionTemplates,
	[template_types.sway] = SwayTemplates,
	[template_types.toughness] = WeaponToughnessTemplates,
	[template_types.warp_charge] = WeaponWarpChargeTemplates,
	[template_types.weapon_handling] = WeaponHandlingTemplates,
	[template_types.weapon_shout] = WeaponShoutTemplates,
}

WeaponTweakTemplates.get_base_stats = function (weapon_template, template_type, target)
	local base_template = BASE_TEMPLATES[template_type]

	if not base_template then
		ferror("no such template '%s' in BASE_TEMPLATES", template_type)

		return
	end

	local base_identifier = WeaponTweakTemplates.get_template_identifiers(weapon_template, template_type, target)
	local base_stats = base_identifier and base_template[base_identifier]

	return base_stats
end

WeaponTweakTemplates.get_template_identifiers = function (weapon_template, template_type, target)
	local base_template_lookup = weapon_template.__base_template_lookup
	local lookup_entry = base_template_lookup[template_type]

	if lookup_entry then
		local identifier_lookup = lookup_entry[target]

		if identifier_lookup then
			return identifier_lookup.base_identifier, identifier_lookup.new_identifier
		end
	end

	return nil, nil
end

WeaponTweakTemplates.get_base_stats_values = function (base_stats, stat_data)
	local path_len = #stat_data
	local resolved_table = base_stats
	local real_value_range = stat_data[path_len]

	for i = 1, path_len - 1 do
		local path_name = stat_data[i]

		resolved_table = resolved_table[path_name]

		if not resolved_table then
			return nil
		end
	end

	local lerp_basic, lerp_perfect

	if type(resolved_table) == "table" then
		lerp_basic, lerp_perfect = resolved_table.lerp_basic, resolved_table.lerp_perfect
	else
		lerp_basic, lerp_perfect = resolved_table, resolved_table
	end

	local real_min_lerp, real_max_lerp

	if type(real_value_range) == "table" then
		real_min_lerp, real_max_lerp = real_value_range.min, real_value_range.max
	else
		real_min_lerp, real_max_lerp = real_value_range, real_value_range
	end

	local min = math.lerp(lerp_basic, lerp_perfect, real_min_lerp)
	local max = math.lerp(lerp_basic, lerp_perfect, real_max_lerp)

	return min, max
end

WeaponTweakTemplates.get_base_stats_lerp_values = function (stat_data)
	local path_len = #stat_data
	local lerp_value_range = stat_data[path_len]

	if type(lerp_value_range) == "table" then
		return lerp_value_range.min, lerp_value_range.max
	else
		return lerp_value_range, lerp_value_range
	end
end

WeaponTweakTemplates.get_stat_ui_data = function (template_type, stat_data, path_length_offset)
	local base_template_ui_data = WeaponTweakStatsUiDataStats[template_type]

	if not base_template_ui_data then
		return nil
	end

	local resolved_table = base_template_ui_data

	if resolved_table then
		for i = 1, #stat_data - (path_length_offset or 1) do
			local path_name = stat_data[i]

			if resolved_table._array_range then
				local array_range = resolved_table._array_range
				local path_index = tonumber(path_name)

				if path_index >= array_range[1] and path_index <= array_range[2] then
					resolved_table = array_range
				else
					return nil
				end
			else
				resolved_table = resolved_table[path_name]

				if not resolved_table then
					return nil
				end
			end
		end
	end

	return resolved_table
end

return WeaponTweakTemplates
