-- chunkname: @scripts/utilities/herding.lua

local AttackingUnitResolver = require("scripts/utilities/attack/attacking_unit_resolver")
local Health = require("scripts/utilities/health")
local Herding = {}

Herding.modify_ragdoll_push_direction = function (herding_template, original_push_direction, ragdoll_unit, hit_zone_name)
	local custom_ragdoll_push_template = herding_template.push_ragdoll

	if not custom_ragdoll_push_template then
		return original_push_direction
	end

	local custom_push_vector = custom_ragdoll_push_template.custom_vector
	local hit_zone_overrides = custom_ragdoll_push_template.hit_zone_overrides

	if hit_zone_overrides and hit_zone_overrides[hit_zone_name] then
		custom_push_vector = hit_zone_overrides[hit_zone_name]
	end

	if not custom_push_vector then
		return original_push_direction
	end

	custom_push_vector = Vector3.from_array(custom_push_vector)

	local rotated_custom_push_vector = Quaternion.rotate(Quaternion.look(original_push_direction), custom_push_vector)
	local custom_push_direction = Vector3.normalize(0.5 * original_push_direction + rotated_custom_push_vector)

	return custom_push_direction
end

Herding.modify_stagger_direction = function (herding_template, original_attack_direction, attacking_unit, attacked_unit)
	local custom_stagger_template = herding_template.stagger

	if not custom_stagger_template then
		return original_attack_direction
	end

	local attacking_unit_owner_unit = AttackingUnitResolver.resolve(attacking_unit)
	local custom_attack_direction = original_attack_direction
	local target_position = POSITION_LOOKUP[attacked_unit]
	local attacker_position = POSITION_LOOKUP[attacking_unit_owner_unit]
	local unit_data_extension, first_person_component
	local stagger_override = custom_stagger_template.override

	if stagger_override == "up" or stagger_override == "down" then
		local vertical = Vector3.normalize(target_position - attacker_position)

		vertical.z = stagger_override == "up" and 1 or -1
		custom_attack_direction = Vector3.normalize(vertical)
	elseif stagger_override == "left" or stagger_override == "right" then
		local horizontal = Vector3.normalize(target_position - attacker_position)

		custom_attack_direction = Vector3.cross(horizontal, Vector3.up())

		if stagger_override == "left" then
			custom_attack_direction = -custom_attack_direction
		end

		custom_attack_direction = Vector3.normalize(0.3 * horizontal + custom_attack_direction)
	elseif stagger_override == "push" then
		custom_attack_direction = Vector3.normalize(Vector3.flat(target_position - attacker_position))
	elseif stagger_override == "pull" then
		custom_attack_direction = Vector3.normalize(attacker_position - target_position)
	elseif stagger_override == "lookat" then
		unit_data_extension = ScriptUnit.extension(attacking_unit_owner_unit, "unit_data_system")
		first_person_component = unit_data_extension:read_component("first_person")

		local rotation = first_person_component.rotation
		local forward = Quaternion.forward(rotation)

		custom_attack_direction = Vector3.normalize(Vector3.flat(forward))
		custom_attack_direction = Vector3.normalize(0.5 * custom_attack_direction + original_attack_direction)
	elseif stagger_override == "forced_lookat" then
		unit_data_extension = ScriptUnit.extension(attacking_unit_owner_unit, "unit_data_system")
		first_person_component = unit_data_extension:read_component("first_person")

		local rotation = first_person_component.rotation
		local forward = Quaternion.forward(rotation)

		custom_attack_direction = Vector3.normalize(Vector3.flat(forward))
	end

	local custom_vector = custom_stagger_template.custom_vector and Vector3.from_array(custom_stagger_template.custom_vector)

	if custom_vector then
		unit_data_extension = unit_data_extension or ScriptUnit.extension(attacking_unit_owner_unit, "unit_data_system")
		first_person_component = first_person_component or unit_data_extension:read_component("first_person")

		local rotation = first_person_component.rotation
		local rotated_custom_vector = Vector3.normalize(Quaternion.rotate(rotation, custom_vector))

		custom_attack_direction = Vector3.normalize(custom_attack_direction + rotated_custom_vector)
	end

	return custom_attack_direction
end

return Herding
