local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local WeaponTweaks = require("scripts/utilities/weapon_tweaks")
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states
local suppression_templates = {}
local loaded_template_files = {}

WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autopistols/settings_templates/autopistol_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/flamers/settings_templates/flamer_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/force_staffs/settings_templates/force_staff_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_suppression_templates", suppression_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/stub_rifles/settings_templates/stub_rifle_suppression_templates", suppression_templates, loaded_template_files)

local function _inherit(move_state_settings, inheritance_settings)
	local new_move_state_settings = table.clone(suppression_templates[inheritance_settings[1]][inheritance_settings[2]])

	if new_move_state_settings.inherits then
		new_move_state_settings = _inherit(new_move_state_settings, new_move_state_settings.inherits)
	end

	for key, override_data in pairs(move_state_settings) do
		new_move_state_settings[key] = override_data
	end

	new_move_state_settings.inherits = nil

	return new_move_state_settings
end

for name, template in pairs(suppression_templates) do
	for _, movement_state in pairs(weapon_movement_states) do
		local move_state_settings = template[movement_state]

		fassert(move_state_settings, "Missing movement state [\"%s\"] for suppression template [\"%s\"] and movement state [\"%s\"]!", movement_state, name, movement_state)

		local inheritance_settings = move_state_settings.inherits

		if inheritance_settings then
			fassert(inheritance_settings[1], "Inheritance wanted for suppression template [\"%s\"], but no parent template to inherit from defined!", name)
			fassert(suppression_templates[inheritance_settings[1]], "Trying to inherit non-existent template [\"%s\"] in suppression template [\"%s\"]!", inheritance_settings[1], name)
			fassert(inheritance_settings[2], "Inheritance wanted for suppression template [\"%s\"], but no movement state to inherit from defined!", name)
			fassert(template[inheritance_settings[2]], "Trying to inherit non-existent movement state [\"%s\"] in suppression template [\"%s\"]!", inheritance_settings[2], name)

			local new_move_state_settings = _inherit(move_state_settings, inheritance_settings)
			suppression_templates[name][movement_state] = new_move_state_settings
		end
	end
end

return settings("SuppressionTemplates", suppression_templates)
