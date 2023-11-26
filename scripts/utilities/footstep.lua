-- chunkname: @scripts/utilities/footstep.lua

local MaterialQuery = require("scripts/utilities/material_query")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local FIRST_PERSON_MODE_PARAMETER = 1
local THIRD_PERSON_MODE_PARAMETER = 0
local _trigger_footstep_and_foley
local Footstep = {}

Footstep.trigger_material_footstep = function (sound_alias, wwise_world, physics_world, source_id, unit, node, query_from, query_to, optional_set_speed_parameter, optional_set_first_person_parameter)
	local hit, material, _, _, _, _ = MaterialQuery.query_material(physics_world, query_from, query_to, sound_alias)

	if hit and material then
		Unit.set_data(unit, "cache_material", material)
	end

	if not hit then
		local cached_material = Unit.get_data(unit, "cache_material")

		material = cached_material
	end

	local wwise_playing_id

	if sound_alias then
		if not source_id or source_id == nil then
			source_id = WwiseWorld.make_auto_source(wwise_world, unit, node)
		end

		if material then
			WwiseWorld.set_switch(wwise_world, "surface_material", material, source_id)
		else
			WwiseWorld.set_switch(wwise_world, "surface_material", "default", source_id)
		end

		if optional_set_speed_parameter then
			local locomotion_ext = ScriptUnit.extension(unit, "locomotion_system")
			local move_speed = locomotion_ext:move_speed()

			WwiseWorld.set_source_parameter(wwise_world, source_id, "foley_speed", move_speed)
		end

		if optional_set_first_person_parameter then
			local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
			local first_person_mode = first_person_extension:is_in_first_person_mode()
			local parameter_value = first_person_mode and 1 or 0

			WwiseWorld.set_source_parameter(wwise_world, source_id, "first_person_mode", parameter_value)
		end

		local fx_extension = ScriptUnit.extension(unit, "fx_system")
		local external_properties

		wwise_playing_id = fx_extension:trigger_gear_wwise_event(sound_alias, external_properties, source_id)
	end

	if material == "water_puddle" or material == "water_deep" then
		material = "water"

		if ALIVE[unit] then
			Managers.state.world_interaction:add_world_interaction(material, unit)
		end
	end

	return wwise_playing_id
end

local WEAPON_FOLEY = "sfx_weapon_locomotion"
local EXTRA_FOLEY = "sfx_player_extra_slot"
local SPEED_EPSILON = 0.010000000000000002

Footstep.update_1p_footsteps = function (t, footstep_time, previous_frame_character_state_name, is_in_first_person_mode, context, ...)
	if not is_in_first_person_mode then
		return footstep_time
	end

	local character_state_name = context.character_state_component.state_name
	local move_speed_squared = context.locomotion_extension:move_speed_squared()
	local footstep_sound_alias, foley_sound_alias, can_play_footstep

	if (character_state_name == "walking" or character_state_name == "sprinting") and (previous_frame_character_state_name == "walking" or previous_frame_character_state_name == "sprinting") then
		footstep_sound_alias = "footstep"
		foley_sound_alias = "sfx_foley_upper_body"
		can_play_footstep = footstep_time < t and move_speed_squared > SPEED_EPSILON
	end

	if not footstep_sound_alias and previous_frame_character_state_name ~= "jumping" and character_state_name == "jumping" then
		footstep_sound_alias = "footstep_jump"
		foley_sound_alias = "sfx_foley_upper_body"
		can_play_footstep = true
	end

	if not footstep_sound_alias and previous_frame_character_state_name == "falling" and character_state_name ~= "falling" then
		footstep_sound_alias = "footstep_land"
		foley_sound_alias = "sfx_foley_land"
		can_play_footstep = true
	end

	if not footstep_sound_alias and previous_frame_character_state_name ~= "dodging" and character_state_name == "dodging" then
		footstep_sound_alias = "sfx_footstep_dodge"
		foley_sound_alias = "sfx_foley_upper_body"
		can_play_footstep = true
	end

	if not footstep_sound_alias then
		return footstep_time
	end

	if not can_play_footstep then
		return footstep_time
	end

	local weapon_template = WeaponTemplate.current_weapon_template(context.weapon_action_component)

	if not weapon_template then
		return footstep_time
	end

	local breed_footstep_intervals = weapon_template.breed_footstep_intervals
	local footstep_intervals = breed_footstep_intervals and breed_footstep_intervals[context.breed.name] or weapon_template.footstep_intervals

	if footstep_intervals then
		_trigger_footstep_and_foley(context, footstep_sound_alias, FIRST_PERSON_MODE_PARAMETER, foley_sound_alias, WEAPON_FOLEY, EXTRA_FOLEY)

		local is_crouching = context.movement_state_component.is_crouching
		local alternate_fire_active = context.alternate_fire_component.is_active
		local sprint_character_state_component = context.sprint_character_state_component
		local interval

		if character_state_name == "sprinting" then
			interval = sprint_character_state_component.sprint_overtime > 0 and footstep_intervals.sprinting_overtime or footstep_intervals.sprinting
		elseif character_state_name == "walking" then
			if is_crouching then
				interval = alternate_fire_active and footstep_intervals.crouch_walking_alternate_fire or footstep_intervals.crouch_walking
			else
				interval = alternate_fire_active and footstep_intervals.walking_alternate_fire or footstep_intervals.walking
			end
		end

		interval = interval or footstep_intervals[character_state_name]

		if interval then
			return t + interval
		else
			return footstep_time
		end
	end

	return footstep_time
end

Footstep.update_3p_footsteps = function (previous_frame_character_state_name, is_in_first_person_mode, context, ...)
	if is_in_first_person_mode then
		return
	end

	local character_state_name = context.character_state_component.state_name

	if previous_frame_character_state_name ~= "dodging" and character_state_name == "dodging" then
		local footstep_sound_alias = "sfx_footstep_dodge"
		local foley_sound_alias = "sfx_foley_upper_body"

		_trigger_footstep_and_foley(context, footstep_sound_alias, THIRD_PERSON_MODE_PARAMETER, foley_sound_alias, WEAPON_FOLEY, EXTRA_FOLEY)
	end
end

function _trigger_footstep_and_foley(context, footstep_sound_alias, first_person_mode_parameter, ...)
	local wwise_world = context.wwise_world
	local unit = context.unit
	local query_from = POSITION_LOOKUP[unit] + Vector3(0, 0, 0.5)
	local query_to = query_from + Vector3(0, 0, -1)

	Footstep.trigger_material_footstep(footstep_sound_alias, wwise_world, context.physics_world, context.feet_source_id, unit, 1, query_from, query_to, true, true)

	local foley_source_id = context.foley_source_id

	if foley_source_id then
		local num_args = select("#", ...)

		for i = 1, num_args do
			local sound_alias = select(i, ...)
			local move_speed = context.locomotion_extension:move_speed()

			WwiseWorld.set_source_parameter(wwise_world, foley_source_id, "foley_speed", move_speed)
			WwiseWorld.set_source_parameter(wwise_world, foley_source_id, "first_person_mode", first_person_mode_parameter)
			context.fx_extension:trigger_gear_wwise_event(sound_alias, nil, foley_source_id)
		end
	end
end

return Footstep
