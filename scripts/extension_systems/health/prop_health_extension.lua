-- chunkname: @scripts/extension_systems/health/prop_health_extension.lua

local Component = require("scripts/utilities/component")
local HealthExtensionInterface = require("scripts/extension_systems/health/health_extension_interface")
local PropDifficultySettings = require("scripts/settings/difficulty/prop_difficulty_settings")
local PropHealthExtension = class("PropHealthExtension")

PropHealthExtension.UPDATE_DISABLED_BY_DEFAULT = true

PropHealthExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._owner_system = extension_init_context.owner_system

	local is_server = extension_init_context.is_server

	self._unit = unit
	self._is_server = is_server
	self._health = 100
	self._damage = 0
	self._is_dead = false
	self._is_unkillable = false
	self._is_invulnerable = false
	self._regenerate_health = false
	self._breed_white_list = nil
	self._ignored_colliders = {}
	self._update_enabled = not PropHealthExtension.UPDATE_DISABLED_BY_DEFAULT
	self._speed_on_hit = 0
end

PropHealthExtension.setup_from_component = function (self, create_health_game_object, health, difficulty_scaling, invulnerable, unkillable, regenerate_health, breed_white_list, ignored_collider_actor_names, speed_on_hit)
	if not self._is_server then
		return
	end

	if difficulty_scaling then
		local health_scale = Managers.state.difficulty:get_table_entry_by_challenge(PropDifficultySettings.health_scaling)

		health = health * health_scale
	end

	self._health = health
	self._damage = 0
	self._is_invulnerable = invulnerable
	self._is_unkillable = unkillable
	self._regenerate_health = regenerate_health
	self._create_health_game_object = create_health_game_object

	if breed_white_list then
		local white_list = {}

		for ii = 1, #breed_white_list do
			white_list[breed_white_list[ii]] = true
		end

		self._breed_white_list = white_list
	end

	self._speed_on_hit = speed_on_hit

	if ignored_collider_actor_names then
		local unit = self._unit

		for ii = 1, #ignored_collider_actor_names do
			local actor = Unit.actor(unit, ignored_collider_actor_names[ii])

			self._ignored_colliders[actor] = true
		end
	end

	if regenerate_health and not self._update_enabled then
		self._update_enabled = true

		self._owner_system:enable_update_function(self.__class_name, "fixed_update", self._unit, self)
	end
end

PropHealthExtension.on_unit_id_resolved = function (self, world, unit)
	if self._is_server and self._create_health_game_object then
		self:_create_game_object()
	end
end

PropHealthExtension.destroy = function (self)
	if self._is_server and self._game_object_id then
		self:_destroy_game_object()
	end
end

PropHealthExtension._create_game_object = function (self)
	local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(self._unit)
	local game_object_data = {
		game_object_type = NetworkLookup.game_object_types.prop_health,
		is_level_unit = is_level_unit,
		unit_id = unit_id,
		health = self._health,
		damage = self._damage,
		is_dead = self._is_dead,
	}
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = GameSession.create_game_object(game_session, "prop_health", game_object_data)

	self._game_session = game_session
	self._game_object_id = game_object_id
end

PropHealthExtension._destroy_game_object = function (self)
	GameSession.destroy_game_object(self._game_session, self._game_object_id)

	self._game_session = nil
	self._game_object_id = nil
end

PropHealthExtension.on_game_object_created = function (self, game_session, game_object_id)
	self._game_session = game_session
	self._game_object_id = game_object_id

	if not self._update_enabled then
		self._update_enabled = true

		self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)
	end
end

PropHealthExtension.on_game_object_destroyed = function (self, game_session, game_object_id)
	self._game_session = nil
	self._game_object_id = nil

	if self._update_enabled then
		self._update_enabled = false

		self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
	end
end

PropHealthExtension.pre_update = function (self, unit, dt, t)
	self._was_hit_by_critical_hit_this_render_frame = false
end

PropHealthExtension.fixed_update = function (self, unit, dt, t)
	if self._is_dead or not self._regenerate_health or not self._is_server then
		return
	end

	local damage = self._damage

	if damage > 0 then
		local current_health_percent = self:current_health_percent()
		local heal_multiplier = math.lerp(1, 5, 1 - current_health_percent)
		local heal_amount = self._health * 0.05 * heal_multiplier * dt
		local heal_type

		self:add_heal(heal_amount, heal_type)
	end
end

PropHealthExtension.update = function (self, unit, dt, t)
	local game_session = self._game_session
	local game_object_id = self._game_object_id

	if self._is_server or not game_session or not game_object_id then
		return
	end

	local was_dead = self._is_dead

	self._damage = GameSession.game_object_field(game_session, game_object_id, "damage")
	self._health = GameSession.game_object_field(game_session, game_object_id, "health")
	self._is_dead = GameSession.game_object_field(game_session, game_object_id, "is_dead")

	if not was_dead and self._is_dead then
		self:_died()

		if self._update_enabled then
			self._update_enabled = false

			self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
		end
	end
end

PropHealthExtension.kill = function (self)
	if self._is_unkillable then
		Log.warning("PropHealthExtension", "Trying to kill prop health extension which is unkillable")

		return
	end

	self._is_dead = true

	if self._game_object_id then
		GameSession.set_game_object_field(self._game_session, self._game_object_id, "is_dead", true)
	end

	self:_died()
end

PropHealthExtension._died = function (self)
	Component.event(self._unit, "unit_died")
	Unit.flow_event(self._unit, "lua_prop_died")

	HEALTH_ALIVE[self._unit] = nil
end

local function _add_force_on_parts(actor, mass, speed, attack_direction)
	local direction = attack_direction

	if not direction then
		local random_x = math.random() * 2 - 1
		local random_y = math.random() * 2 - 1
		local random_z = math.random() * 2 - 1
		local random_direction = Vector3(random_x, random_y, random_z)

		random_direction = Vector3.normalize(random_direction)
		direction = random_direction
	end

	Actor.add_impulse(actor, direction * mass * speed)
end

PropHealthExtension.add_damage = function (self, damage_amount, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit)
	if self._ignored_colliders[hit_actor] then
		return 0
	end

	if not self:_can_receive_damage(attacking_unit, attack_type) then
		return 0
	end

	local current_damage = self._damage
	local health = self._health
	local new_damage = current_damage + damage_amount
	local game_session = self._game_session
	local game_object_id = self._game_object_id

	if game_session and game_object_id then
		local network_damage = math.min(new_damage, health)

		GameSession.set_game_object_field(game_session, game_object_id, "damage", network_damage)
	end

	self._damage = new_damage

	if hit_actor and Actor.is_dynamic(hit_actor) then
		_add_force_on_parts(hit_actor, Actor.mass(hit_actor), self._speed_on_hit, attack_direction)
	end

	local unit = self._unit

	Component.event(unit, "add_damage", damage_amount, hit_actor, attack_direction, attacking_unit)
	Component.event(unit, "on_hit", attack_direction, attacking_unit)
	Unit.set_flow_variable(unit, "lua_prop_health_percentage", health - new_damage / health)
	Unit.flow_event(unit, "lua_prop_damaged")

	if health <= new_damage then
		self:kill()
	end

	return damage_amount
end

PropHealthExtension.add_heal = function (self, heal_amount, heal_type)
	local health = self._health
	local old_damage = self._damage
	local actual_heal_amount = math.min(heal_amount, old_damage)
	local new_damage = old_damage - actual_heal_amount
	local game_session = self._game_session
	local game_object_id = self._game_object_id

	if game_session and game_object_id then
		local network_damage = math.min(new_damage, health)

		GameSession.set_game_object_field(game_session, game_object_id, "damage", network_damage)
	end

	self._damage = new_damage

	return actual_heal_amount
end

PropHealthExtension.set_last_damaging_unit = function (self, last_damaging_unit, hit_zone_name, last_hit_was_critical)
	self._last_damaging_unit = last_damaging_unit
	self._last_hit_zone_name = hit_zone_name
	self._last_hit_was_critical = last_hit_was_critical
	self._was_hit_by_critical_hit_this_render_frame = self._was_hit_by_critical_hit_this_render_frame or last_hit_was_critical
end

PropHealthExtension.last_damaging_unit = function (self)
	return self._last_damaging_unit
end

PropHealthExtension.last_hit_zone_name = function (self)
	return self._last_hit_zone_name
end

PropHealthExtension.last_hit_was_critical = function (self)
	return self._last_hit_was_critical
end

PropHealthExtension.was_hit_by_critical_hit_this_render_frame = function (self)
	return self._was_hit_by_critical_hit_this_render_frame
end

PropHealthExtension.max_health = function (self)
	return self._health
end

PropHealthExtension.current_health = function (self)
	return math.max(0, self._health - self._damage)
end

PropHealthExtension.current_health_percent = function (self)
	local health = self._health

	if health <= 0 then
		return 0
	end

	return math.max(0, 1 - self._damage / health)
end

PropHealthExtension.damage_taken = function (self)
	return self._damage
end

PropHealthExtension.permanent_damage_taken = function (self)
	return 0
end

PropHealthExtension.permanent_damage_taken_percent = function (self)
	return 0
end

PropHealthExtension.total_damage_taken = function (self)
	return math.min(self._health, self._damage)
end

PropHealthExtension.health_depleted = function (self)
	if self._is_unkillable then
		return false
	else
		return self._damage >= self._health
	end
end

PropHealthExtension.is_alive = function (self)
	return not self._is_dead
end

PropHealthExtension.is_unkillable = function (self)
	return self._is_unkillable
end

PropHealthExtension.is_invulnerable = function (self)
	return self._is_invulnerable
end

PropHealthExtension.set_unkillable = function (self, should_be_unkillable)
	if not self._is_server then
		return
	end

	self._is_unkillable = should_be_unkillable
end

PropHealthExtension.set_invulnerable = function (self, should_be_invulnerable)
	if not self._is_server then
		return
	end

	self._is_invulnerable = should_be_invulnerable
end

PropHealthExtension.num_wounds = function (self)
	return 1
end

PropHealthExtension.max_wounds = function (self)
	return 1
end

PropHealthExtension.create_health_game_object = function (self)
	return self._create_health_game_object
end

PropHealthExtension._can_receive_damage = function (self, attacking_unit, attack_type)
	if attacking_unit == self._unit then
		return true
	end

	if self._is_dead or self._is_invulnerable then
		return false
	end

	if attack_type and attack_type == "door_smash" then
		return true
	end

	local breed_white_list = self._breed_white_list

	if not breed_white_list then
		return true
	end

	local unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")

	if unit_data_extension then
		local breed_name = unit_data_extension:breed_name()

		return breed_white_list[breed_name]
	end

	return false
end

implements(PropHealthExtension, HealthExtensionInterface)

return PropHealthExtension
