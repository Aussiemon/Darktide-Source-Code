local Attack = require("scripts/utilities/attack/attack")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local Toughness = require("scripts/utilities/toughness/toughness")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
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

	if target_allies then
		local buff_to_add = shout_settings.buff_to_add
		local revive = shout_settings.revive_allies
		local coherency_extension = ScriptUnit.has_extension(player_unit, "coherency_system")
		local in_coherence_units = coherency_extension:in_coherence_units()

		for unit, _ in pairs(in_coherence_units) do
			if ALIVE[unit] then
				if buff_to_add then
					local buff_extension = ScriptUnit.extension(unit, "buff_system")

					buff_extension:add_internally_controlled_buff(buff_to_add, t, "owner_unit", player_unit)
				end

				local specialization_extension = ScriptUnit.has_extension(player_unit, "specialization_system")

				if revive then
					local side_extension = ScriptUnit.has_extension(unit, "side_system")
					local is_player_unit = side_extension.is_player_unit

					if specialization_extension then
						local revive_special_rule = special_rules.shout_revives_allies
						local has_special_rule = specialization_extension:has_special_rule(revive_special_rule)

						if has_special_rule and is_player_unit then
							local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
							local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")

							if character_state_component and PlayerUnitStatus.is_knocked_down(character_state_component) then
								local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")
								assisted_state_input_component.force_assist = true
							end
						end
					end
				end

				local toughness_special_rule = special_rules.shout_restores_toughness
				local has_special_rule = specialization_extension:has_special_rule(toughness_special_rule)

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
	end

	if target_enemies then
		local enemy_side_names = side:relation_side_names("enemy")
		local ai_target_units = side.ai_target_units
		local player_units = side.valid_enemy_player_units
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local radius = shout_settings.radius
		local num_hits = broadphase:query(player_position, radius, broadphase_results, enemy_side_names)
		local damage_profile = shout_settings.damage_profile
		local damage_type = shout_settings.damage_type
		local power_level = shout_settings.power_level or DEFAULT_POWER_LEVEL
		local buff_to_add = shout_settings.buff_to_add
		local buff_to_add_non_monster = shout_settings.buff_to_add_non_monster
		local shout_dot = shout_settings.shout_dot
		local specialization_extension = ScriptUnit.has_extension(player_unit, "specialization_system")

		for i = 1, num_hits do
			repeat
				local enemy_unit = broadphase_results[i]

				if not ai_target_units[enemy_unit] or player_units[enemy_unit] then
					break
				end

				local minion_position = POSITION_LOOKUP[enemy_unit]
				local attack_direction = Vector3.normalize(Vector3.flat(minion_position - player_position))

				if Vector3.length_squared(attack_direction) == 0 then
					attack_direction = Quaternion.forward(player_rotation)
				end

				local dot = Vector3.dot(shout_direction, attack_direction)

				if not shout_dot or shout_dot and shout_dot < dot then
					local unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
					local breed = unit_data_extension:breed()
					local is_monster = breed.tags.monster
					local buff_name = buff_to_add or not is_monster and buff_to_add_non_monster

					if buff_name then
						local buff_extension = ScriptUnit.extension(enemy_unit, "buff_system")

						buff_extension:add_internally_controlled_buff(buff_name, t, "owner_unit", player_unit)
					end

					local buff_special_rule = special_rules.shout_applies_buff_to_enemies
					local has_special_rule = specialization_extension:has_special_rule(buff_special_rule)

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

					local hit_zone_name = "torso"

					Attack.execute(enemy_unit, damage_profile, "attack_direction", attack_direction, "power_level", power_level, "hit_zone_name", hit_zone_name, "damage_type", damage_type, "attacking_unit", player_unit)

					if specialization_extension then
						local shout_causes_suppression = specialization_extension:has_special_rule(special_rules.shout_causes_suppression)

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
	local specialization_extension = ScriptUnit.has_extension(player_unit, "specialization_system")
	local buff_special_rule = special_rules.shout_applies_buff_to_enemies
	local has_special_rule_to_add_buffs = specialization_extension:has_special_rule(buff_special_rule)

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
