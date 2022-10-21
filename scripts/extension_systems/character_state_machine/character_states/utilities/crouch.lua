local Spread = require("scripts/utilities/spread")
local Sway = require("scripts/utilities/sway")
local Crouch = {
	crouch_input = function (input_source, is_crouching, requires_press_to_interrupt)
		local wants_crouch = nil
		local hold_to_sprint = input_source:get("hold_to_crouch")

		if hold_to_sprint and (is_crouching or not requires_press_to_interrupt) then
			wants_crouch = input_source:get("crouching")
		elseif input_source:get("crouch") then
			wants_crouch = not is_crouching
		else
			wants_crouch = is_crouching
		end

		return wants_crouch
	end
}

Crouch.check = function (unit, first_person_extension, animation_extension, weapon_extension, movement_state_component, sway_control_component, sway_component, spread_control_component, input_source, t)
	Profiler.start("crouch")

	local is_crouching = movement_state_component.is_crouching
	local wants_crouch = nil

	if input_source:get("hold_to_crouch") then
		wants_crouch = input_source:get("crouching")
	elseif input_source:get("crouch") then
		wants_crouch = not is_crouching
	else
		wants_crouch = is_crouching
	end

	if wants_crouch and not is_crouching then
		Crouch.enter(unit, first_person_extension, animation_extension, weapon_extension, movement_state_component, sway_control_component, sway_component, spread_control_component, t)

		is_crouching = true
	elseif not wants_crouch and is_crouching and Crouch.can_exit(unit) then
		Crouch.exit(unit, first_person_extension, animation_extension, weapon_extension, movement_state_component, sway_control_component, sway_component, spread_control_component, t)

		is_crouching = false
	end

	Profiler.stop("crouch")

	return is_crouching
end

Crouch.can_exit = function (unit)
	local mover = Unit.mover(unit)
	local position = Mover.position(mover)

	return Unit.mover_fits_at(unit, "default", position)
end

Crouch.enter = function (unit, first_person_extension, animation_extension, weapon_extension, movement_state_component, sway_control_component, sway_component, spread_control_component, t)
	animation_extension:anim_event("to_crouch")
	animation_extension:anim_event_1p("to_crouch")
	first_person_extension:set_wanted_player_height("crouch", 0.3)
	ScriptUnit.extension(unit, "locomotion_system"):set_active_mover("crouch")

	movement_state_component.is_crouching = true
	movement_state_component.is_crouching_transition_start_t = t
	local spread_template = weapon_extension:spread_template()
	local sway_template = weapon_extension:sway_template()

	Sway.add_immediate_sway(sway_template, sway_control_component, sway_component, movement_state_component, "crouch_transition")
	Spread.add_immediate_spread(t, spread_template, spread_control_component, movement_state_component, "crouch_transition")
end

Crouch.exit = function (unit, first_person_extension, animation_extension, weapon_extension, movement_state_component, sway_control_component, sway_component, spread_control_component, t)
	animation_extension:anim_event("to_uncrouch")
	animation_extension:anim_event_1p("to_uncrouch")
	first_person_extension:set_wanted_player_height("default", 0.2)
	ScriptUnit.extension(unit, "locomotion_system"):set_active_mover("default")

	movement_state_component.is_crouching = false
	movement_state_component.is_crouching_transition_start_t = t

	if sway_control_component then
		local sway_template = weapon_extension:sway_template()

		Sway.add_immediate_sway(sway_template, sway_control_component, sway_component, movement_state_component, "crouch_transition")
	end

	if spread_control_component then
		local spread_template = weapon_extension:spread_template()

		Spread.add_immediate_spread(t, spread_template, spread_control_component, movement_state_component, "crouch_transition")
	end
end

return Crouch
