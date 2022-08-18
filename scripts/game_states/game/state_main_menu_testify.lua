local CharacterCreate = require("scripts/utilities/character_create")
local StateMainMenuTestify = {}

StateMainMenuTestify.create_random_character = function (_, state_main_menu)
	Managers.time:register_timer("character_creation_timer", "main")

	state_main_menu._character_create = CharacterCreate:new(state_main_menu._item_definitions)

	state_main_menu._character_create:set_name("Testify")
	state_main_menu._character_create:upload_profile()

	state_main_menu._wait_for_character_profile_upload = true
end

StateMainMenuTestify.wait_for_profile_synchronization = function (_, state_main_menu)
	if state_main_menu:waiting_for_profile_synchronization() then
		return Testify.RETRY
	end
end

return StateMainMenuTestify
