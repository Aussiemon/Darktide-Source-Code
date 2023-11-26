-- chunkname: @scripts/utilities/player_unit_peeking.lua

local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSetting.special_rules
local PlayerUnitPeeking = {}
local _initialize_3p, _initialize_1p

PlayerUnitPeeking.start = function (peeking_component, t)
	peeking_component.is_peeking = true
end

PlayerUnitPeeking.stop = function (peeking_component, first_person_extension, optional_height_time_to_change, optional_height_change_function)
	peeking_component.is_peeking = false

	first_person_extension:reset_height_change(optional_height_time_to_change, optional_height_change_function)
end

PlayerUnitPeeking.leaving_peekable_character_state = function (peeking_component, animation_extension, first_person_extension, optional_height_time_to_change, optional_height_change_function)
	if peeking_component.is_peeking then
		PlayerUnitPeeking.stop(peeking_component, first_person_extension, optional_height_time_to_change, optional_height_change_function)
	end

	if peeking_component.in_cover then
		peeking_component.in_cover = false

		PlayerUnitPeeking.on_leave_cover(animation_extension)
	end
end

PlayerUnitPeeking.on_enter_cover = function (animation_extension)
	animation_extension:anim_event_1p("to_cover")
	animation_extension:anim_event("to_cover")
end

PlayerUnitPeeking.on_leave_cover = function (animation_extension)
	animation_extension:anim_event_1p("from_cover")
	animation_extension:anim_event("from_cover")
end

PlayerUnitPeeking.fixed_update = function (peeking_component, ledge_finder_extension, animation_extension, first_person_extension, specialization_extension, is_crouching, breed)
	local has_significant_obstacle_in_front, looking_at_obstacle = ledge_finder_extension:has_significant_obstacle_in_front()
	local in_cover = has_significant_obstacle_in_front and looking_at_obstacle or false

	if peeking_component.in_cover ~= in_cover then
		peeking_component.in_cover = in_cover

		if in_cover then
			PlayerUnitPeeking.on_enter_cover(animation_extension)
		else
			PlayerUnitPeeking.on_leave_cover(animation_extension)
		end
	end

	local peeking_is_possible, peeking_ledge = false
	local can_peek = has_significant_obstacle_in_front and is_crouching

	can_peek = can_peek and specialization_extension:has_special_rule(special_rules.veteran_cover_peeking)

	if can_peek then
		local num_ledges, ledges = ledge_finder_extension:ledges()

		peeking_ledge = PlayerUnitPeeking.best_peekable_ledge(num_ledges, ledges, first_person_extension, breed)
		peeking_is_possible = peeking_ledge ~= nil
	end

	peeking_component.peeking_is_possible = peeking_is_possible

	if peeking_component.is_peeking then
		if peeking_is_possible then
			peeking_component.peeking_height = peeking_ledge.height_distance_from_player_unit + 0.2
		else
			PlayerUnitPeeking.stop(peeking_component, first_person_extension)
		end
	end
end

PlayerUnitPeeking.best_peekable_ledge = function (num_ledges, ledges, first_person_extension, breed)
	local significant_obstacle_distance = breed.ledge_finder_tweak_data.significant_obstacle_distance
	local significant_obstacle_distance_sq = significant_obstacle_distance * significant_obstacle_distance
	local crouch_height = first_person_extension:default_height("crouch")
	local default_height = first_person_extension:default_height("default")

	for i = num_ledges, 1, -1 do
		local ledge = ledges[i]
		local height_distance = ledge.height_distance_from_player_unit

		if significant_obstacle_distance_sq >= ledge.distance_flat_sq_from_player_unit and height_distance >= crouch_height - 0.2 and height_distance <= default_height - 0.2 then
			return ledge
		end
	end

	return nil
end

PlayerUnitPeeking.update_first_person_animations = function (unit_1p, data, dt, t)
	if not data.is_initialized then
		_initialize_1p(unit_1p, data)
	end
end

PlayerUnitPeeking.update_third_person_animations = function (unit_3p, data, dt)
	if not data.is_initialized then
		_initialize_3p(unit_3p, data)
	end

	local peek_y_index = Unit.animation_find_variable(unit_3p, "peek_y")

	if peek_y_index then
		local wanted_peek_y = 0
		local peeking_component = data.peeking_component

		if peeking_component.is_peeking then
			local first_person_extension = data.first_person_extension
			local extrapolated_character_height = first_person_extension:extrapolated_character_height()
			local default_crouch_height = first_person_extension:default_height("crouch")
			local default_standing_height = first_person_extension:default_height("default")
			local p = math.ilerp(default_crouch_height, default_standing_height, extrapolated_character_height)

			wanted_peek_y = math.lerp(0.1, 1, p)
		end

		local lerped_peek_y = math.lerp(data.lerped_peek_y, wanted_peek_y, math.min(dt * 10, 1))

		data.lerped_peek_y = lerped_peek_y

		Unit.animation_set_variable(unit_3p, peek_y_index, lerped_peek_y)
	end
end

function _initialize_3p(unit, data)
	local unit_data = ScriptUnit.extension(unit, "unit_data_system")

	data.peeking_component = unit_data:read_component("peeking")
	data.first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	data.lerped_peek_y = 0
	data.is_initialized = true
end

function _initialize_1p(unit_1p, data)
	data.is_initialized = true
end

return PlayerUnitPeeking
