require("scripts/extension_systems/point_of_interest/point_of_interest_observer_extension")
require("scripts/extension_systems/point_of_interest/point_of_interest_target_extension")

local PointOfInterestSettings = require("scripts/settings/point_of_interest/point_of_interest_settings")
local PointOfInterestUtilities = require("scripts/extension_systems/point_of_interest/utilities/point_of_interest_utilities")
local Vo = require("scripts/utilities/vo")
local PointOfInterestSystem = class("PointOfInterestSystem", "ExtensionSystemBase")

PointOfInterestSystem.init = function (self, extension_system_creation_context, ...)
	PointOfInterestSystem.super.init(self, extension_system_creation_context, ...)

	self._is_server = extension_system_creation_context.is_server
	self._world = extension_system_creation_context.world
	self._physics_world = extension_system_creation_context.physics_world
	self._broadphase = Broadphase(PointOfInterestSettings.broadphase_cell_size, 256)
	self._broadphase_by_extension = {}
	self._observers = {}
	self._targets = {}
	self._dynamic_targets = {}
	self._seen_recently = {}
	self._current_observer_unit = nil
end

PointOfInterestSystem.destroy = function (self)
	local broadphase_by_extension = self._broadphase_by_extension
	local broadphase = self._broadphase

	for extension, broadphase_id in pairs(broadphase_by_extension) do
		Broadphase.remove(broadphase, broadphase_id)
	end

	table.clear(self._broadphase_by_extension)
end

PointOfInterestSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = PointOfInterestSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	if extension_name == "PointOfInterestTargetExtension" then
		local broadphase_id = Broadphase.add(self._broadphase, unit, Unit.world_position(unit, 1), 0.5)
		self._broadphase_by_extension[extension] = broadphase_id
		self._targets[unit] = extension
	elseif extension_name == "PointOfInterestObserverExtension" then
		self._observers[unit] = extension
	end

	return extension
end

PointOfInterestSystem.on_remove_extension = function (self, unit, extension_name)
	if extension_name == "PointOfInterestTargetExtension" then
		local extension = ScriptUnit.extension(unit, "point_of_interest_system")
		local broadphase_id = self._broadphase_by_extension[extension]

		Broadphase.remove(self._broadphase, broadphase_id)

		self._broadphase_by_extension[extension] = nil
		self._targets[unit] = nil
		self._dynamic_targets[unit] = nil
	elseif extension_name == "PointOfInterestObserverExtension" then
		self._observers[unit] = nil
	end

	PointOfInterestSystem.super.on_remove_extension(self, unit, extension_name)
end

PointOfInterestSystem.extensions_ready = function (self, world, unit)
	local extension = ScriptUnit.extension(unit, "point_of_interest_system")

	if extension.is_dynamic then
		local is_dynamic = extension:is_dynamic()

		if is_dynamic then
			self._dynamic_targets[unit] = extension
		end
	end
end

PointOfInterestSystem.update = function (self, context, dt, t, ...)
	if not self._is_server then
		return
	end

	Profiler.start("update dynamic targets")
	self:_update_dynamic_targets()
	Profiler.stop("update dynamic targets")
	Profiler.start("update seen recently")
	self:_update_seen_recently(t)
	Profiler.stop("update seen recently")
	Profiler.start("update look at")
	self:_update_lookat(t)
	Profiler.stop("update look at")
end

PointOfInterestSystem._update_dynamic_targets = function (self)
	local broadphase = self._broadphase
	local move = Broadphase.move
	local broadphase_by_extension = self._broadphase_by_extension

	for unit, extension in pairs(self._dynamic_targets) do
		local broadphase_id = broadphase_by_extension[extension]

		move(broadphase, broadphase_id, POSITION_LOOKUP[unit])
	end
end

PointOfInterestSystem._update_seen_recently = function (self, t)
	local seen_recently = self._seen_recently
	local threshold = PointOfInterestSettings.seen_recently_threshold
	local threshold_time = t - threshold

	for unit, seen_time in pairs(seen_recently) do
		if seen_time < threshold_time then
			seen_recently[unit] = nil
		end
	end
end

local FOUND_UNITS = {}

PointOfInterestSystem._update_lookat = function (self, t)
	local observers = self._observers

	if observers[self._current_observer_unit] == nil or next(observers, self._current_observer_unit) == nil then
		self._current_observer_unit = nil
	end

	self._current_observer_unit = next(observers, self._current_observer_unit)
	local observer_unit = self._current_observer_unit

	if observer_unit == nil then
		return
	end

	local Broadphase = Broadphase
	local broadphase = self._broadphase
	local observer_extension = observers[observer_unit]
	local time_since_last = t - observer_extension:last_lookat_trigger()

	if time_since_last <= PointOfInterestSettings.event_trigger_interval then
		return
	end

	local seen_recently = self._seen_recently
	local physics_world = self._physics_world
	local darkness_system = Managers.state.extension:system("darkness_system")
	local observer_position, observer_rotation = observer_extension:first_person_position_rotation()
	local observer_forward = Quaternion.forward(observer_rotation)
	local dialogue_extension = ScriptUnit.extension_input(observer_unit, "dialogue_system")
	local query_radius = PointOfInterestSettings.max_view_distance * 0.5
	local query_position = observer_position + observer_forward * query_radius

	table.clear(FOUND_UNITS)

	local num_nearby = Broadphase.query(broadphase, query_position, query_radius, FOUND_UNITS)

	for i = 1, num_nearby, 1 do
		local target_unit = FOUND_UNITS[i]
		local saw_unit_recently = seen_recently[target_unit]

		if not saw_unit_recently then
			local target_extension = self._targets[target_unit]
			local target_center = target_extension:center_position()
			local view_distance_sq = target_extension:view_distance_sq()
			local view_half_angle = observer_extension:view_half_angle()
			local in_range, observer_to_target_vector, observer_target_direction, _, _ = PointOfInterestUtilities.is_in_range(observer_position, target_center, observer_forward, view_distance_sq, view_half_angle)

			if in_range and not darkness_system:is_in_darkness(target_center) then
				local observer_to_target_length = Vector3.length(observer_to_target_vector)
				local collision_filter = target_extension:collision_filter()
				local is_in_view = PointOfInterestUtilities.can_raycast(physics_world, observer_unit, target_unit, observer_position, observer_target_direction, observer_to_target_length, collision_filter)

				if is_in_view then
					target_extension:set_has_been_seen()
					observer_extension:set_last_lookat_trigger(t)

					local faction_event = target_extension:faction_event()
					local tag = target_extension:tag()

					if faction_event then
						local faction_breed_name = target_extension:faction_breed_name()

						Vo.faction_look_at_event(dialogue_extension, faction_event, faction_breed_name, tag, observer_to_target_length)
					else
						Vo.look_at_event(dialogue_extension, tag, observer_to_target_length)
					end

					seen_recently[target_unit] = t
				end
			end
		end
	end
end

return PointOfInterestSystem
