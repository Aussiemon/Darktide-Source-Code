local CharacterCreate = require("scripts/utilities/character_create")
local StateMainMenuTestify = {}

StateMainMenuTestify.create_random_character = function (_, state_main_menu)
	Managers.time:register_timer("character_creation_timer", "main")

	local character_create = state_main_menu:new_character_create()

	character_create:set_name("Testify")

	local profile = character_create:profile()

	for class_name, class_data in pairs(profile.archetype.specializations) do
		if class_data.title and not class_data.disabled then
			character_create:set_specialization(class_name)

			break
		end
	end

	character_create:randomize_backstory_properties()
	character_create:upload_profile()
	state_main_menu:set_wait_for_character_profile_upload(true)
end

StateMainMenuTestify.wait_for_profile_synchronization = function (_, state_main_menu)
	if state_main_menu:waiting_for_profile_synchronization() then
		return Testify.RETRY
	end
end

return StateMainMenuTestify
