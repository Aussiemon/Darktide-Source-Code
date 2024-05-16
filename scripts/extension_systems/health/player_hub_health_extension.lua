-- chunkname: @scripts/extension_systems/health/player_hub_health_extension.lua

local HealthExtensionInterface = require("scripts/extension_systems/health/health_extension_interface")
local PlayerHubHealthExtension = class("PlayerHubHealthExtension")

PlayerHubHealthExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._health = extension_init_data.health
	self._base_max_wounds = extension_init_data.wounds
end

PlayerHubHealthExtension.pre_update = function (self, unit, dt, t)
	return
end

PlayerHubHealthExtension.fixed_update = function (self, unit, dt, t)
	return
end

PlayerHubHealthExtension.is_alive = function (self)
	return true
end

PlayerHubHealthExtension.is_unkillable = function (self)
	return true
end

PlayerHubHealthExtension.is_invulnerable = function (self)
	return true
end

PlayerHubHealthExtension.current_health = function (self)
	return self._health
end

PlayerHubHealthExtension.current_health_percent = function (self)
	return 1
end

PlayerHubHealthExtension.damage_taken = function (self)
	return 0
end

PlayerHubHealthExtension.permanent_damage_taken = function (self)
	return 0
end

PlayerHubHealthExtension.permanent_damage_taken_percent = function (self)
	return 0
end

PlayerHubHealthExtension.total_damage_taken = function (self)
	return 0
end

PlayerHubHealthExtension.max_health = function (self, force_knocked_down_health)
	return self._health
end

PlayerHubHealthExtension.add_damage = function (self, damage_amount, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit)
	local actual_damage_dealt = 0

	return actual_damage_dealt
end

PlayerHubHealthExtension.add_heal = function (self, heal_amount, heal_type)
	local actual_heal_amount = 0

	return actual_heal_amount
end

PlayerHubHealthExtension.reduce_permanent_damage = function (self, amount)
	return
end

PlayerHubHealthExtension.on_player_unit_spawn = function (self, spawn_health_percentage)
	return
end

PlayerHubHealthExtension.on_player_unit_respawn = function (self, respawn_health_percentage)
	return
end

PlayerHubHealthExtension.remove_wounds = function (self, num_wounds)
	return
end

PlayerHubHealthExtension.entered_knocked_down = function (self)
	return
end

PlayerHubHealthExtension.exited_knocked_down = function (self)
	return
end

PlayerHubHealthExtension.health_depleted = function (self)
	return false
end

PlayerHubHealthExtension.should_die = function (self)
	return false
end

PlayerHubHealthExtension.set_unkillable = function (self, should_be_unkillable)
	return
end

PlayerHubHealthExtension.set_invulnerable = function (self, should_be_invulnerable)
	return
end

PlayerHubHealthExtension.set_last_damaging_unit = function (self, last_damaging_unit, hit_zone_name, last_hit_was_critical)
	return
end

PlayerHubHealthExtension.last_damaging_unit = function (self)
	return nil
end

PlayerHubHealthExtension.last_hit_zone_name = function (self)
	return nil
end

PlayerHubHealthExtension.last_hit_was_critical = function (self)
	return false
end

PlayerHubHealthExtension.was_hit_by_critical_hit_this_render_frame = function (self)
	return false
end

PlayerHubHealthExtension.kill = function (self)
	return
end

PlayerHubHealthExtension.num_wounds = function (self)
	return self._base_max_wounds
end

PlayerHubHealthExtension.max_wounds = function (self)
	return self._base_max_wounds
end

PlayerHubHealthExtension.persistent_data = function (self)
	return
end

PlayerHubHealthExtension.apply_persistent_data = function (self, damage_percent, permanent_damage_percent)
	return
end

implements(PlayerHubHealthExtension, HealthExtensionInterface)

return PlayerHubHealthExtension
