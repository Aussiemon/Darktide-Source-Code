-- chunkname: @scripts/extension_systems/weapon/actions/action_give_pocketable.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local Pickups = require("scripts/settings/pickup/pickups")
local PlayerAssistNotifications = require("scripts/utilities/player_assist_notifications")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Pocketable = require("scripts/utilities/pocketable")
local Vo = require("scripts/utilities/vo")
local ActionGivePocketable = class("ActionGivePocketable", "ActionWeaponBase")
local RECIEVE_GIFTED_ITEM_ALIAS = "recieve_gifted_item"

ActionGivePocketable.init = function (self, action_context, action_params, action_setting)
	ActionGivePocketable.super.init(self, action_context, action_params, action_setting)

	self._input_extension = action_context.input_extension
	self._aim_ready_up_time = action_setting.aim_ready_up_time or 0
	self._last_unit = nil

	local unit_data_extension = self._unit_data_extension

	self._action_module_targeting_component = unit_data_extension:write_component("action_module_targeting")
end

ActionGivePocketable.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionGivePocketable.super.start(self, action_settings, t, time_scale, action_start_params)
end

local external_properties = {}

ActionGivePocketable.fixed_update = function (self, dt, t, time_in_action)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local target_unit = self._action_module_targeting_component.target_unit_1

	if target_unit then
		local action_settings = self._action_settings
		local inventory_component = self._inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local player_unit = self._player_unit
		local finish_time = action_settings.total_time
		local give_time = action_settings.give_time or finish_time
		local time_scale = self._weapon_action_component.time_scale
		local within_trigger_time = ActionUtility.is_within_trigger_time(time_in_action, dt, give_time / time_scale)

		if within_trigger_time then
			local pickup_name = self._weapon_template.give_pickup_name
			local pickup_data = Pickups.by_name[pickup_name]
			local inventory_item = Pocketable.item_from_name(pickup_data.inventory_item)
			local inventory_slot_name = pickup_data.inventory_slot_name

			if inventory_item then
				PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, player_unit, t)
				PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, wielded_slot, t)

				if self._is_server then
					local assist_notification_type = action_settings.assist_notification_type

					if assist_notification_type and ALIVE[target_unit] then
						PlayerAssistNotifications.show_notification(target_unit, self._player_unit, assist_notification_type)
					end

					PlayerUnitVisualLoadout.equip_item_to_slot(target_unit, inventory_item, inventory_slot_name, nil, t)
					table.clear(external_properties)

					external_properties.pocketable_name = pickup_name

					local fx_extension = ScriptUnit.extension(target_unit, "fx_system")

					fx_extension:trigger_exclusive_gear_wwise_event(RECIEVE_GIFTED_ITEM_ALIAS, external_properties)

					local voice_event_data = action_settings.voice_event_data

					if voice_event_data then
						Vo.on_demand_vo_event(player_unit, voice_event_data.voice_tag_concept, voice_event_data.voice_tag_id)
					end
				end
			end
		end
	end
end

ActionGivePocketable.finish = function (self, reason, data, t, time_in_action)
	ActionGivePocketable.super.finish(self, reason, data, t, time_in_action)

	self._action_module_targeting_component.target_unit_1 = nil
end

return ActionGivePocketable
