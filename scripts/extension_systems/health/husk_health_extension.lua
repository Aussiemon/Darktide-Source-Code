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

HuskHealthExtension.is_alive = function (self)
	return not self.is_dead
end

HuskHealthExtension.is_unkillable = function (self)
	return false
end

HuskHealthExtension.is_invulnerable = function (self)
	return false
end

HuskHealthExtension.current_damaged_health = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	return math.max(0, health - damage)
end

HuskHealthExtension.current_health = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	return math.max(0, health - damage)
end

HuskHealthExtension.current_damaged_health_percent = function (self)
	local health, damage, _ = _health_and_damage(self.game_session, self.game_object_id)

	if health <= 0 then
		return 0
	end

	return math.max(0, 1 - damage / health)
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

	return damage / health
end

HuskHealthExtension.total_damage_taken = function (self)
	local health, damage = _health_and_damage(self.game_session, self.game_object_id)

	return math.min(health, damage)
end

HuskHealthExtension.damaged_max_health = function (self)
	local health, _ = _health_and_damage(self.game_session, self.game_object_id)

	return math.max(0, health)
end

HuskHealthExtension.max_health = function (self)
	return GameSession.game_object_field(self.game_session, self.game_object_id, "health")
end

HuskHealthExtension.add_damage = function (self)
	fassert(false, "Not allowed to call HuskHealthExtension:add_damage() on husks!")
end

HuskHealthExtension.add_heal = function (self)
	fassert(false, "Not allowed to call HuskHealthExtension:add_heal() on husks!")
end

HuskHealthExtension.health_depleted = function (self)
	fassert(false, "Not allowed to call HuskHealthExtension:health_depleted() on husks!")
end

HuskHealthExtension.set_unkillable = function (self)
	fassert(false, "Not allowed to call HuskHealthExtension:set_unkillable() on husks!")
end

HuskHealthExtension.set_invulnerable = function (self)
	fassert(false, "Not allowed to call HuskHealthExtension:set_invulnerable() on husks!")
end

HuskHealthExtension.num_wounds = function (self)
	return 1
end

HuskHealthExtension.max_wounds = function (self)
	return 1
end

implements(HuskHealthExtension, HealthExtensionInterface)

return HuskHealthExtension
