local CharacterAppearanceViewTestify = {}

CharacterAppearanceViewTestify.character_appearance_view_continue = function (character_appearance_view)
	character_appearance_view:_on_continue_pressed()
end

CharacterAppearanceViewTestify.character_appearance_view_options_widgets = function (character_appearance_view)
	local widgets_by_name = character_appearance_view:widgets_by_name()
	local options_widgets = {}

	for widget_key, widget in pairs(widgets_by_name) do
		if string.starts_with(widget_key, "grid_2_option_") then
			table.insert(options_widgets, widget)
		end
	end

	return options_widgets
end

CharacterAppearanceViewTestify.character_appearance_view_set_item_per_slot = function (character_appearance_view, slot_name, item)
	local character_create = character_appearance_view:character_create()

	character_create:set_item_per_slot(slot_name, item)
end

CharacterAppearanceViewTestify.character_appearance_view_character_current_rotation = function (character_appearance_view)
	local profile_spawner = character_appearance_view:profile_spawner()

	return profile_spawner:rotation_angle()
end

CharacterAppearanceViewTestify.character_appearance_view_rotate_character_to_angle = function (character_appearance_view, dest_angle, increment)
	local profile_spawner = character_appearance_view:profile_spawner()
	local current_angle = profile_spawner:rotation_angle()

	if math.approximately_equal(current_angle, dest_angle, increment) then
		return
	end

	if current_angle < dest_angle then
		profile_spawner:set_character_rotation(current_angle + increment)
	else
		profile_spawner:set_character_rotation(current_angle - increment)
	end

	return Testify.RETRY
end

CharacterAppearanceViewTestify.character_appearance_view_reset_rotation_angle = function (character_appearance_view)
	local profile_spawner = character_appearance_view:profile_spawner()

	profile_spawner:set_character_rotation(0)
end

CharacterAppearanceViewTestify.create_new_character = function (character_appearance_view)
	Managers.event:trigger("event_create_new_character_continue")
end

return CharacterAppearanceViewTestify
