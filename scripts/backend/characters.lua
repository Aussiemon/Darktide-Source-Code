-- Decompilation Error: _run_step(_unwarp_expressions, node)

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
local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {
	"fetch",
	"create",
	"delete",
	"equip_item_slot"
}
local Characters = class("Characters")

Characters.init = function (self)
	return
end

Characters.equip_item_slot = function (self, character_id, slot_name, gear_id)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/inventory/"):path(slot_name), {
		method = "PUT",
		body = {
			instanceId = gear_id
		}
	}):next(function (data)
		return data.body
	end)
end

Characters.create = function (self, new_character)
	assert(type(new_character) == "table", "Missing or invalid new_character")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(), {
		method = "POST",
		body = {
			newCharacter = new_character
		}
	}):next(function (data)
		return data.body
	end):next(function (result)
		if not result.characterId then
			local p = Promise:new()

			p:reject(BackendUtilities.create_error(BackendError.UnknownError, "Invalid characterId"))

			return p
		end

		local character_id = result.characterId

		return self:fetch(character_id)
	end)
end

local function _process_stats(stats)
	local result = {}

	for i, v in ipairs(stats) do
		local type_path = table.concat(v.typePath, "/")
		result[type_path] = v.value
	end

	return result
end

Characters.get_character_stats = function (self, account_id, character_id, stat_prefix)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-23, warpins: 1 ---
	assert(account_id, "account_id must be specified")
	assert(character_id, "character_id must be specified")

	slot4 = BackendUtilities.make_account_title_request
	slot5 = "characters"
	slot7 = BackendUtilities.url_builder(character_id):path("/statistics/")
	slot6 = BackendUtilities.url_builder(character_id).path("/statistics/").path
	slot8 = stat_prefix or ""

	return BackendUtilities.make_account_title_request(slot5, slot6(slot7, slot8)):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-4, warpins: 1 ---
		return _process_stats(data.body.statistics)
		--- END OF BLOCK #0 ---



	end)

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #1 24-24, warpins: 1 ---
	slot8 = ""
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 25-31, warpins: 2 ---
	--- END OF BLOCK #2 ---



end

Characters.fetch_account_character = function (self, account_id, character_id, include_inventory, include_progression)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-33, warpins: 1 ---
	assert(account_id, "account_id must be specified")
	assert(character_id, "character_id must be specified")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):query("includeInventoryDetails", include_inventory):query("includeProgressionDetails", include_progression), {}, account_id):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-2, warpins: 1 ---
		return data.body
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

Characters.fetch = function (self, character_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-13, warpins: 1 ---
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id)):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-3, warpins: 1 ---
		if character_id then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 4-7, warpins: 1 ---
			return data.body.character
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 8-10, warpins: 1 ---
			return data.body.characters
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 11-11, warpins: 2 ---
		return
		--- END OF BLOCK #1 ---



	end)
	--- END OF BLOCK #0 ---



end

Characters.delete_character = function (self, character_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	slot2 = assert

	if type(character_id) ~= "string" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-8, warpins: 1 ---
		slot3 = false
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-9, warpins: 1 ---
		slot3 = true
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-25, warpins: 2 ---
	slot2(slot3, "Missing or invalid character_id")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id), {
		method = "DELETE"
	}):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-2, warpins: 1 ---
		return data.body
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #1 ---



end

Characters.set_specialization = function (self, character_id, specialization)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	return self:set_data(character_id, "career", {
		specialization = specialization
	})
	--- END OF BLOCK #0 ---



end

Characters.set_talents = function (self, character_id, talents)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	return self:set_data(character_id, "career", {
		talents = talents
	})
	--- END OF BLOCK #0 ---



end

Characters.get_talents = function (self, character_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	return self:get_data(character_id, "career", "talents")
	--- END OF BLOCK #0 ---



end

Characters.set_prologue_completed = function (self, character_id, completed)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	return self:set_data(character_id, "path_trust", {
		prologue_completed = completed
	})
	--- END OF BLOCK #0 ---



end

Characters.get_prologue_completed = function (self, character_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	return self:get_data(character_id, "path_trust", "prologue_completed")
	--- END OF BLOCK #0 ---



end

Characters.set_last_seen_path_of_trust = function (self, character_id, scene_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	return self:set_data(character_id, "path_trust", {
		last_seen_cutscene = scene_id
	})
	--- END OF BLOCK #0 ---



end

Characters.get_last_seen_path_of_trust = function (self, character_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	return self:get_data(character_id, "path_trust", "last_seen_cutscene")
	--- END OF BLOCK #0 ---



end

Characters.set_character_height = function (self, character_id, value)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	return self:set_data(character_id, "personal", {
		character_height = value
	})
	--- END OF BLOCK #0 ---



end

Characters.get_character_height = function (self, character_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	return self:get_data(character_id, "personal", "character_height")
	--- END OF BLOCK #0 ---



end

local function _process_narrative(data)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	local result = {}

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 6-11, warpins: 0 ---
	for i, v in ipairs(data) do

		-- Decompilation error in this vicinity:
		--- BLOCK #0 6-9, warpins: 1 ---
		local type_path = v.typePath[2]
		result[type_path] = v.value
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 10-11, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 12-12, warpins: 1 ---
	return result
	--- END OF BLOCK #2 ---



end

Characters.get_narrative = function (self, character_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	slot2 = fassert

	if type(character_id) ~= "string" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-8, warpins: 1 ---
		slot3 = false
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-9, warpins: 1 ---
		slot3 = true
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-22, warpins: 2 ---
	slot2(slot3, "Invalid character_id %s", character_id)

	return self:get_data(character_id, "narrative"):next(function (response)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-4, warpins: 1 ---
		return _process_narrative(response.body.data)
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #1 ---



end

Characters.set_narrative_story_chapter = function (self, character_id, story_name, chapter_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	slot4 = fassert

	if type(character_id) ~= "string" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-8, warpins: 1 ---
		slot5 = false
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-9, warpins: 1 ---
		slot5 = true
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-18, warpins: 2 ---
	slot4(slot5, "Invalid character_id %s", character_id)

	slot4 = fassert

	if type(story_name) ~= "string" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 19-20, warpins: 1 ---
		slot5 = false
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 21-21, warpins: 1 ---
		slot5 = true
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 22-30, warpins: 2 ---
	slot4(slot5, "Invalid story_name %s", story_name)

	slot4 = fassert

	if type(chapter_id) ~= "number" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 31-32, warpins: 1 ---
		slot5 = false
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 33-33, warpins: 1 ---
		slot5 = true
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 34-43, warpins: 2 ---
	slot4(slot5, "Invalid chapter_id %s", chapter_id)

	return self:set_data(character_id, "narrative|stories", {
		[story_name] = chapter_id
	})
	--- END OF BLOCK #3 ---



end

Characters.set_data = function (self, character_id, section, data)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	slot4 = assert

	if type(character_id) ~= "string" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-8, warpins: 1 ---
		slot5 = false
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-9, warpins: 1 ---
		slot5 = true
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-34, warpins: 2 ---
	slot4(slot5, "Missing or invalid character_id")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/data/" .. section), {
		method = "PUT",
		body = {
			data = data
		}
	}):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-2, warpins: 1 ---
		return nil
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #1 ---



end

Characters.get_data = function (self, character_id, section, part)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	slot4 = assert

	if type(character_id) ~= "string" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-8, warpins: 1 ---
		slot5 = false
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-9, warpins: 1 ---
		slot5 = true
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-30, warpins: 2 ---
	slot4(slot5, "Missing or invalid character_id")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/data/" .. section)):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-3, warpins: 1 ---
		if part then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 4-9, warpins: 1 ---
			if #data.body.data > 0 then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 10-17, warpins: 1 ---
				return data.body.data[1].value[part]
				--- END OF BLOCK #0 ---



			else

				-- Decompilation error in this vicinity:
				--- BLOCK #0 18-20, warpins: 1 ---
				return nil
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 21-21, warpins: 1 ---
			return data
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 22-22, warpins: 3 ---
		return
		--- END OF BLOCK #1 ---



	end)
	--- END OF BLOCK #1 ---



end

Characters.check_name = function (self, name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	slot2 = assert

	if type(name) ~= "string" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-8, warpins: 1 ---
		slot3 = false
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-9, warpins: 1 ---
		slot3 = true
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-35, warpins: 2 ---
	slot2(slot3, "Missing or invalid name")

	local path = BackendUtilities.url_builder():path("/data/characters/name/" .. name .. "/check"):to_string()

	return Managers.backend:title_request(path):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-2, warpins: 1 ---
		return data.body
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #1 ---



end

implements(Characters, Interface)

return Characters
