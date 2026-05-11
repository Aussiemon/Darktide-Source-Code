-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_skulls_guns_full.lua

require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_skulls")

local LevelProps = require("scripts/settings/level_prop/level_props")
local MutatorGameplayLiveEventSkullsGunsFull = class("MutatorGameplayLiveEventSkullsGunsFull", "MutatorGameplayLiveEventSkulls")

MutatorGameplayLiveEventSkullsGunsFull.init = function (self, owner, settings, triggered_by_level)
	MutatorGameplayLiveEventSkullsGunsFull.super.init(self, owner, settings, triggered_by_level)

	if not self._is_server then
		return
	end

	self._horde_pacing_per_skull = Managers.state.difficulty:get_table_entry_by_resistance(self._settings.horde_pacing_per_skull)
	self._min_auto_event_duration = self._settings.min_auto_event_duration
	self._active_auto_events = {}
	self._spawned_servo_skulls = {}
	self._servo_skulls_recovered = 0

	Managers.state.pacing:set_auto_event_template("live_event_skulls_guns_auto_event_template")
	Managers.event:register(self, "event_skulls_totem_damaged", "_on_event_skulls_totem_damaged")
	Managers.event:register(self, "event_skulls_totem_shattered", "_on_event_skulls_totem_shattered")
	Managers.event:register(self, "event_on_interaction_success", "_on_event_on_interaction_success")
	Managers.event:register(self, "mission_buffs_event_player_spawned", "_on_event_mission_buffs_event_player_spawned")
end

MutatorGameplayLiveEventSkullsGunsFull.destroy = function (self)
	Managers.event:unregister(self, "event_skulls_totem_damaged")
	Managers.event:unregister(self, "event_skulls_totem_shattered")
	Managers.event:unregister(self, "event_on_interaction_success")
	Managers.event:unregister(self, "mission_buffs_event_player_spawned")

	for _, auto_event_data in pairs(self._active_auto_events) do
		Managers.state.pacing:request_auto_event_end(auto_event_data.auto_event_id)
	end

	self._active_auto_events = {}

	Managers.state.pacing:restore_auto_event_template()
	MutatorGameplayLiveEventSkullsGunsFull.super.destroy(self)
end

local function _distance(start_unit, end_unit)
	local start_position = Unit.world_position(start_unit, 1)
	local end_position = Unit.world_position(end_unit, 1)

	return Vector3.distance(start_position, end_position)
end

MutatorGameplayLiveEventSkullsGunsFull.closest_alive_player_to_unit = function (self, unit)
	local player_manager = Managers.player
	local players = player_manager:players()
	local tracked_units = {}

	for unique_id, player in pairs(players) do
		if player:unit_is_alive() then
			tracked_units[#tracked_units + 1] = player.player_unit
		end
	end

	local lowest_distance = math.huge
	local player

	for i = 1, #tracked_units do
		local distance = _distance(tracked_units[i], unit)

		if distance < lowest_distance then
			lowest_distance = distance
			player = tracked_units[i]
		end
	end

	return player
end

MutatorGameplayLiveEventSkullsGunsFull._on_event_skulls_totem_damaged = function (self, unit)
	local position = Unit.world_position(unit, 1) or Vector3(0, 0, 0)
	local auto_event_context = {
		composition = "default",
		inject_captain = false,
		inject_monster = false,
		inject_twin = false,
		intial_cooldown_multiplier_value = 0,
		size = "default",
		worldposition = position,
		node_id = math.uuid(),
	}
	local auto_event_data = self._active_auto_events[unit]

	if auto_event_data then
		Managers.state.pacing:request_auto_event_end(auto_event_data.auto_event_id)
	end

	local auto_event_id = Managers.state.pacing:request_auto_event(auto_event_context)

	self._active_auto_events[unit] = {
		duration = self._min_auto_event_duration,
		auto_event_id = auto_event_id,
	}

	self:show_objective_popup_notification("event_start")
end

MutatorGameplayLiveEventSkullsGunsFull.update = function (self, dt, t)
	MutatorGameplayLiveEventSkullsGunsFull.super.update(self, dt, t)

	for unit, auto_event_data in pairs(self._active_auto_events) do
		auto_event_data.duration = auto_event_data.duration - dt

		if auto_event_data.duration < 0 and not HEALTH_ALIVE[unit] then
			Managers.state.pacing:request_auto_event_end(auto_event_data.auto_event_id)

			self._active_auto_events[unit] = nil
		end
	end
end

MutatorGameplayLiveEventSkullsGunsFull._on_event_skulls_totem_stage_01 = function (self, unit)
	return
end

MutatorGameplayLiveEventSkullsGunsFull._on_event_skulls_totem_shattered = function (self, unit)
	local auto_event_data = self._active_auto_events[unit]

	if auto_event_data and auto_event_data.duration < 0 then
		Managers.state.pacing:request_auto_event_end(auto_event_data.auto_event_id)

		self._active_auto_events[unit] = nil
	end

	local closest_player = self:closest_alive_player_to_unit(unit)
	local rotation = Quaternion.identity()

	if closest_player then
		local player_world_pos = Unit.world_position(closest_player, 1)
		local totem_world_pos = Unit.world_position(unit, 1)

		Vector3.set_z(player_world_pos, totem_world_pos.z)

		rotation = Quaternion.look(Vector3.subtract(totem_world_pos, player_world_pos), Vector3.up())
		rotation = Quaternion.multiply(rotation, Quaternion.axis_angle(Vector3.up(), math.pi))
	end

	local unit_instance, game_object_id = Managers.state.unit_spawner:spawn_network_unit("content/levels/live_events/skulls_guns/event_interactable_servo_skull", "level_prop", Vector3.add(Unit.world_position(unit, 1), Vector3.multiply(Vector3.up(), 1.75)), rotation, nil, LevelProps.le_skulls_guns_skull_prop)

	self._spawned_servo_skulls[unit_instance] = game_object_id
end

MutatorGameplayLiveEventSkullsGunsFull._has_interactable_unit_in_spawns = function (self, unit)
	for skull_unit, _ in pairs(self._spawned_servo_skulls) do
		if skull_unit == unit then
			return true
		end
	end

	return false
end

MutatorGameplayLiveEventSkullsGunsFull._on_event_on_interaction_success = function (self, unit, _)
	if not self._is_server then
		return
	end

	if not self:_has_interactable_unit_in_spawns(unit) then
		return
	end

	self._servo_skulls_recovered = self._servo_skulls_recovered + 1

	local players = Managers.player:players()

	for _, connected_player in pairs(players) do
		Managers.event:trigger("mission_buffs_event_add_externally_controlled_to_player", connected_player, "live_event_skull_guns_coherency_buff")
	end

	self._owner.scratchpad.events_completed = (self._owner.scratchpad.events_completed or 0) + 1

	local idx = self._owner.scratchpad.events_completed
	local pacing_modifier = {}

	for k, v in pairs(self._horde_pacing_per_skull) do
		pacing_modifier[k] = v[math.clamp(idx, 1, #v)]
	end

	Managers.state.pacing:add_pacing_modifiers(pacing_modifier)
	Managers.stats:record_team("hook_live_event_skulls_guns_recovered", 1)
	self:show_objective_popup_notification("event_end")
end

MutatorGameplayLiveEventSkullsGunsFull._on_event_mission_buffs_event_player_spawned = function (self, player, is_respawn, unit)
	if is_respawn then
		return
	end

	for i = 1, self._servo_skulls_recovered do
		Managers.event:trigger("mission_buffs_event_add_externally_controlled_to_player", player, "live_event_skull_guns_coherency_buff")
	end
end

return MutatorGameplayLiveEventSkullsGunsFull
