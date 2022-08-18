require("scripts/extension_systems/weapon/actions/action_ability_base")

local Action = require("scripts/utilities/weapon/action")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Interrupt = require("scripts/utilities/attack/interrupt")
local Luggable = require("scripts/utilities/luggable")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Toughness = require("scripts/utilities/toughness/toughness")
local Vo = require("scripts/utilities/vo")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local proc_events = BuffSettings.proc_events
local ActionStanceChange = class("ActionStanceChange", "ActionAbilityBase")

ActionStanceChange.init = function (self, action_context, action_params, action_settings)
	ActionStanceChange.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._ability_type = action_settings.ability_type or "none"
end

ActionStanceChange.start = function (self, action_settings, t, time_scale, action_start_params)
	local stop_reload = action_settings.stop_reload
	local anim = action_settings.anim
	local anim_3p = action_settings.anim_3p or anim
	local block_weapon_actions = action_settings.block_weapon_actions
	local refill_toughness = action_settings.refill_toughness
	local vo_tag = action_settings.vo_tag
	local player_unit = self._player_unit
	local ability_template_tweak_data = self._ability_template_tweak_data
	local buff_to_add = ability_template_tweak_data.buff_to_add
	local slot_to_wield = action_settings.auto_wield_slot or ability_template_tweak_data.auto_wield_slot
	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension

	Luggable.drop_luggable(t, player_unit, inventory_component, visual_loadout_extension, true)

	if vo_tag then
		Vo.play_combat_ability_event(player_unit, vo_tag)
	end

	if stop_reload then
		local weapon_action_component = self._unit_data_extension:read_component("weapon_action")
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local current_action_name, _ = Action.current_action(weapon_action_component, weapon_template)

		if current_action_name == "action_start_reload" or current_action_name == "action_reload" then
			Interrupt.action(t, player_unit, "veteran_ability")
		end
	end

	if slot_to_wield then
		local inventory_comp = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("inventory")
		local wielded_slot = inventory_comp.wielded_slot

		if slot_to_wield ~= wielded_slot then
			PlayerUnitVisualLoadout.wield_slot(slot_to_wield, player_unit, t)
		end
	end

	if buff_to_add then
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

		buff_extension:add_internally_controlled_buff(buff_to_add, t)
	end

	if anim then
		self:trigger_anim_event(anim, anim_3p)
	end

	if block_weapon_actions then
		self._weapon_actions_blocked = true
		local weapon_extension = ScriptUnit.extension(player_unit, "weapon_system")

		weapon_extension:block_actions("weapon_action")
	end

	if self._is_server and refill_toughness then
		Toughness.recover_max_toughness(player_unit)
	end
end

ActionStanceChange.finish = function (self, reason, ...)
	ActionStanceChange.super.finish(self, reason, ...)

	local action_settings = self._action_settings

	if action_settings then
		local player_unit = self._player_unit
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local param_table = buff_extension:request_proc_event_param_table()
		param_table.unit = player_unit

		buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
	end

	if self._weapon_actions_blocked then
		self._weapon_actions_blocked = nil
		local weapon_extension = ScriptUnit.extension(self._player_unit, "weapon_system")

		weapon_extension:unblock_actions("weapon_action")
	end
end

return ActionStanceChange
