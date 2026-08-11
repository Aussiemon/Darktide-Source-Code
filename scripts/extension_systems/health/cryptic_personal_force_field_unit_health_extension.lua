-- chunkname: @scripts/extension_systems/health/cryptic_personal_force_field_unit_health_extension.lua

local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HealthExtensionInterface = require("scripts/extension_systems/health/health_extension_interface")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local force_field_ability_talent_settings = TalentSettings.cryptic.force_field
local CrypticPersonalForceFieldUnitHealthExtension = class("CrypticPersonalForceFieldUnitHealthExtension", "HealthExtensionBase")

CrypticPersonalForceFieldUnitHealthExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._is_server = extension_init_context.is_server
	self._world = extension_init_context.world
	self._owner_unit = extension_init_data.owner_unit
	self._unit = unit
	self._next_allowed_t = 0
	self._max_health = 1
	self._invincible = true
	self._health = 1
	self._local_damage = 1
	self._damage_cooldown = 1
	self._is_dead = false
	self._damage_taken_total = 0
	self._is_expired = false

	if self._is_server and self._owner_unit then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn

		self._owner_player = player_unit_spawn_manager:owner(self._owner_unit)

		local owner_talent_extension = ScriptUnit.has_extension(self._owner_unit, "talent_system")

		self._create_arcs_on_expire = owner_talent_extension and owner_talent_extension:has_special_rule("cryptic_force_field_generates_arcs_based_on_hits_blocked")
		self._num_ranged_attacks_received = 0
	end
end

CrypticPersonalForceFieldUnitHealthExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "health", self._max_health)
	GameSession.set_game_object_field(self._game_session, self._game_object_id, "damage", 0)

	self._health_extension = ScriptUnit.extension(self._unit, "health_system")
end

CrypticPersonalForceFieldUnitHealthExtension.pre_update = function (self, unit, dt, t)
	self._was_hit_by_critical_hit_this_render_frame = false
end

CrypticPersonalForceFieldUnitHealthExtension.fixed_update = function (self, unit, dt, t)
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local is_expired = GameSession.game_object_field(game_session, game_object_id, "expired")

	if not self._is_expired and is_expired then
		self._is_expired = is_expired

		self:kill()
	end
end

CrypticPersonalForceFieldUnitHealthExtension.add_damage = function (self, damage_amount, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit)
	if self._is_server then
		local is_ranged_attack = attack_type == "ranged" or damage_profile and damage_profile.count_as_ranged_attack

		if is_ranged_attack then
			self._num_ranged_attacks_received = self._num_ranged_attacks_received + 1
		end

		self:send_stat_data(damage_amount, damage_profile, attack_type)
	end
end

CrypticPersonalForceFieldUnitHealthExtension.tried_adding_damage = function (self, damage_amount, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit)
	if self._is_server then
		local is_ranged_attack = attack_type == "ranged" or damage_profile and damage_profile.count_as_ranged_attack

		if is_ranged_attack then
			self._num_ranged_attacks_received = self._num_ranged_attacks_received + 1
		end

		self:send_stat_data(damage_amount, damage_profile, attack_type)
	end
end

CrypticPersonalForceFieldUnitHealthExtension._add_damage = function (self, damage)
	if damage then
		self._damage_taken_total = self._damage_taken_total + damage
	end

	local t = Managers.time:time("gameplay")

	if t < self._next_allowed_t then
		return
	end

	self._next_allowed_t = t + self._damage_cooldown

	if self._invincible then
		return
	end

	local game_session = self._game_session
	local game_object_id = self._game_object_id

	self._health = math.max(0, self._health - self._local_damage)

	GameSession.set_game_object_field(game_session, game_object_id, "damage", self._max_health - self._health)
	GameSession.set_game_object_field(game_session, game_object_id, "health", self._health)

	if self._health <= 0 then
		self:kill()
	end
end

CrypticPersonalForceFieldUnitHealthExtension.send_stat_data = function (self, damage_amount, damage_profile, attack_type)
	if self._owner_player then
		Managers.stats:record_private("hook_crytic_force_field_hit", self._owner_player, damage_amount, damage_profile, attack_type)
	end
end

local BROADPHASE_RESULTS = Script.new_array(16)

CrypticPersonalForceFieldUnitHealthExtension.kill = function (self)
	CrypticPersonalForceFieldUnitHealthExtension.super.kill(self)

	self._is_dead = true

	if not self._is_server or not self._owner_unit or not HEALTH_ALIVE[self._owner_unit] or not self._create_arcs_on_expire then
		return
	end

	local num_arcs_based_on_ranged_attacks_received = math.ceil(self._num_ranged_attacks_received / force_field_ability_talent_settings.force_field_arcs.num_hits_needed_per_arc)
	local max_num_arcs = math.clamp(num_arcs_based_on_ranged_attacks_received, 1, force_field_ability_talent_settings.force_field_arcs.max_arcs)

	if max_num_arcs <= 0 then
		return
	end

	local unit_data_extension = ScriptUnit.extension(self._owner_unit, "unit_data_system")
	local first_person_component = unit_data_extension:read_component("first_person")
	local player_rotation = first_person_component.rotation
	local player_forward_flat = Vector3.normalize(Vector3.flat(Quaternion.forward(player_rotation)))
	local fx_system = Managers.state.extension:system("fx_system")
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[self._owner_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local player_position = POSITION_LOOKUP[self._owner_unit]
	local arc_source_position = player_position + Vector3.multiply(Vector3.up(), 0.8)
	local broadphase_radius = force_field_ability_talent_settings.force_field_arcs.broadphase_radius
	local template_effect_name = "force_field_arc_chain_lightning_source"
	local template_effect = EffectTemplates[template_effect_name]
	local num_arcs_created = 0
	local num_hits = broadphase.query(broadphase, player_position, broadphase_radius, BROADPHASE_RESULTS, enemy_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]
		local enemy_unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
		local breed = enemy_unit_data_extension and enemy_unit_data_extension:breed()
		local untargetable = breed and breed.is_untargetable

		if HEALTH_ALIVE[enemy_unit] and not untargetable then
			local enemy_position = POSITION_LOOKUP[enemy_unit]
			local is_enemy_in_front = Vector3.dot(Vector3.normalize(enemy_position - player_position), player_forward_flat) > 0.5

			if is_enemy_in_front then
				num_arcs_created = num_arcs_created + 1

				fx_system:start_player_template_effect(template_effect, self._owner_unit, enemy_unit, nil, arc_source_position)

				if max_num_arcs <= num_arcs_created then
					break
				end
			end
		end
	end
end

CrypticPersonalForceFieldUnitHealthExtension.is_dead = function (self)
	return self._is_dead
end

CrypticPersonalForceFieldUnitHealthExtension.add_heal = function (self, heal_amount, heal_type)
	return
end

CrypticPersonalForceFieldUnitHealthExtension.max_health = function (self)
	return self._max_health
end

CrypticPersonalForceFieldUnitHealthExtension.current_health = function (self)
	return self._health
end

CrypticPersonalForceFieldUnitHealthExtension.current_health_percent = function (self)
	if self._max_health <= 0 then
		return 0
	end

	return self._health / self._max_health
end

CrypticPersonalForceFieldUnitHealthExtension.damage_taken = function (self)
	return 0
end

CrypticPersonalForceFieldUnitHealthExtension.permanent_damage_taken = function (self)
	return 0
end

CrypticPersonalForceFieldUnitHealthExtension.permanent_damage_taken_percent = function (self)
	return 0
end

CrypticPersonalForceFieldUnitHealthExtension.total_damage_taken = function (self)
	return 0
end

CrypticPersonalForceFieldUnitHealthExtension.health_depleted = function (self)
	return self._health <= 0
end

CrypticPersonalForceFieldUnitHealthExtension.is_alive = function (self)
	return not self._is_dead
end

CrypticPersonalForceFieldUnitHealthExtension.is_unkillable = function (self)
	return true
end

CrypticPersonalForceFieldUnitHealthExtension.is_invulnerable = function (self)
	return true
end

CrypticPersonalForceFieldUnitHealthExtension.set_unkillable = function (self, should_be_unkillable)
	self._is_unkillable = should_be_unkillable
end

CrypticPersonalForceFieldUnitHealthExtension.set_invulnerable = function (self, should_be_invulnerable)
	self._is_invulnerable = should_be_invulnerable
end

CrypticPersonalForceFieldUnitHealthExtension.set_last_damaging_unit = function (self, last_damaging_unit, hit_zone_name, last_hit_was_critical)
	self._last_damaging_unit = last_damaging_unit
	self._last_hit_zone_name = hit_zone_name
	self._last_hit_was_critical = last_hit_was_critical
	self._was_hit_by_critical_hit_this_render_frame = self._was_hit_by_critical_hit_this_render_frame or last_hit_was_critical
end

CrypticPersonalForceFieldUnitHealthExtension.last_damaging_unit = function (self)
	return self._last_damaging_unit
end

CrypticPersonalForceFieldUnitHealthExtension.last_hit_zone_name = function (self)
	return self._last_hit_zone_name
end

CrypticPersonalForceFieldUnitHealthExtension.last_hit_was_critical = function (self)
	return self._last_hit_was_critical
end

CrypticPersonalForceFieldUnitHealthExtension.was_hit_by_critical_hit_this_render_frame = function (self)
	return self._was_hit_by_critical_hit_this_render_frame
end

CrypticPersonalForceFieldUnitHealthExtension.num_wounds = function (self)
	return 1
end

CrypticPersonalForceFieldUnitHealthExtension.max_wounds = function (self)
	return 1
end

implements(CrypticPersonalForceFieldUnitHealthExtension, HealthExtensionInterface)

return CrypticPersonalForceFieldUnitHealthExtension
