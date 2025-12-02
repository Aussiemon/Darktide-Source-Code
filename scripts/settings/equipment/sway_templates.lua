-- chunkname: @scripts/settings/equipment/sway_templates.lua

local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local WeaponTweaks = require("scripts/utilities/weapon_tweaks")
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states
local sway_templates = {}
local loaded_template_files = {}

WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolt_pistols/settings_templates/boltpistol_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/needlepistols/settings_templates/needlepistol_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/settings_templates/ogryn_heavystubber_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotpistol_shield/settings_templates/shotpistol_shield_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_sway_templates", sway_templates, loaded_template_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_sway_templates", sway_templates, loaded_template_files)

local function _inherit(move_state_settings, inheritance_settings)
	local new_move_state_settings = table.clone(sway_templates[inheritance_settings[1]][inheritance_settings[2]])

	if new_move_state_settings.inherits then
		new_move_state_settings = _inherit(new_move_state_settings, new_move_state_settings.inherits)
	end

	for key, override_data in pairs(move_state_settings) do
		new_move_state_settings[key] = override_data
	end

	new_move_state_settings.inherits = nil

	return new_move_state_settings
end

local _immediate_sway_types = {
	"suppression_hit",
	"damage_hit",
	"shooting",
	"alternate_fire_start",
	"crouch_transition",
}

for name, template in pairs(sway_templates) do
	for _, movement_state in pairs(weapon_movement_states) do
		local move_state_settings = template[movement_state]
		local inheritance_settings = move_state_settings.inherits

		if inheritance_settings then
			local new_move_state_settings = _inherit(move_state_settings, inheritance_settings)

			sway_templates[name][movement_state] = new_move_state_settings
			move_state_settings = new_move_state_settings
		end

		for _, immediate_sway_type in ipairs(_immediate_sway_types) do
			local immediate_sway_settings = move_state_settings.immediate_sway[immediate_sway_type]

			if immediate_sway_settings then
				for i, entry in ipairs(immediate_sway_settings) do
					move_state_settings.immediate_sway[immediate_sway_type].num_sway_values = #move_state_settings.immediate_sway[immediate_sway_type]
				end
			end
		end
	end
end

return settings("SwayTemplates", sway_templates)
