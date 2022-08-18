local WwiseVisualization = require("core/wwise/lua/wwise_visualization")
local WwiseBankReference = require("core/wwise/lua/wwise_bank_reference")
WwiseFlowCallbacks = WwiseFlowCallbacks or {}
local M = WwiseFlowCallbacks
local Application = stingray.Application
local Matrix4x4 = stingray.Matrix4x4
local Quaternion = stingray.Quaternion
local Script = stingray.Script
local Unit = stingray.Unit
local Vector3 = stingray.Vector3
local Wwise = stingray.Wwise
local WwiseWorld = stingray.WwiseWorld
local listener_map = nil

if Wwise then
	listener_map = {
		Listener0 = Wwise.LISTENER_0,
		Listener1 = Wwise.LISTENER_1,
		Listener2 = Wwise.LISTENER_2,
		Listener3 = Wwise.LISTENER_3,
		Listener4 = Wwise.LISTENER_4,
		Listener5 = Wwise.LISTENER_5,
		Listener6 = Wwise.LISTENER_6,
		Listener7 = Wwise.LISTENER_7
	}
end

M.wwise_load_bank = function (t)
	local name = t.Name or t.name or ""

	if name == "" then
		return
	end

	Wwise.load_bank(name)

	local use_ref_count = t.Reference_Count or false

	if use_ref_count and use_ref_count == true then
		WwiseBankReference:add(name)
	end
end

M.wwise_unit_load_bank = function (t)
	local name = t.Name or t.name or ""
	local unit = t.Unit or t.unit

	if unit then
		if name == "" then
			name = Unit.get_data(unit, "wwise_bank_name", "resource")
		end

		if name and name ~= "" then
			Wwise.load_bank(name)

			local use_ref_count = t.Reference_Count or false

			if use_ref_count and use_ref_count == true then
				WwiseBankReference:add(name)
			end
		end
	end
end

M.wwise_unload_bank = function (t)
	local name = t.Name or t.name or ""

	if name == "" then
		local unit = Application.flow_callback_context_unit()

		if unit then
			name = Unit.get_data(unit, "Wwise", "bank_name")
		end

		if name == nil or name == "" then
			return
		end
	end

	local use_ref_count = t.Reference_Count or false

	if use_ref_count and use_ref_count == true then
		WwiseBankReference:remove(name)

		if WwiseBankReference:count(name) == 0 then
			Wwise.unload_bank(name)
		end
	else
		Wwise.unload_bank(name)
	end
end

M.wwise_set_language = function (t)
	local name = t.Name or t.name or ""

	Wwise.set_language(name)
end

M.wwise_set_listener_pose = function (t)
	local position = t.Position or t.position

	if not position then
		return
	end

	local listener = listener_map[t.Listener or t.listener]
	local rotation = t.Rotation or t.rotation or Quaternion.identity()
	local pose = Matrix4x4.from_quaternion_position(rotation, position)
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_listener(wwise_world, listener, pose)
end

M.wwise_move_listener_to_unit = function (t)
	local unit = t.Unit or t.unit

	if not unit then
		return
	end

	local listener = listener_map[t.Listener or t.listener]
	local unit_node_index = Script.index_offset()

	if t.Unit_Node or t.unit_node then
		unit_node_index = Unit.node(unit, t.Unit_Node or t.unit_node)
	end

	local pose = Unit.world_pose(unit, unit_node_index)
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_listener(wwise_world, listener, pose)
end

M.wwise_trigger_event = function (t)
	local event_resource = t.Event_resource or t.event_resource or ""
	local unit = t.Unit or t.unit
	local use_occlusion = t.use_occlusion or false
	local r1, r2 = nil
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())
	local source_id = t.Existing_Source_Id or t.existing_source_id

	if source_id then
		r1, r2 = WwiseWorld.trigger_resource_event(wwise_world, event_resource, use_occlusion, source_id)
	elseif unit then
		if event_resource == "" then
			event_resource = Unit.get_data(unit, "wwise_event", "resource") or ""
		end

		local unit_node_index = Script.index_offset()

		if t.Unit_Node or t.unit_node then
			unit_node_index = Unit.node(unit, t.Unit_Node or t.unit_node)
		end

		local position = t.Position or t.position

		if position then
			local world_position = Vector3.add(Unit.world_position(unit, unit_node_index), position)
			r1, r2 = WwiseWorld.trigger_resource_event(wwise_world, event_resource, use_occlusion, world_position)
		else
			r1, r2 = WwiseWorld.trigger_resource_event(wwise_world, event_resource, use_occlusion, unit, unit_node_index)
		end
	else
		local position = t.Position or t.position

		if position then
			r1, r2 = WwiseWorld.trigger_resource_event(wwise_world, event_resource, use_occlusion, position)
		else
			r1, r2 = WwiseWorld.trigger_resource_event(wwise_world, event_resource)
		end
	end

	return {
		playing_id = r1,
		source_id = r2,
		Playing_Id = r1,
		Source_Id = r2
	}
end

M.wwise_event_resource = function (t)
	local event_resource = t.Event_resource or t.event_resource or ""

	return {
		resource = event_resource
	}
end

local function make_source(t, wwise_world_function)
	local unit = t.Unit or t.unit
	local r1 = nil
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if unit then
		local unit_node_index = Script.index_offset()
		local node = t.Unit_Node or t.unit_node

		if node and node ~= "" then
			unit_node_index = Unit.node(unit, node)
		end

		r1 = wwise_world_function(wwise_world, unit, unit_node_index)
	else
		local position = t.Position or t.position
		r1 = (not position or wwise_world_function(wwise_world, position)) and (not source_id or wwise_world_function(wwise_world, source_id)) and wwise_world_function(wwise_world)
	end

	return r1
end

M.wwise_make_auto_source = function (t)
	local id = make_source(t, WwiseWorld.make_auto_source)

	return {
		source_id = id,
		Source_Id = id
	}
end

M.wwise_make_manual_source = function (t)
	local id = make_source(t, WwiseWorld.make_manual_source)

	return {
		source_id = id,
		Source_Id = id
	}
end

M.wwise_destroy_manual_source = function (t)
	local id = t.Source_Id or t.source_id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if WwiseWorld.has_source(wwise_world, id) then
		WwiseWorld.destroy_manual_source(wwise_world, id)
	end
end

M.wwise_stop_event = function (t)
	local id = t.Playing_Id or t.playing_id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.stop_event(wwise_world, id)
end

M.wwise_pause_event = function (t)
	local id = t.Playing_Id or t.playing_id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.pause_event(wwise_world, id)
end

M.wwise_resume_event = function (t)
	local id = t.Playing_Id or t.playing_id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.resume_event(wwise_world, id)
end

M.wwise_set_source_position = function (t)
	local id = t.Source_Id or t.source_id
	local val = t.Position or t.position
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_source_position(wwise_world, id, val)
end

M.wwise_set_source_parameter = function (t)
	local id = t.Source_Id or t.source_id
	local name = t.Parameter_Name or t.parameter_name or ""
	local val = t.Value or t.value
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_source_parameter(wwise_world, id, name, val)
end

M.wwise_set_global_parameter = function (t)
	local name = t.Parameter_Name or t.parameter_name or ""
	local val = t.Value or t.value
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_global_parameter(wwise_world, name, val)
end

M.wwise_set_state = function (t)
	local group = t.Group or t.group
	local state = t.State or t.state

	if not group or not state then
		return
	end

	Wwise.set_state(group, state)
end

M.wwise_set_switch = function (t)
	local group = t.Group or t.group
	local state = t.State or t.state

	if not group or not state then
		return
	end

	local id = t.Source_Id or t.source_id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.set_switch(wwise_world, group, state, id)
end

M.wwise_post_trigger = function (t)
	local id = t.Source_Id or t.source_id
	local name = t.Name or t.name

	if id and name then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.post_trigger(wwise_world, id, name)
	end
end

M.wwise_has_source = function (t)
	local id = t.Source_Id or t.source_id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if WwiseWorld.has_source(wwise_world, id) then
		return {
			yes = true,
			Yes = true
		}
	else
		return {
			No = true,
			no = true
		}
	end
end

M.wwise_is_playing = function (t)
	local id = t.Playing_Id or t.playing_id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	if WwiseWorld.is_playing(wwise_world, id) then
		return {
			yes = true,
			Yes = true
		}
	else
		return {
			No = true,
			no = true
		}
	end
end

M.wwise_get_playing_elapsed = function (t)
	local id = t.Playing_Id or t.playing_id
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())
	local elapsed_in_ms = WwiseWorld.get_playing_elapsed(wwise_world, id)
	elapsed_in_ms = elapsed_in_ms or 0
	local seconds = elapsed_in_ms / 1000

	return {
		seconds = seconds,
		Seconds = seconds
	}
end

M.wwise_add_soundscape_source = function (t)
	local event_resource = t.Event_resource or t.event_resource or ""
	local unit = t.Unit or t.unit
	local shape = t.Shape or t.shape
	local positioning = t.Positioning or t.positioning
	local trigger_range = t.Trigger_Range or t.trigger_range
	local result_id = -1

	if unit then
		if event_resource == "" then
			event_resource = Unit.get_data(unit, "wwise_event", "resource") or ""

			if event_resource == "" then
				return {
					ss_source_id = result_id,
					SS_Source_Id = result_id
				}

				shape = shape or Unit.get_data(unit, "Wwise", "shape") or "point"
				shape = string.lower(shape)
				local shape_map = {
					point = Wwise.SHAPE_POINT,
					sphere = Wwise.SHAPE_SPHERE,
					box = Wwise.SHAPE_BOX
				}
				shape = shape_map[shape] or Wwise.SHAPE_POINT

				if not positioning then
					positioning = string.lower(Unit.get_data(unit, "Wwise", "positioning") or "closest")
				end

				local default_scale = 10
				local scale = default_scale

				if shape == Wwise.SHAPE_SPHERE then
					scale = t.Sphere_Radius or t.sphere_radius

					if not scale or scale <= 0 then
						scale = Unit.get_data(unit, "Wwise", "sphere_radius") or default_scale
					end
				elseif shape == Wwise.SHAPE_BOX then
					scale = t.Box_Scale or t.box_scale

					if not scale then
						scale = Vector3(0, 0, 0)
						scale.x = Unit.get_data(unit, "Wwise", "box_extents", 1) or default_scale
						scale.y = Unit.get_data(unit, "Wwise", "box_extents", 2) or default_scale
						scale.z = Unit.get_data(unit, "Wwise", "box_extents", 3) or default_scale
					end
				end
			end
		end

		local positioning_map = {
			closest = Wwise.POSITIONING_CLOSEST_TO_LISTENER,
			["random in shape"] = Wwise.POSITIONING_RANDOM_IN_SHAPE,
			["random around listener"] = Wwise.POSITIONING_RANDOM_AROUND_LISTENER
		}
		positioning = positioning_map[positioning] or Wwise.POSITIONING_CLOSEST_TO_LISTENER
		local unit_node_index = Script.index_offset()

		if (t.Unit_Node or t.unit_node) and Unit.has_node(unit, t.Unit_Node or t.unit_node) then
			unit_node_index = Unit.node(unit, t.Unit_Node or t.unit_node)
		end

		if Unit.get_data(unit, "Wwise", "unit_node") and Unit.has_node(unit, Unit.get_data(unit, "Wwise", "unit_node")) then
			unit_node_index = Unit.node(unit, Unit.get_data(unit, "Wwise", "unit_node"))
		end

		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())
		result_id = WwiseWorld.add_soundscape_unit_wwise_event_source(wwise_world, event_resource, unit, unit_node_index, shape, scale, positioning, 0, 5, trigger_range)
	end

	return {
		ss_source_id = result_id,
		SS_Source_Id = result_id
	}
end

M.wwise_remove_soundscape_source = function (t)
	local id = t.SS_Source_Id or t.ss_source_id

	if not id then
		print("Error: nil soundscape source id, removing soundscape source failed.")

		return
	end

	if id == -1 then
		return
	end

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.remove_soundscape_source(wwise_world, id)
end

M.wwise_trigger_soundscape_source = function (t)
	local id = t.SS_Source_Id or t.ss_source_id

	if not id then
		print("Error: nil soundscape source id, removing soundscape source failed.")

		return
	end

	if id == -1 then
		return
	end

	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.trigger_soundscape_source(wwise_world, id)
end

M.wwise_set_obstruction_and_occlusion_for_soundscape_source = function (t)
	local id = t.SS_Source_Id or t.ss_source_id
	local obstruction = t.Obstruction or t.obstruction or 0
	local occlusion = t.Occlusion or t.occlusion or 0

	if id then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_obstruction_and_occlusion_for_soundscape_source(wwise_world, id, obstruction, occlusion)
	end
end

M.wwise_set_parameter_for_soundscape_source = function (t)
	print("wwise_set_parameter_for_soundscape_source")

	local id = t.SS_Source_Id or t.ss_source_id
	local name = t.Name or t.name or ""
	local value = t.Value or t.value or 0

	if id then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_parameter_for_soundscape_source(wwise_world, id, name, value)
	end
end

M.wwise_add_soundscape_render_unit = function (t)
	local unit = t.Unit or t.unit

	if unit then
		WwiseVisualization.add_soundscape_unit(unit)
	end
end

M.wwise_set_environment = function (t)
	local name = t.Aux_Bus or t.aux_bus
	local value = t.Value or t.value

	if name and value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_environment(wwise_world, name, value)
	end
end

M.wwise_set_dry_environment = function (t)
	local value = t.Value or t.value

	if value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_dry_environment(wwise_world, value)
	end
end

M.wwise_reset_environment = function (t)
	local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

	WwiseWorld.reset_environment(wwise_world)
end

M.wwise_set_source_environment = function (t)
	local id = t.Source_Id or t.source_id
	local name = t.Aux_Bus or t.aux_bus
	local value = t.Value or t.value

	if id and name and value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_environment_for_source(wwise_world, id, name, value)
	end
end

M.wwise_set_source_dry_environment = function (t)
	local id = t.Source_Id or t.source_id
	local value = t.Value or t.value

	if id and value then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_dry_environment_for_source(wwise_world, id, value)
	end
end

M.wwise_reset_source_environment = function (t)
	local id = t.Source_Id or t.source_id

	if id then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.reset_environment_for_source(wwise_world, id)
	end
end

M.wwise_set_obstruction_and_occlusion = function (t)
	local id = t.Source_Id or t.source_id
	local listener = listener_map[t.Listener or t.listener]
	local obstruction = t.Obstruction or t.obstruction or 0
	local occlusion = t.Occlusion or t.occlusion or 0

	if id and listener then
		local wwise_world = Wwise.wwise_world(Application.flow_callback_context_world())

		WwiseWorld.set_obstruction_and_occlusion(wwise_world, listener, id, obstruction, occlusion)
	end
end

if not Wwise then
	for k, v in pairs(M) do
		M[k] = function (t)
			return
		end
	end
end

M.dialogue_silence_unit = function (t)
	local unit = t.Unit or t.unit
	local new_silenced_value = t.set_silenced or false

	if unit then
		if Unit.alive(unit) then
			local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")

			if dialogue_extension then
				dialogue_extension.input:set_silenced(new_silenced_value)
			else
				print("Warning: dialogue silence unit: can't find dialogue_system extension in ", unit)
			end
		else
			print("Warning: dialogue silence unit: omit non alive unit ", unit)
		end
	else
		print("Warning: dialogue silence unit: nil unit doing nothing.")
	end
end

return
