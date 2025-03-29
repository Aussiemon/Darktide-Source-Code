-- chunkname: @scripts/extension_systems/ability/utilities/shout_ability_implementation.lua

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local MinionState = require("scripts/utilities/minion_state")
local PlayerAssistNotifications = require("scripts/utilities/player_assist_notifications")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ShoutTargetTemplates = require("scripts/settings/ability/shout_target_templates")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local Toughness = require("scripts/utilities/toughness/toughness")
local attack_types = AttackSettings.attack_types
local breed_types = BreedSettings.types
local buff_keywords = BuffSettings.keywords
local stagger_types = StaggerSettings.stagger_types
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local MINION_BREED_TYPE = breed_types.minion
local PLAYER_BREED_TYPE = breed_types.player
local special_rules = SpecialRulesSettings.special_rules
local ShoutAbilityImplementation = {}
local _handle_enemy_targets, _handle_allied_targets
local broadphase_results = {}

ShoutAbilityImplementation.execute = function (radius, shout_target_template_name, player_unit, t, locomotion_component, shout_direction)
	local side_system = Managers.state.extension:system("side_system")
	local player_side = side_system.side_by_unit[player_unit]
	local player_buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local shout_target_template = ShoutTargetTemplates[shout_target_template_name]
	local enemies_hit = _handle_enemy_targets(t, radius, shout_target_template.enemies, player_unit, locomotion_component, player_side, player_buff_extension)

	_handle_allied_targets(t, radius, shout_target_template.allies, player_unit, locomotion_component, player_side, player_buff_extension)

	return enemies_hit
end

function _handle_enemy_targets(t, radius, target_settings, player_unit, locomotion_component, player_side, player_buff_extension)
	if not target_settings then
		return 0
	end

	if not player_side then
		return 0
	end

	local units_hit = 0
	local player_position = locomotion_component.position
	local player_rotation = locomotion_component.rotation
	local player_stat_buffs = player_buff_extension:stat_buffs()
	local enemy_side_names = player_side:relation_side_names("enemy")
	local ai_target_units = player_side.ai_target_units
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local radius_modifier = player_stat_buffs.shout_radius_modifier or 1
	local radius_to_use = radius * radius_modifier

	table.clear(broadphase_results)

	local num_hits = broadphase.query(broadphase, player_position, radius_to_use, broadphase_results, enemy_side_names, MINION_BREED_TYPE)
	local damage_profile = target_settings.damage_profile
	local damage_type = target_settings.damage_type
	local power_level = target_settings.power_level or DEFAULT_POWER_LEVEL
	local buff_to_add = target_settings.buff_to_add
	local buff_to_add_non_monster = target_settings.buff_to_add_non_monster
	local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")

	for ii = 1, num_hits do
		repeat
			local enemy_unit = broadphase_results[ii]

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

			local can_hit = true

			if MinionState.is_sleeping_deamonhost(enemy_unit) then
				local perception_extension = ScriptUnit.extension(enemy_unit, "perception_system")
				local has_line_of_sight = perception_extension:immediate_line_of_sight_check(player_unit)

				if not has_line_of_sight then
					can_hit = false
				end
			end

			local unallowed_breeds = target_settings.can_not_hit

			if unallowed_breeds then
				local unit_data = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
				local target_breed = unit_data and unit_data:breed()
				local breed_name = target_breed.name

				if unallowed_breeds[breed_name] then
					can_hit = false
				end
			end

			if can_hit then
				units_hit = units_hit + 1

				local unit_data_extension = ScriptUnit.extension(enemy_unit, "unit_data_system")
				local breed = unit_data_extension:breed()
				local ignored_breeds = target_settings.buff_ignored_breeds
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
					local special_rule_buff_name
					local monster_buff_name = target_settings.special_rule_buff_enemy_monster

					if monster_buff_name then
						if is_monster then
							special_rule_buff_name = monster_buff_name
						else
							special_rule_buff_name = target_settings.special_rule_buff_enemy
						end
					else
						special_rule_buff_name = target_settings.special_rule_buff_enemy
					end

					buff_extension:add_internally_controlled_buff(special_rule_buff_name, t)
				end

				local stagger_result

				if damage_profile then
					local lerp_t = math.clamp01(1 - length_squared / (radius_to_use * radius_to_use), 0, 1)
					local scaled_power_level = math.lerp(power_level * 0.1, power_level, lerp_t)
					local hit_zone_name = "torso"
					local _, _, _, shout_stagger_result = Attack.execute(enemy_unit, damage_profile, "attack_direction", attack_direction, "power_level", scaled_power_level, "hit_zone_name", hit_zone_name, "damage_type", damage_type, "attacking_unit", player_unit, "attack_type", attack_types.shout)

					stagger_result = shout_stagger_result
				end

				if target_settings.force_stagger_type_if_not_staggered and stagger_result and stagger_result == "no_stagger" then
					local force_stagger_type_if_not_staggered_duration = target_settings.force_stagger_type_if_not_staggered_duration

					Stagger.force_stagger(enemy_unit, target_settings.force_stagger_type_if_not_staggered, attack_direction, force_stagger_type_if_not_staggered_duration, 1, force_stagger_type_if_not_staggered_duration, player_unit)
				end

				local force_stagger_type = target_settings.force_stagger_type
				local force_stagger_duration = target_settings.force_stagger_duration

				if force_stagger_type then
					Stagger.force_stagger(enemy_unit, force_stagger_type, attack_direction, force_stagger_duration, 1, force_stagger_duration, player_unit)
				end

				local has_force_strong_stagger_keyword = player_buff_extension:has_keyword(buff_keywords.shout_forces_strong_stagger)

				if has_force_strong_stagger_keyword then
					Stagger.force_stagger(enemy_unit, stagger_types.heavy, attack_direction, 4, 1, 4, player_unit)
				end

				if talent_extension and damage_profile then
					local shout_causes_suppression = talent_extension:has_special_rule(special_rules.shout_causes_suppression)

					if shout_causes_suppression then
						Suppression.apply_suppression(enemy_unit, player_unit, damage_profile, POSITION_LOOKUP[player_unit])
					end
				end
			end
		until true
	end

	return units_hit
end

function _handle_allied_targets(t, radius, target_settings, player_unit, locomotion_component, player_side, player_buff_extension)
	if not target_settings then
		return
	end

	if not player_side then
		return
	end

	local player_position = locomotion_component.position
	local player_stat_buffs = player_buff_extension:stat_buffs()
	local buff_to_add = target_settings.buff_to_add
	local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")
	local shout_restores_toughness = talent_extension:has_special_rule(special_rules.shout_restores_toughness) or target_settings.shout_restores_toughness

	if buff_to_add or shout_restores_toughness then
		local coherency_extension = ScriptUnit.has_extension(player_unit, "coherency_system")
		local in_coherence_units = coherency_extension:in_coherence_units()

		for unit, _ in pairs(in_coherence_units) do
			if ALIVE[unit] then
				if buff_to_add then
					local buff_extension = ScriptUnit.extension(unit, "buff_system")

					buff_extension:add_internally_controlled_buff(buff_to_add, t, "owner_unit", player_unit)
				end

				if shout_restores_toughness then
					local recover_toughness_effect = target_settings.recover_toughness_effect

					if recover_toughness_effect then
						local fx_extension = ScriptUnit.extension(unit, "fx_system")

						fx_extension:spawn_exclusive_particle(recover_toughness_effect, Vector3(0, 0, 1))
					end

					local toughness_percent = target_settings.toughness_replenish_percent or 1

					Toughness.replenish_percentage(unit, toughness_percent, nil, "ability_shout")
				end
			end
		end
	end

	local revive_allies = target_settings.revive_allies

	if revive_allies and talent_extension then
		local allied_side_names = player_side:relation_side_names("allied")
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local radius_modifier = player_stat_buffs.shout_radius_modifier or 1
		local radius_to_use = radius * radius_modifier

		table.clear(broadphase_results)

		local num_hits = broadphase.query(broadphase, player_position, radius_to_use, broadphase_results, allied_side_names, PLAYER_BREED_TYPE)

		for ii = 1, num_hits do
			local unit = broadphase_results[ii]
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

return ShoutAbilityImplementation
