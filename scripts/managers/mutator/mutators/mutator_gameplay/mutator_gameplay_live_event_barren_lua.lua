-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_barren_lua.lua

require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_base")

local MutatorGameplayBarrenLua = class("MutatorGameplayBarrenLua", "MutatorGameplayBase")
local REMOVE_SYSTEMS = {
	"chest_system",
	"health_station_system",
}
local _DESPAWN_RPC_BY_SYSTEM = {
	chest_system = "rpc_chest_despawn",
	health_station_system = "rpc_health_station_despawn",
}

MutatorGameplayBarrenLua.init = function (self, owner, settings, triggered_by_level)
	MutatorGameplayBarrenLua.super.init(self, owner, settings, triggered_by_level)

	if not self._is_server then
		return
	end

	self._units_to_delete = {}
	self._despawned_level_units = {}

	self:_collect_existing_units()
	Managers.event:register(self, "unit_registered", "_on_unit_registered")
end

MutatorGameplayBarrenLua._collect_existing_units = function (self)
	local extension_manager = Managers.state.extension

	if not extension_manager then
		return
	end

	for i = 1, #REMOVE_SYSTEMS do
		local system_name = REMOVE_SYSTEMS[i]

		if extension_manager:has_system(system_name) then
			local unit_to_extension_map = extension_manager:system(system_name):unit_to_extension_map()

			for unit, _ in pairs(unit_to_extension_map) do
				self._units_to_delete[unit] = system_name
			end
		end
	end
end

MutatorGameplayBarrenLua._on_unit_registered = function (self, unit)
	local extension_manager = Managers.state.extension

	if not extension_manager then
		return
	end

	for i = 1, #REMOVE_SYSTEMS do
		local system_name = REMOVE_SYSTEMS[i]

		if extension_manager:has_system(system_name) then
			local unit_to_extension_map = extension_manager:system(system_name):unit_to_extension_map()

			if unit_to_extension_map[unit] then
				self._units_to_delete[unit] = system_name

				return
			end
		end
	end
end

MutatorGameplayBarrenLua.update = function (self, dt, t)
	MutatorGameplayBarrenLua.super.update(self, dt, t)

	if not self._is_server then
		return
	end

	local units_to_delete = self._units_to_delete

	if not next(units_to_delete) then
		return
	end

	for unit, system_name in pairs(units_to_delete) do
		self:_destroy_unit(unit, system_name)
	end

	table.clear(units_to_delete)
end

MutatorGameplayBarrenLua._destroy_unit = function (self, unit, system_name)
	if not Unit.alive(unit) then
		return
	end

	local unit_spawner = Managers.state.unit_spawner

	if not unit_spawner then
		return
	end

	if unit_spawner:is_marked_for_deletion(unit) then
		return
	end

	local level_unit_id = unit_spawner:level_index(unit)

	if level_unit_id then
		local rpc_name = _DESPAWN_RPC_BY_SYSTEM[system_name]
		local game_session_manager = Managers.state.game_session

		if rpc_name and game_session_manager then
			game_session_manager:send_rpc_clients(rpc_name, level_unit_id)
		end

		local despawned = self._despawned_level_units[system_name]

		if not despawned then
			despawned = {}
			self._despawned_level_units[system_name] = despawned
		end

		despawned[#despawned + 1] = level_unit_id
	end

	unit_spawner:mark_for_deletion(unit)
end

MutatorGameplayBarrenLua.hot_join_sync = function (self, sender, channel)
	if not self._is_server then
		return
	end

	for system_name, level_unit_ids in pairs(self._despawned_level_units) do
		local rpc_name = _DESPAWN_RPC_BY_SYSTEM[system_name]
		local rpc = rpc_name and RPC[rpc_name]

		if rpc then
			for i = 1, #level_unit_ids do
				rpc(channel, level_unit_ids[i])
			end
		end
	end
end

MutatorGameplayBarrenLua.destroy = function (self)
	if self._is_server then
		Managers.event:unregister(self, "unit_registered")

		self._units_to_delete = nil
		self._despawned_level_units = nil
	end

	MutatorGameplayBarrenLua.super.destroy(self)
end

return MutatorGameplayBarrenLua
