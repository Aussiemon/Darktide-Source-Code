-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates.lua

local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local template_types = WeaponTweakTemplateSettings.template_types
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states
local template_type_paths = {
	[template_types.ammo] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/ammo_trait_templates",
	[template_types.burninating] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/burninating_trait_templates",
	[template_types.charge] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/charge_trait_templates",
	[template_types.damage] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/damage_trait_templates",
	[template_types.dodge] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/dodge_trait_templates",
	[template_types.explosion] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/explosion_trait_templates",
	[template_types.movement_curve_modifier] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/movement_curve_modifier_trait_templates",
	[template_types.recoil] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/recoil_trait_templates",
	[template_types.size_of_flame] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/size_of_flame_trait_templates",
	[template_types.spread] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/spread_trait_templates",
	[template_types.sprint] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/sprint_trait_templates",
	[template_types.stamina] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/stamina_trait_templates",
	[template_types.sway] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/sway_trait_templates",
	[template_types.warp_charge] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/warp_charge_trait_templates",
	[template_types.weapon_handling] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_handling_trait_templates",
	[template_types.weapon_shout] = "scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_shout_trait_templates"
}
local templates = {}
local entries_to_duplicate = {}

local function _inject_weapon_movement_states(template)
	table.clear(entries_to_duplicate)

	local num_entries = #template

	for i = 1, num_entries do
		local entry = template[i]
		local first_path = entry[1]

		if first_path == WeaponTweakTemplateSettings.ALL_WEAPON_MOVEMENT_STATES then
			entries_to_duplicate[i] = true
		end
	end

	for index, _ in pairs(entries_to_duplicate) do
		local entry = template[index]
		local depth = #entry

		for weapon_movement_state, _ in pairs(weapon_movement_states) do
			local copied_entry = {
				weapon_movement_state
			}

			for i = 2, depth do
				copied_entry[i] = entry[i]
			end

			num_entries = num_entries + 1
			template[num_entries] = copied_entry
		end
	end

	for i = num_entries, 1, -1 do
		if entries_to_duplicate[i] then
			table.swap_delete(template, i)
		end
	end
end

local function _test_template(template, name, template_type)
	local num_entries = #template

	for i = 1, num_entries do
		local entry = template[i]
		local lerp_value_id = #entry
		local num_paths = lerp_value_id - 1

		for path_index = 1, num_paths do
			local path = entry[path_index]

			if type(path) ~= "table" then
				local var_2_0 = false
			else
				local is_table = true
			end
		end

		local lerp_value = entry[lerp_value_id]
		local is_number = type(lerp_value) == "number"
		local is_table = type(lerp_value) == "table"

		if is_table then
			local have_max = not not lerp_value.max
			local have_min = not not lerp_value.min

			if have_max then
				-- Nothing
			end

			::label_2_0::

			local have_lerp_values = have_min
		end

		::label_2_1::
	end

	local default_lerp_value = template.DEFAULT_LERP_VALUE
end

local function _extract_trait_templates(type, path)
	local type_templates = {}
	local collection = require(path)

	for name, template in pairs(collection) do
		_inject_weapon_movement_states(template)
		_test_template(template, name, type)

		type_templates[name] = template
	end

	templates[type] = type_templates
end

for type, path in pairs(template_type_paths) do
	_extract_trait_templates(type, path)
end

return settings("WeaponTraitTemplates", templates)
