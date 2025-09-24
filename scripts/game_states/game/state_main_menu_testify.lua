-- chunkname: @scripts/game_states/game/state_main_menu_testify.lua

local StateMainMenuTestify = {
	create_character_by_archetype_and_gender = function (state_main_menu, archetype_name, gender)
		local character_create = state_main_menu:character_create_instance()

		character_create:set_name("Testify")

		local archetype_options = character_create:archetype_options()
		local archetype

		for _, archetype_option in ipairs(archetype_options) do
			if archetype_option.name == archetype_name then
				archetype = archetype_option
			end
		end

		character_create:set_archetype(archetype)
		character_create:randomize_backstory_properties()
		character_create:set_gender(gender)
		character_create:upload_profile()
		state_main_menu:set_wait_for_character_profile_upload(true)
	end,
	create_random_character = function (state_main_menu)
		local character_create = state_main_menu:character_create_instance()

		character_create:set_name("Testify")
		character_create:randomize_backstory_properties()
		character_create:upload_profile()
		state_main_menu:set_wait_for_character_profile_upload(true)
	end,
	wait_for_profile_synchronization = function (state_main_menu)
		if state_main_menu:waiting_for_profile_synchronization() then
			return Testify.RETRY
		end
	end,
}

return StateMainMenuTestify
