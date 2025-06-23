-- chunkname: @scripts/extension_systems/toughness/player_unit_toughness_extension.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local ToughnessOnHit = require("scripts/utilities/toughness/toughness_on_hit")
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local toughness_replenish_types = ToughnessSettings.replenish_types
local buff_keywords = BuffSettings.keywords
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
	self._stat_coherency_tougness_counter = 0
	self._total_amount_restored = 0

	local toughness_template = extension_init_data.toughness_template

	self:_initialize_toughness(toughness_template)

	game_object_data.toughness = self:max_toughness()
	self._toughness_template = toughness_template
	self._fx_extension = ScriptUnit.extension(unit, "fx_system")
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._inventory_component = unit_data_extension:read_component("inventory")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._character_state_component = unit_data_extension:read_component("character_state")
	self._assisted_state_input_component = unit_data_extension:read_component("assisted_state_input")
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

		local buffs = self._buff_extension and self._buff_extension:stat_buffs()
		local buff_extra = buffs and buffs.toughness_bonus_flat or 0

		GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_bonus", buff_extra)
	end
end

PlayerUnitToughnessExtension.max_toughness_visual = function (self)
	local buffs = self._buff_extension and self._buff_extension:stat_buffs()
	local buff_extra = buffs and buffs.toughness or 0
	local toughness_bonus = buffs and buffs.toughness_bonus or 1
	local max_toughness = (self._max_toughness + buff_extra) * toughness_bonus

	return max_toughness
end

PlayerUnitToughnessExtension.max_toughness = function (self)
	local buffs = self._buff_extension and self._buff_extension:stat_buffs()
	local buff_extra = buffs and buffs.toughness or 0
	local buff_extra_flat = buffs and buffs.toughness_bonus_flat or 0
	local toughness_bonus = buffs and buffs.toughness_bonus or 1
	local max_toughness = (self._max_toughness + buff_extra) * toughness_bonus

	max_toughness = math.ceil(max_toughness) + buff_extra_flat

	return max_toughness
end

PlayerUnitToughnessExtension.toughness_damage = function (self)
	return self._toughness_damage
end

PlayerUnitToughnessExtension.remaining_toughness = function (self)
	local max_toughness = self:max_toughness()
	local toughness_damage = self:toughness_damage()
	local remaining_toughness = max_toughness - toughness_damage

	return remaining_toughness
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
		local wanted_regen_amount = regen_rate * dt
		local regen_amount = math.min(wanted_regen_amount, self._toughness_damage)

		self._toughness_damage = self._toughness_damage - regen_amount

		GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", self._toughness_damage)

		self._stat_coherency_tougness_counter = self._stat_coherency_tougness_counter + regen_amount

		self:_handle_procs(wanted_regen_amount, regen_amount, "coherency")
	elseif self._stat_coherency_tougness_counter > 0 then
		local player = Managers.state.player_unit_spawn:owner(self._unit)

		if player then
			Managers.stats:record_private("hook_coherency_toughness_regenerated", player, self._stat_coherency_tougness_counter)
		end

		self._stat_coherency_tougness_counter = 0
	end
end

PlayerUnitToughnessExtension._initialize_toughness = function (self, toughness_template)
	local toughness_constant = NetworkConstants.toughness
	local min, max = toughness_constant.min, toughness_constant.max

	self._max_toughness = toughness_template.max
	self._toughness_damage = 0

	local session = self._game_session

	if session then
		GameSession.set_game_object_field(session, self._game_object_id, "toughness", toughness_template.max)
	end
end

PlayerUnitToughnessExtension.handle_max_toughness_changes_due_to_buffs = function (self, max_toughness_before, max_toughness_after)
	if max_toughness_after < max_toughness_before then
		local diff = max_toughness_before - max_toughness_after
		local new_toughness_damage = math.max(self._toughness_damage - diff, 0)
		local network_toughness_damage = math.min(new_toughness_damage, NetworkConstants.toughness.max)

		self._toughness_damage = network_toughness_damage

		GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", network_toughness_damage)
	end
end

PlayerUnitToughnessExtension.toughness_templates = function (self)
	local weapon_toughness_template = self._weapon_extension:toughness_template()

	return self._toughness_template, weapon_toughness_template
end

PlayerUnitToughnessExtension.recover_toughness = function (self, recovery_type)
	if self:_toughness_regen_disabled(nil, recovery_type) then
		return 0
	end

	local toughness_template = self._toughness_template
	local max_toughness = self:max_toughness()
	local toughness_damage = self._toughness_damage
	local weapon_toughness_template = self._weapon_extension:toughness_template()
	local modifier = weapon_toughness_template and weapon_toughness_template.recovery_percentage_modifiers[recovery_type] or 1
	local stat_buffs = self._buff_extension:stat_buffs()
	local is_melee_kill = recovery_type == toughness_replenish_types.melee_kill
	local toughness_melee_replenish_stat_buff = is_melee_kill and stat_buffs.toughness_melee_replenish or 1
	local total_toughness_replenish_stat_buff = stat_buffs.toughness_replenish_modifier
	local total_toughness_replenish_multiplier = stat_buffs.toughness_replenish_multiplier or 1
	local stat_buff_multiplier = toughness_melee_replenish_stat_buff + total_toughness_replenish_stat_buff - 1

	stat_buff_multiplier = stat_buff_multiplier * total_toughness_replenish_multiplier

	local recovery_percentage = toughness_template.recovery_percentages[recovery_type] * stat_buff_multiplier * modifier
	local wanted_amount = max_toughness * recovery_percentage
	local new_toughness = math.max(0, toughness_damage - wanted_amount)
	local network_toughness_damage = math.min(new_toughness, NetworkConstants.toughness.max)

	self._toughness_damage = network_toughness_damage

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", network_toughness_damage)

	local recovered_tougness = toughness_damage - network_toughness_damage

	self:_handle_procs(wanted_amount, recovered_tougness, recovery_type)

	return recovered_tougness
end

PlayerUnitToughnessExtension.recover_percentage_toughness = function (self, fixed_percentage, ignore_stat_buffs, reason)
	if self:_toughness_regen_disabled(nil, nil, reason) then
		return 0
	end

	local max_toughness = self:max_toughness()
	local toughness_damage = self._toughness_damage

	if not ignore_stat_buffs then
		local stat_buffs = self._buff_extension:stat_buffs()
		local stat_buff_multiplier = stat_buffs.toughness_replenish_modifier
		local total_toughness_replenish_multiplier = stat_buffs.toughness_replenish_multiplier or 1

		fixed_percentage = fixed_percentage * stat_buff_multiplier * total_toughness_replenish_multiplier
	end

	local wanted_amount = max_toughness * fixed_percentage
	local new_toughness = math.max(0, toughness_damage - wanted_amount)
	local network_toughness_damage = math.min(new_toughness, NetworkConstants.toughness.max)

	self._toughness_damage = network_toughness_damage

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", network_toughness_damage)

	local recovered_tougness = toughness_damage - network_toughness_damage

	self:_handle_procs(wanted_amount, recovered_tougness, reason)

	if reason == "zealot_channel" then
		self._total_amount_restored = self._total_amount_restored + recovered_tougness
	end

	return recovered_tougness
end

PlayerUnitToughnessExtension.get_and_clear_restored_amount = function (self)
	local restored = self._total_amount_restored or 0

	self._total_amount_restored = 0

	return restored
end

PlayerUnitToughnessExtension.recover_flat_toughness = function (self, amount, ignore_stat_buffs, reason)
	if self:_toughness_regen_disabled(nil, nil, reason) then
		return 0
	end

	local toughness_damage = self._toughness_damage

	if not ignore_stat_buffs then
		local stat_buffs = self._buff_extension:stat_buffs()
		local stat_buff_multiplier = stat_buffs.toughness_replenish_modifier
		local total_toughness_replenish_multiplier = stat_buffs.toughness_replenish_multiplier or 1

		amount = amount * stat_buff_multiplier * total_toughness_replenish_multiplier
	end

	local new_toughness = math.max(0, toughness_damage - amount)
	local network_toughness_damage = math.min(new_toughness, NetworkConstants.toughness.max)

	self._toughness_damage = network_toughness_damage

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", network_toughness_damage)

	local recovered_tougness = toughness_damage - network_toughness_damage

	self:_handle_procs(amount, recovered_tougness, reason)

	return recovered_tougness
end

PlayerUnitToughnessExtension.recover_max_toughness = function (self, reason, ignore_state_block)
	if self:_toughness_regen_disabled(ignore_state_block, nil, reason) then
		return 0
	end

	local max_toughness = self:max_toughness()
	local toughness_damage = self._toughness_damage

	self._toughness_damage = 0

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "toughness_damage", 0)

	local recovered_tougness = toughness_damage

	self:_handle_procs(max_toughness, recovered_tougness, reason or "unknown")

	return recovered_tougness
end

PlayerUnitToughnessExtension.set_toughness_broken_time = function (self)
	local t = Managers.time:time("gameplay")

	self._toughness_broken_at_t = t
end

PlayerUnitToughnessExtension.time_since_toughness_broken = function (self)
	local t = Managers.time:time("gameplay")

	return self._toughness_broken_at_t and t - self._toughness_broken_at_t or math.huge
end

PlayerUnitToughnessExtension.set_toughness_regen_delay = function (self)
	local t = Managers.time:time("gameplay")

	self._toughness_regen_delay = t
end

PlayerUnitToughnessExtension.add_damage = function (self, damage_amount, attack_result, hit_actor, damage_profile, attack_type, attack_direction, hit_world_position_or_nil)
	local unit = self._unit
	local weapon_toughness_template = self._weapon_extension:toughness_template()
	local toughness_template = self._toughness_template
	local is_melee = attack_type == attack_types.melee
	local max_toughness = self:max_toughness()
	local toughness_damage = self._toughness_damage
	local start_tougness = max_toughness - toughness_damage
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

	if start_tougness > 0 and self._toughness_damage == max_toughness then
		self:_record_toughness_broken()
	end

	local current_toughness = max_toughness - clamped_toughness_damage
	local toughness_damage_dealt = start_tougness - current_toughness

	return toughness_damage_dealt
end

local ABILITIES_ALLOW_RECOVERY_REASONS = {
	zealot_channel = true,
	ability_stance = true
}

PlayerUnitToughnessExtension._toughness_regen_disabled = function (self, ignore_state_block, optional_recovery_type, optional_reason)
	if not ignore_state_block and PlayerUnitStatus.is_knocked_down(self._character_state_component) and not self._assisted_state_input_component.force_assist then
		return true
	end

	if not HEALTH_ALIVE[self._unit] then
		return true
	end

	local has_prevent_toughness_replenish = self._buff_extension:has_keyword(buff_keywords.prevent_toughness_replenish)

	if has_prevent_toughness_replenish then
		return true
	end

	local has_prevent_toughness_replenish_except_abilities = self._buff_extension:has_keyword(buff_keywords.prevent_toughness_replenish_except_abilities)

	if has_prevent_toughness_replenish_except_abilities and not ABILITIES_ALLOW_RECOVERY_REASONS[optional_reason] then
		return true
	end

	return false
end

PlayerUnitToughnessExtension._handle_procs = function (self, amount, recovered_amount, reason)
	if amount <= 0 then
		return
	end

	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.amount = amount
		param_table.reason = reason
		param_table.recovered_amount = recovered_amount

		buff_extension:add_proc_event(proc_events.on_toughness_replenished, param_table)
	end
end

PlayerUnitToughnessExtension._record_toughness_broken = function (self)
	local player = Managers.state.player_unit_spawn:owner(self._unit)

	if player then
		Managers.stats:record_private("hook_toughness_broken", player)
	end
end

return PlayerUnitToughnessExtension
