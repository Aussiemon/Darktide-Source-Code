local AlternateFire = require("scripts/utilities/alternate_fire")
local CameraTrees = require("scripts/settings/camera/camera_trees")
local HubCameraSettings = require("scripts/settings/camera/hub_camera_settings")
local MoodHandler = require("scripts/managers/camera/mood_handler/mood_handler")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local CameraModes = require("scripts/managers/player/player_game_states/utilities/camera_modes")
local DEFAULT_CAMERA_TREE = "world"
local DEFAULT_CAMERA_NODE = "world"
local DEFAULT_DEAD_CAMERA_TREE = "dead"
local DEFAULT_DEAD_CAMERA_NODE = "dead"
local CINEMATIC_CAMERA_TREE = "cinematic"
local CINEMATIC_GAMEPLAY_CAMERA_TREE = "cinematic_gameplay"
local CINEMATIC_CAMERA_NODE = "story_slave"
local TESTIFY_CAMERA_TREE = "testify_camera"
local TESTIFY_CAMERA_NODE = "testify"
local CameraHandler = class("CameraHandler")

CameraHandler.init = function (self, player, world)
	self._player = player
	self._viewport_name = player.viewport_name
	self._viewport = nil
	self._current_camera_tree = nil
	self._camera_follow_unit = nil
	self._side_system = Managers.state.extension:system("side_system")
	self._side_id = nil
	self._first_person_spectating_mode = true
	self._camera_spawned = false
	self._mode = CameraModes.first_person
	self._world = world
	self._wwise_player_state = "none"
	self._wwise_suppression_state = "none"
	self._mood_handler = MoodHandler:new(world, player)
	self._is_hogtied = nil
	self._is_being_rescued = nil

	if Managers.state.game_mode:use_third_person_hub_camera() then
		self._using_hub_camera = true
		self._hub_idle_timer = 0
		self._hub_idle_camera_zoom = 1
		self._hub_camera_speed_zoom = 0
	end
end

CameraHandler.on_reload = function (self, refreshed_resources)
	local viewport_name = self._viewport_name

	self:_load_node_trees(viewport_name)

	local unit = self._camera_follow_unit

	if unit then
		local camera_extensionension = ScriptUnit.extension(unit, "camera_system")
		local wanted_tree, wanted_camera_node, wanted_object = camera_extensionension:camera_tree_node()
		local camera_manager = Managers.state.camera

		camera_manager:set_node_tree_root_unit(viewport_name, wanted_tree, unit, wanted_object, true)
		camera_manager:set_camera_node(viewport_name, wanted_tree, wanted_camera_node)
	end
end

CameraHandler.update = function (self, dt, t, player_orientation, input)
	local player = self._player
	local ALIVE = ALIVE
	local old_unit = self._camera_follow_unit
	local new_unit = old_unit

	if not Managers.state.cinematic:active() then
		local player_is_available = player:unit_is_alive()
		local is_hogtied = false
		local is_being_rescued = false
		local is_dead = false
		local unit_data_extension = ScriptUnit.has_extension(player.player_unit, "unit_data_system")

		if unit_data_extension then
			local character_state_component = unit_data_extension:read_component("character_state")
			local assisted_state_input_component = unit_data_extension:read_component("assisted_state_input")
			is_hogtied = PlayerUnitStatus.is_hogtied(character_state_component)
			is_being_rescued = PlayerUnitStatus.is_assisted(assisted_state_input_component)
			is_dead = PlayerUnitStatus.is_dead(character_state_component)
		end

		local was_hogtied = self._is_hogtied
		self._is_hogtied = is_hogtied
		local force_switch = false
		local was_being_rescued = self._is_being_rescued
		self._is_being_rescued = is_being_rescued

		if is_dead then
			force_switch = self._mode ~= CameraModes.dead
			new_unit = player.player_unit
			self._mode = CameraModes.dead
		elseif is_hogtied and not was_being_rescued and is_being_rescued then
			new_unit = player.player_unit
			self._mode = CameraModes.observer
		elseif not was_hogtied and is_hogtied then
			new_unit = player.player_unit
			self._mode = CameraModes.observer
		elseif is_hogtied and player_is_available and input:get("spectate_next") then
			new_unit = self:_next_follow_unit(nil)
			self._mode = CameraModes.observer
		elseif not is_hogtied and player_is_available and old_unit ~= player.player_unit then
			new_unit = self:_follow_owner()
			self._mode = CameraModes.first_person
		elseif not is_hogtied and player_is_available then
			self._mode = CameraModes.first_person
		elseif not old_unit or not ALIVE[old_unit] or not player_is_available and (input:get("spectate_next") or old_unit == player.player_unit) then
			new_unit = self:_next_follow_unit(player.player_unit)
			self._mode = CameraModes.observer
		end

		local weather_system = Managers.state.extension:system("weather_system")

		weather_system:update_weather(new_unit)

		local switched_target = old_unit ~= new_unit

		if switched_target then
			self:_switch_follow_target(new_unit)
		end

		self:_update_follow(switched_target or force_switch)
		self:_update_wwise_state(new_unit)
		self:_update_player_mood(switched_target, new_unit)
	else
		self:remove_all_moods(old_unit)
		self:_update_player_mood(true, old_unit)
	end

	self:_update_camera_manager(dt, t, player_orientation)

	return new_unit
end

CameraHandler.remove_all_moods = function (self, unit)
	local mood_extension = ScriptUnit.has_extension(unit, "mood_system")

	if mood_extension then
		local moods_data = mood_extension:moods_data()

		self._mood_handler:remove_all_moods(moods_data)
		mood_extension:remove_all_moods()
	end
end

CameraHandler._update_camera_manager = function (self, dt, t, player_orientation)
	local player = self._player
	local camera_manager = Managers.state.camera
	local viewport_name = player.viewport_name
	local camera_follow_unit = self._camera_follow_unit

	if self._mode == CameraModes.observer and self._first_person_spectating_mode and ALIVE[camera_follow_unit] then
		local unit_data_component = ScriptUnit.extension(camera_follow_unit, "unit_data_system")
		local fp_component = unit_data_component:read_component("first_person")
		local y, p, r = Quaternion.to_yaw_pitch_roll(fp_component.rotation)

		camera_manager:update(dt, t, viewport_name, y, p, r)
	else
		local yaw, pitch, roll = player_orientation:orientation()
		local yaw_offset, pitch_offset, roll_offset = player_orientation:orientation_offset()

		camera_manager:update(dt, t, viewport_name, yaw + yaw_offset, pitch + pitch_offset, roll + roll_offset)
	end
end

CameraHandler._switch_follow_target = function (self, new_unit)
	local old_unit = self._camera_follow_unit
	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	if old_unit and ALIVE[old_unit] then
		local first_person_extension = ScriptUnit.has_extension(old_unit, "first_person_system")

		if first_person_extension then
			first_person_extension:set_camera_follow_target(false)
		end
	end

	self._camera_follow_unit = new_unit
	local is_player_unit = player_unit_spawn_manager:is_player_unit(new_unit)

	if new_unit and is_player_unit then
		ScriptUnit.extension(new_unit, "first_person_system"):set_camera_follow_target(true, self._first_person_spectating_mode)
	end

	if is_player_unit then
		Managers.wwise_game_sync:set_followed_player_unit(new_unit)
	else
		Managers.wwise_game_sync:set_followed_player_unit(nil)
	end

	Managers.state.chunk_lod:reset_timer()
end

CameraHandler.post_update = function (self, dt, t, player_orientation)
	local cinematic_manager = Managers.state.cinematic

	if cinematic_manager:active() then
		local old_unit = self._camera_follow_unit
		local new_unit = nil
		new_unit, self._mode = cinematic_manager:active_camera()

		if new_unit ~= old_unit then
			self:_switch_follow_target(new_unit)
			self:_update_follow(true)
			self:_update_wwise_state(new_unit)
		end
	end

	self:_post_update(dt, t, player_orientation)
end

CameraHandler._post_update = function (self, dt, t, player_orientation)
	local camera_manager = Managers.state.camera
	local viewport_name = self._viewport_name
	local camera_follow_unit = self._camera_follow_unit

	if ALIVE[camera_follow_unit] then
		local first_person_extension = ScriptUnit.has_extension(camera_follow_unit, "first_person_system")

		if first_person_extension then
			if self._using_hub_camera then
				self:_update_hub_camera_variables(dt, t, camera_follow_unit, viewport_name)
			end

			camera_manager:set_variable(viewport_name, "character_height", first_person_extension:extrapolated_character_height())

			local unit_data_extension = ScriptUnit.extension(camera_follow_unit, "unit_data_system")
			local weapon_action_component = unit_data_extension:read_component("weapon_action")
			local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
			local vertical_fov, custom_vertical_fov, near_range = AlternateFire.camera_variables(weapon_template)

			camera_manager:set_variable(viewport_name, "zoom_vertical_fov", vertical_fov)
			camera_manager:set_variable(viewport_name, "zoom_custom_vertical_fov", custom_vertical_fov)
			camera_manager:set_variable(viewport_name, "zoom_near_range", near_range)
		end

		local buff_extension = ScriptUnit.has_extension(camera_follow_unit, "buff_system")
		local stat_buffs = buff_extension and buff_extension:stat_buffs()

		if stat_buffs then
			local fov_multiplier = stat_buffs.fov_multiplier

			if fov_multiplier then
				camera_manager:set_variable(viewport_name, "fov_multiplier", fov_multiplier)
			end
		end
	end

	camera_manager:post_update(dt, t, viewport_name)
end

local quaternion_right = Quaternion.right
local quaternion_forward = Quaternion.forward
local vector3_cross = Vector3.cross
local vector3_dot = Vector3.dot
local math_lerp = math.lerp

CameraHandler._update_hub_camera_variables = function (self, dt, t, unit, viewport_name)
	local unit_data = ScriptUnit.extension(unit, "unit_data_system")
	local first_person = unit_data:read_component("first_person")
	local locomotion = unit_data:read_component("locomotion")
	local hub_jog_character_state_component = unit_data:read_component("hub_jog_character_state")
	local move_state = hub_jog_character_state_component.move_state
	local move_method = hub_jog_character_state_component.method
	local idle_camera_zoom = self._hub_idle_camera_zoom
	local camera_speed_zoom = self._hub_camera_speed_zoom
	local idle_timer = self._hub_idle_timer

	if move_method == "idle" or move_method == "turn_on_spot" then
		idle_timer = idle_timer + dt
		local idle_camera_zoom_delay = HubCameraSettings.idle_camera_zoom_delay

		if idle_camera_zoom_delay < idle_timer then
			local ramp_up = math.clamp(idle_timer - idle_camera_zoom_delay, 0, 1)
			idle_camera_zoom = math_lerp(idle_camera_zoom, 1, dt * HubCameraSettings.idle_camera_zoom_speed * ramp_up)
		end

		camera_speed_zoom = math_lerp(camera_speed_zoom, 0, dt * HubCameraSettings.camera_speed_zoom_out_speed)
	else
		idle_camera_zoom = math_lerp(idle_camera_zoom, 0, dt * HubCameraSettings.idle_camera_zoom_out_speed)
		idle_timer = 0
		local speed_zoom_target = HubCameraSettings.move_state_speed_zoom_targets[move_state] or 0
		camera_speed_zoom = math_lerp(camera_speed_zoom, speed_zoom_target, dt * HubCameraSettings.camera_speed_zoom_in_speed)
	end

	self._hub_idle_camera_zoom = idle_camera_zoom
	self._hub_camera_speed_zoom = camera_speed_zoom
	self._hub_idle_timer = idle_timer
	local look_rotation = first_person.rotation
	local camera_forward = quaternion_forward(look_rotation)
	local camera_right = quaternion_right(look_rotation)
	local flat_look_direction = vector3_cross(camera_right, Vector3.down())
	local locomotion_rotation = locomotion.rotation
	local character_forward = quaternion_forward(locomotion_rotation)
	local hub_back_look_offset = (1 - vector3_dot(flat_look_direction, character_forward)) / 2
	local hub_up_look_offset = vector3_dot(camera_forward, Vector3.up())
	local camera_manager = Managers.state.camera

	camera_manager:set_variable(viewport_name, "hub_idle_offset", math.ease_quad(idle_camera_zoom))
	camera_manager:set_variable(viewport_name, "hub_speed_zoom", math.easeCubic(camera_speed_zoom))
	camera_manager:set_variable(viewport_name, "hub_back_look_offset", hub_back_look_offset * idle_camera_zoom)
	camera_manager:set_variable(viewport_name, "hub_up_look_offset", hub_up_look_offset * idle_camera_zoom)
	camera_manager:set_variable(viewport_name, "hub_up_back_look_offset", hub_back_look_offset * hub_up_look_offset * idle_camera_zoom)
	camera_manager:set_variable(viewport_name, "hub_down_back_look_offset", hub_back_look_offset * -hub_up_look_offset * idle_camera_zoom)
	camera_manager:set_variable(viewport_name, "hub_up_forward_look_offset", (1 - hub_back_look_offset) * hub_up_look_offset * idle_camera_zoom)
end

CameraHandler._update_follow = function (self, follow_unit_switch)
	local follow_unit = self._camera_follow_unit
	local follow_unit_available = follow_unit and ALIVE[follow_unit]

	if self._mode == CameraModes.dead then
		if follow_unit_switch then
			local camera_manager = Managers.state.camera
			local viewport_name = self._viewport_name

			if follow_unit_available then
				camera_manager:set_node_tree_root_position(viewport_name, DEFAULT_DEAD_CAMERA_TREE, POSITION_LOOKUP[follow_unit])
			end

			camera_manager:set_camera_node(viewport_name, DEFAULT_DEAD_CAMERA_TREE, DEFAULT_DEAD_CAMERA_NODE)
		end
	elseif follow_unit_available then
		self:_update_follow_camera(follow_unit, follow_unit_switch)
	elseif follow_unit_switch then
		local camera_manager = Managers.state.camera
		local viewport_name = self._viewport_name
		local current_camera_node = camera_manager:current_camera_node(viewport_name)

		if follow_unit_available then
			local camera_extension = ScriptUnit.extension(follow_unit, "camera_system")
			local _, _, wanted_object = camera_extension:camera_tree_node()

			camera_manager:set_node_tree_root_unit(viewport_name, DEFAULT_CAMERA_TREE, follow_unit, wanted_object)

			if current_camera_node ~= DEFAULT_CAMERA_NODE then
				camera_manager:set_camera_node(viewport_name, DEFAULT_CAMERA_TREE, DEFAULT_CAMERA_NODE)
			end
		elseif current_camera_node ~= DEFAULT_CAMERA_NODE then
			camera_manager:set_camera_node(viewport_name, DEFAULT_CAMERA_TREE, DEFAULT_CAMERA_NODE)
		end
	end
end

local mood_blend_list = {}

CameraHandler._update_player_mood = function (self, switched_target, follow_unit)
	table.clear(mood_blend_list)

	local mood_extension = ScriptUnit.has_extension(follow_unit, "mood_system")

	if mood_extension then
		local moods_data = mood_extension:moods_data()

		self._mood_handler:update_moods(mood_blend_list, moods_data)
		Managers.state.camera:set_mood_blend_list(mood_blend_list)
	end
end

CameraHandler._update_follow_camera = function (self, unit, follow_unit_switch)
	local mode = self._mode
	local wanted_tree, wanted_camera_node, wanted_object = nil

	if mode == CameraModes.cutscene then
		wanted_camera_node = CINEMATIC_CAMERA_NODE
		wanted_tree = CINEMATIC_CAMERA_TREE
	elseif mode == CameraModes.cutscene_gameplay then
		wanted_camera_node = CINEMATIC_CAMERA_NODE
		wanted_tree = CINEMATIC_GAMEPLAY_CAMERA_TREE
	elseif mode == CameraModes.testify then
		wanted_camera_node = TESTIFY_CAMERA_NODE
		wanted_tree = TESTIFY_CAMERA_TREE
	else
		local camera_extension = ScriptUnit.extension(unit, "camera_system")
		wanted_tree, wanted_camera_node, wanted_object = camera_extension:camera_tree_node()
	end

	local camera_manager = Managers.state.camera
	local viewport_name = self._viewport_name
	local current_camera_node = camera_manager:current_camera_node(viewport_name)

	if wanted_tree ~= self._current_camera_tree or follow_unit_switch then
		camera_manager:set_node_tree_root_unit(viewport_name, wanted_tree, unit, wanted_object, true)
	end

	if wanted_camera_node ~= current_camera_node then
		camera_manager:set_camera_node(viewport_name, wanted_tree, wanted_camera_node)
	end

	self._current_camera_tree = wanted_tree
end

local DEFAULT_WWISE_PLAYER_STATE = "none"
local DEFAULT_WWISE_SUPPRESSION_STATE = "none"

CameraHandler._update_wwise_state = function (self, unit)
	local player_state = DEFAULT_WWISE_PLAYER_STATE
	local suppression_state = DEFAULT_WWISE_SUPPRESSION_STATE

	if unit then
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")
		local suppression_extension = ScriptUnit.has_extension(unit, "suppression_system")

		if fx_extension then
			player_state = fx_extension:wwise_player_state()
		end

		if suppression_extension then
			suppression_state = suppression_extension:wwise_suppression_state()
		end
	end

	if player_state ~= self._wwise_player_state then
		Wwise.set_state("player_state", player_state)

		self._wwise_player_state = player_state
	end

	if suppression_state ~= self._wwise_suppression_state then
		Wwise.set_state("suppression_state", suppression_state)

		self._wwise_suppression_state = suppression_state
	end
end

CameraHandler._follow_owner = function (self)
	local player = self._player
	local side_system = self._side_system
	local side = side_system.side_by_unit[player.player_unit]
	self._side_id = side.side_id

	return player.player_unit
end

local valid_follow_units = {}

CameraHandler._next_follow_unit = function (self, except_unit)
	local side_system = self._side_system
	local old_unit = self._camera_follow_unit

	if self._side_id then
		table.clear(valid_follow_units)

		local side = side_system:get_side(self._side_id)
		local player_units = side.player_units
		local player_unit_spawn_manager = Managers.state.player_unit_spawn

		for i = 1, #player_units do
			local player_unit = player_units[i]
			local player = player_unit_spawn_manager:owner(player_unit)
			local human_controlled = player and player:is_human_controlled()

			if human_controlled then
				valid_follow_units[#valid_follow_units + 1] = player_unit
			end
		end

		if old_unit == nil then
			local selected_unit = valid_follow_units[1]

			if selected_unit == except_unit then
				selected_unit = valid_follow_units[2]
			end

			return selected_unit
		else
			local num_units = #valid_follow_units
			local selected_index = 1

			for i = 1, num_units do
				local unit = valid_follow_units[i]

				if unit == old_unit then
					selected_index = i % num_units + 1

					break
				end
			end

			local selected_unit = valid_follow_units[selected_index]

			if selected_unit == except_unit and num_units == 1 then
				selected_unit = nil
			elseif selected_unit == except_unit then
				selected_unit = valid_follow_units[selected_index % num_units + 1]
			end

			return selected_unit
		end
	else
		return nil
	end
end

CameraHandler._get_theme_shading_environment = function (self, themes)
	if themes then
		for _, theme in ipairs(themes) do
			local slots_info = Theme.shading_environment_slots(theme)

			if slots_info and table.size(slots_info) > 0 then
				for _, slot_info in ipairs(slots_info) do
					if slot_info.slot_id == 0 then
						return slot_info.shading_environment_name
					end
				end

				break
			end
		end
	end

	return nil
end

CameraHandler.spawn_camera = function (self, level, themes)
	local viewport_name = self._viewport_name
	local camera_manager = Managers.state.camera
	local pos = Vector3.zero()
	local rot = Quaternion.identity()
	local theme_shading_environment_name = self:_get_theme_shading_environment(themes)
	local default_shading_environment_name = theme_shading_environment_name or Level.get_data(level, "shading_environment")
	local viewport = camera_manager:create_viewport(viewport_name, nil, pos, rot, default_shading_environment_name)
	local external_fov_multiplier = 1

	self:_load_node_trees(viewport_name)
	camera_manager:set_camera_node(viewport_name, DEFAULT_CAMERA_TREE, DEFAULT_CAMERA_NODE)
	camera_manager:set_variable(viewport_name, "external_fov_multiplier", external_fov_multiplier)
	Managers.state.bone_lod:register_bone_lod_viewport(viewport)

	self._camera_spawned = true
	self._viewport = viewport
end

CameraHandler._load_node_trees = function (self, viewport_name)
	local camera_manager = Managers.state.camera

	camera_manager:load_node_tree(viewport_name, DEFAULT_CAMERA_TREE, DEFAULT_CAMERA_TREE)

	for tree_id, tree_name in pairs(CameraTrees) do
		camera_manager:load_node_tree(viewport_name, tree_id, tree_name)
	end
end

CameraHandler.is_observing = function (self)
	return self._mode == CameraModes.observer and self._first_person_spectating_mode
end

CameraHandler.camera_follow_unit = function (self)
	return self._camera_follow_unit
end

CameraHandler.destroy_camera = function (self)
	local viewport = self._viewport

	Managers.state.bone_lod:unregister_bone_lod_viewport(viewport)

	local viewport_name = self._viewport_name
	local camera_manager = Managers.state.camera

	camera_manager:destroy_viewport(viewport_name)

	self._camera_spawned = false
	self._viewport = nil
end

CameraHandler.destroy = function (self)
	self._mood_handler:destroy()

	self._mood_handler = nil

	self:_update_wwise_state(nil)
	Managers.wwise_game_sync:set_followed_player_unit(nil)
end

return CameraHandler
