local CharacterCreate = require("scripts/utilities/character_create")
local StateMainMenuTestify = {
	create_character_by_archetype_and_gender = function (archetype_name, gender, state_main_menu)
		local character_create = state_main_menu:character_create_instance()

		character_create:set_name("Testify")

		local archetype_options = character_create:archetype_options()
		local archetype = nil

		for _, archetype_option in ipairs(archetype_options) do
			if archetype_option.name == archetype_name then
				archetype = archetype_option
			end
		end

		character_create:set_archetype(archetype)

		local profile = character_create:profile()

		for class_name, class_data in pairs(profile.archetype.specializations) do
			if class_data.title and not class_data.disabled then
				character_create:set_specialization(class_name)

				break
			end
		end

		character_create:randomize_backstory_properties()
		character_create:set_gender(gender)
		character_create:upload_profile()
		state_main_menu:set_wait_for_character_profile_upload(true)
	end
}

StateMainMenuTestify.create_random_character = function (_, state_main_menu)
	local character_create = state_main_menu:character_create_instance()

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

StateMainMenuTestify.wait_for_narrative_loaded = function (_, state_main_menu)
	if not Managers.narrative:is_narrative_loaded_for_player_character() then
		return Testify.RETRY
	end
end

return StateMainMenuTestify
