local Component = require("scripts/utilities/component")
local Interactions = require("scripts/settings/interaction/interactions")
local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local InteractionTemplates = require("scripts/settings/interaction/interaction_templates")
local Vo = require("scripts/utilities/vo")
local InteractorExtension = class("InteractorExtension")
local interaction_duration_buffs = InteractionSettings.duration_buffs
local interaction_results = InteractionSettings.results
local interaction_speed_buffs = InteractionSettings.speed_buffs
local interaction_states = InteractionSettings.states
local MAX_INTERACTION_DISTANCE = InteractionSettings.max_interaction_distance
local MAX_INTERACTION_COS_ANGLE = math.cos(InteractionSettings.max_interaction_angle)
local ONGOING_INTERACTION_LEEWAY = InteractionSettings.ongoing_interaction_leeway
local INTERACTABLE_FILTER = "filter_player_character_interactable_overlap"
local LINE_OF_SIGHT_FILTER = "filter_player_character_interactable_line_of_sight_check"
local _distance_to_actor = nil

InteractorExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data, ...)
	local world = extension_init_context.world
	self._is_server = extension_init_context.is_server
	self._world = world
	self._unit = unit
	self._player = extension_init_data.player
	self._physics_world = extension_init_context.physics_world
	self._input_extension = ScriptUnit.extension(unit, "input_system")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._show_interaction_ui = false
	self._show_counter_ui = false
	self._bot_interaction_type = nil
	self._bot_interaction_actor_index = 0
	self._bot_interaction_unit = nil
	self._interaction_objects = {}
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._unit_data_extension = unit_data_extension

	self:_init_action_components(unit_data_extension)
end

InteractorExtension.destroy = function (self)
	if self._is_server then
		local interaction_component = self._interaction_component
		local state = interaction_component.state
		local target_unit = interaction_component.target_unit

		if state == interaction_states.is_interacting and ALIVE[target_unit] then
			local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")

			interactee_extension:stopped(interaction_results.interaction_cancelled)
		end
	end
end

InteractorExtension._init_action_components = function (self, unit_data_extension)
	self._interaction_component = unit_data_extension:write_component("interaction")
	self._first_person_component = unit_data_extension:read_component("first_person")

	self:_reset_interaction()
end

InteractorExtension._reset_interaction = function (self)
	local interaction_component = self._interaction_component
	interaction_component.target_unit = nil
	interaction_component.target_actor_node_index = 0
	interaction_component.type = "default"
	interaction_component.state = interaction_states.waiting_to_interact
	interaction_component.duration = 0
	interaction_component.start_time = 0
	interaction_component.done_time = 0
	self._focus_unit = nil
	self._focus_actor_node_index = 0
end

InteractorExtension.set_bot_interaction_unit = function (self, target_unit, target_actor, interaction_type)
	local player = self._player

	if target_unit then
		local has_interactee_extension = ScriptUnit.has_extension(target_unit, "interactee_system")
	end

	self._bot_interaction_unit = target_unit
	self._bot_interaction_actor_index = 0

	if target_actor then
		local _, target_actor_node_index = Actor.unit(target_actor)
		self._bot_interaction_actor_index = target_actor_node_index
	end

	self._bot_interaction_type = interaction_type
end

InteractorExtension.calculate_duration_buff = function (self, interactee_extension)
	local interaction_type = interactee_extension:interaction_type()
	local buff_stat_name = interaction_duration_buffs[interaction_type]
	local buff_extension = self._buff_extension

	if not buff_stat_name or not buff_extension then
		return 1
	end

	local stat_buffs = buff_extension:stat_buffs()
	local buff_mod = stat_buffs[buff_stat_name]

	return buff_mod
end

InteractorExtension.calculate_speed_buff = function (self, interactee_extension)
	local interaction_type = interactee_extension:interaction_type()
	local buff_stat_name = interaction_speed_buffs[interaction_type]
	local buff_extension = self._buff_extension

	if not buff_stat_name or not buff_extension then
		return 1
	end

	local stat_buffs = buff_extension:stat_buffs()
	local buff_mod = stat_buffs[buff_stat_name]

	return buff_mod
end

InteractorExtension.calculate_duration = function (self, interactee_extension)
	local interaction_duration = interactee_extension:interaction_length()
	local buff_mod = self:calculate_duration_buff(interactee_extension)
	local duration = interaction_duration * buff_mod
	local speed_buff_mod = self:calculate_speed_buff(interactee_extension)
	duration = duration / speed_buff_mod

	return duration
end

InteractorExtension.fixed_update = function (self, unit, dt, t, fixed_frame, context)
	local chosen_target = nil
	local chosen_target_actor_node_index = 0
	local focus_target = nil
	local focus_target_actor_node_index = 0
	local interaction_component = self._interaction_component
	local state = interaction_component.state

	if state == interaction_states.waiting_to_interact then
		if self._unit_data_extension.is_resimulating and fixed_frame < context.resimulate_to_frame then
			return
		end

		local player = self._player

		if player:is_human_controlled() then
			chosen_target, chosen_target_actor_node_index, focus_target, focus_target_actor_node_index = self:_find_reachable_object(unit)
		else
			local bot_interaction_unit = self._bot_interaction_unit
			local bot_interaction_type = self._bot_interaction_type

			if ALIVE[bot_interaction_unit] and self:_can_interact(bot_interaction_unit, bot_interaction_type) then
				chosen_target_actor_node_index = self._bot_interaction_actor_index
				chosen_target = bot_interaction_unit
			end
		end
	end

	if chosen_target and chosen_target ~= interaction_component.target_unit then
		local interactee_extension = ScriptUnit.extension(chosen_target, "interactee_system")
		local interaction_type = interactee_extension:interaction_type()
		local interaction_duration = self:calculate_duration(interactee_extension)

		self:_reset_interaction()

		interaction_component.type = interaction_type
		interaction_component.target_unit = chosen_target
		interaction_component.target_actor_node_index = chosen_target_actor_node_index
		interaction_component.duration = interaction_duration
	elseif chosen_target and chosen_target_actor_node_index ~= interaction_component.target_actor_node_index then
		interaction_component.target_actor_node_index = chosen_target_actor_node_index
	elseif not chosen_target and chosen_target ~= interaction_component.target_unit and state == interaction_states.waiting_to_interact then
		self:_reset_interaction()
	elseif chosen_target and chosen_target == interaction_component.target_unit then
		local interactee_extension = ScriptUnit.extension(chosen_target, "interactee_system")
		local interaction_duration = self:calculate_duration(interactee_extension)
		interaction_component.duration = interaction_duration
	end

	if not self._unit_data_extension.is_resimulating then
		if focus_target and ScriptUnit.has_extension(focus_target, "interactee_system") then
			self._focus_unit = focus_target
			self._focus_actor_node_index = focus_target_actor_node_index
		else
			self._focus_unit = nil
			self._focus_actor_node_index = 0
		end
	end

	if state ~= interaction_states.none then
		self:_check_current_state(unit, dt, t, chosen_target, state)

		local ready_to_interact = chosen_target and state == interaction_states.waiting_to_interact
		self._show_interaction_ui = ready_to_interact
		self._show_counter_ui = state == interaction_states.is_interacting
	end
end

InteractorExtension._check_current_state = function (self, unit, dt, t, chosen_target, state)
	local input_extension = self._input_extension
	local world = self._world
	local is_server = self._is_server

	if chosen_target and state == interaction_states.waiting_to_interact then
		local interaction_button_pressed = input_extension:get("interact_pressed")

		if interaction_button_pressed then
			local interaction_component = self._interaction_component
			local interaction_type = interaction_component.type
			local interaction = self:interaction()

			interaction:start(world, unit, interaction_component, t, is_server)

			local target_unit = interaction_component.target_unit
			local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")

			Vo.interaction_start_event(unit, target_unit, interaction:type())
			self:_start_interaction_timer(t)
			interactee_extension:started(unit)

			if is_server then
				Component.event(target_unit, "interaction_started", interaction_type, unit)
			end

			state = interaction_states.is_interacting
			interaction_component.state = state
		end
	end

	if state == interaction_states.is_interacting then
		local interaction_component = self._interaction_component
		local interaction = self:interaction()
		local target_unit = interaction_component.target_unit
		local target_node = interaction_component.target_actor_node_index

		if target_unit then
			local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
			local hold_required = interactee_extension:hold_required()
			local ui_interaction = interactee_extension.ui_interaction and interactee_extension:ui_interaction()
			local holding = input_extension:get("interact_hold")
			local can_interact = self:_check_valid_ongoing_interaction(target_unit, target_node)
			local interaction_result = nil

			if hold_required and not holding then
				interaction_result = interaction_results.stopped_holding
			elseif ui_interaction then
				if input_extension:get("finished_interaction") then
					interaction_result = interaction_results.success
				else
					interaction_result = interaction_results.ongoing
				end
			elseif not can_interact then
				interaction_result = interaction_results.interaction_cancelled
			elseif interaction_component.done_time <= t then
				interaction_result = interaction_results.success
			else
				interaction_result = interaction_results.ongoing
			end

			if interaction_result ~= interaction_results.ongoing then
				interaction:stop(world, unit, interaction_component, t, interaction_result, is_server)
				self:_reset_interaction()

				if is_server then
					interactee_extension:stopped(interaction_result)

					local interaction_type = interaction_component.type

					if interaction_result == interaction_results.success then
						Component.event(target_unit, "interaction_success", interaction_type, unit)
					else
						Component.event(target_unit, "interaction_canceled", interaction_type, unit)
					end
				end
			end
		else
			local interaction_result = interaction_results.interaction_cancelled

			interaction:stop(world, unit, interaction_component, t, interaction_result, is_server)
			self:_reset_interaction()
		end
	end
end

InteractorExtension.cancel_interaction = function (self, t)
	if self:is_interacting() then
		local unit = self._unit
		local interaction = self:interaction()
		local world = self._world
		local is_server = self._is_server
		local interaction_component = self._interaction_component
		local interaction_result = interaction_results.interaction_cancelled
		local target_unit = interaction_component.target_unit

		if target_unit then
			local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")

			interactee_extension:stopped(interaction_result)
		end

		if is_server then
			local interaction_type = interaction_component.type

			Component.event(target_unit, "interaction_canceled", interaction_type, unit)
		end

		interaction:stop(world, unit, interaction_component, t, interaction_result, is_server)
		self:_reset_interaction()
	end
end

InteractorExtension._start_interaction_timer = function (self, t)
	local interaction_component = self._interaction_component
	interaction_component.start_time = t
	interaction_component.done_time = t + interaction_component.duration
end

local INDEX_DISTANCE = 2
local INDEX_ACTOR = 4

InteractorExtension._find_reachable_object = function (self, interactor_unit)
	local first_person_component = self._first_person_component
	local look_pos = first_person_component.position
	local look_rot = first_person_component.rotation
	local look_forward = Quaternion.forward(look_rot)
	local focus_target = nil
	local focus_target_actor_node_index = 0
	local chosen_target = nil
	local chosen_target_actor_node_index = 0
	local physics_world = self._physics_world
	local max_interact_distance = MAX_INTERACTION_DISTANCE
	local hits, _ = PhysicsWorld.raycast(physics_world, look_pos, look_forward, max_interact_distance, "all", "collision_filter", INTERACTABLE_FILTER)
	local ALIVE = ALIVE

	if hits then
		local los_distance = nil

		for hit_idx = 1, #hits do
			local hit = hits[hit_idx]
			local hit_actor = hit[INDEX_ACTOR]
			local target_unit, target_actor_node_index = Actor.unit(hit_actor)

			if hit_actor and target_unit ~= interactor_unit and ALIVE[target_unit] then
				local hit_distance = hit[INDEX_DISTANCE]

				if not los_distance then
					local los_hit, _, los_dist, _ = PhysicsWorld.raycast(physics_world, look_pos, look_forward, max_interact_distance, "closest", "collision_filter", LINE_OF_SIGHT_FILTER)
					los_distance = los_hit and los_dist or math.huge
				end

				if los_distance and hit_distance <= los_distance then
					local can_interact, has_interaction_extension = self:_check_valid_interaction_target(target_unit)

					if can_interact then
						chosen_target = target_unit
						chosen_target_actor_node_index = target_actor_node_index or chosen_target_actor_node_index
					elseif has_interaction_extension then
						focus_target = target_unit
						focus_target_actor_node_index = target_actor_node_index or focus_target_actor_node_index
					end
				else
					break
				end
			end
		end
	end

	if chosen_target then
		return chosen_target, chosen_target_actor_node_index, focus_target, focus_target_actor_node_index
	end

	local radius = InteractionSettings.detection_radius
	local sphere_offset = InteractionSettings.sphere_offset
	local look_height_scale = InteractionSettings.look_height_scale
	local height_scale = InteractionSettings.height_scale
	local height = self._first_person_component.height
	local look_pos_x, look_pos_y, look_pos_z = Vector3.to_elements(look_pos)
	local base_pos = Vector3(look_pos_x, look_pos_y, look_pos_z - height * height_scale)
	local look_dir_x, look_dir_y, look_dir_z = Vector3.to_elements(look_forward)
	local look_offset = Vector3.normalize(Vector3(look_dir_x, look_dir_y, look_dir_z * look_height_scale))
	local sphere_pos = base_pos + look_offset * sphere_offset
	local actors, num_actors = self._physics_world:immediate_overlap("shape", "sphere", "position", sphere_pos, "size", radius, "collision_filter", INTERACTABLE_FILTER)
	local closest_cos_angle_to_chosen = -math.huge
	local closest_cos_angle_to_focus = -math.huge

	for i = 1, num_actors do
		local unit_actor = actors[i]
		local target_unit, target_node = Actor.unit(unit_actor)
		local valid_target = target_unit and target_unit ~= interactor_unit and ALIVE[target_unit]

		if valid_target then
			local can_interact, has_interaction_extension = self:_check_valid_interaction_target(target_unit)
			local target_position, target_bounds = Actor.world_bounds(unit_actor)
			local obj_direction, distance_to_center = Vector3.direction_length(target_position - look_pos)
			local cos_angle_to_sight = Vector3.dot(look_forward, obj_direction)
			local closest_angle = nil

			if can_interact then
				closest_angle = closest_cos_angle_to_chosen
			else
				closest_angle = closest_cos_angle_to_focus
			end

			if closest_angle < cos_angle_to_sight and MAX_INTERACTION_COS_ANGLE <= cos_angle_to_sight then
				local distance_to_hit = _distance_to_actor(look_pos, obj_direction, distance_to_center, target_unit, target_node, target_bounds)

				if distance_to_hit < max_interact_distance and self:_check_collision_clear(look_pos, obj_direction, distance_to_hit) then
					if can_interact then
						chosen_target = target_unit
						chosen_target_actor_node_index = target_node
						closest_cos_angle_to_chosen = cos_angle_to_sight
					elseif has_interaction_extension then
						focus_target = target_unit
						focus_target_actor_node_index = target_node
						closest_cos_angle_to_focus = cos_angle_to_sight
					end
				end
			end
		end
	end

	return chosen_target, chosen_target_actor_node_index, focus_target, focus_target_actor_node_index
end

InteractorExtension._check_valid_ongoing_interaction = function (self, target_unit, target_node)
	if target_node == 0 then
		if self._player:is_human_controlled() then
			Log.error("InteractorExtension", "Player interacting without undefined node")
		end

		return true
	end

	if not target_unit or not ALIVE[target_unit] or target_node == 0 then
		return false
	end

	local can_interact, _ = self:_check_valid_interaction_target(target_unit)

	if not can_interact then
		return false
	end

	local first_person_component = self._first_person_component
	local look_pos = first_person_component.position
	local look_rot = first_person_component.rotation
	local look_forward = Quaternion.forward(look_rot)
	local physics_world = self._physics_world
	local max_interact_distance = MAX_INTERACTION_DISTANCE * ONGOING_INTERACTION_LEEWAY
	local hits, _ = PhysicsWorld.raycast(physics_world, look_pos, look_forward, max_interact_distance, "all", "collision_filter", INTERACTABLE_FILTER)

	if hits then
		local los_hit, _, los_dist, _ = PhysicsWorld.raycast(physics_world, look_pos, look_forward, max_interact_distance, "closest", "collision_filter", LINE_OF_SIGHT_FILTER)

		for hit_idx = 1, #hits do
			local hit = hits[hit_idx]
			local hit_distance = hit[INDEX_DISTANCE]

			if not los_hit or hit_distance <= los_dist then
				local hit_actor = hit[INDEX_ACTOR]
				local hit_unit = Actor.unit(hit_actor)

				if target_unit == hit_unit then
					return true
				end
			else
				break
			end
		end
	end

	local unit_actor = Unit.actor(target_unit, target_node)
	local target_position, target_bounds = Actor.world_bounds(unit_actor)
	local vector = target_position - look_pos
	local distance_to_center = Vector3.length(vector)
	local obj_direction = Vector3.normalize(vector)
	local distance_to_hit = _distance_to_actor(look_pos, obj_direction, distance_to_center, target_unit, target_node, target_bounds)

	if max_interact_distance < distance_to_hit then
		return false
	end

	if self:_check_collision_clear(look_pos, obj_direction, distance_to_hit) then
		return true
	end

	return false
end

InteractorExtension._check_valid_interaction_target = function (self, target_unit)
	local interactee_extension = ScriptUnit.has_extension(target_unit, "interactee_system")

	if interactee_extension then
		local interactee_interaction_type = interactee_extension:interaction_type()

		if interactee_interaction_type then
			local can_interact = self:_can_interact(target_unit, interactee_interaction_type)

			return can_interact, interactee_extension
		end
	end

	return false, interactee_extension
end

InteractorExtension._distance_to_interact = function (self, start_pos, direction, max_distance, interact_unit, interact_node)
	local collision_hits = self._physics_world:raycast(start_pos, direction, max_distance, "all", "collision_filter", INTERACTABLE_FILTER)

	if collision_hits then
		for j = 1, #collision_hits do
			local collision_hit = collision_hits[j]
			local collision_actor = collision_hit[INDEX_ACTOR]

			if collision_actor then
				local hit_unit, hit_node = Actor.unit(collision_actor)

				if hit_unit == interact_unit and hit_node == interact_node then
					return collision_hit[INDEX_DISTANCE]
				end
			end
		end
	end

	return max_distance
end

InteractorExtension._check_collision_clear = function (self, start_pos, direction, distance)
	local collision_hits = self._physics_world:raycast(start_pos, direction, distance, "all", "collision_filter", LINE_OF_SIGHT_FILTER)

	if not collision_hits then
		return true
	end

	local collisions_num = #collision_hits

	for j = 1, collisions_num do
		local collision_hit = collision_hits[j]
		local collision_distance = collision_hit[INDEX_DISTANCE]
		local collision_actor = collision_hit[INDEX_ACTOR]
		local hit_unit = Actor.unit(collision_actor)

		if not Unit.get_data(hit_unit, "ignored_by_interaction_raycast") then
			return false
		end
	end

	return true
end

InteractorExtension.can_interact = function (self, target_unit, interaction_type)
	local interaction_component = self._interaction_component
	local state = interaction_component.state
	local chosen_target_unit = interaction_component.target_unit
	local chosen_interaction_type = interaction_component.type

	if (target_unit ~= chosen_target_unit or interaction_type ~= chosen_interaction_type) and state ~= interaction_states.waiting_to_interact then
		return false
	end

	if not self:_can_interact(target_unit, interaction_type) then
		return false
	end

	return true
end

InteractorExtension._can_interact = function (self, target_unit, optional_interaction_type)
	local unit = self._unit
	local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
	local can_interact_with_target = interactee_extension:can_interact(unit, optional_interaction_type)

	if not can_interact_with_target then
		return false
	end

	local interaction = self:interaction(optional_interaction_type)
	local can_interact = interaction:interactor_condition_func(unit, target_unit)

	if not can_interact then
		return false
	end

	return true
end

InteractorExtension.interaction = function (self, optional_interaction_template_name)
	local interaction_template_name = optional_interaction_template_name or self._interaction_component.type
	local interaction_objects = self._interaction_objects

	if not interaction_objects[interaction_template_name] then
		local interaction_template = InteractionTemplates[interaction_template_name]
		local interaction_class_name = interaction_template.interaction_class_name
		interaction_objects[interaction_template_name] = Interactions[interaction_class_name]:new(interaction_template)
	end

	local interaction = interaction_objects[interaction_template_name]

	return interaction
end

InteractorExtension.show_counter_ui = function (self)
	return self._show_counter_ui
end

InteractorExtension.show_interaction_ui = function (self)
	return self._show_interaction_ui
end

InteractorExtension.target_unit = function (self)
	return self._interaction_component.target_unit
end

InteractorExtension.focus_unit = function (self)
	return self._focus_unit
end

InteractorExtension.interaction_progress = function (self)
	local unit = self._unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local interaction_component = unit_data_extension:read_component("interaction")
	local target_unit = interaction_component.target_unit

	if not target_unit then
		return 0, 0, 0
	end

	local interaction_duration = interaction_component.duration

	if interaction_duration == 0 then
		return 0, 0, 0
	end

	local interaction_start_time = interaction_component.start_time

	if interaction_start_time == 0 then
		return 0, 0, interaction_duration
	end

	local current_time = Managers.time:time("gameplay")
	local delta_time = current_time - interaction_start_time
	delta_time = math.min(delta_time, interaction_duration)
	local result = delta_time / interaction_duration

	return math.clamp(result, 0, 1), delta_time, interaction_duration
end

InteractorExtension.hud_description = function (self)
	local interaction_component = self._interaction_component
	local target_unit = interaction_component.target_unit
	local actor_node_index = interaction_component.target_actor_node_index

	if not target_unit then
		target_unit = self._focus_unit
		actor_node_index = self._focus_actor_node_index
	end

	local interaction = self:interaction()
	local hud_description = interaction:hud_description(self._unit, target_unit, actor_node_index)

	return hud_description
end

InteractorExtension.hud_block_text = function (self)
	local interaction_component = self._interaction_component
	local target_unit = interaction_component.target_unit
	local actor_node_index = interaction_component.target_actor_node_index
	local interaction_type = self._interaction_component.type

	if not target_unit then
		target_unit = self._focus_unit
		actor_node_index = self._focus_actor_node_index
		local interactee_extension = ScriptUnit.extension(target_unit, "interactee_system")
		interaction_type = interactee_extension:interaction_type()

		if interaction_type == "none" then
			interaction_type = nil
		end
	end

	local interaction = self:interaction(interaction_type)
	local hud_block_text, hud_block_text_context = interaction:hud_block_text(self._unit, target_unit, actor_node_index)

	return hud_block_text, hud_block_text_context
end

InteractorExtension.marker_offset = function (self)
	local interaction_component = self._interaction_component
	local target_unit = interaction_component.target_unit
	local actor_node_index = interaction_component.target_actor_node_index
	local interaction = self:interaction()

	return interaction:marker_offset(target_unit, actor_node_index)
end

InteractorExtension.is_interacting = function (self)
	local interaction_component = self._interaction_component
	local state = interaction_component.state

	return state == interaction_states.is_interacting
end

local Unit_world_pose = Unit.world_pose
local Intersect_ray_box = Intersect.ray_box

function _distance_to_actor(start_pos, direction, max_distance, interact_unit, interact_node, extents)
	if ALIVE[interact_unit] then
		local actor_pose = Unit_world_pose(interact_unit, interact_node)

		return Intersect_ray_box(start_pos, direction, actor_pose, extents) or max_distance
	end

	return max_distance
end

return InteractorExtension
