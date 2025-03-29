-- chunkname: @scripts/extension_systems/proximity/side_relation_proximity_extension.lua

require("scripts/extension_systems/proximity/side_relation_gameplay_logic/proximity_heal")

local JobInterface = require("scripts/managers/unit_job/job_interface")
local Proximity = require("scripts/utilities/proximity")
local Side = require("scripts/extension_systems/side/side")
local SIDE_RELATION_TYPES = Side.SIDE_RELATION_TYPES
local SideRelationProximityExtension = class("SideRelationProximityExtension")

SideRelationProximityExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._broadphase = extension_init_data.broadphase
	self._side_extension = ScriptUnit.extension(unit, "side_system")

	local side_name = self._side_extension.side:name()
	local relation_data = {}

	self._relation_data = relation_data
	self._logic_context = {
		unit = unit,
		side_name = side_name,
		world = extension_init_context.world,
		physics_world = extension_init_context.physics_world,
	}
	self._job_logic = nil

	local owner_unit_or_nil = extension_init_data.owner_unit_or_nil
	local relation_init_data = extension_init_data.relation_init_data

	for relation_name, init_data in pairs(relation_init_data) do
		local data = self:_initialize_relation(relation_name, init_data, owner_unit_or_nil)

		relation_data[relation_name] = data
	end
end

SideRelationProximityExtension.destroy = function (self)
	if self._job_logic then
		Managers.state.unit_job:unregister_job(self._unit)
	end
end

SideRelationProximityExtension._initialize_relation = function (self, relation_name, relation_init_data, owner_unit_or_nil)
	local proximity_radius = relation_init_data.proximity_radius
	local logic = {}
	local data = {
		num_in_proximity = 0,
		num_logic = 0,
		units_in_proximity = {},
		temp = {},
		stickiness_table = {},
		proximity_radius = relation_init_data.proximity_radius,
		stickiness_limit = relation_init_data.stickiness_limit,
		stickiness_time = relation_init_data.stickiness_time,
		logic = logic,
		owner_unit_or_nil = owner_unit_or_nil,
	}
	local logic_context = self._logic_context
	local logic_configuration = relation_init_data.logic
	local num_logic = #logic_configuration

	for ii = 1, num_logic do
		local logic_config = logic_configuration[ii]
		local logic_class_name = logic_config.class_name
		local init_data = logic_config.init_data
		local class_object = CLASSES[logic_class_name]
		local class_instance = class_object:new(logic_context, init_data, owner_unit_or_nil)

		logic[ii] = class_instance

		if logic_config.use_as_job then
			self:_initialize_job(class_instance)
		end
	end

	data.num_logic = num_logic

	return data
end

SideRelationProximityExtension._initialize_job = function (self, logic_class)
	self._job_logic = logic_class
end

SideRelationProximityExtension.update = function (self, unit, dt, t)
	self:_update_unit_alive_check(unit, dt, t)
	self:_update_proximity(unit, dt, t)
	self:_update_logic(unit, dt, t)
end

SideRelationProximityExtension.start_job = function (self)
	return self._job_logic:start_job()
end

SideRelationProximityExtension.job_completed = function (self)
	return self._job_logic:job_completed()
end

SideRelationProximityExtension.cancel_job = function (self)
	return self._job_logic:cancel_job()
end

SideRelationProximityExtension.is_job_canceled = function (self)
	return self._job_logic:is_job_canceled()
end

local dead_units = {}

SideRelationProximityExtension._update_unit_alive_check = function (self, unit, dt, t)
	local ALIVE = ALIVE

	for _, data in pairs(self._relation_data) do
		local num_dead_units = 0
		local units_in_proximity = data.units_in_proximity
		local stickiness_table = data.stickiness_table

		for proximity_unit, _ in pairs(units_in_proximity) do
			if not ALIVE[proximity_unit] then
				num_dead_units = num_dead_units + 1
				dead_units[num_dead_units] = proximity_unit
			end
		end

		for jj = 1, num_dead_units do
			local dead_unit = dead_units[jj]

			units_in_proximity[dead_unit] = nil
			stickiness_table[dead_unit] = nil

			local data_logic = data.logic
			local num_logic = data.num_logic

			for ii = 1, num_logic do
				local logic = data_logic[ii]

				logic:unit_in_proximity_deleted(dead_unit)
			end
		end

		data.num_in_proximity = data.num_in_proximity - num_dead_units
	end
end

SideRelationProximityExtension._update_proximity = function (self, unit, dt, t)
	local broadphase = self._broadphase
	local side = self._side_extension.side

	for relation_name, data in pairs(self._relation_data) do
		local relation_side_names = side:relation_side_names(relation_name)
		local proximity_radius = data.proximity_radius
		local stickiness_limit = data.stickiness_limit
		local stickiness_time = data.stickiness_time
		local current_in_proximity = data.temp
		local prev_in_proximity = data.units_in_proximity
		local stickiness_table = data.stickiness_table

		local function filter_function(filter_unit)
			return filter_unit ~= unit
		end

		Proximity.check_sticky_proximity(unit, relation_side_names, proximity_radius, current_in_proximity, filter_function, broadphase, stickiness_limit, stickiness_time, stickiness_table, prev_in_proximity, dt)

		local data_logic = data.logic
		local num_logic = data.num_logic
		local num_in_proximity = data.num_in_proximity

		for exit_unit, _ in pairs(prev_in_proximity) do
			local in_proximity = current_in_proximity[exit_unit]

			if not in_proximity then
				for ii = 1, num_logic do
					local logic = data_logic[ii]

					if logic.unit_left_proximity ~= nil then
						logic:unit_left_proximity(exit_unit)
					end
				end

				num_in_proximity = num_in_proximity - 1
			end
		end

		for enter_unit, _ in pairs(current_in_proximity) do
			local was_in_proximity = prev_in_proximity[enter_unit]

			if not was_in_proximity then
				for ii = 1, num_logic do
					local logic = data_logic[ii]

					if logic.unit_entered_proximity ~= nil then
						logic:unit_entered_proximity(enter_unit, t)
					end
				end

				num_in_proximity = num_in_proximity + 1
			end
		end

		data.units_in_proximity = current_in_proximity

		table.clear(prev_in_proximity)

		data.temp = prev_in_proximity
		data.num_in_proximity = num_in_proximity
	end
end

SideRelationProximityExtension._update_logic = function (self, unit, dt, t)
	for relation_name, data in pairs(self._relation_data) do
		local data_logic = data.logic
		local num_logic = data.num_logic

		for ii = 1, num_logic do
			local logic = data_logic[ii]

			if logic.update then
				logic:update(dt, t)
			end
		end
	end
end

implements(SideRelationProximityExtension, JobInterface)

return SideRelationProximityExtension
