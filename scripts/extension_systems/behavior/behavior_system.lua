-- chunkname: @scripts/extension_systems/behavior/behavior_system.lua

require("scripts/extension_systems/behavior/minion_behavior_extension")
require("scripts/extension_systems/behavior/combat_range_user_behavior_extension")
require("scripts/extension_systems/behavior/bot_behavior_extension")
require("scripts/extension_systems/behavior/companion_behavior_extension")

local BehaviorTree = require("scripts/extension_systems/behavior/trees/behavior_tree")
local BehaviorTrees = require("scripts/extension_systems/behavior/trees/behavior_trees")
local BehaviorSystem = class("BehaviorSystem", "ExtensionSystemBase")

BehaviorSystem.init = function (self, ...)
	BehaviorSystem.super.init(self, ...)

	self._behavior_trees = {}

	self:_create_behavior_trees()
	self:_create_staggered_iterator("brain_iterator", function (extension, cumulative_dt, t)
		extension:staggered_update_brain(cumulative_dt, t)

		return extension:staggered_update_rate()
	end)
end

BehaviorSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = BehaviorSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	if extension.staggered_update_brain and extension:brain():active() then
		self:_register_staggered_item_update("brain_iterator", extension, 0)
	end

	return extension
end

BehaviorSystem.on_remove_extension = function (self, unit, extension_name)
	local extension = self._unit_to_extension_map[unit]

	if self:_has_staggered_item_update("brain_iterator", extension) then
		self:_unregister_staggered_item_update("brain_iterator", extension)
	end

	return BehaviorSystem.super.on_remove_extension(self, unit, extension_name)
end

BehaviorSystem._create_behavior_trees = function (self)
	local behavior_trees = self._behavior_trees

	for tree_name, root in pairs(BehaviorTrees) do
		local tree = BehaviorTree:new(root, tree_name)

		behavior_trees[tree_name] = tree
	end
end

BehaviorSystem.on_gameplay_post_init = function (self, level)
	self:call_gameplay_post_init_on_extensions(level)
end

BehaviorSystem.on_location_setup = function (self)
	self:call_gameplay_post_init_on_extensions()
end

BehaviorSystem.on_reload = function (self, refreshed_resources)
	self:_create_behavior_trees()
	BehaviorSystem.super.on_reload(self, refreshed_resources)
end

BehaviorSystem.update = function (self, context, dt, t, ...)
	BehaviorSystem.super.update(self, context, dt, t, ...)
	Managers.state.nav_mesh:kick_async_update(dt)
end

BehaviorSystem.behavior_tree = function (self, tree_name)
	return self._behavior_trees[tree_name]
end

BehaviorSystem.set_iterate_brain = function (self, extension, value)
	if value and extension.staggered_update_brain then
		self:_register_staggered_item_update("brain_iterator", extension, 0)
	elseif self:_has_staggered_item_update("brain_iterator", extension) then
		self:_unregister_staggered_item_update("brain_iterator", extension)
	end
end

BehaviorSystem.prioritize_brain = function (self, extension)
	if self:_has_staggered_item_update("brain_iterator", extension) then
		self:_prioritize_staggered_item_update("brain_iterator", extension)
	end
end

return BehaviorSystem
