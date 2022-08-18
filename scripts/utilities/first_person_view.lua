local FirstPersonView = {
	enter = function (t, first_person_mode_component, optional_rewind_ms)
		first_person_mode_component.wants_1p_camera = true
		first_person_mode_component.show_1p_equipment_at_t = t + (optional_rewind_ms or 0) / 1000 + 0.65
	end,
	exit = function (t, first_person_mode_component)
		first_person_mode_component.wants_1p_camera = false
	end
}

return FirstPersonView
