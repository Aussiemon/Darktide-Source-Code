require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local PlayerAssistNotifications = require("scripts/utilities/player_assist_notifications")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Vo = require("scripts/utilities/vo")
local special_rules = SpecialRulesSetting.special_rules
local ActionUseSyringe = class("ActionUseSyringe", "ActionWeaponBase")

ActionUseSyringe.init = function (self, action_context, action_params, action_settings)
	ActionUseSyringe.super.init(self, action_context, action_params, action_settings)

	self._specialization_extension = ScriptUnit.extension(self._player_unit, "specialization_system")
	local unit_data_extension = self._unit_data_extension
	self._action_module_targeting_component = unit_data_extension:write_component("action_module_targeting")
end

ActionUseSyringe.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionUseSyringe.super.start(self, action_settings, t, time_scale, action_start_params)

	local is_resimulating = self._unit_data_extension.is_resimulating
	local target_unit = self:_target_unit()
	local anim_event = not target_unit and action_settings.no_target_cast_anim_event or action_settings.has_target_anim_event
	local anim_event_3p = not target_unit and action_settings.no_target_cast_anim_event_3p or action_settings.has_target_anim_event_3p

	if anim_event then
		self:trigger_anim_event(anim_event, anim_event_3p)
	end

	local vo_tag = action_settings.vo_tag

	if vo_tag and not is_resimulating then
		Vo.play_combat_ability_event(self._player_unit, vo_tag)
	end

	local gear_sound_alias = action_settings.gear_sound_alias

	if gear_sound_alias and not is_resimulating then
		self._fx_extension:trigger_gear_wwise_event(gear_sound_alias)
	end

	self._did_use = false
end

ActionUseSyringe.finish = function (self, reason, data, t, time_in_action)
	ActionUseSyringe.super.finish(self, reason, data, t, time_in_action)

	local action_module_targeting_component = self._action_module_targeting_component
	action_module_targeting_component.target_unit_1 = nil
	action_module_targeting_component.target_unit_2 = nil
	action_module_targeting_component.target_unit_3 = nil
	local action_settings = self._action_settings

	if action_settings.remove_item_from_inventory and self._did_use then
		local inventory_slot_component = self._inventory_slot_component
		inventory_slot_component.unequip_slot = true
	end
end

ActionUseSyringe.fixed_update = function (self, dt, t, time_in_action)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local time_scale = self._weapon_action_component.time_scale
	local action_settings = self._action_settings
	local use_time = action_settings.use_time / time_scale
	local target_unit = self:_target_unit()
	local should_use = ActionUtility.is_within_trigger_time(time_in_action, dt, use_time) and target_unit

	if should_use then
		self._did_use = true
		local action_module_targeting_component = self._action_module_targeting_component
		action_module_targeting_component.target_unit_1 = nil
		action_module_targeting_component.target_unit_2 = nil
		action_module_targeting_component.target_unit_3 = nil

		if self._is_server then
			local has_override_buff_rule = self._specialization_extension:has_special_rule(special_rules.buff_target_buff_name_override_one)
			local has_override_buff_rule_two = self._specialization_extension:has_special_rule(special_rules.buff_target_buff_name_override_two)
			local buff_name = has_override_buff_rule and action_settings.override_buff_name_one or has_override_buff_rule_two and action_settings.override_buff_name_two or action_settings.buff_name
			local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if target_buff_extension then
				target_buff_extension:add_internally_controlled_buff(buff_name, t)
			end

			local player = Managers.player:player_by_unit(self._player_unit)

			if player then
				local telemetry_reporter_manager = Managers.telemetry_reporters

				telemetry_reporter_manager:reporter("used_items"):register_event(player, "syringe")
			end

			if player then
				local visual_loadout_extension = ScriptUnit.has_extension(self._player_unit, "visual_loadout_system")
				local weapon_template = visual_loadout_extension and visual_loadout_extension:weapon_template_from_slot("slot_pocketable_small")
				local pickup_name = weapon_template and weapon_template.name
				local picked_up_at_t = visual_loadout_extension and visual_loadout_extension:equipped_t_from_slot("slot_pocketable_small") or t
				local time_hoarded = t - picked_up_at_t
				local tension = Managers.state.pacing:tension()
				local combat_state = Managers.state.pacing:combat_state()
				local data = {
					pickup_name = pickup_name,
					used_on_ally = not action_settings.self_use,
					time_held = time_hoarded,
					tension = tension,
					combat_state = combat_state
				}

				Managers.telemetry_events:player_used_stimm(player, data)
			end
		end

		if self._is_server or target_unit == self._player_unit then
			self:_play_hit_react_anim(action_settings, target_unit)

			local hit_reaction_sound_event = action_settings.hit_reaction_sound_event

			if hit_reaction_sound_event then
				local fx_extension = ScriptUnit.extension(target_unit, "fx_system")

				fx_extension:trigger_exclusive_wwise_event(hit_reaction_sound_event)
			end

			local vo_event = action_settings.vo_event

			if vo_event then
				Vo.on_demand_vo_event(target_unit, "on_demand_com_wheel", vo_event)
			end
		end
	end

	if self._did_use and action_settings.remove_item_from_inventory then
		local remove_time = action_settings.remove_item_from_inventory_time or action_settings.total_time
		local should_unequip = remove_time <= time_in_action

		if should_unequip and action_settings.remove_item_from_inventory then
			local inventory_component = self._inventory_component
			local player_unit = self._player_unit

			PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, player_unit, t)
		end
	end

	if not self._did_use and not target_unit and action_settings.exit_without_target and action_settings.minimum_time < time_in_action then
		return true
	end
end

ActionUseSyringe._play_hit_react_anim = function (self, action_settings, target_unit)
	local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")

	if character_state_component and PlayerUnitStatus.is_disabled(character_state_component) then
		return
	end

	local animation_extension = ScriptUnit.extension(target_unit, "animation_system")
	local hit_react_anim_1p = action_settings.hit_reaction_anim_event
	local hit_react_anim_3p = action_settings.hit_reaction_anim_event_3p

	if hit_react_anim_1p then
		animation_extension:anim_event_1p(hit_react_anim_1p)
	end

	if hit_react_anim_3p then
		animation_extension:anim_event(hit_react_anim_3p)
	end
end

ActionUseSyringe._target_unit = function (self)
	local action_settings = self._action_settings
	local action_module_targeting_component = self._action_module_targeting_component
	local target_unit = action_module_targeting_component.target_unit_1
	local self_use = action_settings.self_use or action_settings.self_use_if_no_target and not target_unit
	local target = self_use and self._player_unit or target_unit
	local validate_target_func = action_settings.validate_target_func

	if validate_target_func and not validate_target_func(target) then
		return nil
	end

	return target
end

return ActionUseSyringe
