require("scripts/extension_systems/weapon/actions/action_weapon_base")

local AimPlaceUtil = require("scripts/extension_systems/weapon/actions/utilities/aim_place_util")
local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ActionPlaceBase = class("ActionPlaceBase", "ActionWeaponBase")

ActionPlaceBase.init = function (self, action_context, ...)
	ActionPlaceBase.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._action_component = unit_data_extension:write_component("action_place")
	self._weapon_system = Managers.state.extension:system("weapon_system")
end

ActionPlaceBase.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionPlaceBase.super.start(self, action_settings, t, time_scale, action_start_params)

	local can_place, position, rotation, placed_on_unit = self:_get_placement_data()
	local action_component = self._action_component
	action_component.can_place = can_place
	action_component.position = position
	action_component.rotation = rotation
	action_component.placed_on_unit = placed_on_unit
end

ActionPlaceBase.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local inventory_component = self._inventory_component
	local wielded_slot = inventory_component.wielded_slot
	local player_unit = self._player_unit
	local can_place, position, rotation, placed_on_unit = self:_get_placement_data_from_component()

	if not can_place then
		local cancel_anim_1p = action_settings.anim_cancel_event
		local cancel_anim_3p = action_settings.anim_cancel_event_3p or cancel_anim_1p

		if cancel_anim_1p then
			self:trigger_anim_event(cancel_anim_1p, cancel_anim_3p)
		end

		return true
	end

	local finish_time = action_settings.total_time
	local place_time = action_settings.place_time or finish_time
	local time_scale = self._weapon_action_component.time_scale
	local is_in_placement_time = ActionUtility.is_within_trigger_time(time_in_action, dt, place_time / time_scale)

	if is_in_placement_time then
		if action_settings.remove_item_from_inventory then
			PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, player_unit, t)
			PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, wielded_slot, t)
		end

		if self._is_server then
			self:_place_unit(action_settings, position, rotation, placed_on_unit)
		end
	end

	local unwield_slot = action_settings.unwield_slot
	local is_last_fixed_frame = time_in_action >= finish_time / time_scale

	if is_last_fixed_frame and unwield_slot then
		PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, player_unit, t)
	end
end

ActionPlaceBase._place_unit = function (self, action_settings, position, rotation, placed_on_unit)
	ferror("ActionPlaceBase is using base implementation of _place_unit, it shouldn't")
end

ActionPlaceBase._get_placement_data = function (self)
	local action_settings = self._action_settings
	local use_aim_data = action_settings.use_aim_data

	if use_aim_data then
		return self:_get_placement_data_from_component()
	else
		return self:_calculate_placement_data()
	end
end

ActionPlaceBase._get_placement_data_from_component = function (self)
	local action_component = self._action_component
	local can_place = action_component.can_place
	local position = action_component.position
	local rotation = action_component.rotation
	local placed_on_unit = action_component.placed_on_unit

	return can_place, position, rotation, placed_on_unit
end

ActionPlaceBase._calculate_placement_data = function (self)
	local first_person_component = self._first_person_component
	local place_configuration = self._action_settings.place_configuration
	local physics_world = self._physics_world
	local can_place, position, rotation, placed_on_unit = AimPlaceUtil.aim_placement(physics_world, place_configuration, first_person_component)

	return can_place, position, rotation, placed_on_unit
end

ActionPlaceBase._register_stats_and_telemetry = function (self, item_name, player_or_nil)
	Managers.telemetry_reporters:reporter("placed_items"):register_event(player_or_nil, item_name)

	if player_or_nil then
		Managers.stats:record_private("hook_placed_item", player_or_nil, item_name)
	end
end

return ActionPlaceBase
