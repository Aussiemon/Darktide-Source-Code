-- chunkname: @scripts/managers/narrative/narrative_manager.lua

local BackendError = require("scripts/managers/error/errors/backend_error")
local Promise = require("scripts/foundation/utilities/promise")
local Settings = require("scripts/settings/narrative/narrative_stories")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local Stories = Settings.stories
local Events = Settings.events
local NarrativeManager = class("NarrativeManager")
local DIRTY_INTERVAL = 10
local MIN_WAIT = 0.5

NarrativeManager.STORIES = table.enum_from_array(table.keys(Stories))
NarrativeManager.EVENTS = table.enum_from_array(table.keys(Events))

local function _player_profile()
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local profile = player:profile()

	return profile
end

NarrativeManager.init = function (self)
	self._characters = {}
	self._loading = {}
	self._promise_container = PromiseContainer:new()
end

NarrativeManager.destroy = function (self)
	self:_process_dirty_data(0, true)
	self._promise_container:delete()
end

local function _set_dirty(character_data)
	character_data.time_until_save = character_data.time_until_save or DIRTY_INTERVAL
	character_data.time_until_save = math.max(character_data.time_until_save, MIN_WAIT)
	character_data.is_dirty = true
end

NarrativeManager._set_character_data = function (self, character_id, data_type, key, value)
	local character_data = self._characters[character_id]

	if not character_data or not character_data[data_type] then
		Log.warning("NarrativeManager", "Character data for character_id: %s & data_type: %s is undefined.", character_id, data_type)

		return
	end

	if character_data[data_type][key] == value then
		return
	end

	character_data[data_type][key] = value
	character_data.dirty[data_type][key] = value

	_set_dirty(character_data)
end

NarrativeManager._on_push_dirty_data_success = function (self, character_id)
	local character_data = self._characters[character_id]

	if not character_data then
		Log.warning("NarrativeManager", "Character data for character_id: %s is undefined.", character_id)

		return
	end

	character_data.is_saving = false

	Log.debug("NarrativeManager", "Successfully pushed dirty data for character_id: %s.", character_id)
end

NarrativeManager._on_push_dirty_data_failure = function (self, character_id, err)
	Log.warning("NarrativeManager", "Failed to push dirty data for character_id: %s. Error: %s", character_id, err)

	local character_data = self._characters[character_id]

	if not character_data then
		Log.warning("NarrativeManager", "Character data for character_id: %s is undefined.", character_id)

		return
	end

	character_data.is_saving = false

	local code = err.code

	if not Managers.backend:is_retryable_error_code(code) then
		Log.error("NarrativeManger", "Failed to push dirty data for character_id: %s. Error code: %s", character_id, code)

		return
	end

	table.add_missing_recursive(character_data.dirty, character_data.in_air)
	_set_dirty(character_data)
end

NarrativeManager._push_dirty_data = function (self, character_data)
	if character_data.is_saving then
		Log.warning("NarrativeManager", "Can't push character data. It is already in air for character_id: %s.", character_data.character_id)

		character_data.time_until_save = MIN_WAIT

		return
	end

	character_data.is_dirty = false
	character_data.time_until_save = nil
	character_data.in_air = character_data.dirty
	character_data.dirty = {
		events = {},
		stories = {},
	}
	character_data.is_saving = true

	local character_id = character_data.character_id

	if character_id == nil then
		character_data.is_saving = false

		return
	end

	local event_data = character_data.in_air.events
	local story_data = character_data.in_air.stories

	self._promise_container:cancel_on_destroy(Managers.backend.interfaces.characters:set_narrative_data(character_id, event_data, story_data)):next(callback(self, "_on_push_dirty_data_success", character_id), callback(self, "_on_push_dirty_data_failure", character_id))
end

NarrativeManager._process_dirty_data = function (self, dt, ignore_timer)
	for _, character_data in pairs(self._characters) do
		if not character_data.is_dirty or character_data.is_saving then
			-- Nothing
		else
			character_data.time_until_save = (character_data.time_until_save or 0) - dt

			if not ignore_timer and character_data.time_until_save > 0 then
				-- Nothing
			else
				self:_push_dirty_data(character_data)
			end
		end
	end
end

NarrativeManager.update = function (self, dt, t)
	self:_process_dirty_data(dt, false)
end

NarrativeManager._empty_character_data = function (self, character_id)
	return {
		is_dirty = false,
		is_saving = false,
		character_id = character_id or false,
		stories = {},
		events = {},
		dirty = {
			stories = {},
			events = {},
		},
		in_air = {
			stories = {},
			events = {},
		},
	}
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

NarrativeManager._setup_backend_narrative_data = function (self, character_id, backend_data)
	local character_data = self:_empty_character_data(character_id)
	local backend_stories = backend_data.stories

	for story_name, _ in pairs(Stories) do
		local backend_id = backend_stories and backend_stories[story_name]
		local chapter_index = 0

		if backend_id and backend_id ~= 0 then
			chapter_index = _chapter_index_from_backend_id(story_name, backend_id)

			if not chapter_index then
				Log.warning("NarrativeManager", "Story %s has no chapter with backend_id %s, resetting story.", story_name, backend_id)

				chapter_index = 0
			end
		end

		Log.debug("NarrativeManager", "Initiating story %s to chapter_index %s.", story_name, chapter_index)

		character_data.stories[story_name] = chapter_index
	end

	local backend_events = backend_data.events

	for event_name, _ in pairs(Events) do
		local completed_on_backend = not not backend_events and (backend_events[event_name] == "true" or backend_events[event_name] == true)

		Log.debug("NarrativeManager", "Initiating event %s to %s", event_name, completed_on_backend)

		character_data.events[event_name] = completed_on_backend
	end

	return character_data
end

NarrativeManager._on_load_character_narrative_success = function (self, character_id, backend_data)
	self._loading[character_id] = nil
	self._characters[character_id] = self:_setup_backend_narrative_data(character_id, backend_data)
end

NarrativeManager._on_load_character_narrative_error = function (self, character_id, err)
	self._loading[character_id] = nil

	local level = Managers.error:report_error(BackendError:new(err))

	return Promise.rejected(err)
end

NarrativeManager.load_character_narrative = function (self, character_id)
	local characters = self._characters

	if characters[character_id] then
		return Promise.resolved()
	end

	local loading = self._loading

	if loading[character_id] then
		return loading[character_id]
	end

	loading[character_id] = self._promise_container:cancel_on_destroy(Managers.backend.interfaces.characters:get_narrative(character_id)):next(callback(self, "_on_load_character_narrative_success", character_id), callback(self, "_on_load_character_narrative_error", character_id))

	return loading[character_id]
end

NarrativeManager.last_completed_chapter = function (self, story_name)
	local chapters = Stories[story_name]
	local profile = _player_profile()

	if not profile then
		return false
	end

	local character_id = profile.character_id
	local last_completed_index = self._characters[character_id].stories[story_name]
	local last_chapter = chapters[last_completed_index]

	return last_chapter
end

NarrativeManager.chapter_by_name = function (self, story_name, chapter_name)
	local chapters = Stories[story_name]

	for i = 1, #chapters do
		local chapter = chapters[i]

		if chapter.name == chapter_name then
			return chapter
		end
	end
end

NarrativeManager._should_skip_chapter = function (self, profile, chapter)
	local archetype = profile.archetype
	local archetype_skip_func = chapter.archetype_skip_func

	return archetype_skip_func and archetype_skip_func(chapter, archetype) or false
end

NarrativeManager._next_valid_chapter_index = function (self, profile, story_name)
	local chapters = Stories[story_name]
	local character_id = profile.character_id
	local chapter_count = chapters and #chapters or 0
	local current_chapter_index = self._characters[character_id].stories[story_name]
	local completed_chapter_index = current_chapter_index

	while chapter_count >= completed_chapter_index + 1 and self:_should_skip_chapter(profile, chapters[completed_chapter_index + 1]) do
		completed_chapter_index = completed_chapter_index + 1
	end

	return completed_chapter_index
end

NarrativeManager._skip_until_index = function (self, character_id, story_name, target_chapter_index)
	local chapters = Stories[story_name]
	local last_completed_chapter_index = self._characters[character_id].stories[story_name]

	for i = last_completed_chapter_index + 1, target_chapter_index do
		local chapter = Stories[story_name][i]

		if chapter.on_skip then
			chapter.on_skip()
		end

		if chapter.on_complete then
			chapter.on_complete()
		end
	end

	self:_set_character_data(character_id, "stories", story_name, target_chapter_index)
end

NarrativeManager._skip_until_valid_chapter = function (self, profile, story_name)
	local next_valid_chapter_index = self:_next_valid_chapter_index(profile, story_name)

	self:_skip_until_index(profile.character_id, story_name, next_valid_chapter_index)

	return next_valid_chapter_index
end

NarrativeManager.current_chapter = function (self, story_name, ignore_all_requirements, ignore_mission_requirement)
	local chapters = Stories[story_name]
	local profile = _player_profile()
	local completed_index = self:_skip_until_valid_chapter(profile, story_name)
	local at_chapter = completed_index and chapters[completed_index + 1]

	if not at_chapter then
		return nil
	end

	if ignore_all_requirements then
		return at_chapter
	end

	local requirement = at_chapter.requirement

	if requirement and not requirement(profile) then
		return nil
	end

	return at_chapter
end

NarrativeManager.complete_current_chapter = function (self, story_name, expected_chapter_name)
	local chapter = self:current_chapter(story_name, nil, true)

	if not chapter then
		Log.info("NarrativeManager", "No current chapter to complete in story %s", story_name)

		return false
	end

	local chapter_name = chapter.name

	if expected_chapter_name and chapter_name ~= expected_chapter_name then
		Log.info("NarrativeManager", "This is not the current chapter %s. Current chapter name is: %s", story_name, chapter_name)

		return false
	end

	local profile = _player_profile()
	local character_id = profile.character_id
	local chapter_index = chapter.index

	self:_set_character_data(character_id, "stories", story_name, chapter_index)

	if chapter.on_complete then
		chapter.on_complete()
	end

	return true
end

NarrativeManager.set_story_to_chapter = function (self, story_name, chapter_name)
	local chapters = Stories[story_name]
	local chapter_index = self:chapter_index_from_name(story_name, chapter_name)
	local chapter = chapters[chapter_index]
	local profile = _player_profile()

	if not profile then
		return false
	end

	local requirement = chapter.requirement

	if requirement and not requirement(profile) then
		Log.info("NarrativeManager", "Failed completing chapter %s in story %s, requirement not fulfilled.", chapter_name, story_name)

		return false
	end

	local character_id = profile.character_id

	self:_set_character_data(character_id, "stories", story_name, chapter_index)

	if chapter.on_complete then
		chapter.on_complete()
	end

	return true
end

NarrativeManager.chapter_index_from_name = function (self, story_name, chapter_name)
	local chapters = Stories[story_name]

	for i = 1, #chapters do
		local c = chapters[i]

		if c.name == chapter_name then
			return i
		end
	end
end

NarrativeManager.skip_story = function (self, story_name)
	local chapters = Stories[story_name]
	local character_id = _player_profile().character_id

	self:_skip_until_index(character_id, story_name, #chapters)
end

NarrativeManager.is_chapter_complete = function (self, story_name, chapter_name)
	local chapters = Stories[story_name]

	if not chapters then
		Log.warning("NarrativeManager", "No story with the name '%s'.", story_name)

		return false
	end

	local index = self:chapter_index_from_name(story_name, chapter_name)

	if not index then
		Log.warning("NarrativeManager", "No chapter '%s' in story '%s'.", chapter_name, story_name)

		return false
	end

	local last_completed_chapter = self:last_completed_chapter(story_name)

	if not last_completed_chapter or not last_completed_chapter.name then
		return false
	end

	local last_completed_index = last_completed_chapter.index

	return index <= last_completed_index
end

NarrativeManager.is_story_complete = function (self, story_name)
	local chapters = Stories[story_name]

	if not chapters then
		Log.warning("NarrativeManager", "No story with the name '%s'.", story_name)

		return false
	end

	local last_completed_chapter = self:last_completed_chapter(story_name)

	if not last_completed_chapter or not last_completed_chapter.name then
		return false
	end

	local last_completed_index = last_completed_chapter.index
	local last_chapter_index = chapters[#chapters].index

	return last_chapter_index <= last_completed_index
end

NarrativeManager.reset = function (self)
	self:destroy()
	self:init()
end

NarrativeManager.is_event_complete = function (self, event_name)
	if Events[event_name] == nil then
		Log.warning("NarrativeManager", "No event with name '%s'.", event_name)

		return false
	end

	local profile = _player_profile()
	local character_id = profile.character_id

	return self._characters[character_id].events[event_name] == true
end

NarrativeManager.can_complete_event = function (self, event_name)
	local event = Events[event_name]

	if event == nil then
		Log.warning("NarrativeManager", "No event with name '%s'.", event_name)

		return false
	end

	local event_completed = self:is_event_complete(event_name)

	if event_completed then
		return false
	end

	local requirement = event.requirement

	if requirement then
		local player_profile = _player_profile()

		return requirement(player_profile)
	end

	return true
end

NarrativeManager.complete_event = function (self, event_name)
	local event = Events[event_name]

	if event == nil then
		Log.warning("NarrativeManager", "No event with name '%s'.", event_name)

		return false
	end

	if not self:can_complete_event(event_name) then
		return false
	end

	local profile = _player_profile()
	local character_id = profile.character_id

	self:_set_character_data(character_id, "events", event_name, true)

	if event.on_complete then
		event.on_complete()
	end

	return true
end

return NarrativeManager
