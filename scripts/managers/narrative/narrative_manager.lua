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

	for i = 1, #chapters do
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
	local profile = _player_profile()
	local character_id = profile.character_id
	local data = self._character_narrative_data[character_id]

	return data ~= nil
end

NarrativeManager.last_completed_chapter = function (self, story_name)
	local chapters = Stories[story_name]

	fassert(chapters, "Story %s not found", story_name)

	local profile = _player_profile()
	local character_id = profile.character_id
	local last_completed_index = self._character_narrative_data[character_id].stories[story_name]
	local last_chapter = chapters[last_completed_index]

	return last_chapter
end

NarrativeManager.current_chapter = function (self, story_name)
	local chapters = Stories[story_name]

	fassert(chapters, "Story %s not found", story_name)

	local profile = _player_profile()
	local character_id = profile.character_id
	local last_completed_index = self._character_narrative_data[character_id].stories[story_name]
	local index = last_completed_index + 1
	local chapter = chapters[index]

	if not chapter then
		return nil
	end

	local requirement = chapter.requirement

	if requirement and not requirement(profile) then
		return nil
	end

	return chapter
end

NarrativeManager.current_chapter_completed = function (self, story_name)
	local chapter = self:current_chapter(story_name)

	if not chapter then
		Log.info("NarrativeManager", "No current chapter to complete in story %s", story_name)

		return false
	end

	local profile = _player_profile()
	local character_id = profile.character_id
	self._character_narrative_data[character_id].stories[story_name] = chapter.index

	Managers.backend.interfaces.characters:set_narrative_story_chapter(character_id, story_name, chapter.backend_id):catch(function (err)
		Log.warning("NarrativeManager", "Backend fail setting chapter %s in story %s for character %s: %s", chapter.name, story_name, character_id, table.tostring(err))
	end)

	return true
end

NarrativeManager.reset = function (self)
	table.clear(self._character_narrative_data)
end

return NarrativeManager
