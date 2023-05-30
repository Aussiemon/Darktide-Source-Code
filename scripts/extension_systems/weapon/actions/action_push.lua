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

	if self._block_component.is_blocking and action_settings.block_duration <= time_in_action then
		self._block_component.is_blocking = false
	end

	local damage_time = action_settings.damage_time or 0

	if time_in_action >= damage_time and not self._action_push_component.has_pushed then
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
	local push_cost = weapon_stamina_template and weapon_stamina_template.push_cost or math.huge

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
		local unit_data_ext = ScriptUnit.extension(self._player_unit, "unit_data_system")
		local stamina_read_component = unit_data_ext:read_component("stamina")
		local specialization = unit_data_ext:specialization()
		local specialization_stamina_template = specialization.stamina
		local current_stamina, max_stamina = Stamina.current_and_max_value(self._player_unit, stamina_read_component, specialization_stamina_template)
		local weak_push = current_stamina < push_cost

		if weak_push then
			power_level = power_level * math.clamp(current_stamina * 2 / push_cost, 0.5, 1)
		end

		local push_offset = action_settings.push_offset or 0
		local push_posisition = player_position + player_direction * push_offset
		number_of_units_hit = PushAttack.push(self._physics_world, push_posisition, player_direction, rewind_ms, power_level, action_settings, player_unit, is_predicted, weapon_item, weak_push)
	end

	if not action_settings.block_duration then
		self._block_component.is_blocking = false
	end

	Stamina.drain(self._player_unit, push_cost, t)
	self:_pay_warp_charge_cost(t, 1)

	if action_settings.activate_special then
		self:_set_weapon_special(true, t)
	end

	self:_play_push_particles(t)

	if not self._unit_data_extension.is_resimulating then
		local buff_extension = self._buff_extension

		if buff_extension then
			local param_table = buff_extension:request_proc_event_param_table()

			if param_table then
				param_table.num_hit_units = number_of_units_hit

				buff_extension:add_proc_event(proc_events.on_push_finish, param_table)
			end
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

return ActionPush
