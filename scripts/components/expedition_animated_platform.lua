-- chunkname: @scripts/components/expedition_animated_platform.lua

local ExpeditionAnimatedPlatform = component("ExpeditionAnimatedPlatform")
local DEFAULT_DIST = 100
local DEFAULT_SPEED = 1
local END_FRAME = 3000
local CHEST_UNIT_RESOURCES = {
	"content/environment/artsets/imperial/expeditions/wastes/canyon/props/chests/chest_small_01",
	"content/environment/artsets/imperial/expeditions/wastes/canyon/props/chests/chest_medium_01",
	"content/environment/artsets/imperial/expeditions/wastes/canyon/props/chests/chest_large_01",
}

ExpeditionAnimatedPlatform.init = function (self, unit)
	self._unit = unit
	self._linked_units = {}

	local networked_timer_extension = ScriptUnit.fetch_component_extension(unit, "networked_timer_system")
	local duration = self:get_data(unit, "duration")

	networked_timer_extension:setup_from_component(duration, "loc_description", 1)

	self._networked_timer_extension = networked_timer_extension

	self:_link_chests()
	self:_disable_chests()
	self:_spawn_and_link_platform()
	self:_set_start_frame()
	self:_set_direction_and_speed()
end

ExpeditionAnimatedPlatform._spawn_and_link_platform = function (self)
	local unit = self._unit
	local world = Unit.world(unit)
	local platform_unit_resource = self:get_data(unit, "platform_unit_resource")

	if platform_unit_resource ~= nil and platform_unit_resource ~= "" then
		local ap_attach_point = Unit.node(unit, "ap_attach_point")

		self._platform_unit = World.spawn_unit_ex(world, platform_unit_resource, nil, Unit.world_position(unit, ap_attach_point), Unit.world_rotation(unit, ap_attach_point))

		World.link_unit(world, self._platform_unit, 1, unit, ap_attach_point, nil, false)
	end
end

ExpeditionAnimatedPlatform._set_start_frame = function (self)
	local duration = self:get_data(self._unit, "duration")
	local remaining_time = self._networked_timer_extension:get_remaining_time()
	local progressed_time = duration - remaining_time
	local progressed_percentage = progressed_time / duration
	local end_frame = self._end_frame or END_FRAME
	local start_frame = end_frame * progressed_percentage

	Unit.set_flow_variable(self._unit, "lua_start_frame", start_frame)
end

ExpeditionAnimatedPlatform._set_direction_and_speed = function (self)
	local unit = self._unit
	local ap_base = Unit.node(unit, "ap_base")
	local ap_attach_point = Unit.node(unit, "ap_attach_point")
	local ap_target = Unit.node(unit, "ap_target")
	local direction = Vector3.normalize(Unit.world_position(unit, ap_target) - Unit.world_position(unit, ap_base))
	local rotation = Quaternion.multiply(Quaternion.inverse(Unit.world_rotation(unit, 1)), Quaternion.look(direction))

	Unit.set_local_rotation(unit, ap_base, rotation)
	Unit.set_local_rotation(unit, ap_attach_point, Quaternion.inverse(rotation))

	local distance = Vector3.distance(Unit.world_position(unit, 1), Unit.world_position(unit, ap_target))

	distance = math.min(distance, DEFAULT_DIST)

	local percentage = distance / DEFAULT_DIST
	local new_end_frame = END_FRAME * (percentage * 0.5)

	Unit.set_flow_variable(self._unit, "lua_end_frame", new_end_frame)

	self._end_frame = new_end_frame

	local current_duration = distance
	local duration = self:get_data(unit, "duration")
	local animation_speed = current_duration / duration

	Unit.set_flow_variable(unit, "lua_speed", animation_speed * 0.5)
end

ExpeditionAnimatedPlatform._link_chests = function (self)
	local unit = self._unit
	local ap_attach_point = Unit.node(unit, "ap_attach_point")
	local ap_target = Unit.node(unit, "ap_target")
	local target_pose = Unit.world_pose(unit, ap_target)
	local world = Unit.world(unit)

	for i = 1, #CHEST_UNIT_RESOURCES do
		local chest_units = World.units_by_resource(world, CHEST_UNIT_RESOURCES[i])

		for j = 1, #chest_units do
			local chest_unit = chest_units[j]
			local chest_pose = Unit.world_pose(chest_unit, 1)
			local chest_pos = Matrix4x4.translation(chest_pose)

			if Unit.is_point_inside_volume(unit, "chest_volume", chest_pos) then
				local world_pose = Matrix4x4.inverse(target_pose)
				local new_pose = Matrix4x4.multiply(chest_pose, world_pose)

				Unit.teleport_local_position(chest_unit, 1, Matrix4x4.translation(new_pose))
				Unit.teleport_local_rotation(chest_unit, 1, Matrix4x4.rotation(new_pose))
				World.link_unit(world, chest_unit, 1, unit, ap_attach_point, nil, true)

				self._linked_units[#self._linked_units + 1] = chest_unit
			end
		end
	end
end

ExpeditionAnimatedPlatform._enable_chests = function (self)
	for i = 1, #self._linked_units do
		local linked_unit = self._linked_units[i]

		Unit.enable_physics(linked_unit)
		Unit.flow_event(linked_unit, "interactable_enable")
	end
end

ExpeditionAnimatedPlatform._disable_chests = function (self)
	for i = 1, #self._linked_units do
		local linked_unit = self._linked_units[i]

		Unit.flow_event(linked_unit, "interactable_disable")
		Unit.disable_physics(linked_unit)
	end
end

ExpeditionAnimatedPlatform.enable = function (self, unit)
	return
end

ExpeditionAnimatedPlatform.disable = function (self, unit)
	return
end

ExpeditionAnimatedPlatform.destroy = function (self, unit, is_editor)
	local world = Unit.world(self._unit)

	if is_editor then
		for i = 1, #self._linked_units do
			local linked_unit = self._linked_units[i]

			World.unlink_unit(world, linked_unit)
			World.destroy_unit(world, linked_unit)
		end
	end

	self._linked_units = {}

	if self._platform_unit ~= nil then
		World.unlink_unit(world, self._platform_unit)
		World.destroy_unit(world, self._platform_unit)

		self._platform_unit = nil
	end
end

ExpeditionAnimatedPlatform.editor_finished = function (self)
	if rawget(_G, "LevelEditor") then
		self:_editor_set_found_chests_visibility(true)
	end
end

ExpeditionAnimatedPlatform.editor_validate = function (self, unit)
	return true, ""
end

ExpeditionAnimatedPlatform.play = function (self)
	self._networked_timer_extension:start()
end

ExpeditionAnimatedPlatform.pause = function (self)
	self._networked_timer_extension:pause()
end

ExpeditionAnimatedPlatform.reset = function (self)
	self._networked_timer_extension:stop()
end

ExpeditionAnimatedPlatform.finished = function (self)
	self:_enable_chests()
end

ExpeditionAnimatedPlatform.hot_join_timer_sync = function (self)
	local remaining_time = self._networked_timer_extension:get_remaining_time()

	self:_set_direction_and_speed()
	self:_set_start_frame()

	if not self._networked_timer_extension:is_counting() then
		Unit.flow_event(self._unit, "lua_play_pause")
	else
		Unit.flow_event(self._unit, "lua_play")
	end
end

ExpeditionAnimatedPlatform.component_data = {
	duration = {
		decimals = 1,
		step = 0.1,
		ui_name = "Duration",
		ui_type = "number",
		value = 10,
	},
	platform_unit_resource = {
		filter = "unit",
		preview = false,
		ui_name = "Platform Unit Resource",
		ui_type = "resource",
		value = "",
	},
	inputs = {
		play = {
			accessibility = "public",
			type = "event",
		},
		pause = {
			accessibility = "public",
			type = "event",
		},
		reset = {
			accessibility = "public",
			type = "event",
		},
	},
}

return ExpeditionAnimatedPlatform
