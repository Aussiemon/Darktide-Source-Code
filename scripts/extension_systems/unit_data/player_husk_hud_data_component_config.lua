local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local husk_hud_data_component_config = {
	action_heal_target_over_time = {
		"target_unit"
	},
	action_module_position_finder = {
		"position",
		"normal",
		"position_valid"
	},
	action_module_targeting = {
		"target_unit_1",
		"target_unit_2",
		"target_unit_3"
	},
	warp_charge = {
		"current_percentage"
	},
	shooting_status = {
		"shooting_end_time"
	},
	inventory = {
		"slot_luggable"
	},
	specialization_resource = {
		max_resource = "specialization_resource",
		current_resource = "specialization_resource"
	},
	disabled_character_state = {
		"is_disabled",
		"disabling_type",
		"disabling_unit"
	},
	movement_state = {
		"is_crouching"
	},
	weapon_lock_view = {
		"is_active",
		"pitch",
		"yaw"
	}
}
local slot_configuration = PlayerCharacterConstants.slot_configuration

for slot_name, slot_config in pairs(slot_configuration) do
	if slot_config.wieldable and slot_config.slot_type == "weapon" then
		fassert(husk_hud_data_component_config[slot_name] == nil, "already tracking slot_name %q in husk_hud_data_component_config.", slot_name)

		husk_hud_data_component_config[slot_name] = {
			"powered_weapon_intensity"
		}
	end
end

local looping_sound_aliases = {
	"weapon_temperature"
}

for i = 1, #looping_sound_aliases, 1 do
	local looping_sound_alias = looping_sound_aliases[i]
	local component_name = PlayerUnitData.looping_sound_component_name(looping_sound_alias)

	fassert(husk_hud_data_component_config[component_name] == nil, "Already contains a component named %q", component_name)

	husk_hud_data_component_config[component_name] = {
		"is_playing"
	}
end

return husk_hud_data_component_config
