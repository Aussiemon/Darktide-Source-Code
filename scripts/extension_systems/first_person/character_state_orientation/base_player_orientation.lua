-- chunkname: @scripts/extension_systems/first_person/character_state_orientation/base_player_orientation.lua

local InputDevice = require("scripts/managers/input/input_device")
local SweepStickyness = require("scripts/utilities/action/sweep_stickyness")
local BasePlayerOrientation = class("BasePlayerOrientation")

BasePlayerOrientation.init = function (self, player, orientation)
	local player_unit = player.player_unit
	local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")
	local first_person_extension = ScriptUnit.extension(player_unit, "first_person_system")

	self._player = player
	self._orientation = orientation
	self._first_person_unit = first_person_extension:first_person_unit()
	self._smart_targeting_extension = ScriptUnit.extension(player_unit, "smart_targeting_system")
	self._weapon_extension = ScriptUnit.extension(player_unit, "weapon_system")
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._aim_assist_ramp_component = unit_data_extension:read_component("aim_assist_ramp")
	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._force_look_rotation_component = unit_data_extension:read_component("force_look_rotation")
	self._locomotion_component = unit_data_extension:read_component("locomotion")
	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._recoil_component = unit_data_extension:read_component("recoil")
	self._recoil_control_component = unit_data_extension:read_component("recoil_control")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._weapon_lock_view_component = unit_data_extension:read_component("weapon_lock_view")
	self._lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
end

BasePlayerOrientation.destroy = function (self)
	self._player = nil
	self._orientation = nil
	self._first_person_unit = nil
	self._smart_targeting_extension = nil
	self._weapon_extension = nil
	self._action_sweep_component = nil
	self._aim_assist_ramp_component = nil
	self._alternate_fire_component = nil
	self._first_person_component = nil
	self._force_look_rotation_component = nil
	self._locomotion_component = nil
	self._movement_state_component = nil
	self._recoil_component = nil
	self._recoil_control_component = nil
	self._weapon_action_component = nil
	self._weapon_lock_view_component = nil
end

BasePlayerOrientation.pre_update = function (self)
	error("Don't call this on BasePlayerOrientation. Inherit this class and override :pre_update().")
end

BasePlayerOrientation.orientation = function (self)
	return self._orientation.yaw, self._orientation.pitch, self._orientation.roll
end

BasePlayerOrientation.orientation_offset = function (self)
	return 0, 0, 0
end

BasePlayerOrientation._fill_look_delta_context = function (self, context)
	table.clear(context)

	local action_sweep_component = self._action_sweep_component
	local alternate_fire_component = self._alternate_fire_component
	local lunge_character_state_component = self._lunge_character_state_component
	local weapon_action_component = self._weapon_action_component
	local smart_targeting_extension = self._smart_targeting_extension
	local targeting_data = smart_targeting_extension:targeting_data()
	local is_sticky = SweepStickyness.is_sticking_to_unit(action_sweep_component)
	local is_lunging = lunge_character_state_component and lunge_character_state_component.is_lunging

	context.targeting_data = targeting_data
	context.is_sticky = is_sticky
	context.is_lunging = is_lunging
	context.alternate_fire_component = alternate_fire_component
	context.weapon_action_component = weapon_action_component
end

local _aim_assist_context = {}

BasePlayerOrientation._aim_assist_context = function (self)
	local last_pressed_device = InputDevice.last_pressed_device
	local gamepad_active = last_pressed_device and last_pressed_device:type() == "xbox_controller"

	_aim_assist_context.input_device_wants_aim_assist = gamepad_active
	_aim_assist_context.targeting_data = self._smart_targeting_extension:targeting_data()
	_aim_assist_context.first_person_unit = self._first_person_unit

	local aim_assist_data = self._player.aim_assist_data
	local wants_lock_on = aim_assist_data.wants_lock_on

	_aim_assist_context.wants_lock_on = wants_lock_on

	if wants_lock_on then
		aim_assist_data.wants_lock_on = false
	end

	return _aim_assist_context
end

return BasePlayerOrientation
