local AttackSettings = require("scripts/settings/damage/attack_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local ToughnessOnHit = require("scripts/utilities/toughness/toughness_on_hit")
local attack_types = AttackSettings.attack_types
local toughness_replenish_types = ToughnessSettings.replenish_types
local STANDING_STILL_EPSILON = 0.001
local PlayerUnitToughnessExtension = class("PlayerUnitToughnessExtension")

PlayerUnitToughnessExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	local world = extension_init_context.world
	self._world = world
	self._wwise_world = Wwise.wwise_world(world)
	self._is_local_unit = extension_init_data.is_local_unit
	self._is_human_controlled = extension_init_data.is_human_controlled
	local toughness_template = extension_init_data.toughness_template

	self:_initialize_toughness(toughness_template)

	game_object_data.toughness = self:max_toughness()
	self._toughness_template = toughness_template
	self._fx_extension = ScriptUnit.extension(self._unit, "fx_system")
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	local unit_data_extension = ScriptUnit.extension(self._unit, "unit_data_system")
	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._inventory_component = unit_data_extension:read_component("inventory")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._character_state_component = unit_data_extension:read_component("character_state")
end

PlayerUnitToughnessExtension.extensions_ready = function (self, world, unit)
	self._mood_extension = ScriptUnit.has_extension(unit, "mood_system")
end

PlayerUnitToughnessExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
end

PlayerUnitToughnessExtension.update = function (self, context, dt, t)
	self:_update_toughness(dt, t)

	if self._game_session and self._game_object_id then
		GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness", self:max_toughness())
	end
end

PlayerUnitToughnessExtension.max_toughness_visual = function (self)
	local buffs = self._buff_extension and self._buff_extension:stat_buffs()
	local buff_extra = buffs and buffs.toughness or 0

	return self._max_toughness + buff_extra
end

PlayerUnitToughnessExtension.max_toughness = function (self)
	local buffs = self._buff_extension and self._buff_extension:stat_buffs()
	local buff_extra = buffs and buffs.toughness + buffs.toughness_bonus or 0

	return self._max_toughness + buff_extra
end

PlayerUnitToughnessExtension.toughness_damage = function (self)
	return self._toughness_damage
end

PlayerUnitToughnessExtension.current_toughness_percent_visual = function (self)
	local max_toughness_visual = self:max_toughness_visual()
	local max_toughness = self:max_toughness()
	local bonus_toughness = max_toughness - max_toughness_visual
	local toughness_damage = math.clamp(self._toughness_damage - bonus_toughness, 0, self._toughness_damage)

	return 1 - toughness_damage / self:max_toughness_visual()
end

PlayerUnitToughnessExtension.current_toughness_percent = function (self)
	return 1 - self._toughness_damage / self:max_toughness()
end

PlayerUnitToughnessExtension._update_toughness = function (self, dt, t)
	local toughness_template = self._toughness_template
	local toughness_damage = self._toughness_damage
	local toughness_regen_delay = self._toughness_regen_delay
	local slot_extension = ScriptUnit.extension(self._unit, "slot_system")
	local num_occupied_slots = slot_extension.num_occupied_slots
	local toughness_regen_disabled = self:_toughness_regen_disabled()

	if num_occupied_slots == 0 and toughness_damage > 0 and toughness_regen_delay < t and not toughness_regen_disabled then
		local weapon_toughness_template = self._weapon_extension:toughness_template()
		local unit_data_extension = ScriptUnit.extension(self._unit, "unit_data_system")
		local locomotion_component = unit_data_extension:read_component("locomotion")
		local velocity_magnitude = Vector3.length_squared(locomotion_component.velocity_current)
		local standing_still = velocity_magnitude < STANDING_STILL_EPSILON
		local buffs = self._buff_extension:stat_buffs()
		local base_rate = standing_still and toughness_template.regeneration_speed.moving or toughness_template.regeneration_speed.still
		local weapon_rate_modifier = weapon_toughness_template and (standing_still and weapon_toughness_template.regeneration_speed_modifier.moving or weapon_toughness_template.regeneration_speed_modifier.still) or 1
		local buff_rate_modifier = buffs.toughness_regen_rate_modifier * buffs.toughness_regen_rate_multiplier
		local coherency_rate_modifier = buffs.toughness_coherency_regen_rate_modifier
		coherency_rate_modifier = coherency_rate_modifier + (buffs.toughness_extra_regen_rate or 0)
		local coherency_rate_multiplier = buffs.toughness_coherency_regen_rate_multiplier
		coherency_rate_modifier = coherency_rate_modifier * coherency_rate_multiplier
		local regen_rate = base_rate * weapon_rate_modifier * buff_rate_modifier * coherency_rate_modifier
		local regen_amount = math.min(regen_rate * dt, self._toughness_damage)
		self._toughness_damage = self._toughness_damage - regen_amount

		GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", self._toughness_damage)

		if regen_amount > 0 then
			self:_record_stat(regen_amount, "coherency")
		end
	end
end

PlayerUnitToughnessExtension._initialize_toughness = function (self, toughness_template)
	local toughness_constant = NetworkConstants.toughness
	local min = toughness_constant.min
	local max = toughness_constant.max
	self._max_toughness = toughness_template.max
	self._toughness_damage = 0
	local session = self._game_session

	if session then
		GameSession.set_game_object_field(session, self._game_object_id, "toughness", toughness_template.max)
	end
end

PlayerUnitToughnessExtension.toughness_templates = function (self)
	local weapon_toughness_template = self._weapon_extension:toughness_template()

	return self._toughness_template, weapon_toughness_template
end

PlayerUnitToughnessExtension.recover_toughness = function (self, recovery_type)
	if self:_toughness_regen_disabled() then
		return
	end

	local toughness_template = self._toughness_template
	local max_toughness = self:max_toughness()
	local toughness_damage = self._toughness_damage
	local weapon_toughness_template = self._weapon_extension:toughness_template()
	local modifier = weapon_toughness_template and weapon_toughness_template.recovery_percentage_modifiers[recovery_type] or 1
	local stat_buffs = self._buff_extension:stat_buffs()
	local is_melee_kill = recovery_type == toughness_replenish_types.melee_kill
	local toughness_melee_replenish_stat_buff = is_melee_kill and stat_buffs.toughness_melee_replenish or 1
	local total_toughness_replenish_stat_buff_multiplier = stat_buffs.toughness_replenish_multiplier
	local stat_buff_multiplier = toughness_melee_replenish_stat_buff * total_toughness_replenish_stat_buff_multiplier
	local recovery_percentage = toughness_template.recovery_percentages[recovery_type] * stat_buff_multiplier * modifier
	local new_toughness = math.max(0, toughness_damage - max_toughness * recovery_percentage)
	local network_toughness_damage = math.min(new_toughness, NetworkConstants.toughness.max)
	self._toughness_damage = network_toughness_damage

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", network_toughness_damage)

	local recovered_tougness = toughness_damage - network_toughness_damage

	if recovered_tougness > 0 then
		self:_record_stat(recovered_tougness, recovery_type)
	end
end

PlayerUnitToughnessExtension.recover_percentage_toughness = function (self, fixed_percentage, ignore_stat_buffs, reason)
	if self:_toughness_regen_disabled() then
		return
	end

	local max_toughness = self:max_toughness()
	local toughness_damage = self._toughness_damage

	if not ignore_stat_buffs then
		local stat_buffs = self._buff_extension:stat_buffs()
		local stat_buff_multiplier = stat_buffs.toughness_replenish_multiplier
		fixed_percentage = fixed_percentage * stat_buff_multiplier
	end

	local new_toughness = math.max(0, toughness_damage - max_toughness * fixed_percentage)
	local network_toughness_damage = math.min(new_toughness, NetworkConstants.toughness.max)
	self._toughness_damage = network_toughness_damage

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", network_toughness_damage)

	local recovered_tougness = toughness_damage - network_toughness_damage

	if recovered_tougness > 0 then
		self:_record_stat(recovered_tougness, reason or "unknown")
	end
end

PlayerUnitToughnessExtension.recover_max_toughness = function (self)
	if self:_toughness_regen_disabled() then
		return
	end

	local toughness_damage = self._toughness_damage
	self._toughness_damage = 0

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", 0)

	local recovered_tougness = toughness_damage

	if recovered_tougness > 0 then
		self:_record_stat(recovered_tougness, "unknown")
	end
end

PlayerUnitToughnessExtension.set_toughness_broken_time = function (self)
	local t = Managers.time:time("gameplay")
	self._toughness_broken_at_t = t
end

PlayerUnitToughnessExtension.time_since_toughness_broken = function (self)
	local t = Managers.time:time("gameplay")

	return self._toughness_broken_at_t and t - self._toughness_broken_at_t or math.huge
end

PlayerUnitToughnessExtension.add_damage = function (self, damage_amount, attack_result, hit_actor, damage_profile, attack_type, attack_direction, hit_world_position_or_nil)
	local unit = self._unit
	local weapon_toughness_template = self._weapon_extension:toughness_template()
	local toughness_template = self._toughness_template
	local is_melee = attack_type == attack_types.melee
	local max_toughness = self:max_toughness()
	local toughness_damage = self._toughness_damage
	local new_toughness_damage = toughness_damage + damage_amount
	local clamped_toughness_damage = math.clamp(new_toughness_damage, 0, max_toughness)
	self._toughness_damage = clamped_toughness_damage
	local network_toughness_damage = math.min(clamped_toughness_damage, NetworkConstants.toughness.max)

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", network_toughness_damage)

	if not is_melee then
		if weapon_toughness_template and weapon_toughness_template.optional_on_hit_function_name_override then
			ToughnessOnHit[weapon_toughness_template.optional_on_hit_function_name_override](unit, attack_direction, attack_type)
		elseif toughness_template.optional_on_hit_function then
			toughness_template.optional_on_hit_function(unit, attack_direction)
		end
	end

	local t = Managers.time:time("gameplay")
	local buffs = self._buff_extension:stat_buffs()
	local weapon_modifier = weapon_toughness_template and weapon_toughness_template.regeneration_delay_modifier or 1
	local toughness_regen_delay_buff_modifier = (buffs.toughness_regen_delay_modifier or 1) * (buffs.toughness_regen_delay_multiplier or 1)
	self._toughness_regen_delay = t + toughness_template.regeneration_delay * weapon_modifier * toughness_regen_delay_buff_modifier
end

PlayerUnitToughnessExtension._toughness_regen_disabled = function (self)
	if PlayerUnitStatus.is_knocked_down(self._character_state_component) then
		return true
	end

	if not HEALTH_ALIVE[self._unit] then
		return true
	end

	return false
end

PlayerUnitToughnessExtension._record_stat = function (self, amount, reason)
	if Managers.stats.can_record_stats() then
		local player = Managers.state.player_unit_spawn:owner(self._unit)

		if player and player:is_human_controlled() then
			Managers.stats:record_toughness_regen(player, reason, amount)
		end
	end
end

return PlayerUnitToughnessExtension
