-- chunkname: @scripts/extension_systems/attack_intensity/minion_attack_intensity_extension.lua

local AttackIntensitySettings = require("scripts/settings/attack_intensity/attack_intensity_settings")
local Breed = require("scripts/utilities/breed")
local MinionAttackIntensityExtension = class("MinionAttackIntensityExtension")
local attack_intensities = AttackIntensitySettings.attack_intensities

MinionAttackIntensityExtension.init = function (self, extension_init_context, unit, extension_init_data)
	local breed = extension_init_data.breed
	local cooldowns = breed.attack_intensity_cooldowns

	self._breed, self._cooldowns = breed, cooldowns

	local difficulty_settings = {}
	local allowed_attacks = {}
	local uses_suppression = breed.suppress_config ~= nil

	for intensity_type, _ in pairs(cooldowns) do
		local settings = Managers.state.difficulty:get_table_entry_by_challenge(attack_intensities[intensity_type])

		allowed_attacks[intensity_type] = true
		difficulty_settings[intensity_type] = settings
	end

	self._difficulty_settings = difficulty_settings

	local blackboard = BLACKBOARDS[unit]

	self._perception_component = blackboard.perception

	if uses_suppression then
		self._suppression_component = blackboard.suppression
	end

	self._allowed_attacks = allowed_attacks
	self._current_cooldowns = {}
end

MinionAttackIntensityExtension.update = function (self, unit, dt, t)
	local perception_component = self._perception_component
	local target_unit = perception_component.target_unit

	if not HEALTH_ALIVE[target_unit] then
		return
	end

	if self._allow_all_attacks_duration and t >= self._allow_all_attacks_duration then
		self._allow_all_attacks_duration = nil
		self._allow_all_attacks = false
	end

	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local breed = target_unit_data_extension:breed()
	local target_movement_state

	if Breed.is_player(breed) then
		local movement_state_component = target_unit_data_extension:read_component("movement_state")

		target_movement_state = movement_state_component.method
	end

	local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")
	local suppression_component = self._suppression_component
	local cooldowns, current_cooldowns, allowed_attacks = self._cooldowns, self._current_cooldowns, self._allowed_attacks

	for intensity_type, cooldown in pairs(cooldowns) do
		repeat
			local difficulty_settings = self._difficulty_settings[intensity_type]
			local ignored_movement_states = difficulty_settings.ignored_movement_states
			local ignore_attack_intensity = ignored_movement_states and ignored_movement_states[target_movement_state]

			if ignore_attack_intensity then
				allowed_attacks[intensity_type] = true

				break
			end

			if suppression_component then
				local disallow_when_suppressed = difficulty_settings.disallow_when_suppressed
				local is_suppressed = suppression_component.is_suppressed

				if disallow_when_suppressed and is_suppressed then
					allowed_attacks[intensity_type] = false

					break
				end
			end

			local attack_allowed, ignore_cooldown = not target_attack_intensity_extension or target_attack_intensity_extension:attack_allowed(intensity_type), false

			if attack_allowed then
				if current_cooldowns[intensity_type] and t < current_cooldowns[intensity_type] then
					allowed_attacks[intensity_type] = false

					break
				end

				allowed_attacks[intensity_type] = true
				current_cooldowns[intensity_type] = nil

				break
			end

			if not current_cooldowns[intensity_type] then
				current_cooldowns[intensity_type] = t + (ignore_cooldown and 0 or math.random_range(cooldown[1], cooldown[2]))
				allowed_attacks[intensity_type] = false

				break
			end

			if t >= current_cooldowns[intensity_type] then
				current_cooldowns[intensity_type] = nil
			end
		until true
	end
end

MinionAttackIntensityExtension.set_monster_attacker = function (self, attacker_unit)
	return
end

MinionAttackIntensityExtension.monster_attacker = function (self)
	return
end

MinionAttackIntensityExtension.add_intensity = function (self, intensity_type, intensity)
	return
end

MinionAttackIntensityExtension.get_intensity = function (self, intensity_type)
	return 0
end

MinionAttackIntensityExtension.attack_allowed = function (self, intensity_type)
	return true
end

MinionAttackIntensityExtension.locked_in_melee = function (self)
	return false
end

MinionAttackIntensityExtension.add_to_locked_in_melee_timer = function (self)
	return
end

MinionAttackIntensityExtension.set_attacked = function (self)
	return
end

MinionAttackIntensityExtension.set_attacked_melee = function (self)
	return
end

MinionAttackIntensityExtension.set_damage_dealt = function (self)
	return
end

MinionAttackIntensityExtension.set_allow_all_attacks_duration = function (self, duration)
	local t = Managers.time:time("gameplay")

	self._allow_all_attacks_duration = t + duration
	self._allow_all_attacks = true
end

MinionAttackIntensityExtension.remove_attacked_melee = function (self)
	return
end

MinionAttackIntensityExtension.can_attack = function (self, attack_type)
	if self._allow_all_attacks then
		return true
	end

	return self._allowed_attacks[attack_type]
end

return MinionAttackIntensityExtension
