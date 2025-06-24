-- chunkname: @scripts/extension_systems/buff/player_unit_buff_extension.lua

require("scripts/extension_systems/buff/buff_extension_base")

local BuffArgs = require("scripts/extension_systems/buff/utility/buff_args")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffExtensionInterface = require("scripts/extension_systems/buff/buff_extension_interface")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local Missions = require("scripts/settings/mission/mission_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local MAX_COMPONENT_BUFFS = PlayerCharacterConstants.max_component_buffs
local COMPONENT_KEY_LOOKUP = PlayerCharacterConstants.buff_component_key_lookup
local PlayerUnitBuffExtension = class("PlayerUnitBuffExtension", "BuffExtensionBase")

PlayerUnitBuffExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	PlayerUnitBuffExtension.super.init(self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id, true)

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local buff_component = unit_data_extension:write_component("buff")

	self._buff_component = buff_component
	self._on_screen_effects = {}
	self._active_effect_templates = {}

	local buff_context = self._buff_context

	buff_context.player = extension_init_data.player
	self._max_component_buffs = MAX_COMPONENT_BUFFS
	self._component_buffs = Script.new_array(MAX_COMPONENT_BUFFS)
	self._fx_system = Managers.state.extension:system("fx_system")

	self:_init_components(buff_component)

	if self._is_server then
		self:_init_sync_data(game_object_data_or_game_session)
	else
		self._game_session = game_object_data_or_game_session
		self._game_object_id = nil_or_game_object_id
	end

	local mission_name = Managers.state.mission:mission_name()
	local mission_settings = mission_name and Missions[mission_name]

	self._is_hub = mission_settings and mission_settings.is_hub
	self._cinematic_active = false
end

PlayerUnitBuffExtension._init_components = function (self, buff_component)
	for i = 1, MAX_COMPONENT_BUFFS do
		local key_lookup = COMPONENT_KEY_LOOKUP[i]
		local template_name_key = key_lookup.template_name_key
		local start_time_key = key_lookup.start_time_key
		local active_start_time_key = key_lookup.active_start_time_key
		local stack_count_key = key_lookup.stack_count_key
		local proc_count_key = key_lookup.proc_count_key

		buff_component[template_name_key] = "none"
		buff_component[start_time_key] = 0
		buff_component[active_start_time_key] = 0
		buff_component[stack_count_key] = 0
		buff_component[proc_count_key] = 0
	end

	local portable_random = self._portable_random
	local seed = portable_random:seed()

	buff_component.seed = seed
end

PlayerUnitBuffExtension._init_sync_data = function (self, game_object_data)
	local game_object_buff_keywords = {}
	local synced_buff_keywords = NetworkLookup.synced_buff_keywords

	for ii = 1, #synced_buff_keywords do
		game_object_buff_keywords[ii] = false
	end

	game_object_data.buff_keywords = game_object_buff_keywords
end

PlayerUnitBuffExtension.hot_join_sync = function (self, unit, sender, channel_id)
	return
end

PlayerUnitBuffExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_session = game_session
	self._game_object_id = game_object_id

	local channel_id = self._player:channel_id()
	local buffs_added_before_game_object_creation = self._buffs_added_before_game_object_creation

	if buffs_added_before_game_object_creation then
		for i = 1, #buffs_added_before_game_object_creation do
			local buff_added_before_game_object_creation = buffs_added_before_game_object_creation[i]
			local buff_template_id = buff_added_before_game_object_creation.buff_template_id
			local index = buff_added_before_game_object_creation.index
			local optional_lerp_value = buff_added_before_game_object_creation.optional_lerp_value
			local optional_slot_id = buff_added_before_game_object_creation.optional_slot_id
			local optional_parent_buff_template_id = buff_added_before_game_object_creation.optional_parent_buff_template_id
			local from_talent = buff_added_before_game_object_creation.from_talent

			RPC.rpc_add_buff(channel_id, game_object_id, buff_template_id, index, optional_lerp_value, optional_slot_id, optional_parent_buff_template_id, from_talent)
		end

		self._buffs_added_before_game_object_creation = nil
	end
end

PlayerUnitBuffExtension.extensions_ready = function (self, world, unit)
	self._toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
end

PlayerUnitBuffExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	local is_server = self._is_server
	local toughness_extension = self._toughness_extension
	local max_toughness_before

	if is_server and toughness_extension then
		max_toughness_before = toughness_extension:max_toughness()
	end

	self:_update_buffs(dt, t)
	self:_update_on_screen_fx()
	self:_move_looping_sfx_sources(unit)
	self:_update_proc_events(t)
	self:_update_stat_buffs_and_keywords(t)

	local portable_random = self._portable_random
	local buff_component = self._buff_component

	buff_component.seed = portable_random:seed()

	if is_server and toughness_extension then
		local max_toughness_after = toughness_extension:max_toughness()

		if max_toughness_before ~= max_toughness_after then
			toughness_extension:handle_max_toughness_changes_due_to_buffs(max_toughness_before, max_toughness_after)
		end
	end
end

local game_object_buff_keywords = {}

PlayerUnitBuffExtension.post_update = function (self, unit, dt, t)
	if not self._is_server then
		return
	end

	local synced_buff_keywords = NetworkLookup.synced_buff_keywords
	local active_keywords = self._keywords

	for ii = 1, #synced_buff_keywords do
		local buff_keyword = synced_buff_keywords[ii]

		game_object_buff_keywords[ii] = not not active_keywords[buff_keyword]
	end

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "buff_keywords", game_object_buff_keywords)

	local player = self._player
	local channel_id = player:channel_id()

	if player.remote then
		for index, buff_instance in pairs(self._buffs_by_index) do
			if buff_instance:need_to_sync_start_time() then
				local start_time = buff_instance:start_time()
				local start_frame = start_time / self._fixed_time_step
				local game_object_id = self._game_object_id

				RPC.rpc_buff_set_start_time(channel_id, game_object_id, index, start_frame)
				buff_instance:set_need_to_sync_start_time(false)
			end
		end
	end
end

PlayerUnitBuffExtension.add_internally_controlled_buff = function (self, template_name, t, ...)
	local template = BuffTemplates[template_name]
	local is_server = self._is_server

	if template.predicted then
		-- Nothing
	elseif not is_server then
		return
	end

	local can_add_internally_controlled_buff = self:_can_add_internally_controlled_buff(template, t)

	if can_add_internally_controlled_buff then
		if template.predicted then
			self:_add_predicted_buff(template, t, ...)
		else
			self:_add_rpc_synced_buff(template, t, ...)
		end
	elseif template.predicted then
		self:_update_predicted_buff_start_time_component_on_refresh(template_name)
	end
end

PlayerUnitBuffExtension.add_externally_controlled_buff = function (self, template_name, t, ...)
	local template = BuffTemplates[template_name]
	local is_server = self._is_server
	local client_tried_adding_rpc_buff, index, component_index

	if template.predicted then
		-- Nothing
	elseif not is_server then
		client_tried_adding_rpc_buff = true
	end

	if client_tried_adding_rpc_buff then
		return client_tried_adding_rpc_buff
	end

	local should_be_muted = not self:_check_keywords(template)

	if should_be_muted then
		index = self:_next_local_index()
		self._muted_external_buffs[index] = template
	elseif template.predicted then
		index, component_index = self:_add_predicted_buff(template, t, ...)
	else
		index = self:_add_rpc_synced_buff(template, t, ...)
	end

	return client_tried_adding_rpc_buff, index, component_index
end

PlayerUnitBuffExtension._next_available_component_index = function (self, template)
	local component_buffs = self._component_buffs
	local max_component_buffs = self._max_component_buffs

	for i = 1, max_component_buffs do
		local buff = component_buffs[i]

		if not buff then
			return i
		end
	end

	local buffs_error_string = ""

	for i = 1, max_component_buffs do
		local buff = component_buffs[i]

		buffs_error_string = buffs_error_string .. i .. ": " .. buff:template_name() .. (i < max_component_buffs and "\n" or "")
	end

	ferror("Tried adding a predicted buff %s with no available component buff slot.\nCurrent component buffs: \n%s", template.name, buffs_error_string)
end

PlayerUnitBuffExtension._add_predicted_buff = function (self, template, t, ...)
	local buff_component = self._buff_component
	local index = self:_add_buff(template, t, ...)
	local buff_instance = self._buffs_by_index[index]
	local component_index = buff_instance:component_index()

	if not component_index then
		local next_component_index = self:_next_available_component_index(template)
		local component_keys = COMPONENT_KEY_LOOKUP[next_component_index]

		buff_instance:set_buff_component(buff_component, component_keys, next_component_index)

		component_index = next_component_index
		self._component_buffs[component_index] = buff_instance
	else
		local component_keys = COMPONENT_KEY_LOOKUP[component_index]
		local stack_count_key = component_keys.stack_count_key
		local stack_count = buff_instance:stack_count()

		buff_component[stack_count_key] = stack_count

		local warning_stack_count = 32

		if warning_stack_count < stack_count then
			Log.warning("PlayerUnitBuffExtension", "Buff stack count of %s exceeding %d (%d)", template.name, warning_stack_count, stack_count)
		end

		if template.refresh_duration_on_stack or template.refresh_start_time_on_stack then
			local start_time_key = component_keys.start_time_key

			buff_component[start_time_key] = buff_instance:start_time()
		end
	end

	return index, component_index
end

PlayerUnitBuffExtension._update_predicted_buff_start_time_component_on_refresh = function (self, template_name)
	local stacking_buff_instance = self._stacking_buffs[template_name]
	local component_index = stacking_buff_instance and stacking_buff_instance:component_index()

	if stacking_buff_instance and component_index and stacking_buff_instance:need_to_sync_start_time() then
		local buff_component = self._buff_component
		local component_keys = COMPONENT_KEY_LOOKUP[component_index]
		local start_time_key = component_keys.start_time_key
		local start_time = stacking_buff_instance:start_time()

		buff_component[start_time_key] = start_time

		stacking_buff_instance:set_need_to_sync_start_time(false)
	end
end

PlayerUnitBuffExtension.remove_externally_controlled_buff = function (self, local_index, component_index)
	local muted_external_buffs = self._muted_external_buffs

	if muted_external_buffs[local_index] then
		muted_external_buffs[local_index] = nil

		return
	end

	local buff_instance = self._buffs_by_index[local_index]

	buff_instance = buff_instance or self._component_buffs[component_index]

	local template = buff_instance:template()

	if template.predicted then
		self:_remove_predicted_buff(component_index)
	elseif self._is_server then
		self:_remove_rpc_synced_buff(local_index)
	end
end

PlayerUnitBuffExtension.mark_buff_finished = function (self, local_index)
	local buff_instance = self._buffs_by_index[local_index]

	if buff_instance then
		buff_instance:force_finish()
	end
end

PlayerUnitBuffExtension.remove_internally_controlled_buff_stack = function (self, template_name)
	local buff_instance = self._stacking_buffs[template_name]

	return buff_instance:remove_stack()
end

PlayerUnitBuffExtension._remove_internally_controlled_buff = function (self, local_index)
	local buff_instance = self._buffs_by_index[local_index]
	local template = buff_instance:template()

	if template.predicted then
		local component_index = buff_instance:component_index()

		self:_remove_predicted_buff(component_index)
	elseif self._is_server then
		self:_remove_rpc_synced_buff(local_index)
	end
end

PlayerUnitBuffExtension._remove_predicted_buff = function (self, component_index)
	local buff_instance = self._component_buffs[component_index]
	local stack_count = buff_instance:stack_count()
	local component_keys = COMPONENT_KEY_LOOKUP[component_index]

	if stack_count > 1 then
		local buff_component = self._buff_component
		local stack_count_key = component_keys.stack_count_key

		buff_component[stack_count_key] = stack_count - 1
	else
		buff_instance:remove_buff_component()

		self._component_buffs[component_index] = nil
	end

	for index, buff in pairs(self._buffs_by_index) do
		if buff == buff_instance then
			self:_remove_buff(index)

			break
		end
	end
end

PlayerUnitBuffExtension._on_add_buff = function (self, buff_instance)
	local buff_context = self._buff_context
	local player = buff_context.player

	Managers.event:trigger("event_player_buff_added", player, buff_instance)
end

PlayerUnitBuffExtension._on_add_buff_stack = function (self, existing_buff_instance, previous_stack_count)
	PlayerUnitBuffExtension.super._on_add_buff_stack(self, existing_buff_instance, previous_stack_count)

	local buff_context = self._buff_context
	local player = buff_context.player

	Managers.event:trigger("event_player_buff_stack_added", player, existing_buff_instance)
end

PlayerUnitBuffExtension._on_remove_buff = function (self, buff_instance)
	local buff_context = self._buff_context
	local player = buff_context.player

	Managers.event:trigger("event_player_buff_removed", player, buff_instance)
end

PlayerUnitBuffExtension.server_correction_occurred = function (self, unit, from_frame, to_frame, client_simulated_components)
	local buff_component = self._buff_component
	local seed = buff_component.seed
	local portable_random = self._portable_random

	portable_random:set_seed(seed)

	local component_buffs = self._component_buffs
	local max_component_buffs = self._max_component_buffs

	for i = 1, max_component_buffs do
		local lookup = COMPONENT_KEY_LOOKUP[i]
		local template_name_key = lookup.template_name_key
		local component_template_name = buff_component[template_name_key]
		local current_buff = component_buffs[i]

		if current_buff then
			local current_template_name = current_buff:template_name()

			if current_template_name ~= component_template_name then
				self:_remove_buff_from_server_correction(i)

				component_buffs[i] = nil
			end
		end
	end

	for i = 1, max_component_buffs do
		local lookup = COMPONENT_KEY_LOOKUP[i]
		local template_name_key = lookup.template_name_key
		local start_time_key = lookup.start_time_key
		local component_template_name = buff_component[template_name_key]
		local component_start_time = buff_component[start_time_key]
		local current_buff = component_buffs[i]

		if not current_buff and component_template_name ~= "none" then
			self:_add_buff_from_server_correction(component_template_name, component_start_time, i)
		end
	end

	for i = 1, max_component_buffs do
		local lookup = COMPONENT_KEY_LOOKUP[i]
		local current_buff = component_buffs[i]

		if current_buff then
			local template_name_key = lookup.template_name_key
			local start_time_key = lookup.start_time_key
			local stack_count_key = lookup.stack_count_key
			local component_template_name = buff_component[template_name_key]
			local component_start_time = buff_component[start_time_key]
			local component_stack_count = buff_component[stack_count_key]

			current_buff:set_start_time(component_start_time)

			local stack_count_difference = component_stack_count - current_buff:stack_count()

			if stack_count_difference > 0 then
				for _ = 1, stack_count_difference do
					local template = BuffTemplates[component_template_name]

					self:_add_buff(template, component_start_time)
				end
			elseif stack_count_difference < 0 then
				local difference = stack_count_difference * -1

				for index, buff_instance in pairs(self._buffs_by_index) do
					if current_buff == buff_instance and difference > 0 then
						self:_remove_buff(index)

						difference = difference - 1
					end
				end
			end

			if current_buff.set_active_start_time then
				local active_start_time_key = lookup.active_start_time_key
				local component_active_start_time = buff_component[active_start_time_key]

				current_buff:set_active_start_time(component_active_start_time)
			end
		end
	end
end

PlayerUnitBuffExtension._remove_buff_from_server_correction = function (self, component_index)
	local component_buffs = self._component_buffs
	local buff = component_buffs[component_index]
	local buffs_by_index = self._buffs_by_index

	for index, buff_instance in pairs(buffs_by_index) do
		if buff == buff_instance then
			self:_remove_buff(index)
		end
	end
end

PlayerUnitBuffExtension._add_buff_from_server_correction = function (self, template_name, t, component_index)
	local template = BuffTemplates[template_name]
	local buff_component = self._buff_component
	local index = self:_add_buff(template, t)
	local buff_instance = self._buffs_by_index[index]
	local component_keys = COMPONENT_KEY_LOOKUP[component_index]

	buff_instance:set_buff_component(buff_component, component_keys, component_index)

	self._component_buffs[component_index] = buff_instance
end

PlayerUnitBuffExtension._add_rpc_synced_buff = function (self, template, t, ...)
	local index = self:_add_buff(template, t, ...)
	local game_object_id = self._game_object_id
	local template_name = template.name
	local buff_template_id = NetworkLookup.buff_templates[template_name]
	local buff_instance = self._buffs_by_index[index]
	local additional_arguments = buff_instance:additional_arguments()
	local optional_lerp_value = buff_instance:buff_lerp_value()
	local optional_item_slot = buff_instance:item_slot_name()
	local optional_slot_id = optional_item_slot and NetworkLookup.player_inventory_slot_names[optional_item_slot]
	local optional_parent_buff_template = buff_instance.parent_buff_template and buff_instance:parent_buff_template()
	local optional_parent_buff_template_id = optional_parent_buff_template and NetworkLookup.buff_templates[optional_parent_buff_template]
	local from_talent = additional_arguments.from_talent or false
	local player = self._player

	if player.remote then
		if game_object_id then
			local channel_id = player:channel_id()

			RPC.rpc_add_buff(channel_id, game_object_id, buff_template_id, index, optional_lerp_value, optional_slot_id, optional_parent_buff_template_id, from_talent)
		else
			local buff_added_before_game_object_creation = {
				buff_template_id = buff_template_id,
				index = index,
				optional_lerp_value = optional_lerp_value,
				optional_slot_id = optional_slot_id,
				optional_parent_buff_template_id = optional_parent_buff_template_id,
				from_talent = from_talent,
			}
			local buffs_added_before_game_object_creation = self._buffs_added_before_game_object_creation

			buffs_added_before_game_object_creation[#buffs_added_before_game_object_creation + 1] = buff_added_before_game_object_creation
		end
	end

	return index
end

PlayerUnitBuffExtension._remove_rpc_synced_buff = function (self, index)
	local game_object_id = self._game_object_id

	self:_remove_buff(index)

	local player = self._player

	if player.remote then
		local channel_id = player:channel_id()

		RPC.rpc_remove_buff(channel_id, game_object_id, index)
	end
end

PlayerUnitBuffExtension._set_proc_active_start_time = function (self, index, activation_time)
	if self._is_server then
		local activation_frame = activation_time / self._fixed_time_step
		local player = self._player

		if player.remote then
			local channel_id = player:channel_id()
			local game_object_id = self._game_object_id

			RPC.rpc_buff_proc_set_active_time(channel_id, game_object_id, index, activation_frame)
		end
	else
		local buffs_by_index = self._buffs_by_index
		local buff_instance = buffs_by_index[index]

		if buff_instance and buff_instance.set_active_start_time then
			buff_instance:set_active_start_time(activation_time)
		end
	end
end

PlayerUnitBuffExtension._set_start_time_from_rpc = function (self, index, start_time)
	if self._is_server then
		-- Nothing
	end

	local buffs_by_index = self._buffs_by_index
	local buff_instance = buffs_by_index[index]

	if buff_instance and buff_instance.set_start_time then
		buff_instance:set_start_time(start_time)
	end
end

PlayerUnitBuffExtension._start_fx = function (self, index, template)
	PlayerUnitBuffExtension.super._start_fx(self, index, template)

	local buff_context = self._buff_context
	local is_local_unit = buff_context.is_local_unit
	local unit = buff_context.unit
	local player_effects = template.player_effects
	local player = buff_context.player
	local is_human_controlled = player:is_human_controlled()

	if player_effects and is_local_unit and is_human_controlled then
		local on_screen_effect = player_effects.on_screen_effect

		if on_screen_effect and not self._cinematic_active then
			local world = buff_context.world
			local stop_type = player_effects.stop_type or "destroy"

			self:start_on_screen_effect(index, on_screen_effect, stop_type, world)
		end

		local on_add_wwise_event = player_effects.on_add_wwise_event

		if on_add_wwise_event then
			local wwise_world = buff_context.wwise_world

			WwiseWorld.trigger_resource_event(wwise_world, on_add_wwise_event)
		end

		local player_looping_wwise_start_event = player_effects.looping_wwise_start_event

		if player_looping_wwise_start_event then
			local wwise_world = buff_context.wwise_world

			WwiseWorld.trigger_resource_event(wwise_world, player_looping_wwise_start_event)
		end

		local wwise_state = player_effects.wwise_state

		if wwise_state then
			Wwise.set_state(wwise_state.group, wwise_state.on_state)
		end

		local node_effects = player_effects.node_effects

		if node_effects then
			self:_start_node_effects(node_effects)
		end

		local wwise_parameters = player_effects.wwise_parameters

		if wwise_parameters then
			for parameter_name, parameter_value in pairs(wwise_parameters) do
				Wwise.set_parameter(parameter_name, parameter_value)
			end
		end
	end

	if player_effects and self._is_server then
		local active_effect_templates = self._active_effect_templates
		local effect_template = player_effects.effect_template

		if effect_template and not active_effect_templates[index] then
			local effect_template_id = self._fx_system:start_template_effect(effect_template, unit)

			active_effect_templates[index] = effect_template_id
		end
	end
end

PlayerUnitBuffExtension.start_on_screen_effect = function (self, index, on_screen_effect, stop_type, world)
	if not self._on_screen_effects[index] then
		self._on_screen_effects[index] = {}
	end

	local on_screen_effects = self._on_screen_effects[index]
	local on_screen_effect_id = World.create_particles(world, on_screen_effect, Vector3(0, 0, 1))

	on_screen_effects[#on_screen_effects + 1] = {
		particle_id = on_screen_effect_id,
		stop_type = stop_type,
	}
end

PlayerUnitBuffExtension._stop_fx = function (self, index, template)
	local buff_context = self._buff_context
	local player_effects = template.player_effects
	local player = buff_context.player
	local is_human_controlled = player:is_human_controlled()

	if player_effects and is_human_controlled then
		local is_local_unit = buff_context.is_local_unit

		if is_local_unit then
			local wwise_state = player_effects.wwise_state

			if wwise_state then
				Wwise.set_state(wwise_state.group, wwise_state.off_state)
			end

			local player_looping_wwise_stop_event = player_effects.looping_wwise_stop_event

			if player_looping_wwise_stop_event then
				local wwise_world = self._buff_context.wwise_world

				WwiseWorld.trigger_resource_event(wwise_world, player_looping_wwise_stop_event)
			end

			local player_node_effects = player_effects.node_effects

			if player_node_effects then
				self:_stop_node_effects(player_node_effects)
			end

			local wwise_parameters = player_effects.wwise_parameters

			if wwise_parameters then
				for parameter_name, _ in pairs(wwise_parameters) do
					Wwise.set_parameter(parameter_name, 0)
				end
			end
		end
	end

	local world = buff_context.world

	self:_stop_on_screen_effects(index, world)

	if player_effects and self._is_server then
		local active_effect_templates = self._active_effect_templates
		local fx_system = self._fx_system
		local effect_template_id = active_effect_templates[index]
		local effect_template = player_effects.effect_template

		if effect_template and effect_template_id and fx_system:has_running_global_effect_id(effect_template_id) then
			fx_system:stop_template_effect(effect_template_id)

			active_effect_templates[index] = nil
		end
	end

	PlayerUnitBuffExtension.super._stop_fx(self, index, template)
end

PlayerUnitBuffExtension._stop_on_screen_effects = function (self, index, world)
	local on_screen_effects = self._on_screen_effects[index]

	if on_screen_effects then
		for i = 1, #on_screen_effects do
			local effect = on_screen_effects[i]
			local particle_id = effect.particle_id
			local stop_type = effect.stop_type

			if stop_type == "stop" then
				World.stop_spawning_particles(world, particle_id)
			else
				World.destroy_particles(world, particle_id)
			end
		end

		self._on_screen_effects[index] = nil
	end
end

PlayerUnitBuffExtension._is_cinematic_active = function (self)
	local extension_manager = Managers.state.extension
	local cinematic_scene_system = extension_manager:system("cinematic_scene_system")
	local cinematic_scene_system_active = cinematic_scene_system:is_active()
	local cinematic_manager = Managers.state.cinematic
	local cinematic_manager_active = cinematic_manager:cinematic_active()

	return cinematic_scene_system_active or cinematic_manager_active
end

PlayerUnitBuffExtension._update_on_screen_fx = function (self)
	local buff_context = self._buff_context
	local is_local_unit = buff_context.is_local_unit
	local player = self._player
	local is_human_controlled = player:is_human_controlled()
	local world = buff_context.world

	if not is_local_unit or not is_human_controlled then
		return
	end

	local prev_cinematic_active = self._cinematic_active
	local cinematic_active = self:_is_cinematic_active()

	self._cinematic_active = cinematic_active

	if prev_cinematic_active ~= cinematic_active then
		for index, buff_instance in pairs(self._buffs_by_index) do
			local instance_id = buff_instance:instance_id()

			if cinematic_active then
				self:_stop_on_screen_effects(instance_id, world)
			elseif not cinematic_active then
				local buff_template = buff_instance:template()
				local player_effects = buff_template.player_effects
				local on_screen_effect = player_effects and player_effects.on_screen_effect

				if on_screen_effect then
					local stop_type = player_effects.stop_type or "destroy"

					self:start_on_screen_effect(instance_id, on_screen_effect, stop_type, world)
				end
			end
		end
	end
end

local _inherited_buff_owner = {}

PlayerUnitBuffExtension.add_inherited_buff_owner = function (self, buff_provider)
	_inherited_buff_owner[#_inherited_buff_owner + 1] = buff_provider
end

PlayerUnitBuffExtension.get_inherited_buff_owner = function (self)
	local inherited_buff_owner = _inherited_buff_owner[1]

	table.remove(_inherited_buff_owner, 1)

	return inherited_buff_owner
end

implements(PlayerUnitBuffExtension, BuffExtensionInterface)

return PlayerUnitBuffExtension
