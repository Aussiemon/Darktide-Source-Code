-- chunkname: @scripts/utilities/first_person_view.lua

local FirstPersonView = {}

FirstPersonView.enter = function (t, first_person_mode_component, optional_rewind_seconds)
	first_person_mode_component.wants_1p_camera = true
	first_person_mode_component.show_1p_equipment_at_t = t + (optional_rewind_seconds or 0) + 0.65
end

FirstPersonView.exit = function (t, first_person_mode_component)
	first_person_mode_component.wants_1p_camera = false
end

return FirstPersonView
