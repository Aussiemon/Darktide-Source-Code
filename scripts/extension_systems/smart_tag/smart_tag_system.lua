-- chunkname: @scripts/extension_systems/smart_tag/smart_tag_system.lua

require("scripts/extension_systems/smart_tag/smart_tag_extension")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local SmartTagSettings = require("scripts/settings/smart_tag/smart_tag_settings")
local SmartTag = require("scripts/extension_systems/smart_tag/smart_tag")
local buff_proc_events = BuffSettings.proc_events
local SmartTagSystem = class("SmartTagSystem", "ExtensionSystemBase")
local REMOVE_TAG_REASONS = SmartTag.REMOVE_TAG_REASONS
local REMOVE_TAG_REASONS_LOOKUP = table.mirror_array_inplace(table.keys(REMOVE_TAG_REASONS))
local SERVER_RPCS = {
	"rpc_request_set_smart_tag",
	"rpc_request_cancel_smart_tag",
	"rpc_request_smart_tag_reply",
}
local CLIENT_RPCS = {
	"rpc_set_smart_tag",
	"rpc_set_smart_tag_hot_join",
	"rpc_remove_smart_tag",
	"rpc_smart_tag_reply",
}

local function _warning(...)
	Log.warning("SmartTagSystem", ...)
end

SmartTagSystem.init = function (self, extension_system_creation_context, ...)
	SmartTagSystem.super.init(self, extension_system_creation_context, ...)

	local network_event_delegate = extension_system_creation_context.network_event_delegate

	self._network_event_delegate = network_event_delegate

	if self._is_server then
		self._tag_id = 0

		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	self._all_tags = {}
	self._unit_extension_data = {}
end

SmartTagSystem.destroy = function (self)
	if self._is_server then
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	self._network_event_delegate = nil

	local tag_ids = table.keys(self._all_tags)

	for i = 1, #tag_ids do
		local tag_id = tag_ids[i]

		self:_remove_tag_locally(tag_id, REMOVE_TAG_REASONS.smart_tag_system_destroyed)
	end

	self._all_tags = nil
	self._unit_extension_data = nil
end

local temp_remove_tag_ids = {}
local temp_remove_tag_reason = {}

SmartTagSystem.update = function (self, context, dt, t, ...)
	if self._is_server then
		table.clear(temp_remove_tag_ids)
		table.clear(temp_remove_tag_reason)

		for tag_id, tag in pairs(self._all_tags) do
			local is_valid, remove_reason = tag:is_valid(t)

			if not is_valid then
				temp_remove_tag_ids[#temp_remove_tag_ids + 1] = tag_id
				temp_remove_tag_reason[#temp_remove_tag_reason + 1] = remove_reason
			else
				local template = tag:template()

				if template.update then
					template.update(tag)
				end
			end
		end

		for i = 1, #temp_remove_tag_ids do
			local tag_id = temp_remove_tag_ids[i]
			local reason = temp_remove_tag_reason[i]

			self:_remove_tag_locally(tag_id, reason)

			local reason_id = REMOVE_TAG_REASONS_LOOKUP[reason]

			Managers.state.game_session:send_rpc_clients("rpc_remove_smart_tag", tag_id, reason_id)
		end
	else
		for tag_id, tag in pairs(self._all_tags) do
			local template = tag:template()

			if template.update then
				template.update(tag)
			end
		end
	end
end

SmartTagSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = SmartTagSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	self._unit_extension_data[unit] = extension

	return extension
end

SmartTagSystem.on_remove_extension = function (self, unit, extension_name)
	local all_tags = self._all_tags
	local extension = self._unit_extension_data[unit]
	local owned_tag_ids = extension:owned_tag_ids()

	for i = 1, #owned_tag_ids do
		local tag_id = owned_tag_ids[i]

		all_tags[tag_id]:clear_tagger()
	end

	local replied_tag_ids = extension:replied_tag_ids()

	for tag_id, _ in pairs(replied_tag_ids) do
		all_tags[tag_id]:remove_reply(unit)
	end

	local tag_id = extension:tag_id()

	if tag_id then
		self:_remove_tag_locally(tag_id, REMOVE_TAG_REASONS.tagged_unit_removed)
	end

	self._unit_extension_data[unit] = nil

	SmartTagSystem.super.on_remove_extension(self, unit, extension_name)
end

local tg_on_tag_event_data = {}
local TRAINING_GROUNDS_GAME_MODE_NAME = "training_grounds"

SmartTagSystem.set_tag = function (self, template_name, tagger_unit, target_unit, target_location)
	local template = SmartTagSettings.templates[template_name]
	local tagger_game_object_id

	if tagger_unit then
		local tagger_extension = self._unit_extension_data[tagger_unit]

		tagger_game_object_id = Managers.state.unit_spawner:game_object_id(tagger_unit)
	end

	local target_game_object_id, target_level_index

	if target_unit then
		local target_extension = self._unit_extension_data[target_unit]
		local is_level_unit, target_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(target_unit)

		if is_level_unit then
			target_level_index = target_unit_id
		else
			target_game_object_id = target_unit_id
		end
	end

	local template_name_id = NetworkLookup.smart_tag_templates[template_name]
	local game_mode_name = Managers.state.game_mode:game_mode_name()

	if game_mode_name == TRAINING_GROUNDS_GAME_MODE_NAME then
		table.clear(tg_on_tag_event_data)

		tg_on_tag_event_data.target_unit = target_unit
		tg_on_tag_event_data.target_location = target_location
		tg_on_tag_event_data.template_name = template_name

		Managers.event:trigger("tg_on_tag", tg_on_tag_event_data)
	end

	if self._is_server then
		local tag_id = self:_generate_tag_id()
		local tag = self:_create_tag_locally(tag_id, template_name, tagger_unit, target_unit, target_location)

		if tagger_unit then
			self:_server_check_tag_group_limit(tagger_unit, tag:group())
		end

		Managers.state.game_session:send_rpc_clients("rpc_set_smart_tag", tag_id, template_name_id, tagger_game_object_id, target_game_object_id, target_level_index, target_location)
	else
		Managers.state.game_session:send_rpc_server("rpc_request_set_smart_tag", template_name_id, tagger_game_object_id, target_game_object_id, target_level_index, target_location)
	end
end

SmartTagSystem.set_contextual_unit_tag = function (self, tagger_unit, target_unit, alternate)
	local target_extension = self._unit_extension_data[target_unit]
	local template = target_extension and target_extension:contextual_tag_template(tagger_unit, alternate)

	if template then
		self:set_tag(template.name, tagger_unit, target_unit, nil)
	end
end

SmartTagSystem.cancel_tag = function (self, tag_id, remover_unit, exernal_removal)
	local tag = self._all_tags[tag_id]

	if self._is_server then
		local reason = exernal_removal and REMOVE_TAG_REASONS.external_removal or REMOVE_TAG_REASONS.canceled_by_owner

		self:_remove_tag_locally(tag_id, reason)

		local reason_id = REMOVE_TAG_REASONS_LOOKUP[reason]

		Managers.state.game_session:send_rpc_clients("rpc_remove_smart_tag", tag_id, reason_id)
	else
		local remover_game_object_id = Managers.state.unit_spawner:game_object_id(remover_unit)

		Managers.state.game_session:send_rpc_server("rpc_request_cancel_smart_tag", tag_id, remover_game_object_id)
	end
end

SmartTagSystem.trigger_tag_interaction = function (self, tag_id, interactor_unit, target_unit, optional_alternate)
	local all_tags = self._all_tags
	local tag = all_tags[tag_id]
	local target_extension = self._unit_extension_data[target_unit]
	local template = target_extension and target_extension:contextual_tag_template(interactor_unit, optional_alternate)
	local can_override = template and template.can_override

	if can_override then
		local current_tag_player = self:tagger_player_by_tag_id(tag_id)
		local current_tag_unit = current_tag_player and current_tag_player.player_unit

		if current_tag_unit then
			self:cancel_tag(tag_id, current_tag_unit, true)
			self:set_tag(template.name, interactor_unit, target_unit, nil)

			return
		end
	end

	if tag:tagger_unit() == interactor_unit then
		if tag:is_cancelable() then
			self:cancel_tag(tag_id, interactor_unit)
		end
	else
		local reply = tag:default_reply()

		if reply then
			self:reply_tag(tag_id, interactor_unit, reply.name)
		end
	end
end

SmartTagSystem.reply_tag = function (self, tag_id, replier_unit, reply_name)
	local tag = self._all_tags[tag_id]
	local replier_extension = self._unit_extension_data[replier_unit]
	local replier_game_object_id = Managers.state.unit_spawner:game_object_id(replier_unit)
	local reply_name_id = NetworkLookup.smart_tag_replies[reply_name]

	if self._is_server then
		local reply = SmartTagSettings.replies[reply_name]

		self:_add_reply_locally(tag_id, replier_unit, reply)
		Managers.state.game_session:send_rpc_clients("rpc_smart_tag_reply", tag_id, replier_game_object_id, reply_name_id)
	else
		Managers.state.game_session:send_rpc_server("rpc_request_smart_tag_reply", tag_id, replier_game_object_id, reply_name_id)
	end
end

SmartTagSystem.unit_tagged_by_player_unit = function (self, player_unit, optional_tag_marker_type)
	for _, tag in pairs(self._all_tags) do
		local template = tag and tag:template()
		local marker_type = template.marker_type

		if not optional_tag_marker_type or marker_type == optional_tag_marker_type then
			local tagger_unit = tag:tagger_unit()
			local target_unit = tag:target_unit()

			if tagger_unit == player_unit and target_unit then
				local unit_data = ScriptUnit.has_extension(target_unit, "unit_data_system")
				local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
				local target_breed = unit_data and unit_data:breed()

				if target_breed and target_breed.tags.minion and buff_extension and not buff_extension:has_keyword("unperceivable") then
					return target_unit, tag
				end
			end
		end
	end

	return nil
end

SmartTagSystem.unit_tag_id = function (self, unit)
	local extension = self._unit_extension_data[unit]
	local tag_id = extension and extension:tag_id()

	return tag_id
end

SmartTagSystem.tag_by_id = function (self, tag_id)
	if not tag_id then
		return nil
	end

	local tag = self._all_tags[tag_id]

	return tag
end

SmartTagSystem.unit_tag = function (self, unit)
	local tag_id = self:unit_tag_id(unit)

	if not tag_id then
		return nil
	end

	local tag = self._all_tags[tag_id]

	return tag
end

SmartTagSystem.is_unit_tagged = function (self, unit)
	local tag_id = self:unit_tag_id(unit)

	return tag_id and true or false
end

SmartTagSystem.location_tag_at_position = function (self, position, max_distance)
	local max_distance_sq = max_distance * max_distance
	local best_tag
	local best_tag_distance_sq = math.huge
	local Vector3_distance_squared = Vector3.distance_squared

	for _, tag in pairs(self._all_tags) do
		local tag_location = tag:target_location()

		if tag_location then
			local distance_sq = Vector3_distance_squared(tag_location, position)

			if distance_sq < max_distance_sq and distance_sq < best_tag_distance_sq then
				best_tag = tag
				best_tag_distance_sq = math.huge
			end
		end
	end

	return best_tag
end

SmartTagSystem.tagger_player_by_tag_id = function (self, tag_id)
	local tag = self._all_tags[tag_id]

	if not tag then
		return
	end

	local tagger_player = tag:tagger_player()

	return tagger_player
end

SmartTagSystem._generate_tag_id = function (self)
	local id = self._tag_id + 1

	self._tag_id = id

	return id
end

SmartTagSystem._create_tag_locally = function (self, tag_id, template_name, tagger_unit, target_unit, target_location, replies, is_hotjoin_synced)
	local template = SmartTagSettings.templates[template_name]
	local tag = SmartTag:new(tag_id, template, tagger_unit, target_unit, target_location, replies, self._is_server)

	self._all_tags[tag_id] = tag

	if self._is_server then
		local t = Managers.time:time("gameplay")
		local expire_time = t + template.lifetime

		tag:set_expire_time(expire_time)
	end

	if tagger_unit then
		local tagger_extension = self._unit_extension_data[tagger_unit]

		tagger_extension:register_owned_tag(tag_id)
	end

	if target_unit then
		local target_extension = self._unit_extension_data[target_unit]

		target_extension:register_tag(tag_id)

		if self._is_server and tagger_unit then
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system.side_by_unit[tagger_unit]
			local player_units = side.valid_player_units

			for i = 1, #player_units do
				local player_unit = player_units[i]
				local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

				if buff_extension then
					local param_table = buff_extension:request_proc_event_param_table()

					if param_table then
						param_table.unit = target_unit
						param_table.tagger_unit = tagger_unit
						param_table.tag_name = template_name

						buff_extension:add_proc_event(buff_proc_events.on_tag_unit, param_table)
					end
				end
			end
		end
	end

	if replies then
		for replier_unit, _ in pairs(replies) do
			local replier_extension = self._unit_extension_data[replier_unit]

			replier_extension:register_reply(tag_id)
		end
	end

	if template.start then
		template.start(tag, tagger_unit)
	end

	Managers.event:trigger("event_smart_tag_created", tag, is_hotjoin_synced)

	return tag
end

SmartTagSystem._remove_tag_locally = function (self, tag_id, reason)
	local tag = self._all_tags[tag_id]

	if not tag then
		return
	end

	local tagger_unit = tag:tagger_unit()

	if tagger_unit then
		local tagger_extension = self._unit_extension_data[tagger_unit]

		tagger_extension:unregister_owned_tag(tag_id)
	end

	local replies = tag:replies()

	for replier_unit, _ in pairs(replies) do
		local replier_extension = self._unit_extension_data[replier_unit]

		replier_extension:unregister_reply(tag_id)
	end

	local target_unit = tag:target_unit()

	if target_unit and ALIVE[target_unit] then
		local target_extension = self._unit_extension_data[target_unit]

		target_extension:unregister_tag(tag_id)

		if self._is_server and tagger_unit then
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system.side_by_unit[tagger_unit]
			local player_units = side.valid_player_units

			for i = 1, #player_units do
				local player_unit = player_units[i]
				local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

				if buff_extension then
					local param_table = buff_extension:request_proc_event_param_table()

					if param_table then
						param_table.unit = target_unit
						param_table.tagger_unit = tagger_unit

						buff_extension:add_proc_event(buff_proc_events.on_untag_unit, param_table)
					end
				end
			end
		end
	end

	local template = tag:template()

	if template.stop then
		template.stop(tag)
	end

	Managers.event:trigger("event_smart_tag_removed", tag, reason)
	tag:delete()

	self._all_tags[tag_id] = nil
end

SmartTagSystem._add_reply_locally = function (self, tag_id, replier_unit, reply)
	local tag = self._all_tags[tag_id]

	if not tag then
		return
	end

	tag:add_reply(replier_unit, reply)

	local replier_extension = self._unit_extension_data[replier_unit]

	replier_extension:register_reply(tag_id)

	local replier_player = Managers.state.player_unit_spawn:owner(replier_unit)

	Managers.event:trigger("event_smart_tag_reply_added", tag, reply, replier_player)
end

SmartTagSystem._server_check_tag_group_limit = function (self, tagger_unit, group)
	local all_tags = self._all_tags
	local group_limit = SmartTagSettings.groups[group].limit
	local tagger_extension = self._unit_extension_data[tagger_unit]
	local owned_tag_ids = tagger_extension:owned_tag_ids()
	local num_tags_in_group = 0

	for i = #owned_tag_ids, 1, -1 do
		local tag_id = owned_tag_ids[i]
		local tag = all_tags[tag_id]

		if tag:group() == group then
			num_tags_in_group = num_tags_in_group + 1

			if group_limit < num_tags_in_group then
				local reason = REMOVE_TAG_REASONS.group_limit_exceeded

				self:_remove_tag_locally(tag_id, reason)

				local reason_id = REMOVE_TAG_REASONS_LOOKUP[reason]

				Managers.state.game_session:send_rpc_clients("rpc_remove_smart_tag", tag_id, reason_id)

				break
			end
		end
	end
end

SmartTagSystem.hot_join_sync = function (self, sender, channel)
	local unit_spawner_manager = Managers.state.unit_spawner

	for tag_id, tag in pairs(self._all_tags) do
		local template = tag:template()
		local template_name_id = NetworkLookup.smart_tag_templates[template.name]
		local tagger_unit = tag:tagger_unit()
		local tagger_game_object_id = tagger_unit and unit_spawner_manager:game_object_id(tagger_unit)
		local target_unit = tag:target_unit()
		local target_game_object_id, target_level_index, target_location

		if target_unit then
			local is_level_unit, target_unit_id = unit_spawner_manager:game_object_id_or_level_index(target_unit)

			if is_level_unit then
				target_level_index = target_unit_id
			else
				target_game_object_id = target_unit_id
			end
		else
			target_location = tag:target_location()
		end

		local replies = tag:replies()
		local replier_array = {}
		local reply_name_id_array = {}

		for replier_unit, reply in pairs(replies) do
			replier_array[#replier_array + 1] = unit_spawner_manager:game_object_id(replier_unit)
			reply_name_id_array[#reply_name_id_array + 1] = NetworkLookup.smart_tag_replies[reply.name]
		end

		RPC.rpc_set_smart_tag_hot_join(channel, tag_id, template_name_id, tagger_game_object_id, target_game_object_id, target_level_index, target_location, replier_array, reply_name_id_array)
	end
end

SmartTagSystem.rpc_request_set_smart_tag = function (self, channel_id, template_name_id, tagger_game_object_id, target_game_object_id, target_level_index, target_location)
	local template_name = NetworkLookup.smart_tag_templates[template_name_id]
	local template = SmartTagSettings.templates[template_name]

	if not template then
		return _warning("Rejected tag request from %s, tag template %q does not exist", Network.peer_id(channel_id), template_name)
	end

	if not target_game_object_id and not target_level_index and not target_location then
		return _warning("Rejected tag request from %s, must supply either target_unit or target_location", Network.peer_id(channel_id))
	end

	local tagger_unit = Managers.state.unit_spawner:unit(tagger_game_object_id)

	if not tagger_unit or not self._unit_extension_data[tagger_unit] then
		return
	end

	local target_unit

	if target_game_object_id then
		target_unit = Managers.state.unit_spawner:unit(target_game_object_id, false)

		if not target_unit then
			return
		end
	elseif target_level_index then
		target_unit = Managers.state.unit_spawner:unit(target_level_index, true)

		if not target_unit then
			return
		end
	end

	if target_unit then
		local target_extension = self._unit_extension_data[target_unit]

		if not target_extension or target_extension:tag_id() and not template.can_override then
			return
		end
	end

	local tag_id = self:_generate_tag_id()
	local tag = self:_create_tag_locally(tag_id, template_name, tagger_unit, target_unit, target_location)

	self:_server_check_tag_group_limit(tagger_unit, tag:group())

	local player = Managers.state.player_unit_spawn:owner(tagger_unit)

	Managers.telemetry_reporters:reporter("smart_tag"):register_event(player, template_name)
	Managers.state.game_session:send_rpc_clients("rpc_set_smart_tag", tag_id, template_name_id, tagger_game_object_id, target_game_object_id, target_level_index, target_location)
end

SmartTagSystem.rpc_set_smart_tag = function (self, channel_id, tag_id, template_name_id, tagger_game_object_id, target_game_object_id, target_level_index, target_location)
	local template_name = NetworkLookup.smart_tag_templates[template_name_id]
	local unit_spawner_manager = Managers.state.unit_spawner
	local tagger_unit = tagger_game_object_id and unit_spawner_manager:unit(tagger_game_object_id)
	local target_unit

	if target_game_object_id then
		target_unit = unit_spawner_manager:unit(target_game_object_id, false)
	elseif target_level_index then
		target_unit = unit_spawner_manager:unit(target_level_index, true)
	end

	self:_create_tag_locally(tag_id, template_name, tagger_unit, target_unit, target_location)
end

SmartTagSystem.rpc_set_smart_tag_hot_join = function (self, channel_id, tag_id, template_name_id, tagger_game_object_id, target_game_object_id, target_level_index, target_location, replier_array, reply_name_id_array)
	local template_name = NetworkLookup.smart_tag_templates[template_name_id]
	local unit_spawner_manager = Managers.state.unit_spawner
	local tagger_unit = tagger_game_object_id and unit_spawner_manager:unit(tagger_game_object_id)
	local target_unit

	if target_game_object_id then
		target_unit = unit_spawner_manager:unit(target_game_object_id, false)
	elseif target_level_index then
		target_unit = unit_spawner_manager:unit(target_level_index, true)
	end

	local replies = {}

	for i = 1, #replier_array do
		local replier_game_object_id = replier_array[i]
		local replier_unit = unit_spawner_manager:unit(replier_game_object_id)
		local reply_name_id = reply_name_id_array[i]
		local reply_name = NetworkLookup.smart_tag_replies[reply_name_id]
		local reply = SmartTagSettings.replies[reply_name]

		replies[replier_unit] = reply
	end

	local is_hotjoin_synced = true

	self:_create_tag_locally(tag_id, template_name, tagger_unit, target_unit, target_location, replies, is_hotjoin_synced)
end

SmartTagSystem.rpc_remove_smart_tag = function (self, channel_id, tag_id, reason_id)
	local reason = REMOVE_TAG_REASONS_LOOKUP[reason_id]

	self:_remove_tag_locally(tag_id, reason)
end

SmartTagSystem.rpc_request_cancel_smart_tag = function (self, channel_id, tag_id, remover_game_object_id)
	local tag = self._all_tags[tag_id]

	if not tag then
		return
	end

	local remover_unit = Managers.state.unit_spawner:unit(remover_game_object_id)

	if tag:tagger_unit() ~= remover_unit then
		_warning("Rejected request from %s to cancel tag, tag is owned by someone else", Network.peer_id(channel_id))

		return
	end

	local reason = REMOVE_TAG_REASONS.canceled_by_owner

	self:_remove_tag_locally(tag_id, reason)

	local reason_id = REMOVE_TAG_REASONS_LOOKUP[reason]

	Managers.state.game_session:send_rpc_clients("rpc_remove_smart_tag", tag_id, reason_id)
end

SmartTagSystem.rpc_request_smart_tag_reply = function (self, channel_id, tag_id, replier_game_object_id, reply_name_id)
	local tag = self._all_tags[tag_id]

	if not tag then
		return
	end

	local replier_unit = Managers.state.unit_spawner:unit(replier_game_object_id)

	if replier_unit == nil then
		return
	end

	if tag:tagger_unit() == replier_unit then
		_warning("Rejected request from %s to reply to tag, tag is owned by replier", Network.peer_id(channel_id))

		return
	end

	local reply_name = NetworkLookup.smart_tag_replies[reply_name_id]
	local reply = SmartTagSettings.replies[reply_name]

	self:_add_reply_locally(tag_id, replier_unit, reply)
	Managers.state.game_session:send_rpc_clients("rpc_smart_tag_reply", tag_id, replier_game_object_id, reply_name_id)
end

SmartTagSystem.rpc_smart_tag_reply = function (self, channel_id, tag_id, replier_game_object_id, reply_name_id)
	local replier_unit = Managers.state.unit_spawner:unit(replier_game_object_id)
	local reply_name = NetworkLookup.smart_tag_replies[reply_name_id]
	local reply = SmartTagSettings.replies[reply_name]

	self:_add_reply_locally(tag_id, replier_unit, reply)
end

return SmartTagSystem
