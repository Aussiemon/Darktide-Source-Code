-- chunkname: @scripts/extension_systems/ability/actions/action_ogryn_shout.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Vo = require("scripts/utilities/vo")
local proc_events = BuffSettings.proc_events
local ActionShout = class("ActionShout", "ActionAbilityBase")
local external_properties = {}

ActionShout.init = function (self, action_context, action_params, action_settings)
	ActionShout.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._unit_data_extension = unit_data_extension
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._combat_ability_component = unit_data_extension:write_component("combat_ability")
end

ActionShout.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionShout.super.start(self, action_settings, t, time_scale, action_start_params)

	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local player_position = locomotion_position
	local player_unit = self._player_unit
	local rotation = self._first_person_component.rotation
	local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	local shout_direction = forward
	local ability_template_tweak_data = self._ability_template_tweak_data
	local self_buff_to_add = ability_template_tweak_data.buff_to_add
	local slot_to_wield = action_settings.auto_wield_slot
	local vo_tag = action_settings.vo_tag

	Vo.play_combat_ability_event(player_unit, vo_tag)

	local source_name = action_settings.sound_source or "head"
	local sync_to_clients = action_settings.has_husk_sound
	local include_client = false

	table.clear(external_properties)

	local ability = self._ability

	external_properties.ability_template = ability and ability.ability_template

	self._fx_extension:trigger_gear_wwise_event_with_source("ability_shout", external_properties, source_name, sync_to_clients, include_client)

	if slot_to_wield then
		local inventory_comp = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("inventory")
		local wielded_slot = inventory_comp.wielded_slot

		if slot_to_wield ~= wielded_slot then
			PlayerUnitVisualLoadout.wield_slot(slot_to_wield, player_unit, t)
		end
	end

	local anim = action_settings.anim
	local anim_3p = action_settings.anim_3p or anim

	if anim then
		self:trigger_anim_event(anim, anim_3p)
	end

	local vfx = action_settings.vfx

	if vfx then
		local vfx_pos = player_position + Vector3.up()

		self._fx_extension:spawn_particles(vfx, vfx_pos)
	end

	if self_buff_to_add then
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

		buff_extension:add_internally_controlled_buff(self_buff_to_add, t)
	end

	if not self._is_server then
		return
	end

	ShoutAbilityImplementation.execute(action_settings, player_unit, t, locomotion_component, shout_direction)

	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = player_unit

		buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
	end

	self._combat_ability_component.active = true
end

ActionShout.finish = function (self, reason, data, t, time_in_action, action_settings)
	self._combat_ability_component.active = false
end

return ActionShout
