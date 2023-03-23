local BotNavTransition = require("scripts/managers/bot_nav_transition/utilities/bot_nav_transition")
local LadderNavTransition = require("scripts/managers/bot_nav_transition/utilities/ladder_nav_transition")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local NavigationCostSettings = require("scripts/settings/navigation/navigation_cost_settings")
local SmartObject = require("scripts/extension_systems/nav_graph/utilities/smart_object")
local BotNavTransitionManager = class("BotNavTransitionManager")
local BROADPHASE_CELL_RADIUS = 0.7
local BROADPHASE_MAX_NUM_ENTITIES = 256
local BROADPHASE_CATEGORIES = {
	"bot_nav_transition"
}

BotNavTransitionManager.init = function (self, world, physics_world, nav_world, is_server)
	self._world = world
	self._physics_world = physics_world
	self._nav_world = nav_world
	self._is_server = is_server
	self._bot_nav_transitions = {}
	self._index_offset = SmartObject.MAX_SMART_OBJECT_ID
	self._current_index = self._index_offset + 1
	self._max_bot_nav_transitions = 100
	self._ladder_smart_object_index = self._index_offset + self._max_bot_nav_transitions
	self._ladder_transitions = {}
	self._broadphase = Broadphase(BROADPHASE_CELL_RADIUS, BROADPHASE_MAX_NUM_ENTITIES, BROADPHASE_CATEGORIES)
end

BotNavTransitionManager.on_gameplay_post_init = function (self, level)
	local nav_world = self._nav_world
	local nav_tag_layers = NavigationCostSettings.default_nav_tag_layers_bots
	self._traverse_logic, self._nav_tag_cost_table = Navigation.create_traverse_logic(nav_world, nav_tag_layers, nil, false)
end

BotNavTransitionManager.destroy = function (self)
	self:clear_all_transitions()

	local traverse_logic = self._traverse_logic

	if traverse_logic then
		GwNavTagLayerCostTable.destroy(self._nav_tag_cost_table)
		GwNavTraverseLogic.destroy(traverse_logic)
	end
end

BotNavTransitionManager.clear_temp_transitions = function (self)
	local transitions = self._bot_nav_transitions

	for i, data in pairs(transitions) do
		if not data.permanent then
			self:_destroy_transition(transitions, i)
		end
	end
end

BotNavTransitionManager.clear_all_transitions = function (self)
	local transitions = self._bot_nav_transitions

	for i, data in pairs(transitions) do
		self:_destroy_transition(transitions, i)
	end
end

BotNavTransitionManager._destroy_transition = function (self, transitions, index)
	local transition = transitions[index]
	transitions[index] = nil
	local graph = transition.graph

	GwNavGraph.destroy(graph)

	local broadphase_id = transition.broadphase_id

	Broadphase.remove(self._broadphase, broadphase_id)
end

local IS_BIDIRECTIONAL = false
local BOT_NAV_TRANSITION_RADIUS = 0.7
local BOT_NAV_BROADPHASE_CATEGORY = "bot_nav_transition"
local NEARBY_TRANSITION_SEARCH_RADIUS = 0.1
local broadphase_results = {}

BotNavTransitionManager.create_transition = function (self, wanted_from, via, wanted_to, player_jumped, make_permanent)
	local nav_world = self._nav_world
	local traverse_logic = self._traverse_logic
	local drawer = nil
	local success, from, to = BotNavTransition.check_nav_mesh(wanted_from, wanted_to, nav_world, traverse_logic, drawer)

	if not success then
		return false
	end

	local broadphase = self._broadphase
	local num_results = Broadphase.query(broadphase, from, NEARBY_TRANSITION_SEARCH_RADIUS, broadphase_results, BOT_NAV_BROADPHASE_CATEGORY)
	local hit_existing_transition = num_results > 0

	if hit_existing_transition then
		return false
	end

	local layer_name = BotNavTransition.calculate_nav_tag_layer(from, to, player_jumped)

	if not layer_name then
		return false
	end

	local index = self._current_index
	local transitions = self._bot_nav_transitions

	if transitions[index] then
		self:_destroy_transition(transitions, index)
	end

	local nav_mesh_manager = Managers.state.nav_mesh
	local layer_id = nav_mesh_manager:nav_tag_layer_id(layer_name)
	local physics_world = self._physics_world
	local waypoint = BotNavTransition.resolve_waypoint_position(from, via, player_jumped, physics_world)
	local created, graph = GwNavGraph.create(nav_world, IS_BIDIRECTIONAL, {
		from,
		to
	}, Color.blue(), layer_id, index)

	GwNavGraph.add_to_database(graph)

	local broadphase_id = Broadphase.add(broadphase, nil, from, BOT_NAV_TRANSITION_RADIUS)
	transitions[index] = {
		graph = graph,
		from = Vector3Box(from),
		waypoint = Vector3Box(waypoint),
		to = Vector3Box(to),
		broadphase_id = broadphase_id,
		type = layer_name,
		permanent = make_permanent or false
	}
	local next_index = index
	local index_offset = self._index_offset
	local max_bot_nav_transitions = self._max_bot_nav_transitions

	repeat
		next_index = (next_index - index_offset) % max_bot_nav_transitions + 1 + index_offset
	until not transitions[next_index] or not transitions[next_index].permanent or next_index == index

	self._current_index = next_index

	return true, index
end

BotNavTransitionManager.unregister_transition = function (self, index)
	local bot_nav_transitions = self._bot_nav_transitions

	self:_destroy_transition(bot_nav_transitions, index)
end

BotNavTransitionManager.traverse_logic = function (self)
	return self._traverse_logic
end

BotNavTransitionManager.transition_data = function (self, smart_object_id)
	local bot_nav_transitions = self._bot_nav_transitions
	local bot_nav_transition = bot_nav_transitions[smart_object_id]

	if bot_nav_transition then
		return bot_nav_transition
	end

	local ladder_transitions = self._ladder_transitions

	for _, data in pairs(ladder_transitions) do
		if data.index == smart_object_id then
			return data
		end
	end

	return nil
end

BotNavTransitionManager.register_ladder = function (self, unit)
	local physics_world = self._physics_world
	local drawer = nil
	local data = {}
	self._ladder_transitions[unit] = data
	local rotation = Unit.local_rotation(unit, 1)
	local down_direction = -Quaternion.up(rotation)
	local backward_direction = -Quaternion.forward(rotation)
	local bottom_node = Unit.node(unit, "node_bottom")
	local top_node = Unit.node(unit, "node_top")
	local bottom_position = Unit.world_position(unit, bottom_node)
	local top_position = Unit.world_position(unit, top_node)
	local ladder_length = Vector3.distance(bottom_position, top_position)
	local ground_position = LadderNavTransition.find_ground_position(top_position, ladder_length, backward_direction, down_direction, physics_world, drawer)

	if not ground_position then
		data.to = Vector3Box(top_position)
		data.waypoint = Vector3Box(top_position)
		data.from = Vector3Box(bottom_position)
		data.failed = true

		return false
	end

	local flat_backward_direction = Vector3.normalize(Vector3.flat(backward_direction))
	local flat_forward_direction = -flat_backward_direction
	local nav_world = self._nav_world
	local traverse_logic = self._traverse_logic
	local top_on_nav_mesh_position = LadderNavTransition.find_position_on_nav_mesh(top_position, nav_world, flat_forward_direction, traverse_logic, drawer)

	if not top_on_nav_mesh_position then
		data.to = Vector3Box(top_position)
		data.waypoint = Vector3Box(top_position)
		data.from = Vector3Box(ground_position)
		data.failed = true

		return false
	end

	local ground_on_nav_mesh_position = LadderNavTransition.find_position_on_nav_mesh(ground_position, nav_world, flat_backward_direction, traverse_logic, drawer)

	if not ground_on_nav_mesh_position then
		data.to = Vector3Box(top_on_nav_mesh_position)
		data.waypoint = Vector3Box(top_position)
		data.from = Vector3Box(ground_position)
		data.failed = true

		return false
	end

	local ladder_is_bidirectional = LadderNavTransition.is_bidirectional(ground_position, bottom_position)
	local layer_name = LadderNavTransition.NAV_TAG_LAYER
	local nav_mesh_manager = Managers.state.nav_mesh
	local layer_id = nav_mesh_manager:nav_tag_layer_id(layer_name)
	local index = self._ladder_smart_object_index + 1
	local created, graph = GwNavGraph.create(nav_world, ladder_is_bidirectional, {
		top_on_nav_mesh_position,
		ground_on_nav_mesh_position
	}, Color.blue(), layer_id, index)

	GwNavGraph.add_to_database(graph)

	self._ladder_smart_object_index = index
	data.graph = graph
	data.index = index
	data.to = Vector3Box(top_on_nav_mesh_position)
	data.waypoint = Vector3Box(top_position)
	data.from = Vector3Box(ground_on_nav_mesh_position)

	return true
end

BotNavTransitionManager.unregister_ladder = function (self, unit)
	local data = self._ladder_transitions[unit]

	if not data.failed then
		local graph = data.graph

		GwNavGraph.destroy(graph)
	end

	self._ladder_transitions[unit] = nil
end

BotNavTransitionManager.allow_nav_tag_layer = function (self, layer_name, layer_allowed)
	local layer_id = Managers.state.nav_mesh:nav_tag_layer_id(layer_name)
	local nav_tag_cost_table = self._nav_tag_cost_table

	if not nav_tag_cost_table then
		return
	end

	if layer_allowed then
		GwNavTagLayerCostTable.allow_layer(nav_tag_cost_table, layer_id)
	else
		GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_id)
	end
end

BotNavTransitionManager.set_nav_tag_layer_cost = function (self, layer_name, layer_cost)
	local layer_id = Managers.state.nav_mesh:nav_tag_layer_id(layer_name)

	GwNavTagLayerCostTable.set_layer_cost_multiplier(self._nav_tag_cost_table, layer_id, layer_cost)
end

return BotNavTransitionManager
