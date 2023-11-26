-- chunkname: @scripts/extension_systems/weapon/actions/action_ranged_wield.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local PlayerUnitPeeking = require("scripts/utilities/player_unit_peeking")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local ActionRangedWield = class("ActionRangedWield", "ActionWeaponBase")

ActionRangedWield.start = function (self, action_settings, t, time_scale, action_start_params)
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template
	local reload_template = weapon_template.reload_template
	local anim, anim_3p

	anim = action_settings.wield_anim_event
	anim_3p = action_settings.wield_anim_event_3p or anim

	if ReloadStates.uses_reload_states(self._inventory_slot_component) then
		local started_reload = ReloadStates.started_reload(reload_template, self._inventory_slot_component)

		if started_reload then
			anim = action_settings.wield_reload_anim_event
			anim_3p = action_settings.wield_reload_anim_event_3p or anim
		end
	end

	self:trigger_anim_event(anim, anim_3p)

	weapon_tweak_templates_component.spread_template_name = weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = weapon_template.sway_template or "none"
	weapon_tweak_templates_component.suppression_template_name = weapon_template.suppression_template or "none"

	if self._peeking_component.in_cover then
		PlayerUnitPeeking.on_enter_cover(self._animation_extension)
	end
end

return ActionRangedWield
