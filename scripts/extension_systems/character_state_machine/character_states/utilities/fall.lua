local Attack = require("scripts/utilities/attack/attack")
local PlayerMovement = require("scripts/utilities/player_movement")
local Fall = {
	set_fall_height = function (locomotion_component, inair_state_component)
		local player_position = PlayerMovement.locomotion_position(locomotion_component)
		inair_state_component.fell_from_height = player_position.z
	end,
	fall_distance = function (locomotion_component, inair_state_component)
		local player_position = PlayerMovement.locomotion_position(locomotion_component)

		return inair_state_component.fell_from_height - player_position.z
	end,
	can_damage = function (unit, player_character_constants, locomotion_component, in_air_character_state_component)
		local fall_damage_settings = player_character_constants.fall_damage
		local min_damage_height = fall_damage_settings.min_damage_height
		local fall_distance = Fall.fall_distance(locomotion_component, in_air_character_state_component)

		if min_damage_height < fall_distance then
			local mover = Unit.mover(unit)
			local num_standing_frames = Mover.standing_frames(mover)
			local on_ground = in_air_character_state_component.on_ground or num_standing_frames > 0

			return on_ground
		end

		return false
	end,
	check_damage = function (unit, player_character_constants, locomotion_component, in_air_character_state_component)
		if not Fall.can_damage(unit, player_character_constants, locomotion_component, in_air_character_state_component) then
			return
		end

		local fall_damage_settings = player_character_constants.fall_damage
		local min_damage_height = fall_damage_settings.min_damage_height
		local max_damage_height = fall_damage_settings.max_damage_height
		local max_power_level = fall_damage_settings.max_power_level
		local heavy_damage_threshold = fall_damage_settings.heavy_damage_height
		local fall_distance = Fall.fall_distance(locomotion_component, in_air_character_state_component)
		local damage_profile, damage_type = nil

		if heavy_damage_threshold < fall_distance then
			damage_profile = fall_damage_settings.damage_profile_heavy
			damage_type = fall_damage_settings.damage_type_heavy
		else
			damage_profile = fall_damage_settings.damage_profile_light
			damage_type = fall_damage_settings.damage_type_light
		end

		if damage_profile then
			local delta_distance = fall_distance - min_damage_height
			local max_delta = max_damage_height - min_damage_height
			local scale = math.clamp(delta_distance / max_delta, 0, 1)
			local scaled_power_level = max_power_level * scale

			Attack.execute(unit, damage_profile, "attack_direction", -Vector3.up(), "power_level", scaled_power_level, "hit_zone_name", "torso", "damage_type", damage_type)
		end
	end,
	trigger_impact_sound = function (unit, fx_extension, player_character_constants, locomotion_component, in_air_character_state_component)
		if not Fall.can_damage(unit, player_character_constants, locomotion_component, in_air_character_state_component) then
			return
		end

		local fall_damage_settings = player_character_constants.fall_damage
		local min_damage_height = fall_damage_settings.min_damage_height
		local max_damage_height = fall_damage_settings.max_damage_height
		local landing_wwise_event_name = fall_damage_settings.landing_wwise_event
		local landing_wwise_parameter_name = fall_damage_settings.landing_wwise_parameter
		local fall_distance = Fall.fall_distance(locomotion_component, in_air_character_state_component)
		local fall_distance_parameter_value = math.clamp((fall_distance - min_damage_height) / (max_damage_height - min_damage_height), 0, 1)

		fx_extension:trigger_exclusive_wwise_event(landing_wwise_event_name, nil, true, landing_wwise_parameter_name, fall_distance_parameter_value)
	end
}

return Fall
