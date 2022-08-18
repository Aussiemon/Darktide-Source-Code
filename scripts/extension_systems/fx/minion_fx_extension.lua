local Effect = require("scripts/extension_systems/fx/utilities/effect")
local LineEffects = require("scripts/settings/effects/line_effects")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local MinionFxExtension = class("MinionFxExtension")
local CLIENT_RPCS = {
	"rpc_trigger_minion_inventory_wwise_event",
	"rpc_trigger_minion_inventory_vfx",
	"rpc_trigger_minion_fx_line"
}

MinionFxExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local is_server = extension_init_context.is_server
	self._is_server = is_server
	self._world = extension_init_context.world
	self._wwise_world = extension_init_context.wwise_world

	if not is_server then
		local network_event_delegate = extension_init_context.network_event_delegate
		self._network_event_delegate = network_event_delegate
		self._game_object_id = nil_or_game_object_id

		network_event_delegate:register_session_unit_events(self, nil_or_game_object_id, unpack(CLIENT_RPCS))
	end
end

MinionFxExtension.extensions_ready = function (self, world, unit)
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
end

MinionFxExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
end

MinionFxExtension.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))
	end
end

MinionFxExtension.should_play_husk_effect = function (self)
	return true
end

MinionFxExtension.trigger_inventory_wwise_event = function (self, event_name, inventory_slot_name, fx_source_name, optional_target_unit, optional_is_ranged_attack)
	fassert(self._is_server, "[MinionFxExtension] Only server is allowed to call this function.")

	local is_ranged_attack = optional_is_ranged_attack ~= nil and optional_is_ranged_attack

	self:_trigger_inventory_wwise_event(event_name, inventory_slot_name, fx_source_name, optional_target_unit, is_ranged_attack)

	local game_object_id = self._game_object_id
	local optional_target_unit_id = Managers.state.unit_spawner:game_object_id(optional_target_unit)
	local event_id = NetworkLookup.sound_events[event_name]
	local inventory_slot_id = NetworkLookup.minion_inventory_slot_names[inventory_slot_name]
	local fx_source_name_id = NetworkLookup.minion_fx_source_names[fx_source_name]

	Managers.state.game_session:send_rpc_clients("rpc_trigger_minion_inventory_wwise_event", game_object_id, event_id, inventory_slot_id, fx_source_name_id, optional_target_unit_id, is_ranged_attack)
end

MinionFxExtension._trigger_inventory_wwise_event = function (self, event_name, inventory_slot_name, fx_source_name, optional_target_unit, is_ranged_attack)
	local visual_loadout_extension = self._visual_loadout_extension
	local wwise_world = self._wwise_world
	local inventory_item = visual_loadout_extension:slot_item(inventory_slot_name)
	local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, fx_source_name)
	local auto_source_id = WwiseWorld.make_auto_source(wwise_world, attachment_unit, node)

	if is_ranged_attack then
		Effect.update_targeted_by_ranged_minion_wwise_parameters(optional_target_unit, wwise_world, auto_source_id)
	end

	WwiseWorld.trigger_resource_event(wwise_world, event_name, auto_source_id)
end

MinionFxExtension.trigger_inventory_vfx = function (self, vfx_name, inventory_slot_name, fx_source_name)
	fassert(self._is_server, "[MinionFxExtension] Only server is allowed to call this function.")
	self:_trigger_inventory_vfx(vfx_name, inventory_slot_name, fx_source_name)

	local game_object_id = self._game_object_id
	local vfx_id = NetworkLookup.vfx[vfx_name]
	local inventory_slot_id = NetworkLookup.minion_inventory_slot_names[inventory_slot_name]
	local fx_source_name_id = NetworkLookup.minion_fx_source_names[fx_source_name]

	Managers.state.game_session:send_rpc_clients("rpc_trigger_minion_inventory_vfx", game_object_id, vfx_id, inventory_slot_id, fx_source_name_id)
end

local ORPHANED_POLICY = "stop"

MinionFxExtension._trigger_inventory_vfx = function (self, vfx_name, inventory_slot_name, fx_source_name)
	local visual_loadout_extension = self._visual_loadout_extension
	local world = self._world
	local inventory_item = visual_loadout_extension:slot_item(inventory_slot_name)
	local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, fx_source_name)
	local position = Vector3.zero()
	local pose = Matrix4x4.identity()
	local particle_id = World.create_particles(world, vfx_name, position)

	World.link_particles(world, particle_id, attachment_unit, node, pose, ORPHANED_POLICY)
end

MinionFxExtension.rpc_trigger_minion_inventory_wwise_event = function (self, channel_id, go_id, event_id, inventory_slot_id, fx_source_name_id, optional_target_unit_id, optional_is_ranged_attack)
	local event_name = NetworkLookup.sound_events[event_id]
	local inventory_slot_name = NetworkLookup.minion_inventory_slot_names[inventory_slot_id]
	local fx_source_name = NetworkLookup.minion_fx_source_names[fx_source_name_id]
	local optional_target_unit = Managers.state.unit_spawner:unit(optional_target_unit_id)

	self:_trigger_inventory_wwise_event(event_name, inventory_slot_name, fx_source_name, optional_target_unit, optional_is_ranged_attack)
end

MinionFxExtension.rpc_trigger_minion_inventory_vfx = function (self, channel_id, go_id, vfx_id, inventory_slot_id, fx_source_name_id)
	local vfx_name = NetworkLookup.vfx[vfx_id]
	local inventory_slot_name = NetworkLookup.minion_inventory_slot_names[inventory_slot_id]
	local fx_source_name = NetworkLookup.minion_fx_source_names[fx_source_name_id]

	self:_trigger_inventory_vfx(vfx_name, inventory_slot_name, fx_source_name)
end

MinionFxExtension.trigger_unit_line_fx = function (self, line_effect, inventory_slot_name, fx_source_name, end_position)
	local particle_id = self:_trigger_unit_line_fx(line_effect, inventory_slot_name, fx_source_name, end_position)

	if self._is_server then
		local game_object_id = self._game_object_id

		Managers.state.game_session:send_rpc_clients("rpc_trigger_minion_fx_line", game_object_id, NetworkLookup.line_effects[line_effect.name], NetworkLookup.minion_inventory_slot_names[inventory_slot_name], NetworkLookup.minion_fx_source_names[fx_source_name], end_position)
	end

	return particle_id
end

local MAX_EMITTERS = 100

MinionFxExtension._trigger_unit_line_fx = function (self, line_effect, inventory_slot_name, fx_source_name, end_position)
	local visual_loadout_extension = self._visual_loadout_extension
	local world = self._world
	local inventory_item = visual_loadout_extension:slot_item(inventory_slot_name)
	local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, fx_source_name)
	local spawner_pose = Unit.world_pose(attachment_unit, node)
	local spawner_position = Matrix4x4.translation(spawner_pose)
	local line = end_position - spawner_position
	local line_direction = Vector3.normalize(line)
	local line_rotation = Quaternion.look(line_direction)
	local line_length = Vector3.length(line)
	local vfx = line_effect.vfx

	if vfx then
		local particle_id = World.create_particles(world, vfx, spawner_position, line_rotation)
		local variable_index = World.find_particles_variable(world, vfx, "hit_distance")

		World.set_particles_variable(world, particle_id, variable_index, Vector3(0.1, line_length, line_length))
	end

	local emitters = line_effect.emitters

	if emitters then
		local emitter_effect_name = emitters.vfx.default
		local start_emitter_effect_name = emitters.vfx.start or emitter_effect_name
		local interval = emitters.interval
		local distance = interval.distance
		local increase = interval.increase
		local emitter_distance = 0
		local num_emitters = 0
		local spawn_emitters = true

		while spawn_emitters do
			local new_emitter_distance = emitter_distance + distance * math.pow(1 + increase, num_emitters)

			if line_length < new_emitter_distance + 1 or MAX_EMITTERS <= num_emitters then
				spawn_emitters = false
			else
				local spawn_pos = spawner_position + line_direction * new_emitter_distance
				local chosen_effect_name = num_emitters == 0 and start_emitter_effect_name or emitter_effect_name

				World.create_particles(self._world, chosen_effect_name, spawn_pos, line_rotation)

				emitter_distance = new_emitter_distance
				num_emitters = num_emitters + 1
			end
		end
	end

	local sfx = line_effect.sfx

	if sfx then
		self:_trigger_wwise_event_on_line(sfx, spawner_position, end_position)
	end
end

local function _closest_point_on_line(player_position, start_position, end_position)
	local closest_point = Geometry.closest_point_on_line(player_position, start_position, end_position)

	return closest_point
end

MinionFxExtension._trigger_wwise_event_on_line = function (self, event_name, start_position, end_position, append_husk_to_event_name)
	local player = Managers.player:local_player(1)

	if player then
		local camera_position = Managers.state.camera:camera_position(player.viewport_name)
		local sound_position = _closest_point_on_line(camera_position, start_position, end_position)
		local rotation = Quaternion.look(end_position - start_position)

		WwiseWorld.trigger_resource_event(self._wwise_world, event_name, sound_position, rotation)
	end
end

MinionFxExtension.rpc_trigger_minion_fx_line = function (self, channel_id, game_object_id, line_effect_id, inventory_slot_name_id, fx_source_name_id, end_position)
	local line_effect_name = NetworkLookup.line_effects[line_effect_id]
	local line_effect = LineEffects[line_effect_name]
	local inventory_slot_name = NetworkLookup.minion_inventory_slot_names[inventory_slot_name_id]
	local fx_source_name = NetworkLookup.minion_fx_source_names[fx_source_name_id]

	self:_trigger_unit_line_fx(line_effect, inventory_slot_name, fx_source_name, end_position)
end

return MinionFxExtension
