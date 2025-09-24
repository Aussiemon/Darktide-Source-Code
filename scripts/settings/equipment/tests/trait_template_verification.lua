-- chunkname: @scripts/settings/equipment/tests/trait_template_verification.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local RecoilTemplates = require("scripts/settings/equipment/recoil_templates")
local SpreadTemplates = require("scripts/settings/equipment/spread_templates")
local SwayTemplates = require("scripts/settings/equipment/sway_templates")
local SuppressionTemplates = require("scripts/settings/equipment/suppression_templates")
local WeaponDodgeTemplates = require("scripts/settings/dodge/weapon_dodge_templates")
local WeaponSprintTemplates = require("scripts/settings/sprint/weapon_sprint_templates")
local WeaponStaminaTemplates = require("scripts/settings/stamina/weapon_stamina_templates")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local WeaponToughnessTemplates = require("scripts/settings/toughness/weapon_toughness_templates")
local WeaponTraitTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_trait_templates")
local WeaponAmmoTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_ammo_templates")
local WeaponBurninatingTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_burninating_templates")
local WeaponSizeOfFlameTemplates = require("scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_size_of_flame_templates")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local template_types = WeaponTweakTemplateSettings.template_types
local BASE_TEMPLATES = {
	[template_types.recoil] = RecoilTemplates,
	[template_types.spread] = SpreadTemplates,
	[template_types.sway] = SwayTemplates,
	[template_types.suppression] = SuppressionTemplates,
	[template_types.dodge] = WeaponDodgeTemplates,
	[template_types.sprint] = WeaponSprintTemplates,
	[template_types.stamina] = WeaponStaminaTemplates,
	[template_types.toughness] = WeaponToughnessTemplates,
	[template_types.damage] = DamageProfileTemplates,
	[template_types.ammo] = WeaponAmmoTemplates,
	[template_types.burninating] = WeaponBurninatingTemplates,
	[template_types.size_of_flame] = WeaponSizeOfFlameTemplates,
}
local _verify_trait_templates, _verify_trait_template, _verify_trait_template_entry, _verify_damage_trait_template_entries, _verify_damage_trait_template_entry, _verify_trait_template_entries, _check_lerp_value

local function _trait_template_verification()
	for template_type, _ in pairs(template_types) do
		local trait_templates = WeaponTraitTemplates[template_type]
		local type_success, type_error_msg = _verify_trait_templates(template_type, trait_templates)

		if not type_success then
			Log.warning("WeaponTraitTemplateVerification", "%s\n%s", template_type, type_error_msg)
		end
	end
end

function _verify_trait_templates(template_type, trait_templates)
	local base_templates = BASE_TEMPLATES[template_type]
	local success, error_msg = true, ""

	for name, trait_template in pairs(trait_templates) do
		local template_success, template_error_msgs = _verify_trait_template(template_type, trait_template, base_templates)

		if not template_success then
			success = false
			error_msg = string.format("%s%q failed:\n", error_msg, name)

			local num_error_msgs = #template_error_msgs

			for i = 1, num_error_msgs do
				error_msg = string.format("%s\t%s\n", error_msg, template_error_msgs[i])
			end
		end
	end

	return success, error_msg
end

function _verify_trait_template(template_type, trait_template, base_templates)
	local error_msgs = {}
	local lerp_value_success = _check_lerp_value(trait_template, error_msgs)

	if not lerp_value_success then
		return false, error_msgs
	end

	local successful_entries = {}
	local num_entries = #trait_template

	for i = 1, num_entries do
		successful_entries[i] = false
	end

	if template_type == template_types.damage then
		_verify_damage_trait_template_entries(template_type, trait_template, base_templates, successful_entries)
	else
		_verify_trait_template_entries(template_type, trait_template, base_templates, successful_entries)
	end

	local success = true

	for i = 1, num_entries do
		if not successful_entries[i] then
			success = false
			error_msgs[#error_msgs + 1] = string.format("entry id %i could not find any lerp targets.", i)
		end
	end

	return success, error_msgs
end

function _verify_trait_template_entries(template_type, trait_template, base_templates, successful_entries)
	local num_entries = #trait_template

	for i = 1, num_entries do
		local entry = trait_template[i]

		for name, weapon_template in pairs(WeaponTemplates) do
			local base_template_lookup = weapon_template.__base_template_lookup
			local lookup = base_template_lookup[template_type]
			local iterator = pairs

			for lookup_type, lookup_entry in iterator(lookup) do
				local base_template_name = lookup_entry.base_identifier
				local base_template = base_templates[base_template_name]

				if _verify_trait_template_entry(entry, base_template) then
					successful_entries[i] = true

					break
				end
			end

			if successful_entries[i] then
				break
			end
		end
	end
end

function _verify_damage_trait_template_entries(template_type, trait_template, damage_profile_templates, successful_entries)
	local num_entries = #trait_template

	for i = 1, num_entries do
		local entry = trait_template[i]

		for name, damage_profile in pairs(damage_profile_templates) do
			if _verify_damage_trait_template_entry(entry, damage_profile) then
				successful_entries[i] = true

				break
			end
		end
	end
end

function _verify_damage_trait_template_entry(entry, damage_profile)
	local test_template = damage_profile
	local depth = #entry

	for i = 1, depth - 1 do
		local path = entry[i]

		test_template = test_template[path]

		if not test_template then
			return false
		end
	end

	local base_template_entry_is_table = type(test_template) == "table"

	if not base_template_entry_is_table then
		return false
	end

	local base_template_entry_is_lerpable = test_template[1] ~= nil and test_template[2] ~= nil

	if not base_template_entry_is_lerpable then
		return false
	end

	return true
end

function _verify_trait_template_entry(trait_template_entry, base_template)
	local test_template = base_template
	local depth = #trait_template_entry

	for i = 1, depth - 1 do
		local path = trait_template_entry[i]

		test_template = test_template[path]

		if not test_template then
			return false
		end
	end

	local base_template_entry_is_table = type(test_template) == "table"

	if not base_template_entry_is_table then
		return false
	end

	local base_template_entry_is_lerpable = test_template.lerp_basic ~= nil and test_template.lerp_perfect ~= nil

	if not base_template_entry_is_lerpable then
		return false
	end

	return true
end

function _check_lerp_value(trait_template, error_msgs_table)
	local success = true
	local num_entries = #trait_template

	for i = 1, num_entries do
		local entry = trait_template[i]
		local entry_depth = #entry
		local lerp_value = entry[entry_depth]

		if type(lerp_value) ~= "number" then
			success = false
			error_msgs_table[#error_msgs_table + 1] = string.format("entry id %i does not end with a lerp number.", i)
		end
	end

	return success
end

return _trait_template_verification
