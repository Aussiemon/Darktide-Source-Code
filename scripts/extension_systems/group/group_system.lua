-- chunkname: @scripts/extension_systems/group/group_system.lua

require("scripts/extension_systems/group/minion_group_extension")
require("scripts/extension_systems/group/player_group_extension")

local BotGroup = require("scripts/extension_systems/group/bot_group")
local GroupSystem = class("GroupSystem", "ExtensionSystemBase")
local BOT_SERVER_RPCS = {
	"rpc_bot_unit_order",
	"rpc_bot_lookup_order",
}
local MINION_RPCS = {
	"rpc_start_group_sfx",
	"rpc_stop_group_sfx",
}

local function _register_bot_rpc(rpc_name)
	return function (self, channel_id, side_id, ...)
		local side_system = self._side_system
		local side = side_system:get_side(side_id)
		local bot_group = self._bot_groups[side]

		return bot_group[rpc_name](bot_group, channel_id, ...)
	end
end

GroupSystem.init = function (self, extension_system_creation_context, ...)
	GroupSystem.super.init(self, extension_system_creation_context, ...)

	self._groups = {}
	self._locked_group_ids = {}
	self._num_groups = 0
	self._current_group_id = 0

	self._network_event_delegate:register_session_events(self, unpack(MINION_RPCS))

	local is_server = self._is_server

	if is_server then
		local num_server_rpcs = #BOT_SERVER_RPCS

		for i = 1, num_server_rpcs do
			local rpc_name = BOT_SERVER_RPCS[i]

			self[rpc_name] = _register_bot_rpc(rpc_name)
		end

		self._network_event_delegate:register_session_events(self, unpack(BOT_SERVER_RPCS))

		local extension_manager = extension_system_creation_context.extension_manager

		self._side_system = extension_manager:system("side_system")
		self._bot_groups = {}
	end
end

GroupSystem.destroy = function (self)
	if self._is_server then
		self._network_event_delegate:unregister_events(unpack(BOT_SERVER_RPCS))
	end

	self._network_event_delegate:unregister_events(unpack(MINION_RPCS))
end

GroupSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	if self._is_server and extension_init_data.player then
		local side_id = extension_init_data.side_id
		local side_system = self._side_system
		local side = side_system:get_side(side_id)
		local bot_group = self._bot_groups[side]

		bot_group = bot_group or self:_create_bot_group(side)
		extension_init_data.bot_group = bot_group
	end

	local extension = GroupSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
	local group_id = extension_init_data.group_id

	if group_id then
		local group = self:group_from_id(group_id)

		if not group then
			self:_create_group(group_id)
		end

		self:_add_member_to_group(unit, group_id)
	end

	return extension
end

GroupSystem.register_extension_update = function (self, unit, extension_name, extension)
	GroupSystem.super.register_extension_update(self, unit, extension_name, extension)

	if extension.register_extension_update then
		extension:register_extension_update(unit)
	end
end

GroupSystem._create_bot_group = function (self, side)
	local nav_world, extension_manager = self._nav_world, self._extension_manager
	local bot_traverse_logic = Managers.state.bot_nav_transition:traverse_logic()
	local bot_group = BotGroup:new(side, nav_world, bot_traverse_logic, extension_manager)

	self._bot_groups[side] = bot_group

	return bot_group
end

GroupSystem.on_remove_extension = function (self, unit, extension_name)
	local unit_to_extension_map = self._unit_to_extension_map
	local extension = unit_to_extension_map[unit]
	local group_id = extension:group_id()

	if group_id then
		self:_remove_member_from_group(unit, group_id)
	end

	GroupSystem.super.on_remove_extension(self, unit, extension_name)

	if self._is_server then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local is_player_unit = player_unit_spawn_manager:is_player_unit(unit)

		if not is_player_unit then
			return
		end

		local side_system = self._side_system
		local side = side_system.side_by_unit[unit]
		local side_player_units = side:added_player_units()
		local num_side_player_units = #side_player_units

		if num_side_player_units <= 1 then
			self:_destroy_bot_group(side)
		end
	end
end

GroupSystem._destroy_bot_group = function (self, side)
	local bot_groups = self._bot_groups
	local bot_group = bot_groups[side]

	bot_group:delete()

	self._bot_groups[side] = nil
end

local DEFAULT_MIN_MINIONS = 5

GroupSystem._add_member_to_group = function (self, member_unit, group_id)
	local group = self:group_from_id(group_id)
	local member_id = #group.members + 1

	if member_id == DEFAULT_MIN_MINIONS then
		group.min_members_spawned = true

		if group.group_start_sound_event and not group.group_sound_event_started then
			self:start_group_sfx(group_id, group.group_start_sound_event, group.group_stop_sound_event)

			group.group_sound_event_started = true
		end
	end

	group.members[member_id] = member_unit
end

GroupSystem._remove_member_from_group = function (self, member_unit, group_id)
	local group = self:group_from_id(group_id)
	local members = group.members
	local member_id = table.index_of(members, member_unit)

	table.swap_delete(members, member_id)

	local extension = self._unit_to_extension_map[member_unit]

	extension:leave_group()

	if not self._locked_group_ids[group_id] and #members == 0 then
		if group.sfx then
			self:stop_group_sfx(group)
		end

		self:_remove_group(group_id)
	end
end

GroupSystem._create_group = function (self, id)
	local index = self._num_groups + 1
	local groups = self._groups
	local group = {
		min_members_spawned = false,
		id = id,
		members = {},
	}

	groups[index] = group
	self._num_groups = index
end

GroupSystem.generate_group_id = function (self)
	local group_id = self._current_group_id + 1

	self._current_group_id = group_id

	local group = self:group_from_id(group_id)

	if not group then
		self:_create_group(group_id)
	end

	return group_id
end

local TEMP_BOT_GROUPS = {}

GroupSystem.bot_groups_from_sides = function (self, sides)
	table.clear_array(TEMP_BOT_GROUPS, #TEMP_BOT_GROUPS)

	local bot_groups = self._bot_groups
	local num_sides = #sides

	for i = 1, num_sides do
		local side = sides[i]
		local bot_group = bot_groups[side]

		if bot_group then
			TEMP_BOT_GROUPS[#TEMP_BOT_GROUPS + 1] = bot_group
		end
	end

	return TEMP_BOT_GROUPS
end

GroupSystem.group_from_id = function (self, group_id)
	local groups = self._groups

	for i = 1, self._num_groups do
		local group = groups[i]
		local id = group.id

		if id == group_id then
			return group, i
		end
	end
end

GroupSystem.lock_group_id = function (self, group_id)
	self._locked_group_ids[group_id] = true
end

GroupSystem.unlock_group_id = function (self, group_id)
	self._locked_group_ids[group_id] = nil
end

GroupSystem.num_groups = function (self)
	return self._num_groups
end

GroupSystem._remove_group = function (self, group_id)
	local _, index = self:group_from_id(group_id)

	table.swap_delete(self._groups, index)

	self._num_groups = self._num_groups - 1
end

GroupSystem.update = function (self, context, dt, t)
	self:_update_group_sfx()

	if not self._is_server then
		return
	end

	local bot_groups = self._bot_groups

	for side, bot_group in pairs(bot_groups) do
		bot_group:update(side, dt, t)
	end
end

local function _get_group_average_position(group)
	local members = group.members
	local average_position = Vector3(0, 0, 0)
	local num_members = #members

	for i = 1, num_members do
		local member_unit = members[i]
		local position = Unit.world_position(member_unit, 1)

		average_position = average_position + position
	end

	average_position = num_members > 0 and average_position / num_members or average_position

	return average_position
end

GroupSystem.group_position = function (self, group_id)
	local group = self:group_from_id(group_id)

	if not group then
		return
	end

	return _get_group_average_position(group)
end

GroupSystem._update_group_sfx = function (self)
	local wwise_world = self._wwise_world

	for i = 1, self._num_groups do
		local group = self._groups[i]
		local group_sfx = group.sfx

		if group_sfx then
			local num_members = #group.members
			local playing_id = group_sfx.playing_id
			local is_currently_playing = WwiseWorld.is_playing(wwise_world, playing_id)

			if group.min_members_spawned and num_members < group_sfx.min_members or not is_currently_playing then
				self:stop_group_sfx(group)

				group.average_position = nil
			else
				local position = _get_group_average_position(group)

				WwiseWorld.set_source_position(wwise_world, group_sfx.source_id, position)
				WwiseWorld.set_source_parameter(wwise_world, group_sfx.source_id, "minion_counter_horde", num_members)
			end
		end
	end
end

GroupSystem.start_group_sfx = function (self, group_id, start_event_name, stop_event_name_or_nil, optional_min_members)
	local group = self:group_from_id(group_id)

	if not group then
		return
	end

	local wwise_world = self._wwise_world
	local position = _get_group_average_position(group)

	group.average_position = Vector3Box(position)

	local group_sfx = {}
	local wwise_source_id = WwiseWorld.make_manual_source(wwise_world, position)
	local playing_id = WwiseWorld.trigger_resource_event(wwise_world, start_event_name, false, wwise_source_id)
	local min_members = optional_min_members or DEFAULT_MIN_MINIONS

	group_sfx.source_id = wwise_source_id
	group_sfx.playing_id = playing_id
	group_sfx.stop_event = stop_event_name_or_nil
	group_sfx.min_members = min_members
	group.sfx = group_sfx

	if self._is_server then
		local start_event_id = NetworkLookup.sound_events[start_event_name]
		local stop_event_id = stop_event_name_or_nil and NetworkLookup.sound_events[stop_event_name_or_nil] or nil

		Managers.state.game_session:send_rpc_clients("rpc_start_group_sfx", group_id, start_event_id, stop_event_id)
	end
end

GroupSystem.stop_group_sfx = function (self, group)
	local group_sfx = group.sfx

	if not group_sfx then
		return
	end

	local wwise_world = self._wwise_world
	local stop_event_name = group_sfx.stop_event
	local source_id = group_sfx.source_id

	if stop_event_name then
		WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, false, source_id)
	end

	WwiseWorld.destroy_manual_source(wwise_world, source_id)

	group.sfx = nil
end

GroupSystem.rpc_start_group_sfx = function (self, channel_id, group_id, start_event_id, stop_event_id)
	local start_event_name = NetworkLookup.sound_events[start_event_id]
	local stop_event_name = stop_event_id and NetworkLookup.sound_events[stop_event_id] or nil

	self:start_group_sfx(group_id, start_event_name, stop_event_name)
end

GroupSystem.rpc_stop_group_sfx = function (self, channel_id, group_id)
	local group = self:group_from_id(group_id)

	self:stop_group_sfx(group)
end

return GroupSystem
