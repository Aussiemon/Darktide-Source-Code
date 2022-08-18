local MainMenuViewTestify = {
	delete_all_characters = function (_, main_menu_view)
		local character_profiles = main_menu_view:character_profiles()
		local character_ids = {}

		for i = 1, #character_profiles, 1 do
			local character_id = character_profiles[i].character_id
			character_ids[#character_ids + 1] = character_id
		end

		Managers.event:trigger("event_request_delete_multiple_characters", character_ids)
	end,
	navigate_to_create_character_from_main_menu = function (_, main_menu_view)
		main_menu_view:on_create_character_pressed()
	end,
	press_play_main_menu = function (_, main_menu_view)
		main_menu_view:on_play_pressed()
	end,
	select_character_widget = function (index, main_menu_view)
		main_menu_view:on_character_widget_selected(index)
	end,
	is_any_character_created = function (_, main_menu_view)
		local character_profiles = main_menu_view:character_profiles()
		local number_profiles = #character_profiles

		return number_profiles ~= 0
	end,
	wait_for_main_menu_play_button_enabled = function (_, main_menu_view)
		local play_button = main_menu_view._widgets_by_name.play_button.content

		if play_button.visible and play_button.hotspot.disabled ~= true then
			return
		else
			return Testify.RETRY
		end
	end
}

return MainMenuViewTestify
