-- chunkname: @scripts/script_flow_nodes/ui_flow_callbacks.lua

local MainFlowCallbacks = require("scripts/script_flow_nodes/flow_callbacks")

UIFlowCallbacks = UIFlowCallbacks or {}

local flow_return_table = {}
local flow_callback_white_list = {
	"get_component_data",
	"set_component_data",
	"trigger_lua_unit_event",
	"trigger_lua_string_event",
	"local_player_level_larger_than",
}

for function_name, func in pairs(MainFlowCallbacks) do
	if not table.find(flow_callback_white_list, function_name) then
		UIFlowCallbacks[function_name] = function ()
			return
		end
	else
		UIFlowCallbacks[function_name] = func
	end
end

UIFlowCallbacks.clear_return_value = function ()
	table.clear(flow_return_table)
end

UIFlowCallbacks.player_voice = function (params)
	return
end

UIFlowCallbacks.player_fx = function (params)
	return
end

UIFlowCallbacks.player_footstep = function (params)
	return
end

UIFlowCallbacks.companion_footstep = function (params)
	return
end

UIFlowCallbacks.companion_inventory_fx = function (params)
	return
end

UIFlowCallbacks.player_material_fx = function (params)
	return
end

UIFlowCallbacks.enable_script_component = function (params)
	local guid = params.guid
	local unit = params.unit
	local world = Application.flow_callback_context_world()
	local extension_manager = Managers.ui:world_extension_manager(world)
	local component_system = extension_manager:system("component_system")

	component_system:enable_component(unit, guid)
end

UIFlowCallbacks.disable_script_component = function (params)
	local guid = params.guid
	local unit = params.unit
	local world = Application.flow_callback_context_world()
	local extension_manager = Managers.ui:world_extension_manager(world)
	local component_system = extension_manager:system("component_system")

	component_system:disable_component(unit, guid)
end

UIFlowCallbacks.call_script_component = function (params)
	local guid = params.guid
	local unit = params.unit
	local function_name = params.event
	local world = Application.flow_callback_context_world()
	local extension_manager = Managers.ui:world_extension_manager(world)
	local component_system = extension_manager:system("component_system")

	component_system:flow_call_component(unit, guid, function_name)
end

UIFlowCallbacks.register_extensions = function (params)
	local unit = params.unit
	local world = Application.flow_callback_context_world()
	local extension_manager = Managers.ui:world_extension_manager(world)

	extension_manager:register_unit(world, unit, "flow_spawned")
end

UIFlowCallbacks.delete_extension_registered_unit = function (params)
	local unit = params.unit
	local world = Application.flow_callback_context_world()
	local extension_manager = Managers.ui:world_extension_manager(world)

	Unit.flow_event(unit, "cleanup_before_destroy")
	Unit.flow_event(unit, "unit_despawned")
	extension_manager:unregister_unit(unit)
	World.destroy_unit(world, unit)
end

UIFlowCallbacks.spawn_unit = function (params)
	return
end

UIFlowCallbacks.unspawn_unit = function (params)
	return
end

UIFlowCallbacks.is_dedicated_server = function (params)
	flow_return_table.is_dedicated_server = DEDICATED_SERVER

	return flow_return_table
end

return UIFlowCallbacks
