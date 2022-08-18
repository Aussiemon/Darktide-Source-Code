local PlayerSpecialization = require("scripts/utilities/player_specialization/player_specialization")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local WarpCharge = require("scripts/utilities/warp_charge")
local RPCS = {
	"rpc_update_talents"
}
local PlayerHuskSpecializationExtension = class("PlayerHuskSpecializationExtension")

PlayerHuskSpecializationExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	local player = extension_init_data.player
	self._player = player
	self._world = extension_init_context.world
	self._wwise_world = extension_init_context.wwise_world
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local first_person_unit = first_person_extension:first_person_unit()
	self._first_person_unit = first_person_unit
	self._is_local_unit = extension_init_data.is_local_unit
	local peer_id = player:peer_id()
	self._channel_id = Managers.state.game_session:peer_to_channel(peer_id)
	self._game_object_id = Managers.state.unit_spawner:game_object_id(self._unit)
	local archetype = extension_init_data.archetype
	local specialization_name = extension_init_data.specialization_name
	local talents = extension_init_data.talents
	self._archetype = archetype
	self._specialization_name = specialization_name
	self._talents = talents
	self._initialized_fixed_frame_t = extension_init_context.fixed_frame_t
	self._game_object_id = Managers.state.unit_spawner:game_object_id(self._unit)
	self._network_event_delegate = extension_init_context.network_event_delegate

	self._network_event_delegate:register_session_unit_events(self, self._game_object_id, unpack(RPCS))

	self._active_special_rules = {}

	self:_init_components()
end

PlayerHuskSpecializationExtension._init_components = function (self)
	if self._is_local_unit then
		local unit_data_extension = ScriptUnit.extension(self._unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")
		local specialization_resource_component = unit_data_extension:write_component("specialization_resource")
		warp_charge_component.state = "idle"
		warp_charge_component.last_charge_at_t = 0
		warp_charge_component.remove_at_t = 0
		warp_charge_component.current_percentage = 0
		warp_charge_component.starting_percentage = 0
		warp_charge_component.ramping_modifier = 0
		specialization_resource_component.current_resource = 0
		specialization_resource_component.max_resource = 0
		self._fx_extension = ScriptUnit.extension(self._unit, "fx_system")
		self._warp_charge_component = warp_charge_component
		self._unit_data_extension = unit_data_extension
	end
end

PlayerHuskSpecializationExtension.extensions_ready = function (self, world, unit)
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")

	self:_update_specialization_and_talents(self._specialization_name, self._talents)
end

PlayerHuskSpecializationExtension.update = function (self, unit, dt, t)
	return
end

PlayerHuskSpecializationExtension.fixed_update = function (self, unit, dt, t, fixed_frame, context, ...)
	local local_player = Managers.player:local_player(1)
	local camera_handler = local_player.camera_handler
	local is_observing = camera_handler and camera_handler:is_observing()
	local player = self._player
	local first_person_unit = self._first_person_unit
	local is_local_unit = self._is_local_unit
	local warp_charge_component = self._warp_charge_component
	local world = self._world

	if not is_observing and is_local_unit then
		WarpCharge.update(dt, t, warp_charge_component, player, unit, first_person_unit, is_local_unit, world)
	elseif is_observing and not is_local_unit then
		local follow_unit = camera_handler:camera_follow_unit()

		WarpCharge.update_observer(dt, t, player, unit, first_person_unit, world, follow_unit)
	end
end

PlayerHuskSpecializationExtension.destroy = function (self)
	self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(RPCS))
end

PlayerHuskSpecializationExtension.get_specialization_name = function (self)
	return self._specialization_name
end

PlayerHuskSpecializationExtension.has_special_rule = function (self, special_rule_name)
	local active_special_rules = self._active_special_rules

	return active_special_rules[special_rule_name]
end

PlayerHuskSpecializationExtension._update_specialization_and_talents = function (self, specialization_name, talents)
	self._specialization_name = specialization_name
	self._talents = talents
	local _, special_rules = nil

	if Managers.state.game_mode:specializations_disabled() then
		special_rules = {}
	else
		_, _, _, _, special_rules = PlayerSpecialization.from_selected_talents(self._archetype, specialization_name, talents)
	end

	local active_special_rules = self._active_special_rules

	table.clear(self._active_special_rules)

	for _, special_rule_name in pairs(special_rules) do
		active_special_rules[special_rule_name] = true
	end
end

local temp_talent_name_set = {}

PlayerHuskSpecializationExtension.rpc_update_talents = function (self, channel_id, unit_id, specialization_name_id, talent_id_array)
	local specialization_name = NetworkLookup.archetype_specialization_names[specialization_name_id]

	table.clear(temp_talent_name_set)

	for i = 1, #talent_id_array, 1 do
		local talent_name_id = talent_id_array[i]
		local talent_name = NetworkLookup.archetype_talent_names[talent_name_id]
		temp_talent_name_set[talent_name] = true
	end

	self:_update_specialization_and_talents(specialization_name, temp_talent_name_set)
end

return PlayerHuskSpecializationExtension
