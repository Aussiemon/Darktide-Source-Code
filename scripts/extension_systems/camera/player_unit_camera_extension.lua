-- chunkname: @scripts/extension_systems/camera/player_unit_camera_extension.lua

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitCameraExtension = class("PlayerUnitCameraExtension")

PlayerUnitCameraExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._unit = unit
	self._use_third_person_hub_camera = not not extension_init_data.use_third_person_hub_camera
	self._breed = extension_init_data.breed

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._assisted_state_input_component = unit_data_extension:read_component("assisted_state_input")
	self._character_state_component = unit_data_extension:read_component("character_state")
	self._disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
	self._sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
	self._weapon_lock_view_component = unit_data_extension:read_component("weapon_lock_view")
	self._scanning_component = unit_data_extension:read_component("scanning")
	self._camera_tree_component = unit_data_extension:write_component("camera_tree")

	self:_evaluate_camera_tree()

	self._is_local_unit = extension_init_data.is_local_unit
	self._is_server = extension_init_context.is_server
end

PlayerUnitCameraExtension.fixed_update = function (self, unit, dt, t)
	self:_evaluate_camera_tree()
end

local NODE_IGNORE_SCALED_TRANSFORM_OFFSETS = {
	consumed = true
}
local NODE_OBJECT_NAMES = {
	consumed = "j_hips"
}

PlayerUnitCameraExtension._evaluate_camera_tree = function (self)
	local wants_first_person_camera = self._first_person_extension:wants_first_person_camera()
	local character_state_component = self._character_state_component
	local assisted_state_input_component = self._assisted_state_input_component
	local sprint_character_state_component = self._sprint_character_state_component
	local disabling_type = self._disabled_character_state_component.disabling_type
	local is_ledge_hanging = PlayerUnitStatus.is_ledge_hanging(character_state_component)
	local is_assisted = PlayerUnitStatus.is_assisted(assisted_state_input_component)
	local is_pounced = disabling_type == "pounced"
	local is_netted = disabling_type == "netted"
	local is_warp_grabbed = disabling_type == "warp_grabbed"
	local is_mutant_charged = disabling_type == "mutant_charged"
	local is_grabbed = disabling_type == "grabbed"
	local is_consumed = disabling_type == "consumed"
	local tree, node

	if wants_first_person_camera then
		local alternate_fire_is_active = self._alternate_fire_component.is_active
		local wants_sprint_camera = sprint_character_state_component.wants_sprint_camera
		local sprint_overtime = sprint_character_state_component.sprint_overtime
		local have_sprint_over_time = sprint_overtime and sprint_overtime > 0
		local is_lunging = self._lunge_character_state_component.is_lunging

		node = is_assisted and "first_person_assisted" or alternate_fire_is_active and "aim_down_sight" or wants_sprint_camera and have_sprint_over_time and "sprint_overtime" or wants_sprint_camera and "sprint" or is_lunging and "lunge" or "first_person"
		tree = "first_person"
	elseif self._use_third_person_hub_camera then
		tree = "third_person_hub"

		if self._breed.name == "ogryn" then
			node = "third_person_ogryn"
		else
			node = "third_person_human"
		end
	else
		local is_disabled, requires_help = PlayerUnitStatus.is_disabled(character_state_component)
		local is_hogtied = PlayerUnitStatus.is_hogtied(character_state_component)

		node = is_hogtied and "hogtied" or is_ledge_hanging and "ledge_hanging" or is_grabbed and "grabbed" or not (not is_pounced and not is_netted and not is_warp_grabbed and not is_mutant_charged and not is_grabbed) and "pounced" or is_consumed and "consumed" or is_disabled and requires_help and "disabled" or "third_person"
		tree = "third_person"
	end

	local camera_tree_component = self._camera_tree_component

	camera_tree_component.tree = tree
	camera_tree_component.node = node
	self._tree = tree
	self._node = node

	local object_name = NODE_OBJECT_NAMES[node]
	local object

	if object_name then
		object = Unit.node(self._unit, object_name)
	end

	self._object = object

	local ignore_offset = NODE_IGNORE_SCALED_TRANSFORM_OFFSETS[node]

	if self._ignore_offset ~= ignore_offset then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(self._unit)

		if player:is_human_controlled() then
			local viewport_name = player.viewport_name

			if viewport_name then
				Managers.state.camera:set_variable(viewport_name, "ignore_offset", ignore_offset)
			end
		end
	end

	self._ignore_offset = ignore_offset
end

PlayerUnitCameraExtension.using_third_person_hub_camera = function (self)
	return self._use_third_person_hub_camera
end

PlayerUnitCameraExtension.camera_tree_node = function (self)
	return self._tree, self._node, self._object, self._ignore_offset
end

PlayerUnitCameraExtension.trigger_camera_shake = function (self, event_name, optional_will_be_predicted)
	local is_in_first_person_mode = self._first_person_extension:is_in_first_person_mode()

	if is_in_first_person_mode then
		Managers.state.camera:camera_effect_shake_event(event_name)
	end

	if self._is_server then
		local unit = self._unit
		local event_name_id = NetworkLookup.camera_shake_events[event_name]
		local unit_id = Managers.state.unit_spawner:game_object_id(unit)

		if optional_will_be_predicted then
			local player_unit_spawn_manager = Managers.state.player_unit_spawn
			local predicting_player = player_unit_spawn_manager:owner(unit)
			local except = predicting_player:channel_id()

			Managers.state.game_session:send_rpc_clients_except("rpc_player_trigger_camera_shake", except, unit_id, event_name_id)
		else
			Managers.state.game_session:send_rpc_clients("rpc_player_trigger_camera_shake", unit_id, event_name_id)
		end
	end
end

return PlayerUnitCameraExtension
