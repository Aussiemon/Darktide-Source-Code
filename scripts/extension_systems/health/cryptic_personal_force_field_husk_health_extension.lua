-- chunkname: @scripts/extension_systems/health/cryptic_personal_force_field_husk_health_extension.lua

local HealthExtensionInterface = require("scripts/extension_systems/health/health_extension_interface")
local CrypticPersonalForceFieldHuskHealthExtension = class("CrypticPersonalForceFieldHuskHealthExtension", "HealthExtensionBase")

local function _health_and_damage(game_session, game_object_id)
	local health = GameSession.game_object_field(game_session, game_object_id, "health")
	local damage = GameSession.game_object_field(game_session, game_object_id, "damage")

	return health, damage
end

CrypticPersonalForceFieldHuskHealthExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id, owner_id)
	self.game_session = game_session
	self.game_object_id = game_object_id
	self.is_dead = false
	self._is_expired = false
	self._world = extension_init_context.world
end

CrypticPersonalForceFieldHuskHealthExtension.pre_update = function (self, unit, dt, t)
	self._was_hit_by_critical_hit_this_render_frame = false
end

CrypticPersonalForceFieldHuskHealthExtension.fixed_update = function (self, unit, dt, t)
	local game_session = self.game_session
	local game_object_id = self.game_object_id
	local is_expired = GameSession.game_object_field(game_session, game_object_id, "expired")

	if not self._is_expired and is_expired then
		self._is_expired = is_expired
	end
end

CrypticPersonalForceFieldHuskHealthExtension.is_alive = function (self)
	return not self.is_dead
end

CrypticPersonalForceFieldHuskHealthExtension.is_unkillable = function (self)
	return true
end

CrypticPersonalForceFieldHuskHealthExtension.is_invulnerable = function (self)
	return true
end

CrypticPersonalForceFieldHuskHealthExtension.current_health = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	return math.max(0, health - damage)
end

CrypticPersonalForceFieldHuskHealthExtension.current_health_percent = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	if health <= 0 then
		return 0
	end

	return math.max(0, 1 - damage / health)
end

CrypticPersonalForceFieldHuskHealthExtension.damage_taken = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "damage")
end

CrypticPersonalForceFieldHuskHealthExtension.permanent_damage_taken = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "damage")
end

CrypticPersonalForceFieldHuskHealthExtension.permanent_damage_taken_percent = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	if health <= 0 then
		return 0
	end

	return damage / health
end

CrypticPersonalForceFieldHuskHealthExtension.total_damage_taken = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	return math.min(health, damage)
end

CrypticPersonalForceFieldHuskHealthExtension.max_health = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "health")
end

CrypticPersonalForceFieldHuskHealthExtension.add_damage = function (self)
	return
end

CrypticPersonalForceFieldHuskHealthExtension.add_heal = function (self)
	return
end

CrypticPersonalForceFieldHuskHealthExtension.health_depleted = function (self)
	return
end

CrypticPersonalForceFieldHuskHealthExtension.set_unkillable = function (self)
	return
end

CrypticPersonalForceFieldHuskHealthExtension.set_invulnerable = function (self)
	return
end

CrypticPersonalForceFieldHuskHealthExtension.set_last_damaging_unit = function (self, last_damaging_unit, hit_zone_name, last_hit_was_critical)
	self._last_damaging_unit = last_damaging_unit
	self._last_hit_zone_name = hit_zone_name
	self._last_hit_was_critical = last_hit_was_critical
	self._was_hit_by_critical_hit_this_render_frame = self._was_hit_by_critical_hit_this_render_frame or last_hit_was_critical
end

CrypticPersonalForceFieldHuskHealthExtension.last_damaging_unit = function (self)
	return self._last_damaging_unit
end

CrypticPersonalForceFieldHuskHealthExtension.last_hit_zone_name = function (self)
	return self._last_hit_zone_name
end

CrypticPersonalForceFieldHuskHealthExtension.last_hit_was_critical = function (self)
	return self._last_hit_was_critical
end

CrypticPersonalForceFieldHuskHealthExtension.was_hit_by_critical_hit_this_render_frame = function (self)
	return self._was_hit_by_critical_hit_this_render_frame
end

CrypticPersonalForceFieldHuskHealthExtension.num_wounds = function (self)
	return 1
end

CrypticPersonalForceFieldHuskHealthExtension.max_wounds = function (self)
	return 1
end

implements(CrypticPersonalForceFieldHuskHealthExtension, HealthExtensionInterface)

return CrypticPersonalForceFieldHuskHealthExtension
