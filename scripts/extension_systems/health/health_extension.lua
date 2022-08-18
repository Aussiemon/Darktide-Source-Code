local HealthExtensionInterface = require("scripts/extension_systems/health/health_extension_interface")
local HealthExtension = class("HealthExtension")

HealthExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local health = extension_init_data.health or Unit.get_data(unit, "health")

	fassert(health, "health is not defined in either extension_init_data or the unit_data")

	self._health = health
	self._unit = unit
	self._is_unkillable = not not extension_init_data.is_unkillable
	self._is_invulnerable = not not extension_init_data.is_invulnerable
	self._damage = 0
	self._is_dead = false
	game_object_data.health = self._health
	game_object_data.damage = self._damage
	game_object_data.is_dead = self._is_dead
	local has_health_bar = extension_init_data.has_health_bar

	if has_health_bar then
		Managers.event:trigger("add_world_marker_unit", "damage_indicator", unit)
	end
end

HealthExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
end

HealthExtension.is_alive = function (self)
	return not self._is_dead
end

HealthExtension.is_unkillable = function (self)
	return self._is_unkillable
end

HealthExtension.is_invulnerable = function (self)
	return self._is_invulnerable
end

HealthExtension.current_damaged_health = function (self)
	return math.max(0, self._health - self._damage)
end

HealthExtension.current_health = function (self)
	return math.max(0, self._health - self._damage)
end

HealthExtension.current_damaged_health_percent = function (self)
	local damaged_max_health = self:damaged_max_health()

	if damaged_max_health <= 0 then
		return 0
	end

	return math.max(0, 1 - self._damage / damaged_max_health)
end

HealthExtension.current_health_percent = function (self)
	local health = self._health

	if health <= 0 then
		return 0
	end

	return math.max(0, 1 - self._damage / health)
end

HealthExtension.damage_taken = function (self)
	return self._damage
end

HealthExtension.permanent_damage_taken = function (self)
	return 0
end

HealthExtension.permanent_damage_taken_percent = function (self)
	return 0
end

HealthExtension.total_damage_taken = function (self)
	return math.min(self._health, self._damage)
end

HealthExtension.damaged_max_health = function (self)
	return math.max(0, self._health - self._damage)
end

HealthExtension.max_health = function (self)
	return self._health
end

HealthExtension.add_damage = function (self, damage_amount, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit)
	local current_damage = self._damage
	local health = self._health
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local new_damage = current_damage + damage_amount
	local network_damage = math.min(new_damage, health)

	GameSession.set_game_object_field(game_session, game_object_id, "damage", network_damage)

	self._damage = new_damage
end

HealthExtension.add_heal = function (self, heal_amount, heal_type)
	local health = self._health
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local old_damage = self._damage
	local actual_heal_amount = math.min(heal_amount, old_damage)
	local new_damage = old_damage - actual_heal_amount
	local network_damage = math.min(new_damage, health)

	GameSession.set_game_object_field(game_session, game_object_id, "damage", network_damage)

	self._damage = new_damage

	return actual_heal_amount
end

HealthExtension.health_depleted = function (self)
	if self._is_unkillable then
		return false
	else
		return self._health <= self._damage
	end
end

HealthExtension.set_unkillable = function (self, should_be_unkillable)
	self._is_unkillable = should_be_unkillable
end

HealthExtension.set_invulnerable = function (self, should_be_invulnerable)
	self._is_invulnerable = should_be_invulnerable
end

local IS_DEAD_FIELD_NAME = "is_dead"

HealthExtension.kill = function (self)
	if self._is_unkillable then
		Log.warning("HealthExtension", "Trying to kill health extension which is unkillable")

		return
	end

	local side_system = Managers.state.extension:system("side_system")

	side_system:remove_unit_from_tag_units(self._unit)

	HEALTH_ALIVE[self._unit] = nil
	self._is_dead = true

	GameSession.set_game_object_field(self._game_session, self._game_object_id, IS_DEAD_FIELD_NAME, true)
end

HealthExtension.num_wounds = function (self)
	return 1
end

HealthExtension.max_wounds = function (self)
	return 1
end

implements(HealthExtension, HealthExtensionInterface)

return HealthExtension
