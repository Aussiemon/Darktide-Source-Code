-- chunkname: @scripts/extension_systems/unit_data/player_husk_hud_data_component_config.lua

local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local husk_hud_data_component_config = {
	action_module_position_finder = {
		"position",
		"normal",
		"position_valid",
	},
	action_module_targeting = {
		"target_unit_1",
		"target_unit_2",
		"target_unit_3",
	},
	warp_charge = {
		"current_percentage",
	},
	shooting_status = {
		"shooting_end_time",
	},
	inventory = {
		"slot_grenade_ability",
		"slot_luggable",
	},
	slot_primary = {
		"overheat_state",
	},
	slot_secondary = {
		"overheat_state",
	},
	talent_resource = {
		current_resource = "talent_resource",
		max_resource = "talent_resource",
	},
	disabled_character_state = {
		"is_disabled",
		"disabling_type",
		"disabling_unit",
	},
	ledge_hanging_character_state = {
		"time_to_fall_down",
	},
	interacting_character_state = {
		"interaction_template",
	},
	movement_state = {
		"is_crouching",
	},
	grenade_ability = {
		"cooldown",
		"cooldown_paused",
		"num_charges",
	},
	combat_ability = {
		"cooldown",
		"cooldown_paused",
		"num_charges",
	},
	weapon_lock_view = {
		"state",
		"pitch",
		"yaw",
	},
}
local looping_sound_aliases = {}

for i = 1, #looping_sound_aliases do
	local looping_sound_alias = looping_sound_aliases[i]
	local component_name = PlayerUnitData.looping_sound_component_name(looping_sound_alias)

	husk_hud_data_component_config[component_name] = {
		"is_playing",
	}
end

return husk_hud_data_component_config
