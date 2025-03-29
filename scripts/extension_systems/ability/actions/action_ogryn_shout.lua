-- chunkname: @scripts/extension_systems/ability/actions/action_ogryn_shout.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Toughness = require("scripts/utilities/toughness/toughness")
local Vo = require("scripts/utilities/vo")
local proc_events = BuffSettings.proc_events
local ActionOgrynShout = class("ActionOgrynShout", "ActionAbilityBase")
local external_properties = {}

ActionOgrynShout.init = function (self, action_context, action_params, action_settings)
	ActionOgrynShout.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._unit_data_extension = unit_data_extension
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._combat_ability_component = unit_data_extension:write_component("combat_ability")
end

ActionOgrynShout.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionOgrynShout.super.start(self, action_settings, t, time_scale, action_start_params)

	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local player_position = locomotion_position
	local player_unit = self._player_unit
	local vo_tag = action_settings.vo_tag

	Vo.play_combat_ability_event(player_unit, vo_tag)

	local source_name = action_settings.sound_source or "head"
	local sync_to_clients = action_settings.has_husk_sound
	local include_client = false

	table.clear(external_properties)

	local ability = self._ability

	external_properties.ability_template = ability and ability.ability_template

	self._fx_extension:trigger_gear_wwise_event_with_source("ability_shout", external_properties, source_name, sync_to_clients, include_client)

	self._num_hits = 0

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

	local ability_template_tweak_data = self._ability_template_tweak_data
	local self_buff_to_add = ability_template_tweak_data.buff_to_add

	if self_buff_to_add then
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

		buff_extension:add_internally_controlled_buff(self_buff_to_add, t)
	end

	if not self._is_server then
		return
	end

	if action_settings.refill_toughness then
		Toughness.recover_max_toughness(player_unit, "ability_stance")
	end

	local rotation = self._first_person_component.rotation
	local shout_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	local radius = action_settings.radius
	local shout_target_template_name = self._ability_template_tweak_data.shout_target_template or action_settings.shout_target_template

	self._num_hits = ShoutAbilityImplementation.execute(radius, shout_target_template_name, player_unit, t, locomotion_component, shout_direction)

	local buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.num_hits = self._num_hits

		buff_extension:add_proc_event(proc_events.on_ogryn_shout, param_table)
	end

	param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = player_unit

		buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
	end

	self._combat_ability_component.active = true
end

ActionOgrynShout.finish = function (self, reason, data, t, time_in_action, action_settings)
	self._combat_ability_component.active = false
end

return ActionOgrynShout
