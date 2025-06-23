-- chunkname: @scripts/utilities/material_fx.lua

local MaterialQuery = require("scripts/utilities/material_query")
local MaterialQuerySettings = require("scripts/settings/material_query_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local FIRST_PERSON_MODE_PARAMETER = 1
local THIRD_PERSON_MODE_PARAMETER = 0
local FOOTSTEP_EFFECTS = MaterialQuerySettings.footstep_effects
local FOOT_TO_SOURCE_NAME_LOOKUP = {
	right = {
		foot = "right_foot"
	},
	left = {
		foot = "left_foot"
	}
}
local _external_properties = {}
local _place_flow_3p_cb_footstep, _trigger_footstep_and_foley
local MaterialFx = {}

MaterialFx.flow_cb_3p_footstep = function (world, wwise_world, physics_world, unit, sound_alias, foot, use_cached_material_hit)
	local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

	if not fx_extension or not ALIVE[unit] then
		return
	end

	if foot == "both" then
		_place_flow_3p_cb_footstep(fx_extension, world, wwise_world, physics_world, unit, sound_alias, "left", use_cached_material_hit)
		_place_flow_3p_cb_footstep(fx_extension, world, wwise_world, physics_world, unit, sound_alias, "right", use_cached_material_hit)
	else
		_place_flow_3p_cb_footstep(fx_extension, world, wwise_world, physics_world, unit, sound_alias, foot, use_cached_material_hit)
	end
end

MaterialFx.trigger_material_fx = function (unit, world, wwise_world, physics_world, sound_alias, source_id, query_from, query_to, optional_set_speed_parameter, optional_set_first_person_parameter, use_cached_material_hit)
	local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

	if not fx_extension then
		return
	end

	local hit, material, position, normal, _, _ = MaterialQuery.query_material(physics_world, query_from, query_to, sound_alias)

	if not hit and not use_cached_material_hit then
		return
	end

	if hit and material then
		Unit.set_data(unit, "cache_material_footstep", material)
	end

	if not hit then
		local cached_material = Unit.get_data(unit, "cache_material_footstep")

		material = cached_material
	end

	material = material or "default"

	table.clear(_external_properties)

	_external_properties.material = material

	if sound_alias then
		WwiseWorld.set_switch(wwise_world, "surface_material", material, source_id)

		if optional_set_speed_parameter then
			local locomotion_ext = ScriptUnit.extension(unit, "locomotion_system")
			local move_speed = locomotion_ext:move_speed()

			WwiseWorld.set_source_parameter(wwise_world, source_id, "foley_speed", move_speed)
		else
			WwiseWorld.set_source_parameter(wwise_world, source_id, "foley_speed", 0)
		end

		if optional_set_first_person_parameter then
			local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
			local first_person_mode = first_person_extension:is_in_first_person_mode()
			local parameter_value = first_person_mode and 1 or 0

			WwiseWorld.set_source_parameter(wwise_world, source_id, "first_person_mode", parameter_value)
		else
			WwiseWorld.set_source_parameter(wwise_world, source_id, "first_person_mode", 0)
		end

		fx_extension:trigger_gear_wwise_event(sound_alias, _external_properties, source_id)
	end

	local world_interaction = FOOTSTEP_EFFECTS.world_interaction[material]

	if world_interaction then
		local material_group = MaterialQuerySettings.surface_material_groups_lookup[material]

		Managers.state.world_interaction:add_world_interaction(material_group, unit)
	end
end

local WEAPON_FOLEY = "sfx_weapon_locomotion"
local EXTRA_FOLEY = "sfx_player_extra_slot"
local SPEED_EPSILON = 0.010000000000000002

MaterialFx.update_1p_footsteps = function (t, footstep_time, right_foot_next, previous_frame_character_state_name, is_in_first_person_mode, context, ...)
	if not is_in_first_person_mode then
		return footstep_time, right_foot_next
	end

	local character_state_name = context.character_state_component.state_name
	local move_speed_squared = context.locomotion_extension:move_speed_squared()
	local footstep_sound_alias, foley_sound_alias, can_play_footstep

	if (character_state_name == "walking" or character_state_name == "sprinting") and (previous_frame_character_state_name == "walking" or previous_frame_character_state_name == "sprinting") then
		footstep_sound_alias = right_foot_next and "footstep_right" or "footstep_left"
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
		return footstep_time, right_foot_next
	end

	if not can_play_footstep then
		return footstep_time, right_foot_next
	end

	local weapon_template = WeaponTemplate.current_weapon_template(context.weapon_action_component)

	if not weapon_template then
		return footstep_time, right_foot_next
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
			return t + interval, not right_foot_next
		else
			return footstep_time, true
		end
	end

	return footstep_time, right_foot_next
end

MaterialFx.update_3p_footsteps = function (previous_frame_character_state_name, is_in_first_person_mode, context, ...)
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
	local world = context.world
	local physics_world = context.physics_world
	local wwise_world = context.wwise_world
	local unit = context.unit
	local query_from = POSITION_LOOKUP[unit] + Vector3(0, 0, 0.5)
	local query_to = query_from + Vector3(0, 0, -1)
	local set_speed_parameter = true
	local set_first_person_parameter = true
	local use_cached_material_hit = true

	MaterialFx.trigger_material_fx(unit, world, wwise_world, physics_world, footstep_sound_alias, context.feet_source_id, query_from, query_to, set_speed_parameter, set_first_person_parameter, use_cached_material_hit)

	local foley_source_id = context.foley_source_id

	if foley_source_id then
		local move_speed = context.locomotion_extension:move_speed()
		local fx_extension = context.fx_extension
		local num_args = select("#", ...)

		for ii = 1, num_args do
			local sound_alias = select(ii, ...)

			WwiseWorld.set_source_parameter(wwise_world, foley_source_id, "foley_speed", move_speed)
			WwiseWorld.set_source_parameter(wwise_world, foley_source_id, "first_person_mode", first_person_mode_parameter)
			fx_extension:trigger_gear_wwise_event(sound_alias, nil, foley_source_id)
		end
	end
end

function _place_flow_3p_cb_footstep(fx_extension, world, wwise_world, physics_world, unit, sound_alias, foot, use_cached_material_hit)
	local foot_source = FOOT_TO_SOURCE_NAME_LOOKUP[foot].foot
	local _, _, foot_unit_3p, foot_node_3p = fx_extension:vfx_spawner_unit_and_node(foot_source)
	local foot_pos = Unit.world_position(foot_unit_3p, foot_node_3p)
	local query_from = foot_pos + Vector3(0, 0, 0.1)
	local query_to = query_from + Vector3(0, 0, -0.5)
	local source_id = fx_extension:sound_source(foot_source)
	local set_speed_parameter = true
	local set_first_person_parameter = true

	MaterialFx.trigger_material_fx(unit, world, wwise_world, physics_world, sound_alias, source_id, query_from, query_to, set_speed_parameter, set_first_person_parameter, use_cached_material_hit)
end

return MaterialFx
