-- chunkname: @scripts/extension_systems/perception/perception_system.lua

require("scripts/extension_systems/perception/minion_perception_extension")
require("scripts/extension_systems/perception/bot_perception_extension")

local BotGestaltTargetSelectionWeights = require("scripts/settings/bot/bot_gestalt_target_selection_weights")
local BotSettings = require("scripts/settings/bot/bot_settings")
local Breeds = require("scripts/settings/breed/breeds")
local behavior_gestalts = BotSettings.behavior_gestalts
local PerceptionSystem = class("PerceptionSystem", "ExtensionSystemBase")

PerceptionSystem.init = function (self, ...)
	PerceptionSystem.super.init(self, ...)

	self._current_update_unit = nil
	self._current_update_extension = nil
	self._num_update_units = 0
	self._update_units = {}
	self._prioritized_update_units = {}

	if self._is_server then
		self._unit_untargetable_data = Script.new_map(4)
		self._next_global_untargetable_id = 1
	end

	self:_init_line_of_sight_raycasts(self._physics_world)
	self:_preparse_bot_gestalt_target_selection_weights(BotGestaltTargetSelectionWeights)
end

PerceptionSystem.destroy = function (self)
	table.clear(self._line_of_sight_raycast_data)
end

PerceptionSystem._init_line_of_sight_raycasts = function (self, physics_world)
	local line_of_sight_raycast_data = {}

	for name, data in pairs(Breeds) do
		local line_of_sight_collision_filter = data.line_of_sight_collision_filter

		if line_of_sight_collision_filter and not line_of_sight_raycast_data[line_of_sight_collision_filter] then
			local los_data = {}

			los_data.current_casting_units = {}

			local cb = callback(self, "physics_cb_line_of_sight_hit", line_of_sight_collision_filter)

			los_data.raycast = PhysicsWorld.make_raycast(physics_world, cb, "closest", "types", "both", "collision_filter", line_of_sight_collision_filter)
			line_of_sight_raycast_data[line_of_sight_collision_filter] = los_data
		end
	end

	self._line_of_sight_raycast_data = line_of_sight_raycast_data
end

PerceptionSystem.physics_cb_line_of_sight_hit = function (self, line_of_sight_collision_filter, id, hit, hit_position)
	local los_data = self._line_of_sight_raycast_data[line_of_sight_collision_filter]
	local current_casting_units = los_data.current_casting_units
	local casting_unit = current_casting_units[1]
	local extension = self._unit_to_extension_map[casting_unit]

	if extension then
		extension:cb_line_of_sight_hit(hit, hit_position)
	end

	table.remove(current_casting_units, 1)
end

PerceptionSystem.add_line_of_sight_raycast_query = function (self, unit, los_from_position, los_direction, los_distance, line_of_sight_collision_filter)
	local los_data = self._line_of_sight_raycast_data[line_of_sight_collision_filter]
	local raycast = los_data.raycast

	raycast:cast(los_from_position, los_direction, los_distance)

	los_data.current_casting_units[#los_data.current_casting_units + 1] = unit
end

PerceptionSystem.register_extension_update = function (self, unit, extension_name, extension)
	PerceptionSystem.super.register_extension_update(self, unit, extension_name, extension)

	if extension_name ~= "BotPerceptionExtension" then
		self._update_units[unit] = extension
		self._num_update_units = self._num_update_units + 1
	end
end

PerceptionSystem.on_remove_extension = function (self, unit, extension_name)
	if extension_name ~= "BotPerceptionExtension" then
		local current_update_unit = self._current_update_unit

		if current_update_unit == unit then
			self._current_update_unit, self._current_update_extension = next(self._update_units, current_update_unit)
		end

		self._update_units[unit] = nil
		self._prioritized_update_units[unit] = nil
		self._num_update_units = self._num_update_units - 1
	end

	PerceptionSystem.super.on_remove_extension(self, unit, extension_name)
end

PerceptionSystem.register_prioritized_unit_update = function (self, unit)
	local perception_extension = self._unit_to_extension_map[unit]

	self._prioritized_update_units[unit] = perception_extension
end

local UPDATE_ALL_UNITS_TIME = 1

PerceptionSystem.pre_update = function (self, context, dt, t)
	self:pre_update_extension("BotPerceptionExtension", dt, t, context)
end

PerceptionSystem.update = function (self, context, dt, t)
	self:update_extension("BotPerceptionExtension", dt, t, context)

	local num_prioritized_update_units = 0
	local prioritized_update_units = self._prioritized_update_units

	for unit, extension in pairs(prioritized_update_units) do
		extension:update(unit, dt, t)

		num_prioritized_update_units = num_prioritized_update_units + 1
	end

	local update_units = self._update_units
	local current_update_unit = self._current_update_unit
	local current_update_extension = self._current_update_extension
	local counter = 1
	local num_update_units = self._num_update_units - num_prioritized_update_units
	local num_to_update = math.min(math.ceil(num_update_units * dt / UPDATE_ALL_UNITS_TIME), num_update_units)

	while counter <= num_to_update do
		if current_update_unit and not prioritized_update_units[current_update_unit] then
			current_update_extension:update(current_update_unit, dt, t)

			counter = counter + 1
		end

		current_update_unit, current_update_extension = next(update_units, current_update_unit)
	end

	table.clear(prioritized_update_units)

	self._current_update_unit = current_update_unit
	self._current_update_extension = current_update_extension
end

PerceptionSystem.on_reload = function (self, refreshed_resources)
	self:_preparse_bot_gestalt_target_selection_weights(BotGestaltTargetSelectionWeights)
	PerceptionSystem.super.on_reload(self, refreshed_resources)
end

PerceptionSystem._preparse_bot_gestalt_target_selection_weights = function (self, bot_gestalt_target_selection_weights)
	local DEFAULT_BREED_WEIGHT = bot_gestalt_target_selection_weights.DEFAULT_BREED_WEIGHT

	if not DEFAULT_BREED_WEIGHT then
		return
	end

	bot_gestalt_target_selection_weights.DEFAULT_BREED_WEIGHT = nil

	for gestalt, _ in pairs(behavior_gestalts) do
		if not bot_gestalt_target_selection_weights[gestalt] then
			bot_gestalt_target_selection_weights[gestalt] = {}
		end
	end

	for breed_name, _ in pairs(Breeds) do
		for _, weights in pairs(bot_gestalt_target_selection_weights) do
			if not weights[breed_name] then
				weights[breed_name] = DEFAULT_BREED_WEIGHT
			end
		end
	end
end

PerceptionSystem.set_untargetable = function (self, caller_class, unit)
	local unit_untargetable_data = self._unit_untargetable_data
	local untargetable_data = unit_untargetable_data[unit] or {
		num_ids = 0
	}

	unit_untargetable_data[unit] = untargetable_data

	local global_untargetable_id = self._next_global_untargetable_id
	local caller_name = caller_class.__class_name or caller_class.__component_name

	untargetable_data[caller_name] = global_untargetable_id
	untargetable_data[global_untargetable_id] = caller_name
	untargetable_data.num_ids = untargetable_data.num_ids + 1
	self._next_global_untargetable_id = self._next_global_untargetable_id + 1

	return global_untargetable_id
end

PerceptionSystem.set_targetable = function (self, unit, untargetable_id)
	local untargetable_data = self._unit_untargetable_data[unit]
	local caller_name = untargetable_data[untargetable_id]

	untargetable_data[caller_name] = nil
	untargetable_data[untargetable_id] = nil
	untargetable_data.num_ids = untargetable_data.num_ids - 1
end

PerceptionSystem.is_untargetable = function (self, unit)
	local untargetable_data = self._unit_untargetable_data[unit]

	return untargetable_data and untargetable_data.num_ids > 0
end

return PerceptionSystem
