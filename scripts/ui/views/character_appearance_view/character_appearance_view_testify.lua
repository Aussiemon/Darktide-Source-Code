local CharacterAppearanceViewTestify = {
	character_appearance_view_continue = function (_, character_appearance_view)
		character_appearance_view:_on_continue_pressed()
	end,
	create_new_character = function (_, character_appearance_view)
		Managers.event:trigger("event_create_new_character_continue")
	end
}

return CharacterAppearanceViewTestify
