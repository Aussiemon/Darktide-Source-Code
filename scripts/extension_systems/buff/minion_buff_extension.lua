require("scripts/extension_systems/buff/buff_extension_base")

local Ailment = require("scripts/utilities/ailment")
local BuffExtensionInterface = require("scripts/extension_systems/buff/buff_extension_interface")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local BuffExtensionBase = require("scripts/extension_systems/buff/buff_extension_base")
local FixedFrame = require("scripts/utilities/fixed_frame")
local MinionBuffExtension = class("MinionBuffExtension", "BuffExtensionBase")
MinionBuffExtension.UPDATE_DISABLED_BY_DEFAULT = true

MinionBuffExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._owner_system = extension_init_context.owner_system

	MinionBuffExtension.super.init(self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id, false)
end

local buffs_to_sync = {}

MinionBuffExtension.hot_join_sync = function (self, unit, sender, channel)
	if self._buff_context.is_local_unit then
		return
	end

	local network_lookup_buff_templates = NetworkLookup.buff_templates

	table.clear(buffs_to_sync)

	local buffs = self._buffs_by_index

	for index, buff_instance in pairs(buffs) do
		if not buffs_to_sync[buff_instance] then
			buffs_to_sync[buff_instance] = {}
		end

		local local_indexes = buffs_to_sync[buff_instance]
		local_indexes[#local_indexes + 1] = index
	end

	local game_object_id = self._game_object_id

	for buff_instance, index_array in pairs(buffs_to_sync) do
		local template = buff_instance:template()
		local template_name = template.name
		local buff_template_id = network_lookup_buff_templates[template_name]
		local optional_lerp_value = buff_instance:buff_lerp_value()
		local num_index_array = #index_array

		if num_index_array == 1 then
			local index = index_array[1]

			RPC.rpc_add_buff(channel, game_object_id, buff_template_id, index, optional_lerp_value, nil, nil, false)
		else
			RPC.rpc_add_buff_with_stacks(channel, game_object_id, buff_template_id, index_array, optional_lerp_value, nil, nil, false)
		end
	end
end

MinionBuffExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
	local buffs_added_before_game_object_creation = self._buffs_added_before_game_object_creation

	if buffs_added_before_game_object_creation then
		for i = 1, #buffs_added_before_game_object_creation do
			local buff_added_before_game_object_creation = buffs_added_before_game_object_creation[i]
			local buff_template_id = buff_added_before_game_object_creation.buff_template_id
			local index = buff_added_before_game_object_creation.index
			local optional_lerp_value = buff_added_before_game_object_creation.optional_lerp_value
			local optional_slot_id, optional_parent_buff_template_id = nil
			local from_specialization = false

			Managers.state.game_session:send_rpc_clients("rpc_add_buff", game_object_id, buff_template_id, index, optional_lerp_value, optional_slot_id, optional_parent_buff_template_id, from_specialization)
		end

		self._buffs_added_before_game_object_creation = nil
	end
end

MinionBuffExtension.update = function (self, unit, dt, t)
	self:_update_buffs(dt, t)
	self:_move_looping_sfx_sources(unit)
	self:_update_proc_events(t)
	self:_update_stat_buffs_and_keywords(t)
end

local base_request_proc_event_param_table = BuffExtensionBase.request_proc_event_param_table

MinionBuffExtension.request_proc_event_param_table = function (self)
	if not self._update_enabled then
		return nil
	end

	return base_request_proc_event_param_table(self)
end

MinionBuffExtension._on_add_buff = function (self, buff_instance)
	if not self._update_enabled and #self._buffs == 0 then
		self._update_enabled = true

		self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)
	end
end

MinionBuffExtension._on_remove_buff = function (self, buff_instance)
	if self._update_enabled and #self._buffs == 1 then
		self._update_enabled = false

		self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
	end
end

MinionBuffExtension._on_remove_buff_stack = function (self, buff_instance, previous_stack_count)
	local template = buff_instance:template()
	local minion_effects = template.minion_effects

	if minion_effects then
		local stack_node_effects = minion_effects.stack_node_effects

		if stack_node_effects then
			local current_stack_count = buff_instance:stack_count()

			self:_check_stack_node_effects(stack_node_effects, current_stack_count, previous_stack_count)
		end

		local stack_material_vectors = minion_effects.stack_material_vectors

		if stack_material_vectors then
			local current_stack_count = buff_instance:stack_count()
			local material_vector = stack_material_vectors[math.min(current_stack_count, #stack_material_vectors)]

			if material_vector then
				local name = material_vector.name
				local value = material_vector.value

				Unit.set_vector3_for_materials(self._unit, name, Vector3(value[1], value[2], value[3]), true)
			end
		end
	end

	MinionBuffExtension.super._on_remove_buff_stack(self, buff_instance, previous_stack_count)
end

MinionBuffExtension._on_add_buff_stack = function (self, buff_instance, previous_stack_count)
	local template = buff_instance:template()
	local minion_effects = template.minion_effects

	if minion_effects then
		local stack_node_effects = minion_effects.stack_node_effects

		if stack_node_effects then
			local current_stack_count = buff_instance:stack_count()

			self:_check_stack_node_effects(stack_node_effects, current_stack_count, previous_stack_count)
		end

		local stack_material_vectors = minion_effects.stack_material_vectors

		if stack_material_vectors then
			local current_stack_count = buff_instance:stack_count()
			local material_vector = stack_material_vectors[math.min(current_stack_count, #stack_material_vectors)]

			if material_vector then
				local name = material_vector.name
				local value = material_vector.value

				Unit.set_vector3_for_materials(self._unit, name, Vector3(value[1], value[2], value[3]), true)
			end
		end
	end

	MinionBuffExtension.super._on_add_buff_stack(self, buff_instance, previous_stack_count)
end

MinionBuffExtension._post_on_remove_buff = function (self, buff_instance)
	local t = FixedFrame.get_latest_fixed_time()

	self:_update_proc_events(t)
	self:_update_stat_buffs_and_keywords(t, true)
end

MinionBuffExtension.add_proc_event = function (self, event, params)
	local buff_context = self._buff_context

	if buff_context.is_local_unit then
		params.is_local_proc_event = true
	end

	MinionBuffExtension.super.add_proc_event(self, event, params)
end

MinionBuffExtension.add_internally_controlled_buff = function (self, template_name, t, ...)
	local is_local_unit = self._buff_context.is_local_unit

	if not self._is_server and not is_local_unit then
		return
	end

	local template = BuffTemplates[template_name]
	local can_add_internally_controlled_buff = self:_can_add_internally_controlled_buff(template, t)

	if can_add_internally_controlled_buff then
		if is_local_unit then
			self:_add_buff(template, t, ...)
		else
			self:_add_rpc_synced_buff(template, t, ...)
		end
	end
end

MinionBuffExtension.add_externally_controlled_buff = function (self, template_name, t, ...)
	local client_tried_adding_rpc_buff = false
	local is_local_unit = self._buff_context.is_local_unit

	if not self._is_server and not is_local_unit then
		client_tried_adding_rpc_buff = true
	end

	if client_tried_adding_rpc_buff then
		return client_tried_adding_rpc_buff
	end

	local template = BuffTemplates[template_name]
	local should_be_muted = not self:_check_keywords(template)
	local local_index = nil

	if should_be_muted then
		local_index = self:_next_local_index()
		self._muted_external_buffs[local_index] = template
	elseif is_local_unit then
		local_index = self:_add_buff(template, t, ...)
	else
		local_index = self:_add_rpc_synced_buff(template, t, ...)
	end

	return client_tried_adding_rpc_buff, local_index
end

MinionBuffExtension.remove_externally_controlled_buff = function (self, local_index)
	local muted_external_buffs = self._muted_external_buffs

	if muted_external_buffs[local_index] then
		muted_external_buffs[local_index] = nil

		return
	end

	local is_local_unit = self._buff_context.is_local_unit

	if is_local_unit then
		return
	end

	local buff_instance = self._buffs_by_index[local_index]

	if is_local_unit then
		self:_remove_buff(local_index)
	elseif self._is_server then
		self:_remove_rpc_synced_buff(local_index)
	end
end

MinionBuffExtension._remove_internally_controlled_buff = function (self, local_index)
	local buff_instance = self._buffs_by_index[local_index]

	if self._buff_context.is_local_unit then
		self:_remove_buff(local_index)
	elseif self._is_server then
		self:_remove_rpc_synced_buff(local_index)
	end
end

MinionBuffExtension._add_rpc_synced_buff = function (self, template, t, ...)
	local index = self:_add_buff(template, t, ...)
	local game_object_id = self._game_object_id
	local template_name = template.name
	local buff_template_id = NetworkLookup.buff_templates[template_name]
	local buff_instance = self._buffs_by_index[index]
	local optional_lerp_value = buff_instance:buff_lerp_value()

	if game_object_id then
		Managers.state.game_session:send_rpc_clients("rpc_add_buff", game_object_id, buff_template_id, index, optional_lerp_value, nil, nil, false)
	else
		local buff_added_before_game_object_creation = {
			from_specialization = false,
			buff_template_id = buff_template_id,
			index = index,
			optional_lerp_value = optional_lerp_value
		}
		local buffs_added_before_game_object_creation = self._buffs_added_before_game_object_creation
		buffs_added_before_game_object_creation[#buffs_added_before_game_object_creation + 1] = buff_added_before_game_object_creation
	end

	return index
end

MinionBuffExtension._remove_rpc_synced_buff = function (self, index)
	local game_object_id = self._game_object_id

	self:_remove_buff(index)
	Managers.state.game_session:send_rpc_clients("rpc_remove_buff", game_object_id, index)
end

MinionBuffExtension._set_proc_active_start_time = function (self, index, activation_time)
	if self._is_server then
		local activation_frame = activation_time / self._fixed_time_step
		local game_object_id = self._game_object_id

		Managers.state.game_session:send_rpc_clients("rpc_buff_proc_set_active_time", game_object_id, index, activation_frame)
	else
		local buffs_by_index = self._buffs_by_index
		local buff_instance = buffs_by_index[index]

		if buff_instance and buff_instance.set_active_start_time then
			buff_instance:set_active_start_time(activation_time)
		end
	end
end

MinionBuffExtension._start_fx = function (self, index, template)
	MinionBuffExtension.super._start_fx(self, index, template)

	local buff_context = self._buff_context
	local unit = buff_context.unit
	local minion_effects = template.minion_effects

	Unit.set_permutation_for_materials(unit, "HAVE_BURN", true, true)

	if minion_effects then
		local ailment_effect = minion_effects.ailment_effect

		if ailment_effect then
			local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
			local existing_ailment_effect = visual_loadout_extension:ailment_effect()

			if not existing_ailment_effect then
				local include_children = true

				Ailment.play_ailment_effect_template(unit, ailment_effect, include_children)
				visual_loadout_extension:set_ailment_effect(ailment_effect)
			end
		end

		local node_effects = minion_effects.node_effects

		if node_effects then
			self:_start_node_effects(node_effects)
		end

		local material_vector = minion_effects.material_vector

		if material_vector then
			local name = material_vector.name
			local value = material_vector.value

			Unit.set_vector3_for_materials(self._unit, name, Vector3(value[1], value[2], value[3]), true)
		end

		if self._is_server then
			local effect_template = minion_effects.effect_template

			if effect_template then
				local fx_system = Managers.state.extension:system("fx_system")
				local effect_template_id = fx_system:start_template_effect(effect_template, unit)
				self._effect_template_id = effect_template_id
			end
		end
	end
end

MinionBuffExtension._stop_fx = function (self, index, template)
	local minion_effects = template.minion_effects

	if minion_effects then
		local minion_node_effects = minion_effects.node_effects

		if minion_node_effects then
			self:_stop_node_effects(minion_node_effects)
		end

		local material_vector = minion_effects.material_vector

		if material_vector then
			local name = material_vector.name

			Unit.set_vector3_for_materials(self._unit, name, Vector3(0, 0, 0), true)
		end

		if self._is_server then
			local effect_template = minion_effects.effect_template
			local fx_system = Managers.state.extension:system("fx_system")

			if effect_template and self._effect_template_id and fx_system:has_running_global_effect_id(self._effect_template_id) then
				fx_system:stop_template_effect(self._effect_template_id)
			end
		end
	end

	MinionBuffExtension.super._stop_fx(self, index, template)
end

implements(MinionBuffExtension, BuffExtensionInterface)

return MinionBuffExtension
