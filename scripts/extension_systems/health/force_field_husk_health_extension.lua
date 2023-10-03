local HealthExtensionInterface = require("scripts/extension_systems/health/health_extension_interface")
local ForceFieldHuskHealthExtension = class("ForceFieldHuskHealthExtension")

local function _health_and_damage(game_session, game_object_id)
	local health = GameSession.game_object_field(game_session, game_object_id, "health")
	local damage = GameSession.game_object_field(game_session, game_object_id, "damage")

	return health, damage
end

ForceFieldHuskHealthExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id, owner_id)
	self.game_session = game_session
	self.game_object_id = game_object_id
	self.is_dead = false
end

ForceFieldHuskHealthExtension.pre_update = function (self, unit, dt, t)
	self._was_hit_by_critical_hit_this_render_frame = false
end

ForceFieldHuskHealthExtension.is_alive = function (self)
	return not self.is_dead
end

ForceFieldHuskHealthExtension.is_unkillable = function (self)
	return false
end

ForceFieldHuskHealthExtension.is_invulnerable = function (self)
	return false
end

ForceFieldHuskHealthExtension.current_health = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	return math.max(0, health - damage)
end

ForceFieldHuskHealthExtension.current_health_percent = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	if health <= 0 then
		return 0
	end

	return math.max(0, 1 - damage / health)
end

ForceFieldHuskHealthExtension.damage_taken = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "damage")
end

ForceFieldHuskHealthExtension.permanent_damage_taken = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "damage")
end

ForceFieldHuskHealthExtension.permanent_damage_taken_percent = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	if health <= 0 then
		return 0
	end

	return damage / health
end

ForceFieldHuskHealthExtension.total_damage_taken = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	return math.min(health, damage)
end

ForceFieldHuskHealthExtension.max_health = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "health")
end

ForceFieldHuskHealthExtension.add_damage = function (self)
	return
end

ForceFieldHuskHealthExtension.add_heal = function (self)
	return
end

ForceFieldHuskHealthExtension.health_depleted = function (self)
	return
end

ForceFieldHuskHealthExtension.set_unkillable = function (self)
	return
end

ForceFieldHuskHealthExtension.set_invulnerable = function (self)
	return
end

ForceFieldHuskHealthExtension.set_last_damaging_unit = function (self, last_damaging_unit, hit_zone_name, last_hit_was_critical)
	self._last_damaging_unit = last_damaging_unit
	self._last_hit_zone_name = hit_zone_name
	self._last_hit_was_critical = last_hit_was_critical
	self._was_hit_by_critical_hit_this_render_frame = self._was_hit_by_critical_hit_this_render_frame or last_hit_was_critical
end

ForceFieldHuskHealthExtension.last_damaging_unit = function (self)
	return self._last_damaging_unit
end

ForceFieldHuskHealthExtension.last_hit_zone_name = function (self)
	return self._last_hit_zone_name
end

ForceFieldHuskHealthExtension.last_hit_was_critical = function (self)
	return self._last_hit_was_critical
end

ForceFieldHuskHealthExtension.was_hit_by_critical_hit_this_render_frame = function (self)
	return self._was_hit_by_critical_hit_this_render_frame
end

ForceFieldHuskHealthExtension.num_wounds = function (self)
	return 1
end

ForceFieldHuskHealthExtension.max_wounds = function (self)
	return 1
end

implements(ForceFieldHuskHealthExtension, HealthExtensionInterface)

return ForceFieldHuskHealthExtension
