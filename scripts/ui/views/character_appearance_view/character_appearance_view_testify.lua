local CharacterAppearanceViewTestify = {
	character_appearance_view_continue = function (_, character_appearance_view)
		character_appearance_view:_on_continue_pressed()
	end,
	character_appearance_view_options_widgets = function (_, character_appearance_view)
		local widgets_by_name = character_appearance_view:widgets_by_name()
		local options_widgets = {}

		for widget_key, widget in pairs(widgets_by_name) do
			if string.starts_with(widget_key, "grid_2_option_") then
				table.insert(options_widgets, widget)
			end
		end

		return options_widgets
	end,
	character_appearance_view_set_item_per_slot = function (slot_name, item, character_appearance_view)
		local character_create = character_appearance_view:character_create()

		character_create:set_item_per_slot(slot_name, item)
	end,
	character_appearance_view_character_current_rotation = function (_, character_appearance_view)
		local profile_spawner = character_appearance_view:profile_spawner()

		return profile_spawner:rotation_angle()
	end,
	character_appearance_view_rotate_character_to_angle = function (dest_angle, increment, character_appearance_view)
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
	end,
	character_appearance_view_reset_rotation_angle = function (_, character_appearance_view)
		local profile_spawner = character_appearance_view:profile_spawner()

		profile_spawner:set_character_rotation(0)
	end,
	create_new_character = function (_, character_appearance_view)
		Managers.event:trigger("event_create_new_character_continue")
	end
}

return CharacterAppearanceViewTestify
