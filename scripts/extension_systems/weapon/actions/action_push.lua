﻿-- chunkname: @scripts/extension_systems/weapon/actions/action_push.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local LagCompensation = require("scripts/utilities/lag_compensation")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PushAttack = require("scripts/utilities/attack/push_attack")
local Stamina = require("scripts/utilities/attack/stamina")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local proc_events = BuffSettings.proc_events
local ActionPush = class("ActionPush", "ActionWeaponBase")

ActionPush.init = function (self, action_context, ...)
	ActionPush.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension

	self._block_component = unit_data_extension:write_component("block")
	self._action_push_component = unit_data_extension:write_component("action_push")
end

ActionPush.start = function (self, ...)
	ActionPush.super.start(self, ...)

	self._action_push_component.has_pushed = false
end

ActionPush.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings

	if self._block_component.is_blocking and time_in_action >= action_settings.block_duration then
		self._block_component.is_blocking = false
	end

	local damage_time = action_settings.damage_time or 0

	if damage_time <= time_in_action and not self._action_push_component.has_pushed then
		self:_push(t)

		self._action_push_component.has_pushed = true
	end
end

ActionPush.finish = function (self, ...)
	ActionPush.super.finish(self, ...)

	self._block_component.is_blocking = false
	self._action_push_component.has_pushed = false
end

ActionPush._push = function (self, t)
	local action_settings = self._action_settings
	local number_of_units_hit = 0
	local weapon_stamina_template = self._weapon_extension:stamina_template()
	local raw_push_cost = weapon_stamina_template and weapon_stamina_template.push_cost or math.huge
	local buff_extension = self._buff_extension
	local stat_buffs = buff_extension:stat_buffs()
	local push_cost_multiplier = stat_buffs.push_cost_multiplier or 1
	local push_cost = raw_push_cost * push_cost_multiplier

	if not self._unit_data_extension.is_resimulating then
		local locomotion_component = self._locomotion_component
		local locomotion_position = locomotion_component.position
		local player_position = locomotion_position
		local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)
		local power_level = action_settings.power_level or DEFAULT_POWER_LEVEL
		local fp_rotation = self._first_person_component.rotation
		local right = Quaternion.right(fp_rotation)
		local player_direction = Vector3.cross(right, Vector3.down())
		local player_unit = self._player_unit
		local weapon_item = self._weapon.item
		local is_predicted = true
		local unit_data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
		local stamina_read_component = unit_data_ext:read_component("stamina")
		local archetype = unit_data_ext:archetype()
		local base_stamina_template = archetype.stamina
		local current_stamina, max_stamina = Stamina.current_and_max_value(player_unit, stamina_read_component, base_stamina_template)
		local weak_push = current_stamina < push_cost

		if weak_push then
			power_level = power_level * math.clamp(current_stamina * 2 / push_cost, 0.5, 1)
		end

		local push_offset = action_settings.push_offset or 0
		local push_position = player_position + player_direction * push_offset

		number_of_units_hit = PushAttack.push(self._physics_world, push_position, player_direction, rewind_ms, power_level, action_settings, player_unit, is_predicted, weapon_item, weak_push)

		self:_play_push_rumble(number_of_units_hit)
	end

	if not action_settings.block_duration then
		self._block_component.is_blocking = false
	end

	Stamina.drain(self._player_unit, push_cost, t)
	self:_pay_warp_charge_cost_immediate(t, 1)

	if action_settings.activate_special then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, true, "manual_toggle")
	end

	self:_play_push_particles(t)

	if not self._unit_data_extension.is_resimulating and buff_extension then
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.num_hit_units = number_of_units_hit

			buff_extension:add_proc_event(proc_events.on_push_finish, param_table)
		end
	end
end

ActionPush._play_push_particles = function (self, t)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local fx = self._action_settings.fx

	if not fx then
		return
	end

	local effect_name = fx.vfx_effect

	if not effect_name then
		return
	end

	local spawner_name = fx.fx_source
	local fx_extension = self._fx_extension
	local link = true
	local orphaned_policy = "stop"
	local position_offset = fx.fx_position_offset and fx.fx_position_offset:unbox()
	local rotation_offset = fx.fx_rotation_offset and fx.fx_rotation_offset:unbox()

	fx_extension:spawn_unit_particles(effect_name, spawner_name, link, orphaned_policy, position_offset, rotation_offset)
end

local _external_properties = {}

ActionPush._play_push_rumble = function (self, number_of_units_hit)
	local hit_enemies = number_of_units_hit > 0

	table.clear(_external_properties)

	_external_properties.hit_enemies = hit_enemies and "true" or "false"

	self._fx_extension:trigger_exclusive_gear_wwise_event("rumble_push", _external_properties)
end

return ActionPush
