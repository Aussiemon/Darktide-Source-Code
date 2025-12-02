-- chunkname: @scripts/extension_systems/proximity/side_relation_gameplay_logic/proximity_heal.lua

local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Health = require("scripts/utilities/health")
local JobInterface = require("scripts/managers/unit_job/job_interface")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Toughness = require("scripts/utilities/toughness/toughness")
local buff_keywords = BuffSettings.keywords
local improved_medical_crate_settings = BuffSettings.keyword_settings[buff_keywords.improved_medical_crate]
local ProximityHeal = class("ProximityHeal")

ProximityHeal.init = function (self, logic_context, init_data, owner_unit_or_nil)
	self._world = logic_context.world
	self._physics_world = logic_context.physics_world
	self._unit = logic_context.unit
	self._side_name = logic_context.side_name
	self._units_in_proximity = {}
	self._units_healed = {}
	self._fx_time_table = {}

	local med_kit_settings = init_data

	self._med_kit_settings = med_kit_settings
	self._amount_of_damage_healed = 0
	self._owner_unit_or_nil = owner_unit_or_nil
	self._start_time = nil
	self._current_t = nil

	local players_have_improved_keyword = false
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name(self._side_name)
	local player_units = side.player_units

	for _, player_unit in pairs(player_units) do
		local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

		if buff_extension then
			local improved_keyword = buff_extension:has_keyword(buff_keywords.improved_medical_crate)

			if improved_keyword then
				players_have_improved_keyword = true

				break
			end
		end
	end

	self._heal_amount_modifier = players_have_improved_keyword and improved_medical_crate_settings.heal_multiplier or 1
	self._heal_reserve = med_kit_settings.optional_heal_reserve
	self._heal_time = med_kit_settings.optional_heal_time
	self._players_have_improved_keyword = players_have_improved_keyword
	self._knock_down_player_heal_cost_multiplier = med_kit_settings.knock_down_player_heal_cost_multiplier or 1
	self._knock_down_player_heal_speed_multiplier = med_kit_settings.knock_down_player_heal_speed_multiplier or 1
end

ProximityHeal.unit_entered_proximity = function (self, t, unit)
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if not health_extension then
		return
	end

	self._units_in_proximity[unit] = health_extension
end

ProximityHeal.unit_left_proximity = function (self, t, unit)
	self._units_in_proximity[unit] = nil
	self._units_healed[unit] = nil
end

ProximityHeal.unit_in_proximity_deleted = function (self, unit)
	self._units_in_proximity[unit] = nil
	self._fx_time_table[unit] = nil
end

ProximityHeal.update = function (self, dt, t)
	if not self._started then
		return
	end

	self._current_t = t

	local healing_reserve = self._heal_reserve

	if healing_reserve and healing_reserve < self._amount_of_damage_healed then
		return
	end

	local heal_type = self._heal_type
	local heal_rate_percentage = self._med_kit_settings.heal_rate_percentage
	local heal_amount_modifier = self._heal_amount_modifier
	local heal_percentage = dt * heal_rate_percentage
	local amount_healed_this_tick = 0
	local players_have_improved_keyword = self._players_have_improved_keyword
	local optional_buff = self._med_kit_settings.optional_buff
	local knock_down_player_heal_speed_multiplier = self._knock_down_player_heal_speed_multiplier
	local knock_down_player_heal_cost_multiplier = self._knock_down_player_heal_cost_multiplier

	for unit, _ in pairs(self._units_in_proximity) do
		repeat
			local health_extension = ScriptUnit.has_extension(unit, "health_system")

			if health_extension and health_extension:is_alive() then
				local max_health = health_extension:max_health()
				local speed_multiplier = 1
				local cost_multiplier = 1
				local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
				local breed_or_nil = unit_data_extension and unit_data_extension:breed()
				local is_player = Breed.is_player(breed_or_nil)
				local can_heal = true

				if unit_data_extension and is_player then
					local character_state_component = unit_data_extension:read_component("character_state")
					local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)

					if is_knocked_down then
						speed_multiplier = knock_down_player_heal_speed_multiplier
						cost_multiplier = knock_down_player_heal_cost_multiplier
					end

					local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
					local is_consumed = PlayerUnitStatus.is_consumed(disabled_character_state_component)

					if is_consumed then
						can_heal = false
					end
				end

				if not can_heal then
					break
				end

				local heal_amount = max_health * heal_percentage * heal_amount_modifier * speed_multiplier
				local health_added = Health.add(unit, heal_amount, heal_type)

				amount_healed_this_tick = amount_healed_this_tick + health_added * cost_multiplier

				if optional_buff then
					local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
					local stat_buffs = buff_extension and buff_extension:stat_buffs()
					local heal_modifier = stat_buffs and stat_buffs[optional_buff] or 1
					local extra_heal_percentage = heal_percentage * heal_modifier - heal_percentage

					if extra_heal_percentage > 0 then
						local extra_heal_amount = max_health * extra_heal_percentage
						local extra_health_added = Health.add(unit, extra_heal_amount, heal_type)
					end
				end

				if players_have_improved_keyword then
					health_extension:reduce_permanent_damage(heal_amount * improved_medical_crate_settings.permanent_damage_multiplier)
					Toughness.replenish_percentage(unit, improved_medical_crate_settings.toughness_percentage_per_second * dt, false, "proximity_heal")
				end

				if health_added > 0 then
					self:_play_fx_for_unit(unit, t)
				end

				if not self._units_healed[unit] and health_added > 0 then
					self._units_healed[unit] = true
				end
			end
		until true
	end

	self._amount_of_damage_healed = self._amount_of_damage_healed + amount_healed_this_tick
end

ProximityHeal._play_fx_for_unit = function (self, unit, t)
	local last_play_time = self._fx_time_table[unit]
	local fx_interval = self._med_kit_settings.fx_interval

	if not last_play_time or t > last_play_time + fx_interval then
		self._fx_time_table[unit] = t

		Health.play_fx(unit)
	end
end

ProximityHeal.start_job = function (self)
	if self:is_job_completed() or self:is_job_canceled() then
		return
	end

	local t = Managers.time:time("gameplay")

	self._start_time = t
	self._current_t = t
	self._started = true
end

ProximityHeal.is_job_completed = function (self)
	if not self._started then
		return false
	end

	local is_health_depleted = false
	local healing_reserve = self._heal_reserve

	if healing_reserve then
		local amount_of_damage_healed = self._amount_of_damage_healed

		is_health_depleted = healing_reserve <= amount_of_damage_healed
	end

	local is_life_span_over = false
	local life_time = self._heal_time

	if life_time then
		local life_span = self._current_t - self._start_time

		is_life_span_over = life_span >= self._heal_time
	end

	return is_health_depleted or is_life_span_over
end

ProximityHeal.cancel_job = function (self)
	self._is_canceled = true
end

ProximityHeal.is_job_canceled = function (self)
	return not not self._is_canceled
end

implements(ProximityHeal, JobInterface)

return ProximityHeal
