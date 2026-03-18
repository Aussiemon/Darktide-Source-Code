-- chunkname: @scripts/managers/mutator/mutators/mutator_expedition_extra_trickle_hordes.lua

require("scripts/managers/mutator/mutators/mutator_base")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local NavQueries = require("scripts/utilities/nav_queries")
local MutatorExpeditionExtraTrickleHordes = class("MutatorExpeditionExtraTrickleHordes", "MutatorBase")

MutatorExpeditionExtraTrickleHordes.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorExpeditionExtraTrickleHordes.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	self._is_active = true
	self._patrols = {}
	self._astar_data = {
		failed_num = 0,
		patrol = nil,
		target_unit = nil,
		wanted_position = Vector3Box(0, 0, 0),
	}
	self._valid_levels_in_current_section = {}
end

MutatorExpeditionExtraTrickleHordes.on_gameplay_post_init = function (self, level, themes)
	if not self._is_server then
		return
	end

	local template = self._template
	local trickle_horde_templates = template.trickle_horde_templates

	if self._is_server and trickle_horde_templates then
		for i = 1, #trickle_horde_templates do
			local trickle_horde_template = trickle_horde_templates[i]

			Managers.state.pacing:add_trickle_horde(trickle_horde_template)
		end
	end

	local game_mode_manager = Managers.state.game_mode
	local game_mode = game_mode_manager:game_mode()

	self._game_mode = game_mode
	self._astar = GwNavAStar.create(self._nav_world)
end

MutatorExpeditionExtraTrickleHordes.add_externally_controlled_patrol_leader = function (self, patrol)
	if not self._is_server then
		return
	end

	self._patrols[#self._patrols + 1] = patrol
end

local VALID_TYPES = {
	type_arrival = true,
	type_extraction = true,
	type_opportunity = true,
}

MutatorExpeditionExtraTrickleHordes.setup_valid_levels = function (self)
	if #self._valid_levels_in_current_section <= 0 then
		local current_section_index = self._game_mode:current_location_index()

		self._valid_levels_in_current_section = self._game_mode:get_all_levels_of_specified_tag(current_section_index, VALID_TYPES)
	end

	return #self._valid_levels_in_current_section
end

local STUCK_OFFSET = 0.01
local CHECK_STUCK_T = 3

MutatorExpeditionExtraTrickleHordes._check_if_stuck = function (self, t)
	if not self._check_stuck_t then
		self._check_stuck_t = t + CHECK_STUCK_T
	elseif t > self._check_stuck_t then
		for i = 1, #self._patrols do
			local patrol = self._patrols[i]

			for ii = 1, #patrol do
				local unit = patrol[ii]

				if HEALTH_ALIVE[unit] then
					local blackboard = BLACKBOARDS[unit]
					local patrol_component = Blackboard.write_component(blackboard, "patrol")
					local should_patrol = patrol_component.should_patrol

					if should_patrol then
						local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
						local current_velocity = locomotion_extension:current_velocity()
						local speed = Vector3.length(current_velocity)

						if speed < STUCK_OFFSET then
							patrol_component.should_patrol = false
						end
					end
				end
			end
		end

		self._check_stuck_t = t + CHECK_STUCK_T
	end
end

MutatorExpeditionExtraTrickleHordes._process_astar = function (self)
	local done = GwNavAStar.processing_finished(self._astar)

	if not done then
		return true
	end

	local leader_blackboard = BLACKBOARDS[self._astar_data.target_unit]

	if not HEALTH_ALIVE[self._astar_data.target_unit] or not leader_blackboard then
		self._astar_data.target_unit = nil
		self._astar_data.wanted_position = Vector3Box(0, 0, 0)
		self._astar_data.patrol = nil

		table.swap_delete(self._patrols, self._astar_data.selected_patrol_index)

		return false
	end

	local path_found = GwNavAStar.path_found(self._astar)

	if not path_found then
		self._astar_data.target_unit = nil
		self._astar_data.wanted_position = Vector3Box(0, 0, 0)
		self._astar_data.patrol = nil
		self._astar_data.failed_num = 0

		return false
	end

	local patrol_to_position = self._astar_data.wanted_position:unbox()
	local patrol = self._astar_data.patrol
	local patrol_component = Blackboard.write_component(leader_blackboard, "patrol")

	patrol_component.walk_position:store(patrol_to_position)

	patrol_component.should_patrol = true

	for i = 1, #patrol do
		local unit = patrol[i]
		local blackboard = BLACKBOARDS[unit]

		if not HEALTH_ALIVE[unit] or not blackboard then
			self._astar_data.target_unit = nil
			self._astar_data.wanted_position = Vector3Box(0, 0, 0)
			self._astar_data.patrol = nil
			self._astar_data.failed_num = 0

			table.swap_delete(self._patrols, self._astar_data.selected_patrol_index)

			return false
		end

		local other_patrol_component = Blackboard.write_component(blackboard, "patrol")

		if i == 1 then
			other_patrol_component.patrol_leader_unit = self._astar_data.target_unit
			other_patrol_component.patrol_index = i
			other_patrol_component.should_patrol = true
		else
			other_patrol_component.patrol_leader_unit = self._astar_data.target_unit
			other_patrol_component.patrol_index = i
			other_patrol_component.should_patrol = true
		end
	end

	self._astar_data.target_unit = nil
	self._astar_data.wanted_position = Vector3Box(0, 0, 0)
	self._astar_data.patrol = nil
	self._astar_data.failed_num = 0

	return false
end

local ABOVE, BELOW = 2, 3
local MAX_TRIES = 25

MutatorExpeditionExtraTrickleHordes.update = function (self, dt, t)
	if not self._is_server then
		return
	end

	local pacing_manager = Managers.state and Managers.state.pacing

	if not pacing_manager then
		return
	end

	local pacing_enabled = pacing_manager:is_enabled()

	if not pacing_enabled then
		if #self._valid_levels_in_current_section >= 0 then
			self._valid_levels_in_current_section = {}
		end

		return
	end

	local num_valid_levels = self:setup_valid_levels()

	if num_valid_levels <= 0 then
		return
	end

	local astar_data = self._astar_data

	if astar_data.target_unit then
		local proccessing = self:_process_astar()

		if proccessing then
			return
		end
	end

	local current_patrol_unit, selected_patrol, selected_patrol_index

	for i = 1, #self._patrols do
		local patrol = self._patrols[i]
		local first_unit = patrol and patrol[1]

		if first_unit and HEALTH_ALIVE[first_unit] then
			local blackboard = BLACKBOARDS[first_unit]
			local patrol_component = Blackboard.write_component(blackboard, "patrol")
			local should_patrol = patrol_component.should_patrol

			if not should_patrol then
				current_patrol_unit = first_unit
				selected_patrol = patrol
				selected_patrol_index = i
			end
		else
			table.swap_delete(self._patrols, i)
		end
	end

	if not current_patrol_unit then
		return
	end

	local from_position = POSITION_LOOKUP[current_patrol_unit]
	local navigation_extension = ScriptUnit.extension(current_patrol_unit, "navigation_system")
	local traverse_logic = navigation_extension:traverse_logic()
	local wanted_position
	local tries = 0

	repeat
		local random_level = self._valid_levels_in_current_section[math.random(1, #self._valid_levels_in_current_section)]
		local level_postion = random_level.position

		wanted_position = NavQueries.position_on_mesh_guaranteed(self._nav_world, level_postion:unbox(), ABOVE, BELOW, traverse_logic, 20, 5)

		local distance, check_wanted_position = 0, wanted_position

		if check_wanted_position then
			distance = Vector3.distance(from_position, wanted_position)
		end

		tries = tries + 1
	until distance > 50 or tries >= MAX_TRIES

	if not wanted_position then
		return
	end

	GwNavAStar.start(self._astar, self._nav_world, from_position, wanted_position, traverse_logic)

	self._astar_data.target_unit = current_patrol_unit
	self._astar_data.patrol = selected_patrol
	self._astar_data.selected_patrol_index = selected_patrol_index
	self._astar_data.wanted_position = Vector3Box(wanted_position)
end

return MutatorExpeditionExtraTrickleHordes
