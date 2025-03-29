-- chunkname: @scripts/extension_systems/health/health_system.lua

require("scripts/foundation/managers/extension/extension_system_base")
require("scripts/extension_systems/health/force_field_health_extension")
require("scripts/extension_systems/health/force_field_husk_health_extension")
require("scripts/extension_systems/health/health_extension")
require("scripts/extension_systems/health/husk_health_extension")
require("scripts/extension_systems/health/player_hub_health_extension")
require("scripts/extension_systems/health/player_husk_health_extension")
require("scripts/extension_systems/health/player_unit_health_extension")
require("scripts/extension_systems/health/prop_health_extension")

local CLIENT_RPCS = {
	"rpc_kill_unit_health",
}
local HealthSystem = class("HealthSystem", "ExtensionSystemBase")

HealthSystem.init = function (self, ...)
	HealthSystem.super.init(self, ...)

	self._husk_health_extensions = {}

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

HealthSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	table.clear(HEALTH_ALIVE)
end

HealthSystem.register_extension_update = function (self, unit, extension_name, extension)
	HealthSystem.super.register_extension_update(self, unit, extension_name, extension)

	if extension_name == "HuskHealthExtension" then
		self._husk_health_extensions[unit] = extension
	end
end

HealthSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	HEALTH_ALIVE[unit] = true

	return HealthSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
end

HealthSystem.on_remove_extension = function (self, unit, extension_name)
	if extension_name == "HuskHealthExtension" then
		self._husk_health_extensions[unit] = nil
	end

	HEALTH_ALIVE[unit] = nil

	HealthSystem.super.on_remove_extension(self, unit, extension_name)
end

HealthSystem.update = function (self, context, dt, t, ...)
	HealthSystem.super.update(self, context, dt, t, ...)
	self:_update_is_dead_status_husk(dt, t)
end

local _game_object_field = GameSession.game_object_field
local IS_DEAD_FIELD_NAME = "is_dead"

HealthSystem._update_is_dead_status_husk = function (self, dt, t)
	for unit, extension in pairs(self._husk_health_extensions) do
		local game_session = extension.game_session
		local game_object_id = extension.game_object_id
		local is_dead = _game_object_field(game_session, game_object_id, IS_DEAD_FIELD_NAME)

		if extension.is_dead ~= is_dead then
			Managers.event:trigger("unit_died", unit)

			HEALTH_ALIVE[unit] = nil
			extension.is_dead = is_dead
		end
	end
end

HealthSystem.rpc_kill_unit_health = function (self, channel_id, target_unit_id)
	local target_unit = Managers.state.unit_spawner:unit(target_unit_id, false)
	local extension = self._unit_to_extension_map[target_unit]

	extension:kill()
end

return HealthSystem
