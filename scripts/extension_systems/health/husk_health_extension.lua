local HealthExtensionInterface = require("scripts/extension_systems/health/health_extension_interface")
local HuskHealthExtension = class("HuskHealthExtension")

local function _health_and_damage(game_session, game_object_id)
	local health = GameSession.game_object_field(game_session, game_object_id, "health")
	local damage = GameSession.game_object_field(game_session, game_object_id, "damage")

	return health, damage
end

HuskHealthExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id, owner_id)
	self.game_session = game_session
	self.game_object_id = game_object_id
	self.is_dead = false
	local has_health_bar = extension_init_data and extension_init_data.has_health_bar

	if has_health_bar then
		Managers.event:trigger("add_world_marker_unit", "damage_indicator", unit)
	end
end

HuskHealthExtension.pre_update = function (self, unit, dt, t)
	self._was_hit_by_critical_hit_this_render_frame = false
end

HuskHealthExtension.is_alive = function (self)
	return not self.is_dead
end

HuskHealthExtension.is_unkillable = function (self)
	return false
end

HuskHealthExtension.is_invulnerable = function (self)
	return false
end

HuskHealthExtension.current_health = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	return math.max(0, health - damage)
end

HuskHealthExtension.current_health_percent = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	if health <= 0 then
		return 0
	end

	return math.max(0, 1 - damage / health)
end

HuskHealthExtension.damage_taken = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "damage")
end

HuskHealthExtension.permanent_damage_taken = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "damage")
end

HuskHealthExtension.permanent_damage_taken_percent = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	if health <= 0 then
		return 0
	end

	return damage / health
end

HuskHealthExtension.total_damage_taken = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	return math.min(health, damage)
end

HuskHealthExtension.max_health = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "health")
end

HuskHealthExtension.add_damage = function (self)
	return
end

HuskHealthExtension.add_heal = function (self)
	return
end

HuskHealthExtension.health_depleted = function (self)
	return
end

HuskHealthExtension.set_unkillable = function (self)
	return
end

HuskHealthExtension.set_invulnerable = function (self)
	return
end

HuskHealthExtension.set_last_damaging_unit = function (self, last_damaging_unit, hit_zone_name, last_hit_was_critical)
	self._last_damaging_unit = last_damaging_unit
	self._last_hit_zone_name = hit_zone_name
	self._last_hit_was_critical = last_hit_was_critical
	self._was_hit_by_critical_hit_this_render_frame = self._was_hit_by_critical_hit_this_render_frame or last_hit_was_critical
end

HuskHealthExtension.last_damaging_unit = function (self)
	return self._last_damaging_unit
end

HuskHealthExtension.last_hit_zone_name = function (self)
	return self._last_hit_zone_name
end

HuskHealthExtension.last_hit_was_critical = function (self)
	return self._last_hit_was_critical
end

HuskHealthExtension.was_hit_by_critical_hit_this_render_frame = function (self)
	return self._was_hit_by_critical_hit_this_render_frame
end

HuskHealthExtension.num_wounds = function (self)
	return 1
end

HuskHealthExtension.max_wounds = function (self)
	return 1
end

HuskHealthExtension.hit_mass = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "hit_mass")
end

implements(HuskHealthExtension, HealthExtensionInterface)

return HuskHealthExtension
