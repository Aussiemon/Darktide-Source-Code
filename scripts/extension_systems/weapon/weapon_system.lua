require("scripts/extension_systems/weapon/player_unit_weapon_extension")
require("scripts/extension_systems/weapon/projectile_unit_weapon_extension")

local Block = require("scripts/utilities/attack/block")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local WeaponSystem = class("WeaponSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_player_blocked_attack"
}

WeaponSystem.init = function (self, ...)
	WeaponSystem.super.init(self, ...)

	self._actor_proximity_shape_updates = {}
	self._units_to_destroy = {}

	self._network_event_delegate:register_session_events(self, unpack(RPCS))
end

WeaponSystem.delete_units = function (self)
	local unit_spawner_manager = Managers.state.unit_spawner
	local units_to_destroy = self._units_to_destroy

	for unit, _ in pairs(units_to_destroy) do
		unit_spawner_manager:mark_for_deletion(unit)

		units_to_destroy[unit] = nil
	end
end

WeaponSystem.destroy = function (self, ...)
	self._network_event_delegate:unregister_events(unpack(RPCS))
	WeaponSystem.super.destroy(self, ...)
end

WeaponSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = WeaponSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
	extension.use_proximity_shape_update = extension_init_data.use_proximity_shape_update

	return extension
end

WeaponSystem.register_extension_update = function (self, unit, extension_name, extension)
	WeaponSystem.super.register_extension_update(self, unit, extension_name, extension)

	if extension.use_proximity_shape_update then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local first_person_component = unit_data_extension:read_component("first_person")
		self._actor_proximity_shape_updates[unit] = first_person_component
	end
end

WeaponSystem.on_remove_extension = function (self, unit, extension_name)
	self._actor_proximity_shape_updates[unit] = nil

	WeaponSystem.super.on_remove_extension(self, unit, extension_name)
end

WeaponSystem.update = function (self, context, dt, t)
	WeaponSystem.super.update(self, context, dt, t)
	self:_update_actor_proximity_shapes()
	self:_update_units_to_destroy(t)
end

WeaponSystem.destroy_unit_after_time = function (self, unit, time_to_destroy)
	local gameplay_time = Managers.time:time("gameplay")
	self._units_to_destroy[unit] = gameplay_time + time_to_destroy
end

WeaponSystem._update_actor_proximity_shapes = function (self)
	Profiler.start("update_actor_proximity_shapes")

	local physics_world = self._physics_world
	local Quaternion_forward = Quaternion.forward
	local PhysicsWorld_commit_actor_proximity_shape = PhysicsWorld.commit_actor_proximity_shape
	local radius_sq = 36
	local actor_proxmity_shape_updates = self._actor_proximity_shape_updates

	for unit, first_person_component in pairs(actor_proxmity_shape_updates) do
		local position = first_person_component.position
		local direction = Quaternion_forward(first_person_component.rotation)
		local angle = nil

		Profiler.start("commit_actor_proximity_shape")
		PhysicsWorld_commit_actor_proximity_shape(physics_world, position, direction, radius_sq, angle, true)
		Profiler.stop("commit_actor_proximity_shape")
	end

	Profiler.stop("update_actor_proximity_shapes")
end

WeaponSystem._update_units_to_destroy = function (self, t)
	local unit_spawner_manager = Managers.state.unit_spawner
	local units_to_destroy = self._units_to_destroy

	for unit, t_to_destroy in pairs(units_to_destroy) do
		if t_to_destroy <= t then
			unit_spawner_manager:mark_for_deletion(unit)

			units_to_destroy[unit] = nil
		end
	end
end

WeaponSystem.rpc_player_blocked_attack = function (self, channel_id, unit_id, attacking_unit_id, hit_world_position, block_broken, weapon_template_id)
	local player_unit = Managers.state.unit_spawner:unit(unit_id)
	local attacking_unit = Managers.state.unit_spawner:unit(attacking_unit_id)
	local weapon_template_name = NetworkLookup.weapon_templates[weapon_template_id]
	local weapon_template = WeaponTemplates[weapon_template_name]

	Block.player_blocked_attack(player_unit, attacking_unit, hit_world_position, block_broken, weapon_template)
end

return WeaponSystem
