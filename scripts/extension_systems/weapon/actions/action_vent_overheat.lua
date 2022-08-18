require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Attack = require("scripts/utilities/attack/attack")
local Overheat = require("scripts/utilities/overheat")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local ActionVentOverheat = class("ActionVentOverheat", "ActionWeaponBase")

ActionVentOverheat.init = function (self, action_context, action_params, action_settings)
	ActionVentOverheat.super.init(self, action_context, action_params, action_settings)

	local weapon = action_params.weapon
	self._vent_fx_source_name = weapon.fx_sources._vent
end

ActionVentOverheat.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionVentOverheat.super.start(self, action_settings, t, time_scale, action_start_params)

	local overheat_config = self._weapon_template.overheat_configuration

	Overheat.start_venting(t, self._inventory_slot_component, overheat_config)

	local vent_fx = action_settings.venting_fx

	if vent_fx then
		local fx_source_name = self._vent_fx_source_name
		local unit_data_extension = self._unit_data_extension
		local sfx_alias = vent_fx.looping_sound_alias

		if sfx_alias then
			self._looping_sfx_alias = sfx_alias

			self._fx_extension:trigger_looping_wwise_event(sfx_alias, fx_source_name)

			local component_name = PlayerUnitData.looping_sound_component_name(sfx_alias)
			self._looping_sound_component = unit_data_extension:read_component(component_name)
		end

		local vfx_alias = vent_fx.looping_vfx_alias

		if vfx_alias then
			self._looping_vfx_alias = vfx_alias

			self._fx_extension:spawn_looping_particles(vfx_alias, fx_source_name)

			self._looping_vfx_component = unit_data_extension:read_component(vfx_alias)
		end
	end
end

ActionVentOverheat.fixed_update = function (self, dt, t, time_in_action)
	local inventory_slot_component = self._inventory_slot_component
	local overheat_config = self._weapon_template.overheat_configuration
	local player = self._player
	local removed_overheat = Overheat.update_venting(dt, t, player, inventory_slot_component, overheat_config)

	if self._is_server and removed_overheat then
		self:_deal_damage()
	end

	local vent_finished_anim_event = self._action_settings.vent_finished_anim_event
	local vent_finished_anim_event_3p = self._action_settings.vent_finished_anim_event_3p

	if inventory_slot_component.overheat_current_percentage <= 0 and vent_finished_anim_event then
		local anim_event = vent_finished_anim_event
		local anim_event_3p = vent_finished_anim_event_3p or anim_event

		self:trigger_anim_event(anim_event, anim_event_3p)
	end
end

ActionVentOverheat._deal_damage = function (self)
	local current_heat = self._inventory_slot_component.overheat_current_percentage
	local overheat_config = self._weapon_template.overheat_configuration
	local low_threshold = overheat_config.low_threshold

	if current_heat <= low_threshold then
		return
	end

	local vent_power_level = overheat_config.vent_power_level
	local vent_damage_profile = overheat_config.vent_damage_profile
	local vent_damage_type = overheat_config.vent_damage_type
	local min_power = vent_power_level[1]
	local max_power = vent_power_level[2]
	local scaled_current_heat = (current_heat - low_threshold) / (1 - low_threshold)
	local final_power_level = (max_power - min_power) * scaled_current_heat + min_power
	local buff_extension = self._buff_extension
	local stat_buffs = buff_extension and buff_extension:stat_buffs()
	local venting_damage_reduction = stat_buffs.vent_overheat_damage_multiplier or 1
	final_power_level = final_power_level * venting_damage_reduction

	Attack.execute(self._player_unit, vent_damage_profile, "power_level", final_power_level, "damage_type", vent_damage_type, "item", self._weapon.item)
end

ActionVentOverheat.finish = function (self, reason, data, t, time_in_action)
	Overheat.stop_venting(self._inventory_slot_component)

	local fx_extension = self._fx_extension
	local looping_sfx_alias = self._looping_sfx_alias

	if looping_sfx_alias and self._looping_sound_component.is_playing then
		fx_extension:stop_looping_wwise_event(looping_sfx_alias)
	end

	local looping_vfx_alias = self._looping_vfx_alias

	if looping_vfx_alias and self._looping_vfx_component.spawner_name ~= "n/a" then
		fx_extension:stop_looping_particles(looping_vfx_alias, true)
	end
end

ActionVentOverheat.running_action_state = function (self, t, time_in_action)
	local current_heat = self._inventory_slot_component.overheat_current_percentage

	if current_heat <= 0 then
		return "fully_vented"
	end

	return nil
end

return ActionVentOverheat
