-- chunkname: @scripts/ui/hud/elements/wield_info/wield_info_passives_templates.lua

local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local SLOT_DEVICE_NAME = "slot_device"
local SLOT_POCKETABLE_NAME = "slot_pocketable"
local EXPEDITION_GAME_MODE_NAME = "expedition"
local expedition_disallowed_weapon_templates = table.set({
	"expedition_grenade_airstrike_pocketable",
	"motion_detection_mine_fire_pocketable",
	"motion_detection_mine_shock_pocketable",
	"motion_detection_mine_explosive_pocketable",
	"expedition_grenade_artillery_strike_pocketable",
	"expedition_grenade_valkyrie_hover_pocketable",
	"expedition_explosive_luggable_01",
})
local wield_info_passives_templates = {
	{
		name = "expedition_wield_auspex",
		input_descriptions = {
			{
				description = "loc_auspex_input_description_scan_wield_scanner",
				icon = "content/ui/materials/icons/pocketables/hud/auspex_scanner",
				icon_height = 84,
				icon_width = 84,
				input_action = "wield_5",
				icon_color = Color.terminal_text_body(255, true),
			},
		},
		validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
			local game_mode_manager = Managers.state.game_mode

			if game_mode_manager:game_mode_name() == EXPEDITION_GAME_MODE_NAME then
				local save_manager = Managers.save
				local save_data = save_manager:account_data()

				if save_data and save_data.expedition_auspex_map_wielded then
					return false
				end

				local player_unit = player.player_unit
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

			return false
		end,
	},
	{
		name = "in_expedition_safe_zone",
		input_descriptions = {
			{
				description = "loc_expedition_not_allowed_in_safe_zone",
				icon = "content/ui/materials/icons/hud/not_allowed",
				icon_height = 90,
				icon_width = 90,
				text_color = Color.ui_interaction_critical(255, true),
				icon_color = Color.ui_interaction_critical(255, true),
			},
		},
		validation_function = function (wielded_slot_id, item, current_action, current_action_name, player)
			local game_mode_manager = Managers.state.game_mode
			local game_mode = game_mode_manager:game_mode()

			if game_mode.in_safe_zone and game_mode:in_safe_zone() then
				local player_unit = player.player_unit
				local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

				if not unit_data_extension then
					return false
				end

				local inventory_component = unit_data_extension:read_component("inventory")
				local wielded_slot = inventory_component.wielded_slot

				if wielded_slot ~= SLOT_POCKETABLE_NAME then
					return false
				end

				local visual_loadout_extension = ScriptUnit.has_extension(player_unit, "visual_loadout_system")
				local weapon_item = visual_loadout_extension and visual_loadout_extension:item_in_slot(SLOT_POCKETABLE_NAME)
				local weapon_template = weapon_item and WeaponTemplate.weapon_template_from_item(weapon_item)

				if weapon_template and expedition_disallowed_weapon_templates[weapon_template.name] then
					return true
				end
			end

			return false
		end,
	},
	{
		name = "wield_scanner",
		input_descriptions = {
			{
				description = "loc_auspex_input_description_scan_wield_scanner",
				icon = "content/ui/materials/icons/pocketables/hud/auspex_scanner",
				icon_height = 84,
				icon_width = 84,
				input_action = "wield_5",
				icon_color = Color.terminal_text_body(255, true),
			},
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

			local is_not_auspex = weapon_template.name ~= "auspex_scanner"

			if is_not_auspex then
				return false
			end

			return true
		end,
	},
}

return wield_info_passives_templates
