-- chunkname: @scripts/managers/network_story/network_story_manager.lua

local ScriptWorld = require("scripts/foundation/utilities/script_world")
local NetworkStoryManager = class("NetworkStoryManager")
local CLIENT_RPCS = {
	"rpc_network_story_sync",
	"rpc_network_story_set_position_level",
}

NetworkStoryManager.NETWORK_STORY_STATES = table.enum("not_created", "none", "pause_at_start", "playing", "pause_at_end")

NetworkStoryManager.init = function (self, world, is_server, network_event_delegate)
	self._is_server = is_server
	self._main_level = nil
	self._levels = {}
	self._network_event_delegate = nil
	self._world = world
	self._storyteller = World.storyteller(world)
	self._reposition = {}
	self._counter = 0

	if not is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end
end

NetworkStoryManager._change_state = function (self, story, new_state, new_id)
	local old_state = story.state

	story.state = new_state

	if old_state ~= new_state and story.state_change_callback then
		story.state_change_callback(old_state, new_state, new_id)
	end
end

NetworkStoryManager.on_gameplay_post_init = function (self, level)
	return
end

NetworkStoryManager.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

NetworkStoryManager.update = function (self, dt, t)
	local storyteller = self._storyteller

	for level, stories in pairs(self._levels) do
		for story_name, story in pairs(stories) do
			if story.state ~= self.NETWORK_STORY_STATES.not_created then
				local story_time = storyteller:time(story.id)
				local length = storyteller:length(story.id)

				if length < story_time and story.speed > 0 then
					storyteller:set_time(story.id, length)
					storyteller:set_speed(story.id, 0)

					story.speed = 0

					self:_change_state(story, self.NETWORK_STORY_STATES.pause_at_end)

					story.state = self.NETWORK_STORY_STATES.pause_at_end
				elseif story_time < 0 and story.speed < 0 then
					storyteller:set_time(story.id, 0)
					storyteller:set_speed(story.id, 0)

					story.speed = 0

					self:_change_state(story, self.NETWORK_STORY_STATES.pause_at_start)
				end
			end
		end
	end
end

NetworkStoryManager.hot_join_sync = function (self, peer, channel)
	self:_sync_stories(peer, channel)
end

NetworkStoryManager.register_story = function (self, story_name, story_level, state_change_callback)
	self._levels[story_level] = self._levels[story_level] or {}
	self._levels[story_level][story_name] = {
		id = -1,
		length = 0,
		speed = 0,
		level_id = ScriptWorld.level_id(self._world, story_level),
		state = self.NETWORK_STORY_STATES.not_created,
		state_change_callback = state_change_callback,
	}

	return -1
end

NetworkStoryManager.set_position_level = function (self, story_level, unit)
	self._reposition[story_level] = unit

	if self._is_server then
		local level_id = ScriptWorld.level_id(self._world, story_level)
		local unit_spawner_manager = Managers.state.unit_spawner
		local is_level_unit, unit_id = unit_spawner_manager:game_object_id_or_level_index(unit)

		Managers.state.game_session:send_rpc_clients("rpc_network_story_set_position_level", level_id, unit_id, is_level_unit)
	end
end

NetworkStoryManager._create_story = function (self, story_name, story_level)
	if self._storyteller and story_level then
		local story_id = self._storyteller:play_level_story(story_level, story_name)

		if self._reposition[story_level] then
			local position = Unit.local_position(self._reposition[story_level], 1)
			local rotation = Unit.local_rotation(self._reposition[story_level], 1)

			self._storyteller:set_rotation(story_id, rotation)
			self._storyteller:set_position(story_id, position)
		end

		self._storyteller:set_time(story_id, 0)
		self._storyteller:set_speed(story_id, 0)

		local length = self._storyteller:length(story_id)

		self._levels[story_level] = self._levels[story_level] or {}

		local story_definition = self._levels[story_level][story_name]

		story_definition.id = story_id
		story_definition.length = length
		story_definition.debug_description = story_name
		story_definition.loop_mode = Storyteller.NONE

		self:_change_state(story_definition, self.NETWORK_STORY_STATES.pause_at_start, story_id)

		return story_id
	end

	return -1
end

NetworkStoryManager.unregister_story = function (self, story_name, story_level)
	local story = self._levels[story_level][story_name]

	self._levels[story_level][story_name] = nil

	self._storyteller:stop(story.id)
end

NetworkStoryManager.play_story = function (self, story_name, story_level, speed, loop_mode)
	speed = speed or 1

	if self._is_server then
		local story = self._levels[story_level][story_name]

		if story.state == self.NETWORK_STORY_STATES.not_created then
			self:_create_story(story_name, story_level)
		end

		if self._storyteller and story then
			local story_id = story.id

			self._storyteller:set_speed(story_id, speed)

			story.speed = speed

			if speed ~= 0 then
				self:_change_state(story, self.NETWORK_STORY_STATES.playing)
			end

			if loop_mode then
				self._storyteller:set_loop_mode(story_id, loop_mode)

				story.loop_mode = loop_mode
			end

			local time = self._storyteller:time(story_id)

			Managers.state.game_session:send_rpc_clients("rpc_network_story_sync", story.level_id, story_name, story.loop_mode, speed, time)

			return story_id
		end
	end

	return -1
end

NetworkStoryManager.set_story_loop_mode = function (self, story_name, story_level, loop_mode)
	if self._is_server then
		local story = self._levels[story_level][story_name]

		if self._storyteller and story then
			local story_id = story.id

			if loop_mode ~= story.loop_mode then
				return story_id
			end

			self._storyteller:set_loop_mode(story_id, loop_mode)

			story.loop_mode = loop_mode

			local time = self._storyteller:time(story_id)

			Managers.state.game_session:send_rpc_clients("rpc_network_story_sync", story.level_id, story_name, loop_mode, story.speed, time)

			return story_id
		end
	end
end

NetworkStoryManager.reset_story = function (self, story_name, story_level)
	local story = self._levels[story_level][story_name]

	if story.state == self.NETWORK_STORY_STATES.not_created then
		self:_create_story(story_name, story_level)
	else
		self._storyteller:set_time(story.id, 0)
		self._storyteller:set_speed(story.id, 0)

		story.speed = 0

		self:_change_state(story, self.NETWORK_STORY_STATES.pause_at_start)
	end
end

NetworkStoryManager.play_story_from_start = function (self, story_name, story_level, speed)
	self:reset_story(story_name, story_level)

	return self:play_story(story_name, story_level, speed)
end

NetworkStoryManager.get_story_time = function (self, story_name, story_level)
	local story = self._levels[story_level][story_name]

	if story then
		return self._storyteller:time(story.id)
	end

	return -1
end

NetworkStoryManager.get_story_length = function (self, story_name, story_level)
	local story = self._levels[story_level][story_name]

	if story then
		return story.length
	end

	return -1
end

NetworkStoryManager.get_story_state = function (self, story_name, story_level)
	local story = self._levels[story_level][story_name]

	if story then
		return story.state
	end

	return self.NETWORK_STORY_STATES.none
end

NetworkStoryManager.get_story_id = function (self, story_name, story_level)
	local story = self._levels[story_level][story_name]

	if story then
		return story.id
	end

	return -1
end

NetworkStoryManager.rpc_network_story_sync = function (self, channel_id, level_id, story_name, loop_mode, story_speed, story_time)
	local story_level = ScriptWorld.level_from_id(self._world, level_id)
	local story = self._levels[story_level][story_name]

	if story.state == self.NETWORK_STORY_STATES.not_created then
		self:_create_story(story_name, story_level)
	end

	self._storyteller:set_time(story.id, story_time)
	self._storyteller:set_speed(story.id, story_speed)
	self._storyteller:set_loop_mode(story.id, loop_mode)

	if story_speed ~= 0 then
		self:_change_state(story, self.NETWORK_STORY_STATES.playing)
	end

	story.speed = story_speed
	story.loop_mode = loop_mode
end

NetworkStoryManager.rpc_network_story_set_position_level = function (self, channel_id, level_id, unit_id, is_level_unit)
	local unit_spawner_manager = Managers.state.unit_spawner
	local unit = unit_spawner_manager:unit(unit_id, is_level_unit)
	local story_level = ScriptWorld.level_from_id(self._world, level_id)

	self:set_position_level(story_level, unit)
end

NetworkStoryManager._sync_stories = function (self, peer, channel_id)
	local story_time_constants = NetworkConstants.story_time
	local min_story_time = story_time_constants.min
	local max_story_time = story_time_constants.max
	local storyteller = self._storyteller

	for level, stories in pairs(self._levels) do
		for story_name, story in pairs(stories) do
			if story.state ~= self.NETWORK_STORY_STATES.not_created then
				local story_time = storyteller:time(story.id)

				story_time = math.clamp(story_time, min_story_time, max_story_time)

				RPC.rpc_network_story_sync(channel_id, story.level_id, story_name, story.loop_mode, story.speed, story_time)
			end
		end
	end
end

return NetworkStoryManager
