local Attack = require("scripts/utilities/attack/attack")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local MinionState = require("scripts/utilities/minion_state")
local PlayerAssistNotifications = require("scripts/utilities/player_assist_notifications")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Stagger = require("scripts/utilities/attack/stagger")
local Suppression = require("scripts/utilities/attack/suppression")
local Toughness = require("scripts/utilities/toughness/toughness")
local breed_types = BreedSettings.types
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local MINION_BREED_TYPE = breed_types.minion
local PLAYER_BREED_TYPE = breed_types.player
local special_rules = SpecialRulesSetting.special_rules
local ShoutAbilityImplementation = {}
local _suppress_units = nil
local broadphase_results = {}

ShoutAbilityImplementation.execute = function (shout_settings, player_unit, t, locomotion_component, shout_direction)
	table.clear(broadphase_results)

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local target_enemies = shout_settings.target_enemies
	local target_allies = shout_settings.target_allies
	local player_position = locomotion_component.position
	local player_rotation = locomotion_component.rotation
	local player_buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local stat_buffs = player_buff_extension:stat_buffs()

	if target_allies then
		local buff_to_add = shout_settings.buff_to_add
		local coherency_extension = ScriptUnit.has_extension(player_unit, "coherency_system")
		local in_coherence_units = coherency_extension:in_coherence_units()

		for unit, _ in pairs(in_coherence_units) do
			if ALIVE[unit] then
				if buff_to_add then
					local buff_extension = ScriptUnit.extension(unit, "buff_system")

					buff_extension:add_internally_controlled_buff(buff_to_add, t, "owner_unit", player_unit)
				end

				local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")
				local toughness_special_rule = special_rules.shout_restores_toughness
				local has_special_rule = talent_extension:has_special_rule(toughness_special_rule)

				if has_special_rule then
					local recover_toughness_effect = shout_settings.recover_toughness_effect

					if recover_toughness_effect then
						local fx_extension = ScriptUnit.extension(unit, "fx_system")

						fx_extension:spawn_exclusive_particle(recover_toughness_effect, Vector3(0, 0, 1))
					end

					local toughness_percent = shout_settings.toughness_replenish_percent or 1

					Toughness.replenish_percentage(unit, toughness_percent, nil, "ability_shout")
				end
			end
		end

		local revive = shout_settings.revive_allies
		local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")

		if revive and talent_extension then
			local allied_side_names = side:relation_side_names("allied")
			local broadphase_system = Managers.state.extension:system("broadphase_system")
			local broadphase = broadphase_system.broadphase
			local radius_modifier = stat_buffs.shout_radius_modifier or 1
			local radius = shout_settings.radius * radius_modifier
			local num_hits = broadphase:query(player_position, radius, broadphase_results, allied_side_names, PLAYER_BREED_TYPE)

			for i = 1, num_hits do
				local unit = broadphase_results[i]
				local revive_special_rule = special_rules.shout_revives_allies
				local has_special_rule = talent_extension:has_special_rule(revive_special_rule)

				if has_special_rule then
					local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
					local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")

					if character_state_component and PlayerUnitStatus.is_knocked_down(character_state_component) then
						local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")
						assisted_state_input_component.force_assist = true

						if ALIVE[unit] then
							PlayerAssistNotifications.show_notification(unit, player_unit, "saved")
						end
					end
				end
			end
		end
	end

	if target_enemies then
		local enemy_side_names = side:relation_side_names("enemy")
		local ai_target_units = side.ai_target_units
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local radius_modifier = stat_buffs.shout_radius_modifier or 1
		local radius = shout_settings.radius * radius_modifier
		local num_hits = broadphase:query(player_position, radius, broadphase_results, enemy_side_names, MINION_BREED_TYPE)
		local damage_profile = shout_settings.damage_profile
		local damage_type = shout_settings.damage_type
		local power_level = shout_settings.power_level or DEFAULT_POWER_LEVEL
		local buff_to_add = shout_settings.buff_to_add
		local buff_to_add_non_monster = shout_settings.buff_to_add_non_monster
		local shout_dot = shout_settings.shout_dot
		local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")

		for i = 1, num_hits do
			repeat
				local enemy_unit = broadphase_results[i]

				if not ai_target_units[enemy_unit] then
					break
				end

				local minion_position = POSITION_LOOKUP[enemy_unit]
				local flat_to_target = Vector3.flat(minion_position - player_position)
				local attack_direction = Vector3.normalize(flat_to_target)
				local length_squared = Vector3.length_squared(flat_to_target)

				if length_squared == 0 then
					attack_direction = Quaternion.forward(player_rotation)
				end

				local dot = Vector3.dot(shout_direction, attack_direction)
				local can_hit = not shout_dot or shout_dot and shout_dot < dot

				if MinionState.is_sleeping_deamonhost(enemy_unit) then
					local perception_extension = ScriptUnit.extension(enemy_unit, "perception_system")
					local has_line_of_sight = perception_extension:immediate_line_of_sight_check(player_unit)

					if not has_line_of_sight then
						can_hit = false
					end
				end

				if can_hit then
					local unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
					local breed = unit_data_extension:breed()
					local ignored_breeds = shout_settings.buff_ignored_breeds
					local is_monster = breed.tags.monster
					local buff_name = buff_to_add or not is_monster and buff_to_add_non_monster
					local should_add = not ignored_breeds or not ignored_breeds[breed.name]

					if buff_name and should_add then
						local buff_extension = ScriptUnit.extension(enemy_unit, "buff_system")

						buff_extension:add_internally_controlled_buff(buff_name, t, "owner_unit", player_unit)

						local source_player = player_unit and Managers.state.player_unit_spawn:owner(player_unit)

						if source_player then
							Managers.stats:record_private("hook_shout_buff", source_player, buff_name, breed.name)
						end
					end

					local buff_special_rule = special_rules.shout_applies_buff_to_enemies
					local has_special_rule = talent_extension:has_special_rule(buff_special_rule)

					if has_special_rule then
						local buff_extension = ScriptUnit.extension(enemy_unit, "buff_system")
						local special_rule_buff_name = nil
						local monster_buff_name = shout_settings.special_rule_buff_enemy_monster

						if monster_buff_name then
							if is_monster then
								special_rule_buff_name = monster_buff_name
							else
								special_rule_buff_name = shout_settings.special_rule_buff_enemy
							end
						else
							special_rule_buff_name = shout_settings.special_rule_buff_enemy
						end

						buff_extension:add_internally_controlled_buff(special_rule_buff_name, t)
					end

					local lerp_t = math.clamp01(1 - length_squared / (radius * radius), 0, 1)
					local scaled_power_level = math.lerp(power_level * 0.1, power_level, lerp_t)
					local hit_zone_name = "torso"
					local _, _, _, stagger_result = Attack.execute(enemy_unit, damage_profile, "attack_direction", attack_direction, "power_level", scaled_power_level, "hit_zone_name", hit_zone_name, "damage_type", damage_type, "attacking_unit", player_unit)

					if shout_settings.force_stagger_type_if_not_staggered and stagger_result and stagger_result == "no_stagger" then
						local force_stagger_type_if_not_staggered_duration = shout_settings.force_stagger_type_if_not_staggered_duration

						Stagger.force_stagger(enemy_unit, shout_settings.force_stagger_type_if_not_staggered, attack_direction, force_stagger_type_if_not_staggered_duration, 1, force_stagger_type_if_not_staggered_duration, player_unit)
					end

					local force_stagger_type = shout_settings.force_stagger_type
					local force_stagger_duration = shout_settings.force_stagger_duration

					if force_stagger_type then
						Stagger.force_stagger(enemy_unit, force_stagger_type, attack_direction, force_stagger_duration, 1, force_stagger_duration, player_unit)
					end

					if talent_extension then
						local shout_causes_suppression = talent_extension:has_special_rule(special_rules.shout_causes_suppression)

						if shout_causes_suppression then
							Suppression.apply_suppression(enemy_unit, player_unit, damage_profile, POSITION_LOOKUP[player_unit])
						end
					end
				end
			until true
		end
	end

	local suppress_enemies = shout_settings.suppress_enemies

	if suppress_enemies then
		_suppress_units(shout_settings, t, player_unit, player_position, player_rotation)
	end
end

function _suppress_units(shout_settings, t, player_unit, player_position, player_rotation)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local cone_dot = shout_settings.cone_dot
	local cone_range = shout_settings.cone_range
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local num_hits = broadphase:query(player_position, cone_range, broadphase_results, enemy_side_names)
	local rotation = player_rotation
	local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")
	local buff_special_rule = special_rules.shout_applies_buff_to_enemies
	local has_special_rule_to_add_buffs = talent_extension:has_special_rule(buff_special_rule)

	for i = 1, num_hits do
		local enemy_unit = broadphase_results[i]
		local enemy_unit_position = POSITION_LOOKUP[enemy_unit]
		local flat_direction = Vector3.flat(enemy_unit_position - player_position)
		local direction = Vector3.normalize(flat_direction)
		local dot = Vector3.dot(forward, direction)

		if cone_dot < dot then
			local blackboard = BLACKBOARDS[enemy_unit]
			local perception_component = blackboard.perception
			local is_alerted = perception_component.target_unit

			if is_alerted then
				local damage_profile = shout_settings.damage_profile

				Suppression.apply_suppression(enemy_unit, player_unit, damage_profile, player_position)
			end

			if has_special_rule_to_add_buffs then
				local buff_extension = ScriptUnit.extension(enemy_unit, "buff_system")
				local buff_name = nil
				local monster_buff_name = shout_settings.special_rule_buff_enemy_monster

				if monster_buff_name then
					local unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
					local breed = unit_data_extension:breed()
					local is_monster = breed.tags.monster

					if is_monster then
						buff_name = monster_buff_name
					else
						buff_name = shout_settings.special_rule_buff_enemy
					end
				else
					buff_name = shout_settings.special_rule_buff_enemy
				end

				buff_extension:add_internally_controlled_buff(buff_name, t)
			end
		end
	end
end

return ShoutAbilityImplementation
