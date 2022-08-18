-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local BackendError = require("scripts/managers/error/errors/backend_error")
local MasterItems = require("scripts/backend/master_items")
local ProfileUtils = require("scripts/utilities/profile_utils")
local Promise = require("scripts/foundation/utilities/promise")
local ProfilesService = class("ProfilesService")

ProfilesService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
end

local function _find_character_progression(character, characters_progression)
	local character_id = character.id

	for i = 1, #characters_progression, 1 do
		local progression = characters_progression[i]

		if progression.id == character_id then
			return progression
		end
	end
end

local function _fetch_all_backend_profiles(backend_interface)
	local characters_promise = backend_interface.characters:fetch()
	local characters_progression_promise = backend_interface.progression:get_entity_type_progression("character")
	local gear_list_promise = backend_interface.gear:fetch()
	local selected_character_id_promise = backend_interface.account:get_selected_character()

	return Promise.all(characters_promise, characters_progression_promise, gear_list_promise, selected_character_id_promise):next(function (results)
		local characters, characters_progression, gear_list, selected_character_id = unpack(results)

		if not characters or #characters == 0 then
			return Promise.resolved({
				profiles = {}
			})
		end

		local profiles = {}
		local selected_profile = nil

		for i = 1, #characters, 1 do
			local character = characters[i]
			local progression = _find_character_progression(character, characters_progression)
			local profile = ProfileUtils.character_to_profile(character, gear_list, progression)
			profiles[i] = profile

			if selected_character_id and character.id == selected_character_id then
				selected_profile = profile
			end
		end

		selected_profile = selected_profile or profiles[1]

		return Promise.resolved({
			profiles = profiles,
			selected_profile = selected_profile
		})
	end)
end

local function _fetch_backend_profile(backend_interface, character_id)
	local character_promise = backend_interface.characters:fetch(character_id)
	local character_progression_promise = backend_interface.progression:get_progression("character", character_id)
	local gear_list_promise = backend_interface.gear:fetch()

	return Promise.all(character_promise, character_progression_promise, gear_list_promise):next(function (results)
		local character, character_progression, gear_list = unpack(results)
		local profile = ProfileUtils.character_to_profile(character, gear_list, character_progression)

		return Promise.resolved(profile)
	end)
end

local function _handle_fetch_all_profiles_error()
	return Promise.rejected({})
end

ProfilesService.fetch_all_profiles = function (self)
	return _fetch_all_backend_profiles(self._backend_interface):catch(function (error)
		Managers.error:report_error(BackendError:new(error))

		return _handle_fetch_all_profiles_error()
	end)
end

ProfilesService.fetch_profile = function (self, character_id)
	return _fetch_backend_profile(self._backend_interface, character_id):catch(function (error)
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
	end)
end

ProfilesService.create_profile = function (self, profile)
	return self._backend_interface.characters:create(profile):catch(function (error)
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
	end)
end

ProfilesService.delete_profile = function (self, character_id)
	return self._backend_interface.characters:delete_character(character_id):catch(function (error)
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
	end)
end

ProfilesService.prologue_completed = function (self, character_id)
	return self._backend_interface.characters:get_prologue_completed(character_id):next(function (value)
		if value == true or value == "true" then
			return true
		else
			local account_data = Managers.save:account_data()
			local completed_profile_prologues = account_data.completed_profile_prologues

			if completed_profile_prologues[character_id] then
				self:set_prologue_completed(character_id)

				return true
			end

			return false
		end
	end):catch(function (error)
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
	end)
end

ProfilesService.set_prologue_completed = function (self, character_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-12, warpins: 1 ---
	return self._backend_interface.characters:set_prologue_completed(character_id, "true"):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-13, warpins: 1 ---
		Log.warning("ProfilesService", "set_prologue_completed failed: %s", table.tostring(error, 3))

		return Promise.resolved()
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

ProfilesService.fetch_suggested_names_by_archetype = function (self, archetype_name, gender, planet)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-19, warpins: 1 ---
	return Managers.backend.interfaces.social:suggested_names_by_archetype(archetype_name, gender, planet):next(function (names)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-4, warpins: 1 ---
		return Promise.resolved(names)
		--- END OF BLOCK #0 ---



	end):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-4, warpins: 1 ---
		return Promise.resolved({
			"Alex",
			"Rikard",
			"Thomas",
			"Jane",
			"Niki",
			"Marie"
		})
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

ProfilesService.set_character_height = function (self, character_id, value)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-16, warpins: 1 ---
	return self._backend_interface.characters:set_character_height(character_id, value):next(function ()

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-4, warpins: 1 ---
		return Promise.resolved(character_id)
		--- END OF BLOCK #0 ---



	end):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-14, warpins: 1 ---
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

ProfilesService.check_name = function (self, name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-15, warpins: 1 ---
	return self._backend_interface.characters:check_name(name):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-4, warpins: 1 ---
		return Promise.resolved(data)
		--- END OF BLOCK #0 ---



	end):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-14, warpins: 1 ---
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

return ProfilesService
