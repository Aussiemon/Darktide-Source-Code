-- chunkname: @scripts/utilities/attack/damage.lua

local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackIntensitySettings = require("scripts/settings/attack_intensity/attack_intensity_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local Health = require("scripts/utilities/health")
local HudElementPlayerHealthSettings = require("scripts/ui/hud/elements/player_health/hud_element_player_health_settings")
local MinionDeath = require("scripts/utilities/minion_death")
local PlayerDeath = require("scripts/utilities/player_death")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Vo = require("scripts/utilities/vo")
local attack_results = AttackSettings.attack_results
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local TOUGHNESS_BROKEN_ATTACK_INTENSITIES = {
	ranged = math.huge,
	elite_ranged = math.huge,
	elite_shotgun = math.huge,
	ranged_close = math.huge,
}
local Damage = {}
local _trigger_player_hurt_vo

Damage.deal_damage = function (unit, breed_or_nil, attacking_unit, attacking_unit_owner_unit, attack_result, attack_type, damage_profile, damage, permanent_damage, tougness_damage, hit_actor, attack_direction, hit_zone_name, herding_template_or_nil, is_critical_strike, damage_type, hit_world_position_or_nil, wounds_shape_or_nil, instakill)
	local health_extension = ScriptUnit.extension(unit, "health_system")
	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
	local was_alive = health_extension:is_alive()
	local previous_health_percent = health_extension:current_health_percent()
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	local is_minion = Breed.is_minion(breed_or_nil)
	local is_player = Breed.is_player(breed_or_nil)
	local is_prop = Breed.is_prop(breed_or_nil) or Breed.is_living_prop(breed_or_nil)
	local side_system = Managers.state.extension:system("side_system")
	local is_ally = side_system:is_ally(attacking_unit, unit)
	local actual_damage_dealt
	local boss_extension_or_nil = ScriptUnit.has_extension(unit, "boss_system")

	if not is_ally and boss_extension_or_nil then
		boss_extension_or_nil:damaged()
	end

	if toughness_extension then
		toughness_extension:add_damage(tougness_damage, attack_result, hit_actor, damage_profile, attack_type, attack_direction, hit_world_position_or_nil)
	end

	if breed_or_nil and breed_or_nil.clamp_health_percent_damage then
		local health_percent_clamp = breed_or_nil.clamp_health_percent_damage
		local max_health = health_extension:max_health()
		local damage_clamp = max_health * health_percent_clamp

		damage = math.min(damage, damage_clamp)
	end

	if attack_result == attack_results.toughness_broken then
		if is_player and buff_extension then
			local param_table = buff_extension:request_proc_event_param_table()

			if param_table then
				param_table.unit = unit
				param_table.melee_attack = attack_type == "melee"

				buff_extension:add_proc_event(proc_events.on_player_toughness_broken, param_table)
			end
		end

		if is_player then
			local time_since_toughness_broken = toughness_extension:time_since_toughness_broken()
			local toughness_broken_grace_cooldown = Managers.state.difficulty:get_table_entry_by_challenge(AttackIntensitySettings.toughness_broken_grace_cooldown)

			if toughness_broken_grace_cooldown < time_since_toughness_broken then
				local toughness_broken_grace_settings = AttackIntensitySettings.toughness_broken_grace
				local diff_toughness_broken_grace_settings = Managers.state.difficulty:get_table_entry_by_challenge(toughness_broken_grace_settings)
				local has_auric_mutator = Managers.state.pacing:is_auric()
				local dont_max_out_intensity = has_auric_mutator or diff_toughness_broken_grace_settings.dont_max_out_intensity

				if not dont_max_out_intensity then
					AttackIntensity.add_intensity(unit, TOUGHNESS_BROKEN_ATTACK_INTENSITIES)
					toughness_extension:set_toughness_broken_time()
				end
			end
		end
	end

	local attacked_unit_keywords = buff_extension and buff_extension:keywords()
	local current_health_damage = health_extension:damage_taken()
	local max_health = health_extension:max_health()
	local remaining_health = max_health - current_health_damage - damage
	local will_die = remaining_health <= 0

	if will_die then
		local has_resist_death_buff = attacked_unit_keywords and attacked_unit_keywords[buff_keywords.resist_death]

		if has_resist_death_buff and not instakill then
			damage = math.max(0, max_health - current_health_damage - 1)
		end
	end

	if will_die or damage > 0 or permanent_damage > 0 then
		if attacking_unit_owner_unit then
			local attacker_buff_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "buff_system")
			local attacker_health_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "health_system")

			if attacker_buff_extension and attacker_health_extension then
				local stat_buffs = attacker_buff_extension:stat_buffs()
				local leech = stat_buffs.leech

				if leech > 0 then
					local health = health_extension:current_health()
					local damage_dealt = math.clamp(damage, 0, health)
					local heal = damage_dealt * leech

					if heal > 0 then
						Health.add(attacking_unit_owner_unit, heal, DamageSettings.heal_types.leech)
					end
				end
			end
		end

		actual_damage_dealt = health_extension:add_damage(damage, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit_owner_unit)

		if is_player and not damage_profile.skip_on_hit_proc then
			local side = ScriptUnit.extension(unit, "side_system").side
			local player_units = side.valid_player_units

			for i = 1, #player_units do
				local player_unit = player_units[i]
				local player_buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

				if player_buff_extension then
					local param_table = player_buff_extension:request_proc_event_param_table()

					if param_table then
						param_table.attacking_unit = attacking_unit
						param_table.attacking_unit_owner_unit = attacking_unit_owner_unit
						param_table.attacked_unit = unit
						param_table.damage_amount = damage
						param_table.damage_profile_name = damage_profile and damage_profile.name or "none"
						param_table.permanent_damage = permanent_damage
						param_table.attack_type = attack_type

						player_buff_extension:add_proc_event(proc_events.on_damage_taken, param_table)
					end
				end
			end
		end
	elseif health_extension.tried_adding_damage then
		health_extension:tried_adding_damage(damage, permanent_damage, hit_actor, damage_profile, attack_type, attack_direction, attacking_unit_owner_unit)
	end

	if (is_minion or is_prop) and attacking_unit_owner_unit and health_extension.set_last_damaging_unit then
		health_extension:set_last_damaging_unit(attacking_unit_owner_unit, hit_zone_name, is_critical_strike, hit_world_position_or_nil, damage_profile)
	end

	local absorbed_attack = damage == 0 and permanent_damage == 0
	local current_health_percent = health_extension:current_health_percent()

	if is_player and not is_ally and not absorbed_attack then
		local is_critical = current_health_percent <= HudElementPlayerHealthSettings.critical_health_threshold

		if is_critical then
			Vo.health_critical_event(unit)
		elseif permanent_damage < damage then
			_trigger_player_hurt_vo(unit, damage)
		end

		Managers.state.pacing:add_damage_tension("damaged", damage, unit)
	end

	if is_minion and breed_or_nil and breed_or_nil.tags.monster and not is_ally then
		local breed_name = breed_or_nil.name

		if current_health_percent <= DialogueSettings.monster_near_death_health_percent_vo then
			Vo.enemy_generic_vo_event(unit, "monster_near_death_scream", breed_name)
		elseif current_health_percent <= DialogueSettings.monster_critical_health_percent_vo then
			Vo.monster_health_critical_event(attacking_unit_owner_unit)
		elseif current_health_percent <= DialogueSettings.monster_tough_to_kill_vo_health_percent then
			Vo.monster_combat_conversation(attacking_unit_owner_unit, breed_name)
		end
	end

	if health_extension:health_depleted() then
		local is_dying, blackboard = true, BLACKBOARDS[unit]

		if blackboard and is_minion then
			local death_component = blackboard.death

			is_dying = not death_component.hit_during_death
		end

		if is_minion and (was_alive or is_dying) then
			MinionDeath.die(unit, attacking_unit_owner_unit, attack_direction, hit_zone_name, damage_profile, attack_type, herding_template_or_nil, is_critical_strike, damage_type)
		elseif is_player then
			local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
			local character_state_component = unit_data_extension:read_component("character_state")
			local ignores_knockdown = damage_profile.ignores_knockdown
			local is_knocked_down = PlayerUnitStatus.is_knocked_down(character_state_component)
			local num_wounds = health_extension:num_wounds()
			local should_die = ignores_knockdown or is_knocked_down or num_wounds <= 1
			local vo_event

			if should_die then
				local reason = "damage"

				PlayerDeath.die(unit, nil, attacking_unit_owner_unit, reason)

				local should_add_died_tension = ignores_knockdown or num_wounds <= 1

				if should_add_died_tension then
					Managers.state.pacing:add_tension_type("died", unit)
				end

				vo_event = "killed_player"
			else
				PlayerDeath.knock_down(unit)

				vo_event = "downed_player"
			end

			local attacking_breed = Breed.unit_breed_or_nil(attacking_unit_owner_unit)
			local attacking_breed_name = attacking_breed and attacking_breed.name

			if attacking_breed_name then
				Vo.enemy_generic_vo_event(attacking_unit_owner_unit, vo_event, attacking_breed_name)
			end
		end
	end

	local wounds_template = damage_profile.wounds_template

	if is_minion and wounds_template and hit_world_position_or_nil then
		local wounds_extension = ScriptUnit.has_extension(unit, "wounds_system")

		if wounds_extension then
			local hit_actor_node_index = Actor.node(hit_actor)
			local percent_damage_dealt = math.max(previous_health_percent - current_health_percent, 0)

			wounds_extension:add_wounds(wounds_template, hit_world_position_or_nil, hit_actor_node_index, attack_result, percent_damage_dealt, damage_type, hit_zone_name, wounds_shape_or_nil)
		end
	end

	return actual_damage_dealt
end

function _trigger_player_hurt_vo(unit, damage)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local character_state_component = unit_data_extension:read_component("character_state")
	local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

	if not is_disabled then
		Vo.player_damage_event(unit, damage)
	end
end

return Damage
