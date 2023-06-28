local PhysicsUnitProximitySystem = class("PhysicsUnitProximitySystem", "ExtensionSystemBase")
local MAX_AGE_MS = 1000
local FREQUENCY_MS = 32
local AFRO_TEMPLATE = "minion_afro"
local HITBOX_TEMPLATE = "minion_hit_box"
local AFRO_COLLISION_FILTER = "filter_physics_unit_proximity_system"

PhysicsUnitProximitySystem.init = function (self, extension_system_creation_context, ...)
	PhysicsUnitProximitySystem.super.init(self, extension_system_creation_context, ...)

	self._game_session = extension_system_creation_context.game_session
	self._peer_id = Network.peer_id()
	self._observers = {}
	self._player_peers = {}

	PhysicsProximitySystem.enable(self._physics_world, MAX_AGE_MS, FREQUENCY_MS, AFRO_TEMPLATE, HITBOX_TEMPLATE, AFRO_COLLISION_FILTER)
end

PhysicsUnitProximitySystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = {}

	ScriptUnit.set_extension(unit, self._name, extension)

	if extension_name == "PhysicsUnitProximityObserverExtension" then
		if self._is_server then
			self._player_peers[unit] = extension_init_data.player:peer_id()
		end
	elseif extension_name == "PhysicsUnitProximityActorExtension" then
		local time_caching_enabled = extension_init_data.time_caching_enabled

		PhysicsProximitySystem.add_actor(self._physics_world, unit, time_caching_enabled)
	end

	extension.extension_name = extension_name
	self._unit_to_extension_map[unit] = extension

	return extension
end

PhysicsUnitProximitySystem.register_extension_update = function (self, unit, extension_name, extension)
	if extension_name == "PhysicsUnitProximityObserverExtension" then
		self._observers[unit] = -1
	end
end

PhysicsUnitProximitySystem.on_remove_extension = function (self, unit, extension_name)
	if extension_name == "PhysicsUnitProximityObserverExtension" then
		self._observers[unit] = nil
		self._player_peers[unit] = nil
	elseif extension_name == "PhysicsUnitProximityActorExtension" then
		PhysicsProximitySystem.remove_actor(self._physics_world, unit)
	end

	self._unit_to_extension_map[unit] = nil

	ScriptUnit.remove_extension(unit, self._name)
end

PhysicsUnitProximitySystem.activate_unit = function (self, unit)
	local extension = self._unit_to_extension_map[unit]

	if extension.extension_name == "PhysicsUnitProximityActorExtension" then
		PhysicsProximitySystem.activate_actor(self._physics_world, unit)
	end
end

local DEFAULT_OBSERVER_RADIUS = 5

PhysicsUnitProximitySystem.update = function (self, context, dt, t, ...)
	local physics_world = self._physics_world

	PhysicsProximitySystem.clear_observers(physics_world)

	local observers = self._observers

	for observer_unit, _ in pairs(observers) do
		observers[observer_unit] = PhysicsProximitySystem.commit_unit_observer(physics_world, observer_unit, DEFAULT_OBSERVER_RADIUS)
	end
end

local DEFAULT_PROXIMITY_NETWORK_PRIORITY = 2

PhysicsUnitProximitySystem.post_update = function (self, context, dt, t, ...)
	if not self._is_server then
		return
	end

	local unit_spawner_manager = Managers.state.unit_spawner
	local physics_world = self._physics_world
	local game_session = self._game_session
	local default_priority = DEFAULT_PROXIMITY_NETWORK_PRIORITY
	local GameSession_set_game_object_priority = GameSession.set_game_object_priority
	local local_peer_id = self._peer_id
	local observers = self._observers
	local player_peers = self._player_peers

	for observer_unit, index in pairs(observers) do
		local peer_id = player_peers[observer_unit]

		if peer_id ~= local_peer_id then
			local units = PhysicsProximitySystem.get_observer_proximity_units(physics_world, index)

			for i = 1, #units do
				local unit = units[i]
				local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
				local breed = unit_data_extension:breed()
				local priority = breed.proximity_network_priority or default_priority
				local game_object_id = unit_spawner_manager:game_object_id(unit)

				GameSession_set_game_object_priority(game_session, game_object_id, peer_id, priority)
			end
		end
	end
end

return PhysicsUnitProximitySystem
