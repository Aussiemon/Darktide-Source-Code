-- chunkname: @scripts/extension_systems/minion_vortex/minion_vortex_extension.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local NavQueries = require("scripts/utilities/nav_queries")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local VortexLocomotion = require("scripts/extension_systems/locomotion/utilities/vortex_locomotion")
local FixedFrame = require("scripts/utilities/fixed_frame")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local MinionVortexExtension = class("MinionVortexExtension")
local STARTUP_VFX_NAME = "content/fx/particles/environment/expeditions/wastes/sand_tornado_01_startup"
local VFX_NAME = "content/fx/particles/environment/expeditions/wastes/sand_tornado_01"
local SFX_LOOP_NAME = "wwise/events/world/play_vortex_loop"
local SFX_LOOP_STOP_NAME = "wwise/events/world/stop_vortex_loop"
local VORTEX_GRABBED_BUFF_NAME = "vortex_grabbed"

local function _is_valid_vortex_target(character_state_component)
	local requires_help = PlayerUnitStatus.requires_help(character_state_component)
	local is_dead = PlayerUnitStatus.is_dead(character_state_component)

	return not requires_help and not is_dead
end

local function _is_player_near(valid_vortex_target, character_state_component, player_distance, outer_radius, height, minimum_height, vortex_height)
	local is_catapulted = PlayerUnitStatus.is_catapulted(character_state_component)
	local valid_height = minimum_height <= height and height < vortex_height

	return valid_vortex_target and not is_catapulted and player_distance < outer_radius and valid_height
end

MinionVortexExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local game_session = Managers.state.game_session:game_session()

	self._game_session = game_session
	self._game_object_id = Managers.state.unit_spawner:game_object_id(unit)

	local breed = extension_init_data.breed

	self._spawn_time = extension_init_data.spawn_time

	local vortex_template = breed.vortex_template

	self._vortex_template = vortex_template
	self._damage_buff_template = vortex_template.damage_buff_template
	self._nav_world = extension_init_context.nav_world
	self._physics_world = extension_init_context.physics_world
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._vortex_height = vortex_template.vortex_height
	self._inner_radius = vortex_template.inner_radius
	self._outer_radius = vortex_template.outer_radius

	local t = FixedFrame.get_latest_fixed_time()

	self._dissipate_t = t + vortex_template.lifetime
	self._adjacent_ai_units = {}
	self._ai_units_inside = {}
	self._player_units_inside = {}
	self._player_units_ejected = {}
	self._player_datas = {}
	self._catapult_queue = {}
	self._num_adjacent_ai_units = 0

	if self._is_server then
		local blackboard = BLACKBOARDS[unit]

		self:_init_blackboard_components(blackboard, extension_init_data)
	end

	self:_spawn_effects(t, unit)

	local vortex_grabbed_buff_template = BuffTemplates[VORTEX_GRABBED_BUFF_NAME]

	self._vortex_grabbed_max_stacks = vortex_grabbed_buff_template.max_stacks
	self._startup_t = t + vortex_template.startup_time
end

MinionVortexExtension._init_blackboard_components = function (self, blackboard, extension_init_data)
	local vortex_component = Blackboard.write_component(blackboard, "vortex")

	self._vortex_component = vortex_component

	local vortex_template = self._vortex_template

	vortex_component.wander_state = vortex_template.forced_standing_still and "forced_standing_still" or "recalc_path"
	vortex_component.num_players_inside = 0
	vortex_component.idle_time = 0
	vortex_component.wander_time = 0
	vortex_component.new_target_time = 0
	vortex_component.target_unit = extension_init_data.target_unit

	local nav_tag_allowed_layers = {
		bot_damage_drops = 0,
		bot_drops = 0,
		bot_jumps = 0,
		bot_ladders = 0,
		bot_leap_of_faith = 0,
		cover_ledges = 10,
		cover_vaults = 0,
		doors = 1.5,
		jumps = 10,
		ledges = 10,
		ledges_with_fence = 10,
		monster_walls = 0,
		teleporters = 5,
	}
	local nav_cost_map_multipliers = {}
	local traverse_logic, nav_tag_cost_table, nav_cost_map_multiplier_table = Navigation.create_traverse_logic(self._nav_world, nav_tag_allowed_layers, nav_cost_map_multipliers, false)

	self._traverse_logic, self._nav_tag_cost_table, self._nav_cost_map_multiplier_table = traverse_logic, nav_tag_cost_table, nav_cost_map_multiplier_table

	local unit = self._unit
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	self._traverse_logic = navigation_extension:traverse_logic()

	local catapult_nav_tag_allowed_layers = {
		bot_damage_drops = 0,
		bot_drops = 0,
		bot_jumps = 0,
		bot_ladders = 0,
		bot_leap_of_faith = 0,
		cover_ledges = 0,
		cover_vaults = 0,
		doors = 1,
		jumps = 0,
		ledges = 0,
		ledges_with_fence = 0,
		monster_walls = 0,
		teleporters = 0,
	}
	local catapult_traverse_logic, catapult_nav_tag_cost_table, catapult_cost_map_multiplier_table = Navigation.create_traverse_logic(self._nav_world, catapult_nav_tag_allowed_layers, nav_cost_map_multipliers, false)

	self._catapult_traverse_logic = catapult_traverse_logic
	self._catapult_nav_tag_cost_table = catapult_nav_tag_cost_table
	self._catapult_cost_map_multiplier_table = catapult_cost_map_multiplier_table
	self._catapult_astar = GwNavAStar.create(self._nav_world)
end

MinionVortexExtension.traverse_logic = function (self)
	return self._traverse_logic
end

MinionVortexExtension._game_world = function (self)
	local world_name = "level_world"
	local world = Managers.world:world(world_name)
	local wwise_world = Managers.world:wwise_world(world)

	return world, wwise_world
end

MinionVortexExtension.destroy = function (self)
	self:_destroy_effects()
end

MinionVortexExtension.game_object_initialized = function (self, session, object_id)
	self._game_session, self._game_object_id = session, object_id
end

MinionVortexExtension.get_position = function (self)
	return self._vfx_pos:unbox()
end

MinionVortexExtension.update = function (self, context, dt, t)
	local vortex_template = self._vortex_template
	local unit = self._unit
	local minion_position = self._vfx_pos:unbox()
	local inner_radius = vortex_template.inner_radius
	local outer_radius = vortex_template.outer_radius

	self:_update_player_data()
	self:_update_ai_units(unit, minion_position, outer_radius)
	self:_update_lifetime(t, unit)

	if not self:is_active() then
		return
	end

	if self._is_server then
		for player_unit, player_data in pairs(self._player_datas) do
			self:_update_movement_speed_debuffs(t, player_unit, vortex_template)
		end
	else
		local local_player = Managers.player:local_player(1)
		local local_player_unit = local_player.player_unit

		if local_player_unit then
			self:_update_movement_speed_debuffs(t, local_player_unit, vortex_template)
		end
	end

	self:_update_effect_positions(t, dt, vortex_template)

	if self._is_server then
		if t > vortex_template.windup_time then
			self:_attract(unit, t, dt, vortex_template, minion_position, inner_radius, outer_radius)
		end

		local damage_buff_template = self._damage_buff_template

		if damage_buff_template then
			self:_update_damage_calculation(damage_buff_template, outer_radius, inner_radius, dt, t)
		end

		self:_update_catapult_astar()
	end
end

MinionVortexExtension._update_player_data = function (self)
	local players = Managers.player:players()
	local player_datas = self._player_datas
	local new_datas = {}
	local debuff_radius = self._vortex_template.movement_speed_debuff_radius
	local vortex_position = self:get_position()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if ALIVE[player_unit] then
			local player_data = player_datas[player_unit] or {}

			player_data.buff_data = player_data.buff_data or {}
			player_data.buff_extension = player_data.buff_extension or ScriptUnit.has_extension(player_unit, "buff_system")
			player_data.unit_data_extension = player_data.unit_data_extension or ScriptUnit.has_extension(player_unit, "unit_data_system")
			player_data.locomotion_extension = player_data.locomotion_extension or ScriptUnit.has_extension(player_unit, "locomotion_system")
			player_data.position = Unit.local_position(player_unit, 1)
			player_data.player_unit = player_unit

			local distance = Vector3.distance(Vector3.flat(player_data.position), Vector3.flat(vortex_position))

			player_data.in_range_of_vortex = distance < debuff_radius
			new_datas[player_unit] = player_data
		elseif player_datas[player_unit] then
			table.clear(player_datas[player_unit])
		end
	end

	self._player_datas = new_datas
end

local function _broadphase_query(unit, position, radius, query_results)
	local extension_manager = Managers.state.extension
	local broadphase_system = extension_manager:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side = ScriptUnit.extension(unit, "side_system").side
	local relation_side_names = side:relation_side_names("allied")
	local num_hits = Broadphase.query(broadphase, position, radius, query_results, relation_side_names)

	return num_hits
end

MinionVortexExtension._update_ai_units = function (self, unit, center_pos, outer_radius)
	self._num_adjacent_ai_units = _broadphase_query(unit, center_pos, outer_radius, self._adjacent_ai_units)
end

MinionVortexExtension._update_damage_calculation = function (self, damage_buff_template, outer_radius, inner_radius, dt, t)
	local position = self:get_position()
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if ALIVE[player_unit] then
			local player_position = Unit.local_position(player_unit, 1)
			local flattened_player_position = Vector3(player_position.x, player_position.y, 0)
			local flattened_vortex_position = Vector3(position.x, position.y, 0)
			local distance = Vector3.distance(flattened_vortex_position, flattened_player_position)
			local z_approved = player_position.z >= position.z and player_position.z - position.z <= self._vortex_height

			if distance < inner_radius and z_approved then
				local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

				if not buff_extension:has_keyword("corrupted") then
					buff_extension:add_internally_controlled_buff(damage_buff_template, t)
					buff_extension:_update_stat_buffs_and_keywords(t)
				end
			end
		end
	end
end

MinionVortexExtension._attract = function (self, unit, t, dt, vortex_template, center_pos, inner_radius, outer_radius)
	local minimum_height = -vortex_template.vortex_height / 2
	local blackboard = BLACKBOARDS[unit]
	local falloff_radius = outer_radius - inner_radius
	local max_allowed_inner_radius_dist = vortex_template.max_allowed_inner_radius_dist
	local allowed_distance = inner_radius + max_allowed_inner_radius_dist

	if vortex_template.player_attractable then
		self:_update_attract_players(unit, blackboard, vortex_template, t, dt, center_pos, minimum_height, inner_radius, outer_radius, falloff_radius, allowed_distance)
	end

	if vortex_template.ai_attractable then
		self:_update_attract_outside_ai(unit, blackboard, vortex_template, center_pos, minimum_height, inner_radius, outer_radius, falloff_radius)
		self:_update_attract_inside_ai(blackboard, vortex_template, dt, t, center_pos, inner_radius, allowed_distance)
	end
end

local NUM_SEGMENTS = 4
local LAND_TEST_ABOVE, LAND_TEST_BELOW = 15, 15
local EJECT_SEGMENT_LIST = Script.new_array(NUM_SEGMENTS)

MinionVortexExtension._update_attract_players = function (self, unit, blackboard, vortex_template, t, dt, center_pos, minimum_height, inner_radius, outer_radius, falloff_radius, allowed_distance)
	local player_manager = Managers.player
	local players = player_manager:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit
		local player_data = self._player_datas[player_unit]

		if player_data then
			self:_update_attract_player(unit, player_data, blackboard, vortex_template, t, dt, center_pos, minimum_height, inner_radius, outer_radius, falloff_radius, allowed_distance)
		end
	end
end

MinionVortexExtension._update_attract_player = function (self, vortex_unit, player_data, blackboard, vortex_template, t, dt, center_pos, minimum_height, inner_radius, outer_radius, falloff_radius, allowed_distance)
	local players_inside = self._player_units_inside
	local players_ejected = self._player_units_ejected
	local player_unit = player_data.player_unit
	local vortex_height = vortex_template.vortex_height
	local player_position = player_data.position
	local unit_data_extension = player_data.unit_data_extension
	local character_state_component = unit_data_extension:read_component("character_state")
	local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
	local suck_dir = center_pos - player_position
	local height = -suck_dir.z

	Vector3.set_z(suck_dir, 0)

	local player_distance = Vector3.length(suck_dir)
	local is_valid_vortex_target = _is_valid_vortex_target(character_state_component)
	local is_near = _is_player_near(is_valid_vortex_target, character_state_component, player_distance, outer_radius, height, minimum_height, vortex_height)

	if players_inside[player_unit] then
		self:_process_player_inside(t, player_data, disabled_character_state_component, vortex_template, is_valid_vortex_target, player_distance, allowed_distance, height, vortex_height, player_position)
	elseif players_ejected[player_unit] then
		self:_process_player_ejected(t, player_unit, disabled_character_state_component, vortex_template, outer_radius, player_distance)
	elseif is_near then
		self:_process_near_player(t, dt, vortex_unit, vortex_template, player_data, disabled_character_state_component, player_distance, inner_radius, outer_radius, falloff_radius, suck_dir)
	end
end

MinionVortexExtension._update_movement_speed_debuffs = function (self, t, player_unit, vortex_template)
	local debuff_name = self._vortex_template.movement_speed_debuff_name
	local player_data = self._player_datas[player_unit]
	local buff_ext = player_data.buff_extension
	local buffs = player_data.buff_data
	local current_stacks = #buffs
	local unit_data_extension = player_data.unit_data_extension
	local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
	local in_range = player_data.in_range_of_vortex
	local has_debuff = current_stacks > 0
	local vortex_grabbed = PlayerUnitStatus.is_vortex_grabbed(disabled_character_state_component)

	if not in_range and has_debuff or vortex_grabbed and has_debuff then
		-- Nothing
	elseif in_range and not has_debuff then
		buff_ext:add_internally_controlled_buff(debuff_name, t, "owner_unit", self._unit)
	end
end

MinionVortexExtension._remove_move_speed_debuffs = function (self, player_unit)
	local player_data = self._player_datas[player_unit]

	if not player_data then
		return
	end

	local buff_ext = player_data.buff_extension

	if not buff_ext then
		return
	end

	local buffs = player_data.buff_data

	for i = 1, #buffs do
		local buff = buffs[i]

		buff_ext:remove_externally_controlled_buff(buff.buff_index, buff.component_index)
	end

	table.clear(player_data.buff_data)
end

MinionVortexExtension._process_player_ejected = function (self, t, player_unit, disabled_character_state_component, vortex_template, outer_radius, player_distance, bliss_time)
	local players_ejected = self._player_units_ejected

	if bliss_time < 0 and not PlayerUnitStatus.is_vortex_grabbed(disabled_character_state_component) then
		if player_distance < outer_radius then
			local edge_distance = outer_radius - player_distance
			local time_multiplier = edge_distance / outer_radius

			players_ejected[player_unit] = t + 0.5 + vortex_template.player_ejected_bliss_time * 0.5 + vortex_template.player_ejected_bliss_time * time_multiplier * 0.5
		else
			players_ejected[player_unit] = t + 0.5 + vortex_template.player_ejected_bliss_time
		end
	elseif bliss_time < t then
		players_ejected[player_unit] = nil
	end
end

MinionVortexExtension._process_near_player = function (self, t, dt, vortex_unit, vortex_template, player_data, disabled_character_state_component, player_distance, inner_radius, outer_radius, falloff_radius, suck_dir)
	local is_vortex_grabbed = PlayerUnitStatus.is_vortex_grabbed(disabled_character_state_component)

	if self:_is_vortex_immune(player_data) then
		return
	end

	if inner_radius < player_distance then
		local player_attract_speed = vortex_template.player_attract_speed
		local distance_to_inner_radius = player_distance - inner_radius
		local alpha = math.clamp01(1 - distance_to_inner_radius / falloff_radius)
		local speed = player_attract_speed * alpha * dt
		local dir = Vector3.normalize(suck_dir)
		local locomotion_push_component = player_data.unit_data_extension:write_component("locomotion_push")

		locomotion_push_component.new_velocity = dir * speed
	elseif not is_vortex_grabbed then
		self:_vortex_grab(t, vortex_unit, vortex_template, player_data)
	end
end

MinionVortexExtension._process_player_inside = function (self, t, player_data, disabled_character_state_component, vortex_template, valid_vortex_target, player_distance, allowed_distance, height, vortex_height, player_position)
	local player_unit = player_data.player_unit
	local players_inside = self._player_units_inside
	local vortex_eject_height = players_inside[player_unit].vortex_eject_height
	local vortex_eject_time = players_inside[player_unit].vortex_eject_time
	local release_player = not valid_vortex_target or allowed_distance < player_distance
	local catapult_player = vortex_eject_height < height or vortex_height < height or vortex_eject_time < t
	local unit_data_extension = player_data.unit_data_extension
	local disabled_state_input = unit_data_extension:write_component("disabled_state_input")

	if release_player then
		self:_release_player(player_data, disabled_state_input)
	elseif catapult_player then
		self:_try_catapult_player(vortex_template, player_data, disabled_state_input)
	end
end

MinionVortexExtension._try_catapult_player = function (self, vortex_template, player_data, disabled_state_input)
	local player_unit = player_data.player_unit

	if self._catapult_queue[player_unit] then
		return
	end

	local locomotion_extension = player_data.locomotion_extension
	local player_position = player_data.position
	local player_gravity = PlayerCharacterConstants.gravity
	local player_collision_filter = "filter_player_mover"
	local player_eject_speed = vortex_template.player_eject_speed
	local current_velocity = locomotion_extension:current_velocity()
	local velocity_normalized = Vector3.normalize(current_velocity)
	local eject_distance = vortex_template.player_eject_distance
	local landing_pos = player_position + velocity_normalized * eject_distance
	local epsilon_up = Vector3.up() * 0.05
	local wanted_landing_position = NavQueries.position_on_mesh(self._nav_world, landing_pos, LAND_TEST_ABOVE, LAND_TEST_BELOW)

	if wanted_landing_position and not self._catapult_queue[player_unit] then
		local success, velocity = VortexLocomotion.test_angled_trajectory(self._physics_world, player_position, wanted_landing_position + epsilon_up, -player_gravity, player_eject_speed, nil, EJECT_SEGMENT_LIST, NUM_SEGMENTS, player_collision_filter)

		if success then
			player_data.wanted_catapult_velocity = Vector3Box(velocity)
			player_data.wanted_landing_position = Vector3Box(wanted_landing_position)

			local idx = #self._catapult_queue + 1

			self._catapult_queue[idx] = player_unit
			self._catapult_queue[player_unit] = idx
		end
	end
end

MinionVortexExtension._pop_catapult_astar_queue = function (self)
	local unit = self._catapult_queue[1]

	if unit and self._catapult_queue[unit] then
		self._catapult_queue[unit] = nil
	end

	table.remove(self._catapult_queue, 1)

	if self._processing_catapult_astar and not GwNavAStar.processing_finished(self._catapult_astar) then
		GwNavAStar.cancel(self._catapult_astar)

		self._processing_catapult_astar = false
	end
end

MinionVortexExtension._process_catapult_astar = function (self, player_unit, player_data)
	local alive = HEALTH_ALIVE[player_unit]
	local done, found_path = self:_found_path()
	local unit_data_extension = player_data.unit_data_extension
	local disabled_state_input = unit_data_extension:write_component("disabled_state_input")
	local velocity = player_data.wanted_catapult_velocity:unbox()

	if done then
		self:_release_player(player_data, disabled_state_input)
	end

	if found_path and alive then
		local catapulted_state_input = player_data.unit_data_extension:write_component("catapulted_state_input")

		disabled_state_input.wants_disable = false
		disabled_state_input.disabling_type = "none"

		Catapulted.apply(catapulted_state_input, velocity)
	end
end

MinionVortexExtension._start_catapult_astar = function (self)
	local player_unit = self._catapult_queue[1]
	local player_data = self._player_datas[player_unit]
	local wanted_landing_position = player_data and player_data.wanted_landing_position

	if not player_unit or not player_data or not wanted_landing_position then
		self:_pop_catapult_astar_queue()
	else
		GwNavAStar.start(self._catapult_astar, self._nav_world, self:get_position(), wanted_landing_position:unbox(), self._catapult_traverse_logic)

		self._processing_catapult_astar = true
	end
end

MinionVortexExtension._found_path = function (self)
	local done = GwNavAStar.processing_finished(self._catapult_astar)
	local path_found = false

	if done then
		path_found = GwNavAStar.path_found(self._catapult_astar)
		self._processing_catapult_astar = false
	end

	return done, path_found
end

MinionVortexExtension._update_catapult_astar = function (self)
	if table.is_empty(self._catapult_queue) then
		return
	end

	local player_unit = self._catapult_queue[1]
	local player_data = self._player_datas[player_unit]

	if not player_unit or not player_data or not ALIVE[player_unit] then
		self:_pop_catapult_astar_queue()
	elseif self._processing_catapult_astar then
		self:_process_catapult_astar(player_unit, player_data)
	end

	if not self._processing_catapult_astar and not table.is_empty(self._catapult_queue) then
		self:_start_catapult_astar()
	end
end

MinionVortexExtension._release_player = function (self, player_data, disabled_state_input)
	local player_unit = player_data.player_unit

	self._player_units_inside[player_unit] = nil
	self._vortex_component.num_players_inside = self._vortex_component.num_players_inside - 1
	disabled_state_input.disabling_unit = nil
	player_data.wanted_catapult_velocity = nil
	player_data.wanted_landing_position = nil

	local catapult_queue_idx = self._catapult_queue[player_unit]

	if catapult_queue_idx then
		if catapult_queue_idx == 1 then
			self:_pop_catapult_astar_queue()
		else
			table.remove(self._catapult_queue, catapult_queue_idx)

			self._catapult_queue[player_unit] = nil
		end
	end
end

MinionVortexExtension._vortex_grab = function (self, t, vortex_unit, vortex_template, player_data)
	local unit_data_extension = player_data.unit_data_extension
	local disabled_state_input = unit_data_extension:write_component("disabled_state_input")
	local buff_ext = player_data.buff_extension

	if self:_is_vortex_immune(player_data) then
		return
	elseif buff_ext then
		buff_ext:add_internally_controlled_buff(VORTEX_GRABBED_BUFF_NAME, t)
	end

	disabled_state_input.wants_disable = true
	disabled_state_input.disabling_unit = vortex_unit
	disabled_state_input.disabling_type = "vortex_grabbed"

	local vortex_eject_height = vortex_template.player_eject_height

	self._player_units_inside[player_data.player_unit] = {
		vortex_eject_height = vortex_eject_height,
		vortex_eject_time = t + vortex_template.player_in_vortex_max_duration,
	}
	self._vortex_component.num_players_inside = self._vortex_component.num_players_inside + 1
end

MinionVortexExtension._update_attract_outside_ai = function (self, unit, blackboard, vortex_template, center_pos, minimum_height, inner_radius, outer_radius, falloff_radius)
	local vortex_height = vortex_template.vortex_height
	local ai_attract_speed = vortex_template.ai_attract_speed
	local ai_units_inside = self._ai_units_inside

	for i = 1, self._num_adjacent_ai_units do
		local ai_unit = self._adjacent_ai_units[i]

		if not ai_units_inside[ai_unit] then
			local target_blackboard = BLACKBOARDS[ai_unit]
			local breed = Breed.unit_breed_or_nil(ai_unit)

			if breed.vortex_settings then
				local locomotion_extension = ScriptUnit.extension(ai_unit, "locomotion_system")
				local is_alive = HEALTH_ALIVE[ai_unit]

				if locomotion_extension and is_alive then
					local unit_position = POSITION_LOOKUP[ai_unit]
					local suck_dir = center_pos - unit_position
					local height = -suck_dir.z

					Vector3.set_z(suck_dir, 0)

					if minimum_height <= height and height < vortex_height then
						local ai_distance = Vector3.length(suck_dir)

						if inner_radius < ai_distance then
							local distance_to_inner_radius = ai_distance - inner_radius
							local k = math.clamp(1 - distance_to_inner_radius / falloff_radius, 0, 1)
							local speed = ai_attract_speed * k * k
							local dir = Vector3.normalize(suck_dir)
							local velocity = dir * speed

							locomotion_extension:set_external_velocity(velocity)
						else
							local vortex_grabbed_component = Blackboard.write_component(target_blackboard, "vortex_grabbed")

							vortex_grabbed_component.in_vortex_state = "in_vortex_init"
							vortex_grabbed_component.in_vortex = true

							locomotion_extension:set_movement_type("script_driven")

							vortex_grabbed_component.eject_height = vortex_template.ai_eject_height[1]
							ai_units_inside[ai_unit] = true

							if vortex_template.suck_in_ai_func then
								vortex_template:suck_in_ai_func(target_blackboard)
							end
						end
					end
				end
			end
		end

		if ai_units_inside[ai_unit] then
			local target_blackboard = BLACKBOARDS[ai_unit]
			local vortex_grabbed_component = Blackboard.write_component(target_blackboard, "vortex_grabbed")
			local has_landed = vortex_grabbed_component.landing_finished

			if has_landed then
				ai_units_inside[ai_unit] = nil
			end
		end
	end
end

MinionVortexExtension._update_attract_inside_ai = function (self, blackboard, vortex_template, dt, t, center_pos, inner_radius, allowed_distance)
	local ai_rotation_speed = vortex_template.ai_rotation_speed
	local ai_radius_change_speed = vortex_template.ai_radius_change_speed
	local ai_ascension_speed = vortex_template.ai_ascension_speed
	local vortex_height = vortex_template.vortex_height
	local ai_units_inside = self._ai_units_inside

	for ai_unit, _ in pairs(ai_units_inside) do
		local is_alive = HEALTH_ALIVE[ai_unit]

		if is_alive then
			local target_blackboard = BLACKBOARDS[ai_unit]
			local vortex_grabbed_component = target_blackboard.vortex_grabbed
			local in_vortex_state = vortex_grabbed_component.in_vortex_state

			if in_vortex_state == "in_vortex" then
				local unit_position = Unit.local_position(ai_unit, 1)
				local height_difference = unit_position.z - center_pos.z
				local pivot_offset_x, pivot_offset_y = VortexLocomotion.pivot_offset_by_height(vortex_template, height_difference, t)

				center_pos.x = center_pos.x + pivot_offset_x
				center_pos.y = center_pos.y + pivot_offset_y

				local wanted_inner_radius = inner_radius
				local velocity, new_radius, new_height = VortexLocomotion.get_vortex_spin_velocity(unit_position, center_pos, wanted_inner_radius, Vector3.up(), ai_rotation_speed, ai_radius_change_speed, ai_ascension_speed, dt)
				local locomotion_extension = ScriptUnit.extension(ai_unit, "locomotion_system")

				locomotion_extension:set_wanted_velocity(velocity)

				if new_height > vortex_grabbed_component.eject_height or vortex_height < new_height or allowed_distance < new_radius then
					local vortex_grabbed_component_write = Blackboard.write_component(target_blackboard, "vortex_grabbed")
					local ejected_from_vortex = vortex_grabbed_component_write.ejected_from_vortex or Vector3Box()

					ejected_from_vortex:store(velocity)

					vortex_grabbed_component_write.in_vortex_state = "ejected_from_vortex"

					locomotion_extension:set_affected_by_gravity(true)
					locomotion_extension:set_movement_type("constrained_by_mover")
				end
			elseif in_vortex_state == "landed" or in_vortex_state == "" then
				ai_units_inside[ai_unit] = nil
			end
		else
			ai_units_inside[ai_unit] = nil
		end
	end
end

MinionVortexExtension._is_vortex_immune = function (self, player_data)
	local buff_ext = player_data and player_data.buff_extension
	local current_stacks = buff_ext and buff_ext:current_stacks(VORTEX_GRABBED_BUFF_NAME) or 0

	return current_stacks >= self._vortex_grabbed_max_stacks
end

MinionVortexExtension._spawn_effects = function (self, t, unit)
	local world, wwise_world = self:_game_world()
	local vfx_pos = POSITION_LOOKUP[self._unit]

	self._vfx_pos = Vector3Box(vfx_pos)
	self._vfx_velocity = Vector3Box(Vector3.forward())

	World.create_particles(world, STARTUP_VFX_NAME, vfx_pos)

	self._sfx_source_id = WwiseWorld.make_manual_source(wwise_world, unit, 1)
	self._sfx_id = WwiseWorld.trigger_resource_event(wwise_world, SFX_LOOP_NAME, self._sfx_source_id)
end

MinionVortexExtension._destroy_effects = function (self)
	local world, wwise_world = self:_game_world()

	if self._vfx_id then
		World.destroy_particles(world, self._vfx_id)

		self._vfx_id = nil
	end

	if self._sfx_id then
		WwiseWorld.stop_event(wwise_world, self._sfx_id)
		WwiseWorld.destroy_manual_source(wwise_world, self._sfx_source_id)

		self._sfx_source_id = nil
	end
end

MinionVortexExtension._update_effect_positions = function (self, t, dt, vortex_template)
	local world = self:_game_world()
	local unit_pos = Unit.local_position(self._unit, 1)
	local vfx_pos = self._vfx_pos:unbox()

	if not self._vfx_id then
		self._vfx_id = World.create_particles(world, VFX_NAME, vfx_pos)
	end

	local effect_id = self._vfx_id
	local proceed = effect_id and HEALTH_ALIVE[self._unit]

	if not proceed then
		return
	end

	local follow_speed = vortex_template.vfx_follow_speed
	local alpha = math.clamp(follow_speed * dt, 0, 1)
	local vfx_offset = Vector3(0, 0, vortex_template.vfx_ground_offset)
	local new_pos = Vector3.lerp(vfx_pos, unit_pos, alpha)
	local offset_pos = new_pos + vfx_offset

	self._vfx_pos = Vector3Box(new_pos)

	World.move_particles(world, effect_id, offset_pos)
end

MinionVortexExtension.vfx_pos = function (self)
	return self._vfx_pos
end

local DISSIPATION_TIME = 10

MinionVortexExtension._update_lifetime = function (self, t, unit)
	local players_in_range = 0

	for _, data in pairs(self._player_datas) do
		local in_range = data.in_range_of_vortex

		players_in_range = in_range and players_in_range + 1 or players_in_range
	end

	if self._startup_t and t > self._startup_t then
		self._startup_t = nil
	end

	if self._lifetime_end then
		self:_dissipate(t, unit)
	elseif players_in_range ~= 0 or self._num_adjacent_ai_units ~= 1 then
		-- Nothing
	elseif t < self._dissipate_t then
		-- Nothing
	elseif not self._lifetime_end then
		self._dissipate_t = t
		self._lifetime_end = t + DISSIPATION_TIME

		local world, wwise_world = self:_game_world()

		if self._sfx_id then
			WwiseWorld.stop_event(wwise_world, self._sfx_id)
			WwiseWorld.trigger_resource_event(wwise_world, SFX_LOOP_STOP_NAME, self._sfx_source_id)

			self._sfx_id = nil
		end
	end
end

local VFX_VARIABLE_DATA = {
	radius_body = {
		speed_multiplier = 1,
		default = Vector3Box(0.5, 1.8, 0),
		fully_dissipated = Vector3Box(0, 0.2, 0),
	},
	radius_ground = {
		speed_multiplier = 1,
		default = Vector3Box(3, 8, 0),
		fully_dissipated = Vector3Box(0, 2, 0),
	},
	spiral_speed = {
		speed_multiplier = 1,
		default = Vector3Box(1, 0, 0),
		fully_dissipated = Vector3Box(0, 0, 0),
	},
	spiral_rotation = {
		speed_multiplier = 1,
		default = Vector3Box(1, 0, 0),
		fully_dissipated = Vector3Box(0, 0, 0),
	},
	velocity = {
		speed_multiplier = 1.5,
		default = Vector3Box(1, 1, 1),
		fully_dissipated = Vector3Box(0, 0, 0),
	},
}

KILL_PARTICLE_EMIT_AT_PROGRESS = 0.3

MinionVortexExtension._dissipate = function (self, t, unit)
	local world = self:_game_world()
	local alpha = 1 - math.ilerp(self._dissipate_t, self._lifetime_end, t)

	if self._vfx_id then
		for var_name, data in pairs(VFX_VARIABLE_DATA) do
			local default_val = data.default:unbox()
			local fully_dissipated_val = data.fully_dissipated:unbox()
			local progress = math.clamp01(alpha * data.speed_multiplier)
			local v = Vector3.lerp(fully_dissipated_val, default_val, progress)
			local length_variable_index = World.find_particles_variable(world, VFX_NAME, var_name)

			World.set_particles_variable(world, self._vfx_id, length_variable_index, v)
		end

		if alpha < KILL_PARTICLE_EMIT_AT_PROGRESS then
			World.set_particles_emit_rate_multiplier(world, self._vfx_id, 0)
		end
	end

	if self._is_server and t > self._lifetime_end and unit and ALIVE[unit] then
		local minion_spawn_manager = Managers.state.minion_spawn
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

		navigation_extension:stop()
		minion_spawn_manager:despawn_minion(unit)
	end
end

MinionVortexExtension.is_active = function (self)
	if self._lifetime_end then
		return false
	elseif self._startup_t then
		return false
	else
		return true
	end
end

return MinionVortexExtension
