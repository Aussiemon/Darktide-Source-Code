-- chunkname: @scripts/components/nurgle_manifestation.lua

local NurgleManifestation = component("NurgleManifestation")

NurgleManifestation.init = function (self, unit)
	self._editor = false
	self._unit = unit
	self._world = Unit.world(unit)
	self._duration = self:get_data(unit, "duration")

	local networked_timer_extension

	if not rawget(_G, "LevelEditor") then
		networked_timer_extension = ScriptUnit.fetch_component_extension(unit, "networked_timer_system")
	end

	if networked_timer_extension then
		networked_timer_extension:setup_from_component(self._duration, "loc_description", 1)

		self._networked_timer_extension = networked_timer_extension
	end

	self._stage_start_two = 0.78
	self._stage_start_three = 0.93
	self._stage_stem_death = 0.85
	self._lua_event_triggers = {
		{
			false,
			self._stage_start_two,
			"lua_stage_two"
		},
		{
			false,
			0.85,
			"lua_stem_death"
		},
		{
			false,
			self._stage_start_three,
			"lua_stage_three"
		}
	}
	self._start_time = 0
	self._stop_time = 0
	self._play_time = 0
	self._children = {}
	self._timings_eyes = {
		0.05,
		0.016,
		0.021,
		0.016,
		0.034,
		0.058,
		0.061,
		0.045,
		0.069,
		0.073
	}
	self._triggered_eyes = {}
	self._timings_physics = {
		0.013,
		0.02,
		0.055,
		0.06,
		0.058,
		0.055,
		0.071,
		0.015,
		0.045,
		0.055,
		0.061,
		0.057,
		0.064,
		0.059,
		0.1,
		0.072,
		0.115
	}
	self._triggered_physics = {}
	self._awake = false

	self:spawn_children(unit)
	self:set_material_variables(unit)
	self:reset()
	self:set_up_actors(unit)

	return true
end

NurgleManifestation.editor_init = function (self, unit)
	self:init(unit)

	self._editor = true

	self:store_actor_pose(unit)

	return true
end

NurgleManifestation.enable = function (self, unit)
	return
end

NurgleManifestation.disable = function (self, unit)
	return
end

NurgleManifestation.destroy = function (self, unit)
	self:despawn_children(unit)
end

NurgleManifestation.editor_validate = function (self, unit)
	return true, ""
end

NurgleManifestation.update = function (self, unit, dt, t)
	if self._start_time ~= 0 then
		self:trigger_effects(unit)
	end

	return true
end

NurgleManifestation.editor_update = function (self, unit, dt, t)
	self:update(unit, dt, t)

	return true
end

NurgleManifestation.spawn_children = function (self, unit)
	local world = Unit.world(unit)
	local unit_resource_name = self:get_data(unit, "eye_unit_resource")

	for i = 1, 10 do
		local child_unit = World.spawn_unit_ex(world, unit_resource_name)
		local node_index = Unit.node(unit, "ap_eye_" .. string.format("%02d", i))

		World.link_unit(world, child_unit, 1, unit, node_index)

		self._children[#self._children + 1] = child_unit
	end
end

NurgleManifestation.despawn_children = function (self, unit)
	local world = Unit.world(unit)

	for i = 1, #self._children do
		local child_unit = self._children[i]

		World.unlink_unit(world, child_unit)
		World.destroy_unit(world, child_unit)
	end
end

NurgleManifestation.awake = function (self, unit)
	if not self._awake then
		self._awake = true

		for i = 1, #self._children do
			Unit.flow_event(self._children[i], "open")
		end
	end
end

NurgleManifestation.set_material_variables = function (self, unit)
	local name = "poison_start_position"
	local node_index = Unit.node(unit, name)
	local node_position = Unit.world_position(unit, node_index)

	Unit.set_vector3_for_materials_in_unit_and_childs(unit, name, node_position)
	Unit.set_scalar_for_materials_in_unit_and_childs(unit, "stage_start_two", self._stage_start_two)
	Unit.set_scalar_for_materials_in_unit_and_childs(unit, "stage_start_three", self._stage_start_three)
end

NurgleManifestation.trigger_effects = function (self, unit)
	local time = World.render_time(self._world) - self._start_time + self._play_time
	local progress = time / self._duration

	if progress >= 1 then
		self._start_time = 0

		Unit.flow_event(unit, "lua_death")

		return
	end

	if progress >= self._stage_start_two then
		local stage_two_progess = math.max(progress - self._stage_start_two, 0)

		for i = #self._timings_eyes, 1, -1 do
			if not self._triggered_eyes[i] and stage_two_progess > self._timings_eyes[i] then
				Unit.flow_event(self._children[i], "trigger_effect")

				self._triggered_eyes[i] = true
			end
		end

		for i = #self._timings_physics, 1, -1 do
			if not self._triggered_physics[i] and stage_two_progess > self._timings_physics[i] then
				local actor = Unit.actor(unit, "c_dynamic_" .. string.format("%02d", i))

				if actor ~= nil then
					Actor.set_collision_enabled(actor, true)
					Actor.set_kinematic(actor, false)
					Actor.set_simulation_enabled(actor, true)
					Actor.wake_up(actor)

					if i < 9 then
						Unit.flow_event(unit, "lua_claw_break")
						Unit.set_flow_variable(unit, "lua_trigger_position", Actor.position(actor))
					else
						Unit.flow_event(unit, "lua_tree_break")
						Unit.set_flow_variable(unit, "lua_trigger_position", Actor.position(actor))
					end
				end

				self._triggered_physics[i] = true
			end
		end
	end

	local events = self._lua_event_triggers

	for i = 1, #events do
		if not events[i][1] and progress >= events[i][2] then
			events[i][1] = true

			Unit.flow_event(unit, events[i][3])
		end
	end
end

NurgleManifestation.set_up_actors = function (self, unit)
	for i = 1, #self._timings_physics do
		local actor = Unit.actor(unit, "c_dynamic_" .. string.format("%02d", i))

		if actor ~= nil and Actor.is_dynamic(actor) then
			Actor.set_kinematic(actor, true)
			Actor.set_collision_enabled(actor, false)
			Actor.set_simulation_enabled(actor, false)
		end
	end
end

NurgleManifestation.start = function (self)
	local networked_timer_extension = self._networked_timer_extension

	if networked_timer_extension then
		networked_timer_extension:start()

		self._start_time = World.render_time(self._world)

		Unit.set_scalar_for_materials_in_unit_and_childs(self._unit, "start_time", self._start_time)
	end
end

NurgleManifestation.stop = function (self)
	local networked_timer_extension = self._networked_timer_extension

	if networked_timer_extension then
		networked_timer_extension:pause()

		self._stop_time = World.render_time(self._world)
		self._play_time = networked_timer_extension:get_timer()
		self._start_time = 0

		Unit.set_scalar_for_materials_in_unit_and_childs(self._unit, "start_time", 0)
		Unit.set_scalar_for_materials_in_unit_and_childs(self._unit, "start_value", self._play_time / self._duration)
		Unit.set_scalar_for_materials_in_unit_and_childs(self._unit, "duration", self._duration - self._play_time)
	end
end

NurgleManifestation.reset = function (self)
	local networked_timer_extension = self._networked_timer_extension

	if networked_timer_extension then
		networked_timer_extension:stop()
	end

	self._awake = false
	self._stem_dead = false
	self._play_time = 0
	self._start_time = 0
	self._triggered_eyes = {}
	self._triggered_physics = {}

	for i = 1, #self._children do
		Unit.flow_event(self._children[i], "reset")
	end

	Unit.set_scalar_for_materials_in_unit_and_childs(self._unit, "start_time", 0)
	Unit.set_scalar_for_materials_in_unit_and_childs(self._unit, "start_value", 0)
	Unit.set_scalar_for_materials_in_unit_and_childs(self._unit, "duration", self._duration)

	if self._editor then
		self:restore_actor_pose(self._unit)
	end
end

NurgleManifestation.component_data = {
	duration = {
		ui_type = "number",
		decimals = 0,
		value = 20,
		ui_name = "Duration",
		step = 1
	},
	eye_unit_resource = {
		ui_type = "resource",
		preview = true,
		value = "",
		ui_name = "Resource",
		filter = "unit"
	},
	inputs = {
		start = {
			accessibility = "public",
			type = "event"
		},
		stop = {
			accessibility = "public",
			type = "event"
		},
		reset = {
			accessibility = "private",
			type = "event"
		},
		awake = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"NetworkedTimerExtension"
	}
}

return NurgleManifestation
