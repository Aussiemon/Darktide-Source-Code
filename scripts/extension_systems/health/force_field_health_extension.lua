local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local HealthExtensionInterface = require("scripts/extension_systems/health/health_extension_interface")
local TalentSettings = require("scripts/settings/talent/talent_settings_new")
local ForceFieldHealthExtension = class("ForceFieldHealthExtension")
local special_rules = SpecialRulesSetting.special_rules
local talent_settings = TalentSettings.psyker_3.combat_ability

ForceFieldHealthExtension.init = function (self, extension_init_context, unit, extension_init_data)
	local owner_unit = extension_init_data.owner_unit
	self._unit = unit
	self._owner_unit = owner_unit
	self._specialization_extension = ScriptUnit.extension(owner_unit, "specialization_system")
	local sphere_shield = self._specialization_extension:has_special_rule(special_rules.psyker_sphere_shield)
	self._sphere_shield = sphere_shield
	local max_health = talent_settings.health
	local max_sphere_health = talent_settings.sphere_health
	self._next_allowed_t = 0
	self._max_health = sphere_shield and max_sphere_health or max_health
	self._health = self._max_health
	self._is_dead = false
end

ForceFieldHealthExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
	local owner_unit = self._owner_unit
	self._specialization_extension = ScriptUnit.extension(owner_unit, "specialization_system")
	local sphere_shield = self._specialization_extension:has_special_rule(special_rules.psyker_sphere_shield)
	self._sphere_shield = sphere_shield
	local max_health = talent_settings.health
	local max_sphere_health = talent_settings.sphere_health
	self._damage_cooldown = talent_settings.damage_cooldown
	self._max_health = sphere_shield and max_sphere_health or max_health
	self._health = self._max_health

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "health", self._max_health)
	GameSession.set_game_object_field(self._game_session, self._game_object_id, "damage", 0)

	self._health_extension = ScriptUnit.extension(self._unit, "health_system")
end

ForceFieldHealthExtension.pre_update = function (self, unit, dt, t)
	self._was_hit_by_critical_hit_this_render_frame = false
end

ForceFieldHealthExtension.add_damage = function (self, damage_amount, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit)
	self:_add_damage(damage_amount)
end

ForceFieldHealthExtension.tried_adding_damage = function (self, damage_amount, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit)
	self:_add_damage(damage_amount)
end

ForceFieldHealthExtension._add_damage = function (self, damage)
	local t = Managers.time:time("gameplay")

	if t < self._next_allowed_t then
		return
	end

	local game_session = self._game_session
	local game_object_id = self._game_object_id
	self._next_allowed_t = t + self._damage_cooldown
	self._health = math.max(0, self._health - damage)

	GameSession.set_game_object_field(game_session, game_object_id, "damage", self._max_health - self._health)
	GameSession.set_game_object_field(game_session, game_object_id, "health", self._health)

	if self._health <= 0 then
		self:_set_dead()
	end
end

ForceFieldHealthExtension._set_dead = function (self)
	self._is_dead = true
end

ForceFieldHealthExtension.is_dead = function (self)
	return self._is_dead
end

ForceFieldHealthExtension.add_heal = function (self, heal_amount, heal_type)
	return
end

ForceFieldHealthExtension.max_health = function (self)
	return self._max_health
end

ForceFieldHealthExtension.current_health = function (self)
	return self._health
end

ForceFieldHealthExtension.current_health_percent = function (self)
	if self._max_health <= 0 then
		return 0
	end

	return self._health / self._max_health
end

ForceFieldHealthExtension.damage_taken = function (self)
	return 0
end

ForceFieldHealthExtension.permanent_damage_taken = function (self)
	return 0
end

ForceFieldHealthExtension.permanent_damage_taken_percent = function (self)
	return 0
end

ForceFieldHealthExtension.total_damage_taken = function (self)
	return 0
end

ForceFieldHealthExtension.health_depleted = function (self)
	return self._health <= 0
end

ForceFieldHealthExtension.is_alive = function (self)
	return not self._is_dead
end

ForceFieldHealthExtension.is_unkillable = function (self)
	return false
end

ForceFieldHealthExtension.is_invulnerable = function (self)
	return false
end

ForceFieldHealthExtension.set_unkillable = function (self, should_be_unkillable)
	self._is_unkillable = should_be_unkillable
end

ForceFieldHealthExtension.set_invulnerable = function (self, should_be_invulnerable)
	self._is_invulnerable = should_be_invulnerable
end

ForceFieldHealthExtension.set_last_damaging_unit = function (self, last_damaging_unit, hit_zone_name, last_hit_was_critical)
	self._last_damaging_unit = last_damaging_unit
	self._last_hit_zone_name = hit_zone_name
	self._last_hit_was_critical = last_hit_was_critical
	self._was_hit_by_critical_hit_this_render_frame = self._was_hit_by_critical_hit_this_render_frame or last_hit_was_critical
end

ForceFieldHealthExtension.last_damaging_unit = function (self)
	return self._last_damaging_unit
end

ForceFieldHealthExtension.last_hit_zone_name = function (self)
	return self._last_hit_zone_name
end

ForceFieldHealthExtension.last_hit_was_critical = function (self)
	return self._last_hit_was_critical
end

ForceFieldHealthExtension.was_hit_by_critical_hit_this_render_frame = function (self)
	return self._was_hit_by_critical_hit_this_render_frame
end

ForceFieldHealthExtension.num_wounds = function (self)
	return 1
end

ForceFieldHealthExtension.max_wounds = function (self)
	return 1
end

implements(ForceFieldHealthExtension, HealthExtensionInterface)

return ForceFieldHealthExtension
