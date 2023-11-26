﻿-- chunkname: @scripts/extension_systems/weapon/weapon_action_movement.lua

local Action = require("scripts/utilities/weapon/action")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local SharedFunctions = require("scripts/extension_systems/weapon/weapon_action_movement_shared")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local group_keywords = BuffSettings.group_keywords
local group_to_keywords = BuffSettings.group_to_keywords
local _apply_buffs, _check_if_allow_during_spritning_buff
local WeaponActionMovement = class("WeaponActionMovement")

WeaponActionMovement.init = function (self, weapon_extension, unit_data_extension, buff_extension)
	self._weapon_extension = weapon_extension
	self._unit_data_extension = unit_data_extension
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._sprint_character_state_compontent = unit_data_extension:read_component("sprint_character_state")
	self._buff_extension = buff_extension
end

WeaponActionMovement.move_speed_modifier = function (self, t)
	local action_movement_curve, start_t = SharedFunctions.action_movement_curve(self._weapon_action_component, self._action_sweep_component)

	if not action_movement_curve then
		return 1
	end

	local move_curve_t = t - start_t
	local start_mod = action_movement_curve.start_modifier
	local p1, p2 = start_mod, 1
	local segment_progress = 0

	for i = 1, #action_movement_curve do
		local segment = action_movement_curve[i]
		local segment_t = segment.t

		if move_curve_t <= segment_t then
			p2 = segment.modifier
			segment_progress = segment_t == 0 and 1 or move_curve_t / segment_t

			break
		else
			local modifier = segment.modifier

			p1 = modifier
			p2 = modifier
		end
	end

	local mod = math.lerp(p1, p2, segment_progress)

	mod = _apply_buffs(mod, self._weapon_action_component, self._buff_extension, self._sprint_character_state_compontent)

	return mod
end

function _apply_buffs(movement_mod, weapon_action_component, buff_extension, sprint_character_state_component)
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	local current_action_name, action_settings = Action.current_action(weapon_action_component, weapon_template)

	if current_action_name == "none" or not action_settings then
		return nil
	end

	local stat_buffs = buff_extension and buff_extension:stat_buffs()
	local action_kind = action_settings.kind

	if movement_mod < 1 then
		local is_venting = action_kind == "vent_warp_charge"
		local is_shielding = action_kind == "shield"

		if is_venting then
			local decrease_modifier = stat_buffs and stat_buffs[BuffSettings.stat_buffs.vent_warp_charge_decrease_movement_reduction] or 1
			local reduction = 1 - movement_mod
			local decreased_reduction = reduction * decrease_modifier
			local new_mod = 1 - decreased_reduction

			movement_mod = new_mod
		elseif is_shielding then
			local decrease_modifier = stat_buffs and stat_buffs[BuffSettings.stat_buffs.psyker_force_field_movespeed_reduction_multiplier] or 1
			local reduction = 1 - movement_mod
			local decreased_reduction = reduction * decrease_modifier
			local new_mod = 1 - decreased_reduction

			movement_mod = new_mod
		end

		if Sprint.is_sprinting(sprint_character_state_component) and _check_if_allow_during_spritning_buff(action_settings, buff_extension) then
			local reduction = 1 - movement_mod
			local decreased_reduction = reduction * 0.5
			local new_mod = 1 - decreased_reduction

			movement_mod = new_mod
		end

		local decrease_modifier = stat_buffs and stat_buffs[BuffSettings.stat_buffs.weapon_action_movespeed_reduction_multiplier] or 1
		local reduction = 1 - movement_mod
		local decreased_reduction = reduction * decrease_modifier
		local new_mod = 1 - decreased_reduction

		movement_mod = new_mod
	end

	return movement_mod
end

function _check_if_allow_during_spritning_buff(action_settings, buff_extension)
	local action_buff_keywords = action_settings.buff_keywords

	if not action_buff_keywords or not buff_extension then
		return false
	end

	local grouped_keywords = group_to_keywords[group_keywords.allow_action_during_sprint]

	for ii = 1, #action_buff_keywords do
		local keyword = action_buff_keywords[ii]

		if grouped_keywords[keyword] and buff_extension:has_keyword(keyword) then
			return true
		end
	end

	return false
end

return WeaponActionMovement
