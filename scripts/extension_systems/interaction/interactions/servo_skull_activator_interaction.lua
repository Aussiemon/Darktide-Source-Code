require("scripts/extension_systems/interaction/interactions/base_interaction")

local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local ServoSkullActivatorInteraction = class("ServoSkullActivatorInteraction", "BaseInteraction")
local interaction_results = InteractionSettings.results

ServoSkullActivatorInteraction.stop = function (self, world, interactor_unit, unit_data_component, t, result, interactor_is_server)
	if result == interaction_results.success then
		local target_unit = unit_data_component.target_unit

		if interactor_is_server then
			local target_unit_position = Unit.local_position(target_unit, 1)
			local target_unit_rotation = Unit.local_rotation(target_unit, 1)
			local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
			local servo_skull_activator_extension = ScriptUnit.extension(target_unit, "servo_skull_system")
			local objective_name = servo_skull_activator_extension:objective_name()

			mission_objective_zone_system:spawn_servo_skull(target_unit_position, target_unit_rotation)
			mission_objective_zone_system:start_event(objective_name)
			servo_skull_activator_extension:deactivate()
		end
	end
end

return ServoSkullActivatorInteraction
