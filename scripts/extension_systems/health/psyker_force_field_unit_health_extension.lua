-- chunkname: @scripts/extension_systems/health/psyker_force_field_unit_health_extension.lua

local HealthExtensionInterface = require("scripts/extension_systems/health/health_extension_interface")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local PsykerForceFieldUnitHealthExtension = class("PsykerForceFieldUnitHealthExtension")
local special_rules = SpecialRulesSettings.special_rules
local talent_settings = TalentSettings.psyker_3.combat_ability

PsykerForceFieldUnitHealthExtension.init = function (self, extension_init_context, unit, extension_init_data)
	local owner_unit = extension_init_data.owner_unit

	self._unit = unit
	self._owner_unit = owner_unit

	local max_health
	local ability_type = extension_init_data.ability_type

	if ability_type then
		self._talent_extension = ScriptUnit.extension(owner_unit, "talent_system")

		local sphere_shield = self._talent_extension:has_special_rule(special_rules.psyker_sphere_shield)

		max_health = sphere_shield and talent_settings.sphere_health or talent_settings.health

		local ability_extension = ScriptUnit.extension(owner_unit, "ability_system")

		self._ability_name = ability_extension:ability_name(ability_type)
	end

	local deployable_settings = extension_init_data.deployable_settings

	if deployable_settings then
		self._deployable_settings = deployable_settings
		max_health = deployable_settings.max_health
	end

	self._next_allowed_t = 0
	self._invincible = not max_health
	self._max_health = max_health or 1
	self._health = self._max_health
	self._is_dead = false
	self._damage_taken_total = 0
end

PsykerForceFieldUnitHealthExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
	self._damage_cooldown = talent_settings.damage_cooldown
	self._local_damage = 1

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "health", self._max_health)
	GameSession.set_game_object_field(self._game_session, self._game_object_id, "damage", 0)

	self._health_extension = ScriptUnit.extension(self._unit, "health_system")
end

PsykerForceFieldUnitHealthExtension.pre_update = function (self, unit, dt, t)
	self._was_hit_by_critical_hit_this_render_frame = false
end

PsykerForceFieldUnitHealthExtension.add_damage = function (self, damage_amount, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit)
	self:_add_damage(damage_amount)
end

PsykerForceFieldUnitHealthExtension.tried_adding_damage = function (self, damage_amount, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit)
	self:_add_damage(damage_amount)
end

PsykerForceFieldUnitHealthExtension._add_damage = function (self, damage)
	if damage then
		self._damage_taken_total = self._damage_taken_total + damage
	end

	local t = Managers.time:time("gameplay")

	if t < self._next_allowed_t then
		return
	end

	local game_session = self._game_session
	local game_object_id = self._game_object_id

	self._next_allowed_t = t + self._damage_cooldown

	if self._invincible then
		return
	end

	self._health = math.max(0, self._health - self._local_damage)

	GameSession.set_game_object_field(game_session, game_object_id, "damage", self._max_health - self._health)
	GameSession.set_game_object_field(game_session, game_object_id, "health", self._health)

	if self._health <= 0 then
		self:_set_dead()
		self:send_stat_data()
	end
end

PsykerForceFieldUnitHealthExtension.send_stat_data = function (self)
	if self._ability_name == "psyker_force_field_dome" or self._ability_name == "psyker_force_field" then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local owner = player_unit_spawn_manager:owner(self._owner_unit)

		Managers.stats:record_private("hook_psyker_shield_damage_taken", owner, self._damage_taken_total)
	end
end

PsykerForceFieldUnitHealthExtension._set_dead = function (self)
	self._is_dead = true
end

PsykerForceFieldUnitHealthExtension.is_dead = function (self)
	return self._is_dead
end

PsykerForceFieldUnitHealthExtension.add_heal = function (self, heal_amount, heal_type)
	return
end

PsykerForceFieldUnitHealthExtension.max_health = function (self)
	return self._max_health
end

PsykerForceFieldUnitHealthExtension.current_health = function (self)
	return self._health
end

PsykerForceFieldUnitHealthExtension.current_health_percent = function (self)
	if self._max_health <= 0 then
		return 0
	end

	return self._health / self._max_health
end

PsykerForceFieldUnitHealthExtension.damage_taken = function (self)
	return 0
end

PsykerForceFieldUnitHealthExtension.permanent_damage_taken = function (self)
	return 0
end

PsykerForceFieldUnitHealthExtension.permanent_damage_taken_percent = function (self)
	return 0
end

PsykerForceFieldUnitHealthExtension.total_damage_taken = function (self)
	return 0
end

PsykerForceFieldUnitHealthExtension.health_depleted = function (self)
	return self._health <= 0
end

PsykerForceFieldUnitHealthExtension.is_alive = function (self)
	return not self._is_dead
end

PsykerForceFieldUnitHealthExtension.is_unkillable = function (self)
	return false
end

PsykerForceFieldUnitHealthExtension.is_invulnerable = function (self)
	return false
end

PsykerForceFieldUnitHealthExtension.set_unkillable = function (self, should_be_unkillable)
	self._is_unkillable = should_be_unkillable
end

PsykerForceFieldUnitHealthExtension.set_invulnerable = function (self, should_be_invulnerable)
	self._is_invulnerable = should_be_invulnerable
end

PsykerForceFieldUnitHealthExtension.set_last_damaging_unit = function (self, last_damaging_unit, hit_zone_name, last_hit_was_critical)
	self._last_damaging_unit = last_damaging_unit
	self._last_hit_zone_name = hit_zone_name
	self._last_hit_was_critical = last_hit_was_critical
	self._was_hit_by_critical_hit_this_render_frame = self._was_hit_by_critical_hit_this_render_frame or last_hit_was_critical
end

PsykerForceFieldUnitHealthExtension.last_damaging_unit = function (self)
	return self._last_damaging_unit
end

PsykerForceFieldUnitHealthExtension.last_hit_zone_name = function (self)
	return self._last_hit_zone_name
end

PsykerForceFieldUnitHealthExtension.last_hit_was_critical = function (self)
	return self._last_hit_was_critical
end

PsykerForceFieldUnitHealthExtension.was_hit_by_critical_hit_this_render_frame = function (self)
	return self._was_hit_by_critical_hit_this_render_frame
end

PsykerForceFieldUnitHealthExtension.num_wounds = function (self)
	return 1
end

PsykerForceFieldUnitHealthExtension.max_wounds = function (self)
	return 1
end

implements(PsykerForceFieldUnitHealthExtension, HealthExtensionInterface)

return PsykerForceFieldUnitHealthExtension
