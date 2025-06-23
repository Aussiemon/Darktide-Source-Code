-- chunkname: @scripts/extension_systems/event_synchronizer/event_synchronizer_system.lua

require("scripts/extension_systems/event_synchronizer/event_synchronizer_base_extension")
require("scripts/extension_systems/event_synchronizer/decoder_synchronizer_extension")
require("scripts/extension_systems/event_synchronizer/demolition_synchronizer_extension")
require("scripts/extension_systems/event_synchronizer/kill_synchronizer_extension")
require("scripts/extension_systems/event_synchronizer/luggable_synchronizer_extension")
require("scripts/extension_systems/event_synchronizer/mission_objective_zone_synchronizer_extension")
require("scripts/extension_systems/event_synchronizer/side_mission_pickup_synchronizer_extension")
require("scripts/extension_systems/event_synchronizer/timed_synchronizer_extension")

local EventSynchronizerSystem = class("EventSynchronizerSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_event_synchronizer_started",
	"rpc_event_synchronizer_paused",
	"rpc_event_synchronizer_finished",
	"rpc_event_synchronizer_spline_travel_finished",
	"rpc_event_synchronizer_scanning_finished",
	"rpc_event_synchronizer_mission_objective_zone_follow_spline",
	"rpc_event_synchronizer_mission_objective_zone_at_end_of_spline",
	"rpc_event_synchronizer_distribute_seeds",
	"rpc_event_synchronizer_luggable_hide_luggable",
	"rpc_event_synchronizer_demolition_target_override"
}

EventSynchronizerSystem.init = function (self, context, system_init_data, ...)
	EventSynchronizerSystem.super.init(self, context, system_init_data, ...)

	self._network_event_delegate = context.network_event_delegate

	self._network_event_delegate:register_session_events(self, unpack(RPCS))

	self._mission_objective_zone_synchronizers = {}
	self._loaded_view = false
	self._scanner_display_view_requests = 0
end

EventSynchronizerSystem.load_scanner_view = function (self)
	self._scanner_display_view_requests = self._scanner_display_view_requests + 1

	if self._scanner_display_view_requests > 0 and not self._loaded_view and Managers.ui then
		Managers.ui:load_view("scanner_display_view", self.__class_name)

		self._loaded_view = true
	end
end

EventSynchronizerSystem.unload_scanner_view = function (self)
	self._scanner_display_view_requests = self._scanner_display_view_requests - 1

	if self._scanner_display_view_requests == 0 and self._loaded_view then
		Managers.ui:unload_view("scanner_display_view", self.__class_name)

		self._loaded_view = false
	end
end

EventSynchronizerSystem.on_gameplay_post_init = function (self, level)
	self:call_gameplay_post_init_on_extensions(level)
end

EventSynchronizerSystem.destroy = function (self)
	self._network_event_delegate:unregister_events(unpack(RPCS))
	EventSynchronizerSystem.super.destroy(self)
end

EventSynchronizerSystem.hot_join_sync = function (self, sender, channel)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		if extension.seeds then
			local setup_seed, seed = extension:seeds()
			local level_unit_id = Managers.state.unit_spawner:level_index(unit)

			if level_unit_id then
				RPC.rpc_event_synchronizer_distribute_seeds(channel, level_unit_id, setup_seed, seed)
			end
		end

		if extension.hot_join_sync then
			extension:hot_join_sync(sender, channel)
		end
	end
end

EventSynchronizerSystem.rpc_event_synchronizer_started = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	self._unit_to_extension_map[unit]:start_event()
end

EventSynchronizerSystem.rpc_event_synchronizer_paused = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	self._unit_to_extension_map[unit]:pause_event()
end

EventSynchronizerSystem.rpc_event_synchronizer_finished = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	self._unit_to_extension_map[unit]:finished_event()
end

EventSynchronizerSystem.rpc_event_synchronizer_spline_travel_finished = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	self._unit_to_extension_map[unit]:spline_travel_finished()
end

EventSynchronizerSystem.rpc_event_synchronizer_scanning_finished = function (self, channel_id, unit_id)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	self._unit_to_extension_map[unit]:scanning_finished()
end

EventSynchronizerSystem.rpc_event_synchronizer_mission_objective_zone_follow_spline = function (self, channel_id, level_unit_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local is_level_unit = true
	local synchronizer_unit = unit_spawner_manager:unit(level_unit_id, is_level_unit)

	self._unit_to_extension_map[synchronizer_unit]:follow_spline()
end

EventSynchronizerSystem.rpc_event_synchronizer_mission_objective_zone_at_end_of_spline = function (self, channel_id, level_unit_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local is_level_unit = true
	local synchronizer_unit = unit_spawner_manager:unit(level_unit_id, is_level_unit)

	self._unit_to_extension_map[synchronizer_unit]:at_end_of_spline()
end

EventSynchronizerSystem.rpc_event_synchronizer_distribute_seeds = function (self, channel_id, unit_id, setup_seed, seed)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	self._unit_to_extension_map[unit]:distribute_seeds(setup_seed, seed)
end

EventSynchronizerSystem.rpc_event_synchronizer_luggable_hide_luggable = function (self, channel_id, unit_id, luggable_unit_ids)
	local unit = Managers.state.unit_spawner:unit(unit_id, true)
	local is_luggable_level_unit = false

	for _, luggable_unit_id in ipairs(luggable_unit_ids) do
		local luggable_unit = Managers.state.unit_spawner:unit(luggable_unit_id, is_luggable_level_unit)

		self._unit_to_extension_map[unit]:hide_luggable(luggable_unit)
	end
end

EventSynchronizerSystem.rpc_event_synchronizer_demolition_target_override = function (self, channel_id, unit_id, override)
	local is_level_unit = true
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	self._unit_to_extension_map[unit]:set_override_objective_markers(override)
end

return EventSynchronizerSystem
