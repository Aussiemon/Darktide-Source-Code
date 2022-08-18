local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local HealthStationExtension = require("scripts/extension_systems/health_station/health_station_extension")
local HealthStationSystem = class("HealthStationSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_health_station_use",
	"rpc_health_station_hot_join",
	"rpc_health_station_on_socket_spawned",
	"rpc_health_station_on_battery_spawned",
	"rpc_health_station_sync_charges"
}

HealthStationSystem.init = function (self, context, system_init_data, ...)
	HealthStationSystem.super.init(self, context, system_init_data, ...)

	self._mission_settings_health_station = self:_fetch_settings(system_init_data.mission, context.circumstance_name)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

HealthStationSystem._fetch_settings = function (self, mission, circumstance_name)
	local original_settings = mission.health_station
	local circumstance_template = CircumstanceTemplates[circumstance_name]
	local mission_overrides = circumstance_template.mission_overrides
	local circumstance_settings = mission_overrides and mission_overrides.health_station or nil

	return circumstance_settings or original_settings
end

HealthStationSystem.on_gameplay_post_init = function (self, level)
	if self._is_server then
		self:_distribute_charges_to_stations()
	end
end

HealthStationSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

HealthStationSystem.update = function (self, context, dt, t, ...)
	HealthStationSystem.super.update(self, context, dt, t, ...)
end

HealthStationSystem.hot_join_sync = function (self, sender, channel)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local charge_amount = extension:charge_amount()
		local unit_spawner_manager = Managers.state.unit_spawner
		local station_level_id = unit_spawner_manager:level_index(unit)
		local socket_object_id = NetworkConstants.invalid_game_object_id
		local socket_unit = extension:socket_unit()

		if socket_unit then
			socket_object_id = unit_spawner_manager:game_object_id(socket_unit)
		end

		local battery_unit = extension:battery_unit()

		if battery_unit then
			local battery_is_level_unit, battery_id = unit_spawner_manager:game_object_id_or_level_index(battery_unit)

			RPC.rpc_health_station_hot_join(channel, station_level_id, charge_amount, socket_object_id, battery_id, battery_is_level_unit)
		else
			RPC.rpc_health_station_hot_join(channel, station_level_id, charge_amount, socket_object_id, NetworkConstants.invalid_game_object_id, false)
		end
	end
end

HealthStationSystem._distribute_charges_to_stations = function (self)
	fassert(self._is_server, "[HealthStationSystem] Server only method.")

	local mission_settings_health_station = self._mission_settings_health_station
	local charges_to_distribute = mission_settings_health_station and mission_settings_health_station.charges_to_distribute or 0

	if charges_to_distribute > 0 then
		local stations = {}
		local unit_to_extension_map = self._unit_to_extension_map

		for _, extension in pairs(unit_to_extension_map) do
			local battery_spawning_mode = extension:battery_spawning_mode()
			local has_battery_on_start = battery_spawning_mode == "plugged_with_charge" or battery_spawning_mode == "plugged"

			if extension:use_distribution_pool() and has_battery_on_start then
				stations[#stations + 1] = {
					charges = 0,
					extension = extension
				}
			end
		end

		if #stations > 0 then
			local max_charges_per_station = HealthStationExtension.MAX_CHARGES
			local max_total_charges = max_charges_per_station * #stations
			charges_to_distribute = math.min(charges_to_distribute, max_total_charges)

			while charges_to_distribute > 0 do
				local station_index = math.random(1, #stations)
				local charges = stations[station_index].charges

				if charges < max_charges_per_station then
					stations[station_index].charges = charges + 1
					charges_to_distribute = charges_to_distribute - 1
				end
			end

			for i = 1, #stations do
				local station = stations[i]

				if station.charges == 4 then
					station.extension:spawn_battery()
					station.extension:set_charge_amount(0)
				else
					station.extension:set_charge_amount(station.charges)
				end
			end
		end
	end
end

HealthStationSystem.get_closest_health_station = function (self, position)
	local unit_to_extension_map = self._unit_to_extension_map
	local closest_unit = nil
	local closest_distance = math.huge

	for unit, _ in pairs(unit_to_extension_map) do
		local station_position = Unit.world_position(unit, 1)
		local distance_squared = Vector3.distance_squared(position, station_position)

		if distance_squared < closest_distance then
			closest_distance = distance_squared
			closest_unit = unit
		end
	end

	return closest_unit, closest_distance
end

HealthStationSystem.rpc_health_station_use = function (self, channel_id, level_unit_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local unit = unit_spawner_manager:unit(level_unit_id, true)
	local health_station_extension = self._unit_to_extension_map[unit]

	fassert(health_station_extension, "[HealthStationSystem] Invalid call to 'rpc_health_station_use'.")
	health_station_extension:use_charge()
end

HealthStationSystem.rpc_health_station_hot_join = function (self, channel_id, level_unit_id, charge_amount, socket_object_id, battery_id, battery_is_level_unit)
	local unit_spawner_manager = Managers.state.unit_spawner
	local health_station_unit = unit_spawner_manager:unit(level_unit_id, true)
	local health_station_extension = self._unit_to_extension_map[health_station_unit]

	fassert(health_station_extension, "[HealthStationSystem] Invalid call to 'rpc_health_station_hot_join'.")

	local socket_unit = nil

	if socket_object_id ~= NetworkConstants.invalid_game_object_id then
		socket_unit = unit_spawner_manager:unit(socket_object_id, false)
	end

	local battery_unit = nil

	if unit_spawner_manager:valid_unit_id(battery_id, battery_is_level_unit) then
		battery_unit = unit_spawner_manager:unit(battery_id, battery_is_level_unit)
	end

	health_station_extension:hot_join_sync(charge_amount, socket_unit, battery_unit)
end

HealthStationSystem.rpc_health_station_on_socket_spawned = function (self, channel_id, level_unit_id, socket_object_id)
	local unit_spawner_manager = Managers.state.unit_spawner
	local health_station_unit = unit_spawner_manager:unit(level_unit_id, true)
	local health_station_extension = self._unit_to_extension_map[health_station_unit]

	fassert(health_station_extension, "[HealthStationSystem] Invalid call to 'rpc_health_station_on_socket_spawned'.")
	fassert(socket_object_id ~= NetworkConstants.invalid_game_object_id, "[HealthStationExtension] No socket Unit.")

	local is_level_unit = false
	local socket_unit = unit_spawner_manager:unit(socket_object_id, is_level_unit)

	health_station_extension:register_socket_unit(socket_unit)
end

HealthStationSystem.rpc_health_station_on_battery_spawned = function (self, channel_id, level_unit_id, battery_id, battery_is_level_unit)
	local unit_spawner_manager = Managers.state.unit_spawner
	local health_station_unit = unit_spawner_manager:unit(level_unit_id, true)
	local health_station_extension = self._unit_to_extension_map[health_station_unit]

	fassert(health_station_extension, "[HealthStationSystem] Invalid call to 'rpc_health_station_on_battery_spawned'.")
	fassert(unit_spawner_manager:valid_unit_id(battery_id, battery_is_level_unit), "[HealthStationExtension] No battery Unit.")

	local battery_unit = unit_spawner_manager:unit(battery_id, battery_is_level_unit)

	health_station_extension:register_battery_unit(battery_unit)
end

HealthStationSystem.rpc_health_station_sync_charges = function (self, channel_id, level_unit_id, charge_amount)
	local unit_spawner_manager = Managers.state.unit_spawner
	local unit = unit_spawner_manager:unit(level_unit_id, true)
	local health_station_extension = self._unit_to_extension_map[unit]

	fassert(health_station_extension, "[HealthStationSystem] Invalid call to 'rpc_health_station_sync_charges'.")
	health_station_extension:set_charge_amount(charge_amount)
end

return HealthStationSystem
