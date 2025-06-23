-- chunkname: @scripts/ui/hud/elements/wield_info/wield_info_passives_templates.lua

local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local SLOT_DEVICE_NAME = "slot_device"
local wield_info_passives_templates = {
	{
		name = "wield_scanner",
		input_descriptions = {
			{
				description = "loc_auspex_input_description_scan_wield_scanner",
				input_action = "wield_5",
				icon_width = 84,
				icon_height = 84,
				icon = "content/ui/materials/icons/pocketables/hud/auspex_scanner",
				icon_color = Color.terminal_text_body(255, true)
			}
		},
		validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
			local player_unit = player.player_unit
			local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

			if not unit_data_extension then
				return false
			end

			local inventory_component = unit_data_extension:read_component("inventory")
			local wielded_slot = inventory_component.wielded_slot

			if wielded_slot == SLOT_DEVICE_NAME then
				return false
			end

			local visual_loadout_extension = ScriptUnit.has_extension(player_unit, "visual_loadout_system")
			local weapon_item = visual_loadout_extension and visual_loadout_extension:item_in_slot(SLOT_DEVICE_NAME)
			local weapon_template = weapon_item and WeaponTemplate.weapon_template_from_item(weapon_item)

			if not weapon_template then
				return false
			end

			local not_player_wieldable = weapon_template.not_player_wieldable

			if not_player_wieldable then
				return false
			end

			return true
		end
	}
}

return wield_info_passives_templates
