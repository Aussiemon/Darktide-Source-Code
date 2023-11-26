-- chunkname: @scripts/extension_systems/weapon/actions/action_chain_lightning_powerup.lua

require("scripts/extension_systems/weapon/actions/action_chain_lightning_new")

local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTarget = require("scripts/utilities/action/chain_lightning_target")
local FixedFrame = require("scripts/utilities/fixed_frame")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local ActionChainLightningPowerup = class("ActionChainLightningPowerup", "ActionChainLightning")
local special_rules = SpecialRulesSetting.special_rules
local DEPTH_FIRST_VALIDATION = ChainLightning.depth_first_validation_functions
local _on_transfer_func, _on_remove_func

ActionChainLightningPowerup._action_specific_init = function (self, action_context, action_params, action_settings)
	if self._is_server then
		self._chain_root_node = nil
		self._temp_targets = {}
		self._hit_units = {}

		local specialization_extension = ScriptUnit.has_extension(self._player_unit, "specialization_system")

		self._func_context = {
			action_settings = self._action_settings,
			buff_extension = self._buff_extension,
			hit_units = self._hit_units,
			player_unit = self._player_unit,
			specialization_extension = specialization_extension
		}

		self:_create_chain_root_node(action_settings)
	end
end

ActionChainLightningPowerup._action_specific_start = function (self, action_settings, t, time_scale, action_start_params)
	if self._is_server then
		self:_clear_initial_targets()
		ChainLightningTarget.remove_all_child_nodes(self._chain_root_node, _on_remove_func, self._func_context)
		table.clear(self._temp_targets)

		local is_chain_action = action_start_params.is_chain_action
		local previous_action_chain_root_node = action_start_params.chain_root_node

		if is_chain_action and previous_action_chain_root_node then
			ChainLightningTarget.move_all_child_nodes_to_new_root(previous_action_chain_root_node, self._chain_root_node, _on_transfer_func, nil, self._func_context)
		else
			table.clear(self._hit_units)
			self:_find_root_targets(t, 0)
		end
	end
end

local DAMAGE_INTERVAL = 0.5

ActionChainLightningPowerup._action_specific_fixed_update = function (self, dt, t, time_in_action)
	if not self._is_server then
		return
	end

	self:_validate_targets(t)

	local next_damage_t = self._next_damage_t or 0

	if t < next_damage_t then
		return
	end

	self._next_damage_t = t + DAMAGE_INTERVAL

	self:_deal_damage(t, time_in_action)
end

ActionChainLightningPowerup._validate_targets = function (self, t)
	local temp_targets = self._temp_targets

	table.clear(temp_targets)
	ChainLightningTarget.traverse_depth_first(t, self._chain_root_node, temp_targets, DEPTH_FIRST_VALIDATION.node_target_not_alive)

	local num_targets = #temp_targets

	for ii = num_targets, 1, -1 do
		local node = temp_targets[ii]

		ChainLightningTarget.remove_node_and_transfer_all_child_nodes_to_parent(node, nil, _on_remove_func, self._func_context)
	end
end

ActionChainLightningPowerup._cleanup_chain_targets = function (self, t, time_in_action, next_action_params)
	if not self._is_server then
		return
	end

	self:_deal_damage(t, time_in_action)
	self:_clear_initial_targets()
	ChainLightningTarget.remove_all_child_nodes(self._chain_root_node, _on_remove_func, self._func_context)
end

function _on_transfer_func(node, context)
	local target_unit = node:value("unit")
	local old_buff_id = node:value("buff_id")
	local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if target_buff_extension then
		if old_buff_id then
			target_buff_extension:remove_externally_controlled_buff(old_buff_id)
			node:set_value("buff_id", nil)
		end

		local t = FixedFrame.get_latest_fixed_time()
		local action_settings = context.action_settings
		local improved_target_buff = context.specialization_extension:has_special_rule(special_rules.psyker_chain_lightning_improved_target_buff)
		local target_buff = improved_target_buff and action_settings.improved_target_buff or action_settings.target_buff
		local _, buff_id = target_buff_extension:add_externally_controlled_buff(target_buff, t, "owner_unit", context.player_unit)

		node:set_value("buff_id", buff_id)
	end
end

function _on_remove_func(node, context)
	local target_unit = node:value("unit")
	local buff_id = node:value("buff_id")
	local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if buff_id and target_buff_extension then
		target_buff_extension:remove_externally_controlled_buff(buff_id)
		node:set_value("buff_id", nil)
	end
end

return ActionChainLightningPowerup
