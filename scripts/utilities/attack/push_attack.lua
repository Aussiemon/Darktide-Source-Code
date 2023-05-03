local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Attack = require("scripts/utilities/attack/attack")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local IMPACT_FX_DATA_PREDICTED = {
	will_be_predicted = true
}
local IMPACT_FX_DATA_PREDICTED_NON_PREDICTED = {
	will_be_predicted = false
}
local UNIT_LENGTH_THRESHOLD = 0.99
local PushAttack = {}

local function _owned_by_death_manager(hit_unit)
	local unit_data_ext = ScriptUnit.has_extension(hit_unit, "unit_data_system")

	if not unit_data_ext then
		return false
	end

	local owned_by_death_manager = unit_data_ext:is_owned_by_death_manager()

	return owned_by_death_manager
end

local hit_units = {}

PushAttack.push = function (physics_world, push_position, push_direction, rewind_ms, power_level, push_settings, attacking_unit, is_predicted, optional_weapon_item, weak_push)
	local radius = push_settings.push_radius
	local collision_filter = "filter_player_character_push"
	local offset_push_position = push_position + push_direction + Vector3(0, 0, 1)
	local actors, num_actors = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", offset_push_position, "size", radius, "collision_filter", collision_filter, "rewind_ms", rewind_ms)
	local buff_extension = ScriptUnit.has_extension(attacking_unit, "buff_system")
	local stat_buffs = buff_extension and buff_extension:stat_buffs()
	local inner_push_angle_modifier = stat_buffs and stat_buffs.inner_push_angle_modifier or 1
	local outer_push_angle_modifier = stat_buffs and stat_buffs.outer_push_angle_modifier or 1
	local inner_push_rad = push_settings.inner_push_rad * inner_push_angle_modifier
	local outer_push_rad = push_settings.outer_push_rad * outer_push_angle_modifier
	local impact_fx_data = is_predicted and IMPACT_FX_DATA_PREDICTED or IMPACT_FX_DATA_PREDICTED_NON_PREDICTED
	local number_of_units_hit = 0

	table.clear(hit_units)

	for i = 1, num_actors do
		local actor = actors[i]
		local unit = Actor.unit(actor)
		local owned_by_death_manager = _owned_by_death_manager(unit)

		if not owned_by_death_manager and not hit_units[unit] then
			local minion_position = POSITION_LOOKUP[unit]
			local attack_direction = Vector3.normalize(Vector3.flat(minion_position - push_position))
			local damage_profile, damage_type = nil

			if weak_push then
				damage_profile = push_settings.outer_damage_profile
				damage_type = push_settings.outer_damage_type
			elseif Vector3.length_squared(attack_direction) < UNIT_LENGTH_THRESHOLD then
				attack_direction = push_direction
				damage_profile = push_settings.inner_damage_profile
			else
				local angle = Vector3.angle(attack_direction, push_direction, true)

				if angle <= inner_push_rad then
					damage_profile = push_settings.inner_damage_profile
					damage_type = push_settings.inner_damage_type
				elseif angle <= outer_push_rad then
					damage_profile = push_settings.outer_damage_profile
					damage_type = push_settings.outer_damage_type
				end
			end

			local hit_world_position = Actor.position(actor)

			if damage_profile then
				hit_units[unit] = true
				local hit_zone_name = "torso"
				local damage_dealt, attack_result, damage_efficiency, stagger_result = Attack.execute(unit, damage_profile, "attacking_unit", attacking_unit, "attack_direction", attack_direction, "attack_type", attack_types.push, "hit_world_position", hit_world_position, "hit_actor", actor, "power_level", power_level, "hit_zone_name", hit_zone_name, "damage_type", damage_type, "item", optional_weapon_item)

				ImpactEffect.play(unit, actor, damage_dealt, damage_type, hit_zone_name, attack_result, hit_world_position, nil, attack_direction, attacking_unit, impact_fx_data, nil, nil, damage_efficiency, damage_profile)

				if buff_extension then
					local param_table = buff_extension:request_proc_event_param_table()

					if param_table then
						param_table.pushing_unit = attacking_unit
						param_table.pushed_unit = unit
						param_table.stagger_result = stagger_result

						buff_extension:add_proc_event(proc_events.on_push_hit, param_table)
					end
				end

				number_of_units_hit = number_of_units_hit + 1
			end
		end
	end

	return number_of_units_hit
end

return PushAttack
