local AttackIntensitySettings = require("scripts/settings/attack_intensity/attack_intensity_settings")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerUnitAttackIntensityExtension = class("PlayerUnitAttackIntensityExtension")
local attack_intensity_constants = AttackIntensitySettings.constants
local attack_intensities = AttackIntensitySettings.attack_intensities
local ZERO_DOGPILE_DECAY_MULTIPLIER = attack_intensity_constants.zero_dogpile_decay_multiplier
local SPRINT_DECAY_MULTIPLIER = attack_intensity_constants.sprint_decay_multiplier
local DEFAULT_ATTACK_INTENSITY_CLAMP = attack_intensity_constants.default_attack_intensity_clamp
local LOW_INTENSITY_THRESHOLD = attack_intensity_constants.low_intensity_threshold
local LOW_INTENSITY_GRACE_MOD = attack_intensity_constants.low_intensity_grace_mod
local LockedInMeleeSettings = AttackIntensitySettings.locked_in_melee_settings

PlayerUnitAttackIntensityExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._intensity_data = {}
	self._unit = unit

	self:_setup_intensities()

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	self._broadphase = broadphase_system.broadphase
	self._locked_in_melee = false
	self._locked_in_melee_timer = 0
	self._next_locked_in_melee_update = 0
	self._attack_allowed_timer = 0
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._inventory_component = unit_data_extension:read_component("inventory")
end

PlayerUnitAttackIntensityExtension.extensions_ready = function (self, world, unit)
	self._slot_extension = ScriptUnit.extension(unit, "slot_system")
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
end

PlayerUnitAttackIntensityExtension._setup_intensities = function (self)
	local intensity_data = self._intensity_data

	for intensity_type, settings in pairs(attack_intensities) do
		local difficulty_settings = Managers.state.difficulty:get_table_entry_by_challenge(settings)
		intensity_data[intensity_type] = {
			intensity = 0,
			decay_grace_timer = 0,
			attack_allowed = true,
			threshold = difficulty_settings.threshold,
			decay_grace = difficulty_settings.decay_grace,
			decay = difficulty_settings.decay,
			reset = difficulty_settings.reset,
			attack_allowed_decay_multiplier = difficulty_settings.attack_allowed_decay_multiplier,
			ignored_movement_states = difficulty_settings.ignored_movement_states,
			locked_in_melee_check = difficulty_settings.locked_in_melee_check,
			attack_intensity_clamp = difficulty_settings.attack_intensity_clamp
		}
	end
end

PlayerUnitAttackIntensityExtension.update = function (self, unit, dt, t, context)
	self:_update_locked_in_melee(dt, t)

	local slot_extension = self._slot_extension
	local num_occupied_slots = slot_extension.num_occupied_slots
	local movement_state = self._movement_state_component.method
	local intensity_data = self._intensity_data

	for intensity_type, data in pairs(intensity_data) do
		repeat
			local ignored_movement_states = data.ignored_movement_states

			if ignored_movement_states and ignored_movement_states[movement_state] then
				data.intensity = 0
				data.attack_allowed = true
			else
				local locked_in_melee = self._locked_in_melee

				if data.locked_in_melee_check and locked_in_melee then
					data.attack_allowed = false
					data.intensity = data.reset
				else
					local intensity = data.intensity
					local override_grace_mod = 1
					local decay_grace_timer = data.decay_grace_timer

					if intensity < LOW_INTENSITY_THRESHOLD then
						override_grace_mod = LOW_INTENSITY_GRACE_MOD
					elseif movement_state == "sprint" then
						data.decay_grace_timer = 0
						override_grace_mod = SPRINT_DECAY_MULTIPLIER
					elseif num_occupied_slots == 0 then
						override_grace_mod = ZERO_DOGPILE_DECAY_MULTIPLIER
					end

					if decay_grace_timer > 0 then
						data.decay_grace_timer = math.max(decay_grace_timer - dt, 0)
					elseif intensity > 0 then
						local attack_allowed = data.attack_allowed
						local decay = data.decay
						decay = decay * override_grace_mod

						if attack_allowed then
							decay = decay * data.attack_allowed_decay_multiplier or decay
						end

						local new_intensity = math.max(intensity - dt * decay, 0)
						data.intensity = new_intensity

						if new_intensity <= data.reset then
							data.attack_allowed = true
						end
					end
				end
			end
		until true
	end
end

PlayerUnitAttackIntensityExtension._update_locked_in_melee = function (self, dt, t)
	local locked_in_melee_timer = math.max(0, self._locked_in_melee_timer - t)
	local timer_is_below_threshold = locked_in_melee_timer < LockedInMeleeSettings.delay

	if timer_is_below_threshold and self._next_locked_in_melee_update < t then
		self:_check_locked_in_melee(t)

		self._next_locked_in_melee_update = t + LockedInMeleeSettings.update_frequency
	end

	self._locked_in_melee = t < self._locked_in_melee_timer
end

local broadphase_results = {}

PlayerUnitAttackIntensityExtension._check_locked_in_melee = function (self, t)
	local self_unit = self._unit
	local weapon_template = PlayerUnitVisualLoadout.wielded_weapon_template(self._visual_loadout_extension, self._inventory_component)

	if not weapon_template then
		return
	end

	local melee_weapon_equipped = table.contains(weapon_template.keywords, "melee") or table.contains(weapon_template.keywords, "grenadier_gauntlet")

	if melee_weapon_equipped then
		local broadphase = self._broadphase
		local radius = LockedInMeleeSettings.radius
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[self_unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local position = POSITION_LOOKUP[self_unit]
		local num_results = broadphase:query(position, radius, broadphase_results, enemy_side_names)
		local total_challenge_rating = 0
		local delay = LockedInMeleeSettings.delay
		local needed_challenge_rating = Managers.state.difficulty:get_table_entry_by_challenge(LockedInMeleeSettings.needed_challenge_rating)

		for i = 1, num_results, 1 do
			local nearby_unit = broadphase_results[i]
			local unit_data_extension = ScriptUnit.extension(nearby_unit, "unit_data_system")
			local breed = unit_data_extension:breed()

			if breed.combat_range_data ~= nil then
				local blackboard = BLACKBOARDS[nearby_unit]
				local perception_component = blackboard.perception
				local target_unit = perception_component.target_unit

				if self_unit == target_unit then
					local behavior_component = blackboard.behavior
					local combat_range = behavior_component.combat_range

					if combat_range == "melee" then
						local challenge_rating = breed.challenge_rating
						total_challenge_rating = total_challenge_rating + challenge_rating
					end

					if needed_challenge_rating <= total_challenge_rating then
						self._locked_in_melee_timer = t + delay

						break
					end
				end
			end
		end
	end
end

PlayerUnitAttackIntensityExtension.add_intensity = function (self, intensity_type, intensity)
	local data = self._intensity_data[intensity_type]
	local decay_grace = data.decay_grace
	data.decay_grace_timer = decay_grace
	local current_intensity = data.intensity
	local new_intensity = math.clamp(current_intensity + intensity, 0, data.attack_intensity_clamp or DEFAULT_ATTACK_INTENSITY_CLAMP)
	data.intensity = new_intensity

	if data.threshold < new_intensity then
		data.attack_allowed = false
	elseif not data.attack_allowed and new_intensity <= data.reset then
		data.attack_allowed = true
	end
end

PlayerUnitAttackIntensityExtension.attack_allowed = function (self, intensity_type)
	local intensity_data = self._intensity_data[intensity_type]
	local t = Managers.time:time("gameplay")
	local has_attack_allowed_timer = self._attack_allowed_timer < t
	local attack_allowed = intensity_data.attack_allowed

	if attack_allowed and has_attack_allowed_timer then
		return true
	elseif not attack_allowed then
		return false
	elseif attack_allowed and not has_attack_allowed_timer then
		local ignore_cooldown = true

		return false, ignore_cooldown
	end
end

PlayerUnitAttackIntensityExtension.set_monster_attacker = function (self, attacker_unit)
	self._monster_attacker_unit = attacker_unit
end

PlayerUnitAttackIntensityExtension.monster_attacker = function (self)
	return self._monster_attacker_unit
end

PlayerUnitAttackIntensityExtension.get_intensity = function (self, intensity_type)
	return self._intensity_data[intensity_type].intensity
end

PlayerUnitAttackIntensityExtension.total_intensity = function (self)
	local total_intensity = 0
	local intensity_data = self._intensity_data

	for _, data in pairs(intensity_data) do
		local intensity = data.intensity
		total_intensity = total_intensity + intensity
	end

	return total_intensity
end

PlayerUnitAttackIntensityExtension.locked_in_melee = function (self)
	return self._locked_in_melee
end

PlayerUnitAttackIntensityExtension.add_to_locked_in_melee_timer = function (self, time_to_add)
	local t = Managers.time:time("gameplay")
	self._locked_in_melee_timer = t + time_to_add
end

PlayerUnitAttackIntensityExtension.reset_locked_in_melee_timer = function (self)
	self._locked_in_melee_timer = 0
end

PlayerUnitAttackIntensityExtension.total_intensity_percent = function (self)
	local total_intensity = self:total_intensity()
	local total_intensity_percent = total_intensity / (DEFAULT_ATTACK_INTENSITY_CLAMP * table.size(self._intensity_data))

	return math.clamp(total_intensity_percent, 0, 1)
end

PlayerUnitAttackIntensityExtension.set_attacked = function (self)
	local t = Managers.time:time("gameplay")
	local attacked_allowed_time_range = AttackIntensitySettings.attacked_allowed_time_range
	local diff_attacked_allowed_time_range = Managers.state.difficulty:get_table_entry_by_challenge(attacked_allowed_time_range)
	self._attack_allowed_timer = t + math.random_range(diff_attacked_allowed_time_range[1], diff_attacked_allowed_time_range[2])
end

PlayerUnitAttackIntensityExtension.recently_attacked = function (self)
	local t = Managers.time:time("gameplay")

	return t < self._attack_allowed_timer
end

return PlayerUnitAttackIntensityExtension
