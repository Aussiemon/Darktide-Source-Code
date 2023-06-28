require("scripts/extension_systems/weapon/actions/action_ability_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Vo = require("scripts/utilities/vo")
local proc_events = BuffSettings.proc_events
local ActionShout = class("ActionShout", "ActionAbilityBase")
local broadphase_results = {}
local EXTERNAL_PROPERTIES = {}

ActionShout.init = function (self, action_context, action_params, action_settings)
	ActionShout.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension
	self._unit_data_extension = unit_data_extension
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
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
	local wwise_state = action_settings.wwise_state

	if wwise_state then
		Wwise.set_state(wwise_state.group, wwise_state.on_state)
	end

	local vo_tag = action_settings.vo_tag

	if type(vo_tag) == "table" then
		local vo_type = action_settings.vo_type

		if vo_type == "warp_charge" then
			local warp_charge_component = self._unit_data_extension:read_component("warp_charge")
			local warp_charge_current_percentage = warp_charge_component.current_percentage
			local tag = warp_charge_current_percentage > 0.9 and vo_tag.high or vo_tag.low

			Vo.play_combat_ability_event(player_unit, tag)
		end
	else
		Vo.play_combat_ability_event(player_unit, vo_tag)
	end

	local sound_event = action_settings.sound_event

	if sound_event and self._is_local_unit then
		if type(sound_event) == "table" then
			for _, event_name in pairs(sound_event) do
				self._fx_extension:trigger_wwise_event(event_name, false, player_position)
			end
		else
			self._fx_extension:trigger_wwise_event(sound_event, false, player_position)
		end
	end

	local source_name = action_settings.sound_source or "head"
	local sync_to_clients = action_settings.has_husk_sound
	local include_client = false

	table.clear(EXTERNAL_PROPERTIES)

	local ability = self._ability
	EXTERNAL_PROPERTIES.ability_template = ability and ability.ability_template

	self._fx_extension:trigger_gear_wwise_event_with_source("shout", EXTERNAL_PROPERTIES, source_name, sync_to_clients, include_client)

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
end

ActionShout.finish = function (self, reason, data, t, time_in_action, action_settings)
	local wwise_state = action_settings.wwise_state

	if wwise_state then
		Wwise.set_state(wwise_state.group, wwise_state.off_state)
	end
end

return ActionShout
