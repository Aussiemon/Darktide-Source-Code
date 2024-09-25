-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_luggable_effects.lua

require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_projectile_effects")

local Action = require("scripts/utilities/weapon/action")
local ProjectileIntegrationData = require("scripts/extension_systems/locomotion/utilities/projectile_integration_data")
local ProjectileTrajectory = require("scripts/utilities/projectile_trajectory")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local AimLuggableEffects = class("AimLuggableEffects", "AimProjectileEffects")

AimLuggableEffects.init = function (self, context, slot, weapon_template, fx_sources)
	AimLuggableEffects.super.init(self, context, slot, weapon_template, fx_sources)

	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._luggable_component = unit_data_extension:read_component("slot_luggable")
end

local _trajectory_settings = {}

AimLuggableEffects._trajectory_settings = function (self)
	table.clear(_trajectory_settings)

	local luggable_component = self._luggable_component
	local existing_unit = luggable_component.existing_unit_3p
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local is_aiming = action_settings and action_settings.kind == "aim_projectile" and existing_unit

	if not is_aiming then
		return false, nil
	end

	local _action_aim_projectile_component = self._action_aim_projectile_component
	local _weapon_action_component = self._weapon_action_component

	ProjectileTrajectory.trajectory_settings_from_aim_component(action_settings, _action_aim_projectile_component, _weapon_action_component, _trajectory_settings)

	if existing_unit then
		local locomotion_extension_or_nil = existing_unit and ScriptUnit.extension(existing_unit, "locomotion_system")
		local projectile_locomotion_template = locomotion_extension_or_nil and locomotion_extension_or_nil:locomotion_template()

		_trajectory_settings.projectile_locomotion_template = projectile_locomotion_template

		local mass, radius = ProjectileIntegrationData.mass_radius(projectile_locomotion_template, locomotion_extension_or_nil)

		_trajectory_settings.mass = mass
		_trajectory_settings.radius = radius
	end

	return true, _trajectory_settings
end

implements(AimLuggableEffects, WieldableSlotScriptInterface)

return AimLuggableEffects
