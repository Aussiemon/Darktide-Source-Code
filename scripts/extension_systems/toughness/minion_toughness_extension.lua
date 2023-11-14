local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Explosion = require("scripts/utilities/attack/explosion")
local Stagger = require("scripts/utilities/attack/stagger")
local MinionToughnessExtension = class("MinionToughnessExtension")

MinionToughnessExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._world = extension_init_context.world
	self._physics_world = extension_init_context.physics_world
	self._unit = unit
	local breed = extension_init_data.breed
	local toughness_template = breed.toughness_template

	self:_initialize_toughness(unit, toughness_template)

	game_object_data.toughness = self._max_toughness
	self._toughness_template = toughness_template
	local blackboard = BLACKBOARDS[unit]
	self._blackboard = blackboard

	self:_init_blackboard_components(blackboard)

	local fx_system = Managers.state.extension:system("fx_system")
	self._fx_system = fx_system
	local health_extension = ScriptUnit.extension(unit, "health_system")
	self._health_extension = health_extension
	self._is_invulnerable = false
	self._stored_attacks = {}
end

MinionToughnessExtension._init_blackboard_components = function (self, blackboard)
	local toughness_component = Blackboard.write_component(blackboard, "toughness")
	self._toughness_component = toughness_component
	toughness_component.max_toughness = self:max_toughness()
	toughness_component.toughness_damage = self:toughness_damage()
	toughness_component.toughness_percent = self:current_toughness_percent()
end

MinionToughnessExtension._initialize_toughness = function (self, unit, toughness_template)
	local max_toughness = Managers.state.difficulty:get_table_entry_by_challenge(toughness_template.max)
	self._max_toughness = max_toughness
	self._toughness_damage = toughness_template.start_depleted and max_toughness or 0

	if toughness_template.start_depleted then
		local linked_actor_name = toughness_template.linked_actor

		if linked_actor_name then
			self:_set_linked_actor_active(linked_actor_name, false)
		end
	end

	self._toughness_regen_delay = 0
	local session = self._game_session

	if session then
		GameSession.set_game_object_field(session, self._game_object_id, "toughness", max_toughness)
	end

	local linked_actor_name = toughness_template.linked_actor

	if linked_actor_name then
		local linked_actor_id = Unit.find_actor(unit, linked_actor_name)
	end
end

MinionToughnessExtension._set_blackboard_values = function (self)
	local toughness_component = self._toughness_component
	toughness_component.max_toughness = self:max_toughness()
	toughness_component.toughness_damage = self:toughness_damage()
	toughness_component.toughness_percent = self:current_toughness_percent()
end

MinionToughnessExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
	local toughness_template = self._toughness_template
	local effect_template = toughness_template.effect_template

	if effect_template then
		local fx_system = self._fx_system
		local unit = self._unit
		self._global_effect_id = fx_system:start_template_effect(effect_template, unit)
	end
end

MinionToughnessExtension.destroy = function (self)
	local toughness_template = self._toughness_template
	local linked_actor_name = toughness_template.linked_actor

	if linked_actor_name then
		self:_set_linked_actor_active(linked_actor_name, false)
	end
end

MinionToughnessExtension.update = function (self, context, dt, t)
	self:_update_toughness(dt, t)
end

MinionToughnessExtension.max_toughness = function (self)
	return self._max_toughness
end

MinionToughnessExtension.toughness_damage = function (self)
	return self._toughness_damage
end

MinionToughnessExtension.set_toughness_damage = function (self, damage, reactivation_override)
	self._toughness_damage = damage

	if reactivation_override then
		self._reactivate_override = true
	end
end

MinionToughnessExtension.time_since_toughness_broken = function (self)
	return math.huge
end

MinionToughnessExtension.current_toughness_percent = function (self)
	local max_toughness = self:max_toughness()
	local toughness_damage = self:toughness_damage()

	return 1 - toughness_damage / max_toughness
end

MinionToughnessExtension._update_toughness = function (self, dt, t)
	local toughness_template = self._toughness_template
	local toughness_damage = self._toughness_damage
	local max_toughness = self._max_toughness
	local toughness_regen_delay = self._toughness_regen_delay
	local was_depleted = max_toughness <= self._toughness_damage

	if self._override_regen_speed then
		local regen_rate = self._override_regen_speed
		self._toughness_damage = math.max(toughness_damage - regen_rate * dt, 0)
	end

	if toughness_damage > 0 then
		local regenerate_full_delay = self._regenerate_full_delay

		if regenerate_full_delay and self._max_toughness <= toughness_damage then
			if regenerate_full_delay < t then
				self._toughness_damage = 0
				self._regenerate_full_delay = nil
				self._min_health_allowed = nil
			end
		elseif toughness_regen_delay < t and not self._override_regen_speed then
			local regen_rate = toughness_template.regeneration_speed
			self._toughness_damage = math.max(toughness_damage - regen_rate * dt, 0)
		end

		local min_health_allowed = self._min_health_allowed

		if min_health_allowed and min_health_allowed > 0 then
			local health_extension = self._health_extension
			local current_health = health_extension:current_health()

			if current_health <= min_health_allowed then
				self._toughness_damage = 0
				self._regenerate_full_delay = nil
				self._min_health_allowed = nil
			end
		end

		GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", self._toughness_damage)
	end

	local is_depleted = max_toughness <= self._toughness_damage
	local was_reactivated = self._reactivate_override or was_depleted and not is_depleted

	if was_reactivated then
		local depleted_settings = toughness_template.depleted_settings

		if depleted_settings and depleted_settings.stagger_strength_multiplier then
			local stagger_component = Blackboard.write_component(self._blackboard, "stagger")
			stagger_component.stagger_strength_multiplier = 0
		end

		local reactivated_settings = toughness_template.reactivated_settings

		if reactivated_settings then
			local unit = self._unit
			local fx_system = self._fx_system
			local sfx = reactivated_settings.sfx

			if sfx then
				fx_system:trigger_wwise_event(sfx, nil, unit, nil)
			end

			local vfx = reactivated_settings.vfx

			if vfx then
				local position = POSITION_LOOKUP[unit]

				fx_system:trigger_vfx(vfx, position, nil)
			end
		end

		local linked_actor_name = toughness_template.linked_actor

		if linked_actor_name then
			self:_set_linked_actor_active(linked_actor_name, true)
		end

		self._should_explode = false
		self._reactivate_override = nil
	elseif self._should_explode then
		local unit = self._unit
		local depleted_settings = toughness_template.depleted_settings
		local explosion_template = depleted_settings.explosion_template
		local power_level = depleted_settings.explosion_power_level

		self:_explode(unit, explosion_template, power_level)

		self._should_explode = false
	end

	self:_set_blackboard_values()
end

MinionToughnessExtension.add_damage = function (self, damage_amount, attack_result, hit_actor, damage_profile, attack_type, attack_direction, hit_world_position_or_nil)
	if self._is_invulnerable then
		return
	end

	local toughness_template = self._toughness_template
	local toughness_damage = self._toughness_damage
	local max_toughness = self._max_toughness
	local t = Managers.time:time("gameplay")
	local absorbed_attack = false

	if toughness_damage < max_toughness then
		local new_toughness_damage = toughness_damage + damage_amount
		local clamped_toughness_damage = math.clamp(new_toughness_damage, 0, max_toughness)
		local depleted = max_toughness <= clamped_toughness_damage
		local behavior_component = Blackboard.write_component(self._blackboard, "behavior")
		local clamp_toughness_until_condition = toughness_template.clamp_toughness_until_condition

		if clamp_toughness_until_condition and not behavior_component[clamp_toughness_until_condition] then
			clamped_toughness_damage = math.clamp(new_toughness_damage, 0, max_toughness - 0.01)
		end

		self._toughness_damage = clamped_toughness_damage

		GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", clamped_toughness_damage)

		if depleted then
			local regenerate_full_delay = Managers.state.difficulty:get_table_entry_by_challenge(toughness_template.regenerate_full_delay)

			if regenerate_full_delay and not self._regenerate_full_delay then
				self._regenerate_full_delay = t + regenerate_full_delay
			end

			local depleted_settings = toughness_template.depleted_settings

			if depleted_settings.set_toughness_broke_behavior then
				behavior_component.toughness_broke = true
			end

			if toughness_template.break_shield_when_depleted then
				self:break_shield(attack_direction)
			end
		end

		absorbed_attack = clamped_toughness_damage < max_toughness
	end

	if absorbed_attack then
		local hit_world_position = hit_world_position_or_nil or hit_actor and Actor.position(hit_actor) or POSITION_LOOKUP[self._unit]

		self:_store_toughness_attack_absorbed(damage_amount, hit_world_position)

		local game_object_id = self._game_object_id

		Managers.state.game_session:send_rpc_clients("rpc_minion_toughness_attack_absorbed", game_object_id, hit_world_position, damage_amount)
	end

	self._toughness_regen_delay = t + toughness_template.regeneration_delay
end

MinionToughnessExtension.set_invulnerable = function (self, should_be_invulnerable)
	self._is_invulnerable = should_be_invulnerable
end

MinionToughnessExtension.break_shield = function (self, attack_direction, optional_ignore_stagger, optional_regenerate_full_delay_t)
	local toughness_template = self._toughness_template
	local depleted_settings = toughness_template.depleted_settings

	if depleted_settings then
		local unit = self._unit
		local stagger_duration = not optional_ignore_stagger and Managers.state.difficulty:get_table_entry_by_challenge(depleted_settings.stagger_duration)

		if stagger_duration then
			local stagger_type = depleted_settings.stagger_type

			Stagger.force_stagger(unit, stagger_type, attack_direction, stagger_duration, 1, stagger_duration)
		end

		if optional_regenerate_full_delay_t then
			self._regenerate_full_delay = optional_regenerate_full_delay_t
		end

		local stagger_strength_multiplier = depleted_settings.stagger_strength_multiplier

		if stagger_strength_multiplier then
			local stagger_component = Blackboard.write_component(self._blackboard, "stagger")
			stagger_component.stagger_strength_multiplier = stagger_strength_multiplier
		end

		local fx_system = self._fx_system
		local sfx = depleted_settings.sfx

		if sfx then
			fx_system:trigger_wwise_event(sfx, nil, unit, nil)
		end

		local vfx = depleted_settings.vfx

		if vfx then
			local position = POSITION_LOOKUP[unit]

			fx_system:trigger_vfx(vfx, position, nil)
		end

		local max_health_loss_percent = depleted_settings.max_health_loss_percent and Managers.state.difficulty:get_table_entry_by_challenge(depleted_settings.max_health_loss_percent)

		if max_health_loss_percent then
			local health_extension = self._health_extension
			local current_health = health_extension:current_health()
			local max_health = health_extension:max_health()
			local max_health_loss_allowed = max_health * max_health_loss_percent
			local min_health_allowed = math.clamp(current_health - max_health_loss_allowed, 0, max_health)
			self._min_health_allowed = min_health_allowed
		end

		local linked_actor_name = toughness_template.linked_actor

		if linked_actor_name then
			self:_set_linked_actor_active(linked_actor_name, false)
		end

		if depleted_settings.explosion_template then
			self._should_explode = true
		end
	end
end

MinionToughnessExtension.stored_attacks = function (self)
	return self._stored_attacks
end

MinionToughnessExtension._explode = function (self, unit, explosion_template, power_level)
	local charge_level = 1
	local explosion_attack_type = AttackSettings.attack_types.explosion
	local up = Quaternion.up(Unit.local_rotation(unit, 1))
	local explosion_position = POSITION_LOOKUP[unit] + up * 0.1

	Explosion.create_explosion(self._world, self._physics_world, explosion_position, up, unit, explosion_template, power_level, charge_level, explosion_attack_type)
end

MinionToughnessExtension._store_toughness_attack_absorbed = function (self, damage_amount, impact_world_position)
	local attack = {
		damage_amount = damage_amount,
		impact_world_position = Vector3Box(impact_world_position)
	}
	local stored_attacks = self._stored_attacks

	table.insert(stored_attacks, attack)
end

MinionToughnessExtension._set_linked_actor_active = function (self, linked_actor_name, active)
	local unit = self._unit
	local actor_id = Unit.find_actor(unit, linked_actor_name)
	local actor = Unit.actor(unit, actor_id)

	Actor.set_collision_enabled(actor, active)
	Actor.set_scene_query_enabled(actor, active)
end

MinionToughnessExtension.toughness_templates = function (self)
	return self._toughness_template, nil
end

MinionToughnessExtension.is_stagger_immune = function (self)
	local toughness_template = self._toughness_template

	return toughness_template.stagger_immune_while_active and self._toughness_damage < self._max_toughness
end

MinionToughnessExtension.set_override_regen_speed = function (self, speed)
	self._override_regen_speed = speed
end

return MinionToughnessExtension
