-- chunkname: @scripts/extension_systems/weapon/actions/modules/adamant_whistle_targeting_action_module.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local AdamantWhistleTargetingActionModule = class("AdamantWhistleTargetingActionModule")

AdamantWhistleTargetingActionModule.init = function (self, is_server, physics_world, player_unit, component, action_settings)
	self._is_server = is_server
	self._physics_world = physics_world
	self._player_unit = player_unit
	self._component = component
	self._action_settings = action_settings

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

	self._unit_data_extension = unit_data_extension
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._smart_targeting_extension = ScriptUnit.extension(player_unit, "smart_targeting_system")
end

AdamantWhistleTargetingActionModule.start = function (self, action_settings, t)
	local component = self._component

	component.target_unit_1 = nil
	component.target_unit_2 = nil
	component.target_unit_3 = nil
end

AdamantWhistleTargetingActionModule.fixed_update = function (self, dt, t)
	if self._is_server then
		local new_target_unit = self._component.target_unit_1
		local companion_spawner_extension = ScriptUnit.extension(self._player_unit, "companion_spawner_system")
		local companion_unit = companion_spawner_extension:companion_unit()

		if companion_unit and ALIVE[companion_unit] then
			local companion_blackboard = BLACKBOARDS[companion_unit]
			local whistle_component = Blackboard.write_component(companion_blackboard, "whistle")

			whistle_component.current_target = new_target_unit
		end
	end

	if self._unit_data_extension.is_resimulating then
		return
	end

	local action_settings = self._action_settings
	local component = self._component
	local current_target_unit = component.target_unit_1
	local sticky_targeting = action_settings.sticky_targeting

	if not current_target_unit or not sticky_targeting then
		local smart_targeting_extension = self._smart_targeting_extension
		local targeting_data = smart_targeting_extension:targeting_data()
		local new_target_unit = targeting_data.unit
		local valid_target = new_target_unit and not Managers.state.player_unit_spawn:is_player_unit(new_target_unit)

		if not valid_target then
			return
		end

		if new_target_unit ~= current_target_unit then
			component.target_unit_1 = new_target_unit
		end
	end
end

AdamantWhistleTargetingActionModule.finish = function (self, reason, data, t)
	if reason == "hold_input_released" or reason == "stunned" then
		local component = self._component

		component.target_unit_1 = nil
		component.target_unit_2 = nil
		component.target_unit_3 = nil
	end
end

return AdamantWhistleTargetingActionModule
