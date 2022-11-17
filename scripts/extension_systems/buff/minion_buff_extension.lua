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

	MinionBuffExtension.super.init(self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
end

MinionBuffExtension.hot_join_sync = function (self, unit, sender, channel)
	if self._buff_context.is_local_unit then
		return
	end

	local game_object_id = self._game_object_id
	local network_lookup_buff_templates = NetworkLookup.buff_templates
	local buffs = self._buffs_by_index

	for index, buff_instance in pairs(buffs) do
		local template = buff_instance:template()
		local template_name = template.name
		local buff_template_id = network_lookup_buff_templates[template_name]
		local optional_lerp_value = buff_instance:buff_lerp_value()
		local optional_item_slot = buff_instance:item_slot_name()
		local optional_slot_id = optional_item_slot and NetworkLookup.player_inventory_slot_names[optional_item_slot]

		RPC.rpc_add_buff(channel, game_object_id, buff_template_id, index, optional_lerp_value, optional_slot_id)

		if buff_instance.update_proc_events and buff_instance:is_active() then
			local active_start_time = buff_instance:active_start_time()

			RPC.rpc_buff_proc_set_active_time(channel, game_object_id, index, active_start_time)
		end
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

MinionBuffExtension._start_fx = function (self, index, template)
	MinionBuffExtension.super._start_fx(self, index, template)

	local buff_context = self._buff_context
	local unit = buff_context.unit
	local minion_effects = template.minion_effects

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
			local world = buff_context.world
			local wwise_world = buff_context.wwise_world
			local active_vfx = self._active_vfx[index]

			self:_start_node_effects(node_effects, unit, world, wwise_world, active_vfx)
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
	end

	MinionBuffExtension.super._stop_fx(self, index, template)
end

implements(MinionBuffExtension, BuffExtensionInterface)

return MinionBuffExtension
