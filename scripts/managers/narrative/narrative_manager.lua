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
local Promise = require("scripts/foundation/utilities/promise")
local Stories = require("scripts/settings/narrative/narrative_stories")
local NarrativeManager = class("NarrativeManager")
NarrativeManager.STORIES = table.enum(unpack(table.keys(Stories)))

NarrativeManager.init = function (self)
	self._character_narrative_data = {}
end

local function _player_profile()
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local profile = player:profile()

	return profile
end

local function _setup_placeholder_narrative_data()
	local data = {
		stories = {}
	}

	for story_name, chapters in pairs(Stories) do
		data.stories[story_name] = #chapters
	end

	return data
end

local function _chapter_index_from_backend_id(story_name, backend_id)
	local chapters = Stories[story_name]

	for i = 1, #chapters, 1 do
		local c = chapters[i]

		if c.backend_id == backend_id then
			return c.index
		end
	end
end

local function _setup_backend_narrative_data(backend_data)
	local data = {
		stories = {}
	}
	local backend_stories = backend_data.stories

	for story_name, _ in pairs(Stories) do
		local backend_id = backend_stories and backend_stories[story_name]
		local chapter_index = 0

		if backend_id then
			chapter_index = _chapter_index_from_backend_id(story_name, backend_id)

			if not chapter_index then
				Log.warning("NarrativeManager", "Story %s has no chapter with backend_id %s, resetting story", story_name, backend_id)

				chapter_index = 0
			end
		end

		Log.info("NarrativeManager", "Initiating story %s to chapter_index %s", story_name, chapter_index)

		data.stories[story_name] = chapter_index
	end

	return data
end

NarrativeManager.load_character_narrative = function (self, character_id)
	if self._character_narrative_data[character_id] then
		return Promise.resolved()
	end

	return Managers.backend.interfaces.characters:get_narrative(character_id):next(function (data)
		self._character_narrative_data[character_id] = _setup_backend_narrative_data(data)

		return nil
	end):catch(function (err)
		Log.warning("NarrativeManager", "Failed fetching narrative data for character %s: %s", character_id, table.tostring(err))

		self._character_narrative_data[character_id] = _setup_placeholder_narrative_data()

		return nil
	end)
end

NarrativeManager.is_narrative_loaded_for_player_character = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	local profile = _player_profile()
	local character_id = profile.character_id
	local data = self._character_narrative_data[character_id]

	return data ~= nil
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 11-11, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

NarrativeManager.last_completed_chapter = function (self, story_name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-16, warpins: 1 ---
	local chapters = Stories[story_name]

	fassert(chapters, "Story %s not found", story_name)

	local profile = _player_profile()
	local character_id = profile.character_id
	local last_completed_index = self._character_narrative_data[character_id].stories[story_name]
	local last_chapter = chapters[last_completed_index]

	return last_chapter
	--- END OF BLOCK #0 ---



end

NarrativeManager.current_chapter = function (self, story_name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-18, warpins: 1 ---
	local chapters = Stories[story_name]

	fassert(chapters, "Story %s not found", story_name)

	local profile = _player_profile()
	local character_id = profile.character_id
	local last_completed_index = self._character_narrative_data[character_id].stories[story_name]
	local index = last_completed_index + 1
	local chapter = chapters[index]

	if not chapter then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 19-20, warpins: 1 ---
		return nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 21-23, warpins: 2 ---
	local requirement = chapter.requirement

	if requirement and not requirement(profile) then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 29-30, warpins: 1 ---
		return nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 31-31, warpins: 3 ---
	return chapter
	--- END OF BLOCK #2 ---



end

NarrativeManager.current_chapter_completed = function (self, story_name)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	local chapter = self:current_chapter(story_name)

	if not chapter then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-14, warpins: 1 ---
		Log.info("NarrativeManager", "No current chapter to complete in story %s", story_name)

		return false
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 15-39, warpins: 1 ---
	local profile = _player_profile()
	local character_id = profile.character_id
	self._character_narrative_data[character_id].stories[story_name] = chapter.index

	Managers.backend.interfaces.characters:set_narrative_story_chapter(character_id, story_name, chapter.backend_id):catch(function (err)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-14, warpins: 1 ---
		Log.warning("NarrativeManager", "Backend fail setting chapter %s in story %s for character %s: %s", chapter.name, story_name, character_id, table.tostring(err))

		return
		--- END OF BLOCK #0 ---



	end)

	return true
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 40-40, warpins: 2 ---
	--- END OF BLOCK #2 ---



end

NarrativeManager.reset = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	table.clear(self._character_narrative_data)

	return
	--- END OF BLOCK #0 ---



end

return NarrativeManager
