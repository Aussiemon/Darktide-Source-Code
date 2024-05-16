-- chunkname: @scripts/extension_systems/dialogue/dialogue_context_extension.lua

local Ammo = require("scripts/utilities/ammo")
local DialogueContextSettings = require("scripts/settings/dialogue/dialogue_context_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local DialogueContextExtension = class("DialogueContextExtension")

DialogueContextExtension.init = function (self, system, unit, extension_init_data, target_context)
	self._dialogue_context_system = system
	self._unit = unit
	self._target_context = target_context
	self._health_extension = nil
	self._legacy_v2_proximity_extension = nil

	if self._dialogue_context_system:get_start_dialogue_modifier() then
		self._target_context.dialogue_modifier = self._dialogue_context_system:get_start_dialogue_modifier()
	end

	self._timed_counters = {}
end

DialogueContextExtension.extensions_ready = function (self, world, unit)
	self._health_extension = ScriptUnit.extension(unit, "health_system")
	self._legacy_v2_proximity_extension = ScriptUnit.extension(unit, "legacy_v2_proximity_system")
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
end

DialogueContextExtension.update = function (self, t)
	self:_update_extensions_context()
	self:_update_player_unit_status()
	self:_update_player_equipment_context()
	self:_update_timed_timers_context(t)
end

DialogueContextExtension._update_player_equipment_context = function (self)
	self._target_context.total_ammo_percentage = Ammo.current_total_percentage(self._unit)

	local unit_data_extension = ScriptUnit.extension(self._unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot

	if wielded_slot ~= "none" then
		local weapon_action_component = unit_data_extension:read_component("weapon_action")

		self._target_context.weapon_type = weapon_action_component.template_name
		self._target_context.current_slot_percentage = Ammo.current_slot_percentage(self._unit, wielded_slot)
	end
end

DialogueContextExtension._update_player_unit_status = function (self)
	if self._unit then
		local player_unit_combat_state = Managers.state.pacing:player_unit_combat_state(self._unit)

		self._target_context.threat_level = player_unit_combat_state
	end

	local unit_data_extension = ScriptUnit.extension(self._unit, "unit_data_system")

	if unit_data_extension then
		local target_context = self._target_context
		local character_state_component = unit_data_extension:read_component("character_state")

		if character_state_component then
			target_context.is_disabled = PlayerUnitStatus.is_disabled(character_state_component)
			target_context.is_ledge_hanging = tostring(PlayerUnitStatus.is_ledge_hanging(character_state_component))
			target_context.is_knocked_down = tostring(PlayerUnitStatus.is_knocked_down(character_state_component))
			target_context.is_hogtied = tostring(PlayerUnitStatus.is_hogtied(character_state_component))
			target_context.is_catapulted = tostring(PlayerUnitStatus.is_catapulted(character_state_component))
		end

		local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")

		if disabled_character_state_component then
			target_context.is_pounced_down = tostring(PlayerUnitStatus.is_pounced(disabled_character_state_component))
			target_context.is_netted = tostring(PlayerUnitStatus.is_netted(disabled_character_state_component))
			target_context.is_warp_grabbed = tostring(PlayerUnitStatus.is_warp_grabbed(disabled_character_state_component))
			target_context.is_mutant_charged = tostring(PlayerUnitStatus.is_mutant_charged(disabled_character_state_component))
			target_context.is_consumed = tostring(PlayerUnitStatus.is_consumed(disabled_character_state_component))
		end
	end
end

DialogueContextExtension._update_extensions_context = function (self)
	local target_context = self._target_context

	target_context.health = self._health_extension:current_health_percent()

	local proximity_array = self._legacy_v2_proximity_extension.proximity_array

	for i = 1, #proximity_array do
		local proximity_data = proximity_array[i]
		local id, num = proximity_data.id, proximity_data.num

		target_context[id] = num
	end
end

DialogueContextExtension._update_timed_timers_context = function (self, t)
	for key, value in pairs(self._timed_counters) do
		repeat
			value.time_lived = value.time_lived + t * 5

			if value.time_lived > value.time_to_live then
				self._target_context.count = 0
				self._target_context[key] = nil
				self._timed_counters[key] = nil

				break
			end

			if value.delta and value.delta > 0 then
				value.count = value.count + value.delta
				value.delta = 0

				if value.trigger_when_higher and value.trigger_function and value.count > value.trigger_when_higher then
					value.trigger_function(self, value, t)
				end
			end

			self._target_context[key] = value.count
		until true
	end
end

DialogueContextExtension.increase_timed_counter = function (self, key, value)
	local timed_counter = self._timed_counters[key]

	if timed_counter == nil then
		self._timed_counters[key] = DialogueContextSettings:construct(key)
		timed_counter = self._timed_counters[key]
	end

	if value then
		timed_counter.delta = timed_counter.delta + value
	else
		timed_counter.delta = timed_counter.delta + 1
	end
end

DialogueContextExtension.get_timed_counter = function (self, key)
	return self._timed_counters[key]
end

return DialogueContextExtension
