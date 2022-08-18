local HealthExtensionInterface = require("scripts/extension_systems/health/health_extension_interface")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerHuskHealthExtension = class("PlayerHuskHealthExtension")

PlayerHuskHealthExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id, owner_id)
	self._game_session = game_session
	self._game_object_id = game_object_id
	self._world = extension_init_context.world
	self._wwise_world = Wwise.wwise_world(self._world)
	self._is_dead = false
	self._is_knocked_down = false
	self._health = 0
	self._damage = 0
	self._permanent_damage = 0
	self._knocked_down_health = 0
	self._knocked_down_damage = 0
	self._unit = unit
	self._is_local_unit = extension_init_data.is_local_unit
	self._max_wounds = extension_init_data.wounds
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._character_state_read_component = unit_data_extension:read_component("character_state")
end

PlayerHuskHealthExtension.fixed_update = function (self, unit, dt, t)
	self._is_knocked_down = PlayerUnitStatus.is_knocked_down(self._character_state_read_component)
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	self._health = GameSession.game_object_field(game_session, game_object_id, "health")
	self._damage = GameSession.game_object_field(game_session, game_object_id, "damage")
	self._permanent_damage = GameSession.game_object_field(game_session, game_object_id, "permanent_damage")
	self._knocked_down_health = GameSession.game_object_field(game_session, game_object_id, "knocked_down_health")
	self._knocked_down_damage = GameSession.game_object_field(game_session, game_object_id, "knocked_down_damage")
	self._max_wounds = GameSession.game_object_field(game_session, game_object_id, "max_wounds")
end

PlayerHuskHealthExtension.is_alive = function (self)
	return not self._is_dead
end

PlayerHuskHealthExtension.is_unkillable = function (self)
	return false
end

PlayerHuskHealthExtension.is_invulnerable = function (self)
	return false
end

PlayerHuskHealthExtension.current_damaged_health = function (self)
	local max_health = self:max_health()
	local damage_taken = self:damage_taken()

	return math.max(0, max_health - damage_taken)
end

PlayerHuskHealthExtension.current_health = function (self)
	local max_health = self:max_health()
	local damage_taken = self:damage_taken()

	return math.max(0, max_health - damage_taken)
end

PlayerHuskHealthExtension.current_damaged_health_percent = function (self)
	local damaged_max_health = self:damaged_max_health()
	local damage_taken = self:damage_taken()

	if damaged_max_health <= 0 then
		return 0
	end

	return math.max(0, 1 - damage_taken / damaged_max_health)
end

PlayerHuskHealthExtension.current_health_percent = function (self)
	local max_health = self:max_health()
	local damage_taken = self:damage_taken()

	if max_health <= 0 then
		return 0
	end

	return math.max(0, 1 - damage_taken / max_health)
end

PlayerHuskHealthExtension.damage_taken = function (self)
	if self._is_knocked_down then
		return self._knocked_down_damage
	else
		return self._damage
	end
end

PlayerHuskHealthExtension.permanent_damage_taken = function (self)
	if self._is_knocked_down then
		return 0
	else
		return self._permanent_damage
	end
end

PlayerHuskHealthExtension.permanent_damage_taken_percent = function (self)
	local max_health = self:max_health()
	local permanent_damage = self:permanent_damage_taken()

	if max_health <= 0 then
		return 0
	end

	return permanent_damage / max_health
end

PlayerHuskHealthExtension.total_damage_taken = function (self)
	local max_health = self:max_health()
	local damage_taken = self:damage_taken()

	return math.min(max_health, damage_taken)
end

PlayerHuskHealthExtension.damaged_max_health = function (self)
	local max_health = self:max_health()

	return max_health
end

PlayerHuskHealthExtension.max_health = function (self)
	if self._is_knocked_down then
		return self._knocked_down_health
	else
		return self._health
	end
end

PlayerHuskHealthExtension.add_damage = function (self)
	fassert(false, "Not allowed to call PlayerHuskHealthExtension:add_damage() on husks!")
end

PlayerHuskHealthExtension.add_heal = function (self)
	fassert(false, "Not allowed to call PlayerHuskHealthExtension:add_heal() on husks!")
end

PlayerHuskHealthExtension.remove_wounds = function (self)
	fassert(false, "Not allowed to call PlayerHuskHealthExtension:remove_wounds() on husks!")
end

PlayerHuskHealthExtension.entered_knocked_down = function (self)
	fassert(false, "Not allowed to call PlayerHuskHealthExtension:entered_knocked_down() on husks!")
end

PlayerHuskHealthExtension.exited_knocked_down = function (self)
	fassert(false, "Not allowed to call PlayerHuskHealthExtension:exited_knocked_down() on husks!")
end

PlayerHuskHealthExtension.health_depleted = function (self)
	local max_health = self:max_health()
	local damage = self:damage_taken()

	return max_health <= damage
end

PlayerHuskHealthExtension.should_die = function (self)
	local num_wounds = self:num_wounds()

	if num_wounds <= 0 then
		return true
	end

	local max_health = self:max_health()
	local permanent_damage = self:permanent_damage_taken()

	if max_health <= 0 then
		return true
	end

	return permanent_damage / max_health > 1 / num_wounds
end

PlayerHuskHealthExtension.set_unkillable = function (self, should_be_unkillable)
	fassert(false, "Not allowed to call PlayerHuskHealthExtension:set_unkillable() on husks!")
end

PlayerHuskHealthExtension.set_invulnerable = function (self, should_be_invulnerable)
	fassert(false, "Not allowed to call PlayerHuskHealthExtension:set_invulnerable() on husks!")
end

PlayerHuskHealthExtension.kill = function (self)
	self._is_dead = true
	local side_system = Managers.state.extension:system("side_system")

	side_system:remove_unit_from_tag_units(self._unit)

	HEALTH_ALIVE[self._unit] = nil
end

PlayerHuskHealthExtension._calculate_num_wounds = function (self)
	local max_wounds = self:max_wounds()
	local max_health = self:max_health()
	local permanent_damage = self:permanent_damage_taken()
	local health_per_wound = (max_wounds > 0 and max_health / max_wounds) or 0

	if health_per_wound <= 0 then
		return 0
	end

	local wanted_wounds = math.max(max_wounds - math.floor(permanent_damage / health_per_wound), 0)

	return wanted_wounds
end

PlayerHuskHealthExtension.num_wounds = function (self)
	return self:_calculate_num_wounds()
end

PlayerHuskHealthExtension.max_wounds = function (self)
	return self._max_wounds
end

implements(PlayerHuskHealthExtension, HealthExtensionInterface)

return PlayerHuskHealthExtension
