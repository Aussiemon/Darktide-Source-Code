-- chunkname: @scripts/managers/ui/ui_weapon_spawner.lua

local InputDevice = require("scripts/managers/input/input_device")
local MasterItems = require("scripts/backend/master_items")
local UiCharacterProfilePackageLoader = require("scripts/managers/ui/ui_character_profile_package_loader")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local UIWeaponSpawner = class("UIWeaponSpawner")

UIWeaponSpawner.init = function (self, reference_name, world, camera, unit_spawner)
	self._reference_name = reference_name
	self._world = world
	self._camera = camera
	self._unit_spawner = unit_spawner
	self._item_definitions = MasterItems.get_cached()
	self._default_rotation_angle = 0
	self._force_allow_rotation = false
	self._rotation_angle = self._default_rotation_angle
end

UIWeaponSpawner.set_force_allow_rotation = function (self, allow)
	self._force_allow_rotation = allow
end

UIWeaponSpawner.force_allow_rotation = function (self)
	return self._force_allow_rotation
end

UIWeaponSpawner.node_world_position = function (self, node_name)
	local weapon_spawn_data = self._weapon_spawn_data

	if weapon_spawn_data then
		local node = self:_node(node_name) or 1
		local item_unit_3p = weapon_spawn_data.item_unit_3p
		local position = Unit.world_position(item_unit_3p, node)

		return position
	end
end

UIWeaponSpawner._node = function (self, node_name)
	local weapon_spawn_data = self._weapon_spawn_data

	if weapon_spawn_data then
		local item_unit_3p = weapon_spawn_data.item_unit_3p
		local node = node_name and Unit.has_node(item_unit_3p, node_name) and Unit.node(item_unit_3p, node_name)

		return node
	end
end

UIWeaponSpawner.start_presentation = function (self, item, position, rotation, scale, on_spawn_cb, force_highest_mip)
	if self._loading_weapon_data then
		self._loading_weapon_data.loader:destroy()

		self._loading_weapon_data = nil
	end

	self._weapon_loader_index = (self._weapon_loader_index or 0) + 1

	local reference_name = self._reference_name .. "_weapon_item_loader_" .. tostring(self._weapon_loader_index)
	local single_item_loader = UiCharacterProfilePackageLoader:new(reference_name, self._item_definitions)
	local slot_id = "slot_primary"
	local on_loaded_callback = callback(self, "cb_on_item_package_loaded", slot_id, item, on_spawn_cb)

	self._loading_weapon_data = {
		link_unit_name = "content/weapons/default_display",
		loader = single_item_loader,
		reference_name = reference_name,
		position = position and Vector3.to_array(position),
		rotation = rotation and QuaternionBox(rotation),
		scale = scale and Vector3.to_array(scale),
		item = item,
		force_highest_mip = force_highest_mip,
	}

	single_item_loader:load_slot_item(slot_id, item, on_loaded_callback)
end

UIWeaponSpawner.cb_on_item_package_loaded = function (self, slot_id, item, on_spawn_cb)
	if on_spawn_cb then
		on_spawn_cb(slot_id, item)
	end
end

UIWeaponSpawner.destroy = function (self)
	self:_despawn_current_weapon()

	if self._loading_weapon_data then
		self._loading_weapon_data.loader:destroy()

		self._loading_weapon_data = nil
	end
end

UIWeaponSpawner.update = function (self, dt, t, input_service)
	local weapon_spawn_data = self._weapon_spawn_data

	if weapon_spawn_data and weapon_spawn_data.streaming_complete then
		self:_handle_input(input_service, dt)
		self:_update_input_rotation(dt)

		local link_unit = weapon_spawn_data.link_unit
		local auto_tilt_angle, auto_turn_angle = self:_auto_spin_values(dt, t)
		local start_angle = self._rotation_angle or 0
		local rotation = Quaternion.axis_angle(Vector3(0, auto_tilt_angle, 1), -(auto_turn_angle + start_angle))

		if link_unit then
			local initial_rotation = weapon_spawn_data.rotation and QuaternionBox.unbox(weapon_spawn_data.rotation)

			if initial_rotation then
				rotation = Quaternion.multiply(rotation, initial_rotation)
			end

			Unit.set_local_rotation(link_unit, 1, rotation)
		end

		if not weapon_spawn_data.visible then
			weapon_spawn_data.visible = true

			Unit.set_unit_visibility(weapon_spawn_data.item_unit_3p, true, true)
		end
	end

	local loading_weapon_data = self._loading_weapon_data

	if loading_weapon_data then
		local loader = loading_weapon_data.loader

		if loader:is_all_loaded() then
			if self._weapon_spawn_data then
				self:_despawn_current_weapon()
			end

			local position = loading_weapon_data.position and Vector3.from_array(loading_weapon_data.position)
			local rotation = loading_weapon_data.rotation and QuaternionBox.unbox(loading_weapon_data.rotation)
			local scale = loading_weapon_data.scale and Vector3.from_array(loading_weapon_data.scale)
			local item = loading_weapon_data.item
			local link_unit_name = loading_weapon_data.link_unit_name
			local force_highest_mip = loading_weapon_data.force_highest_mip

			self:_spawn_weapon(item, link_unit_name, loader, position, rotation, scale, force_highest_mip)

			self._loading_weapon_data = nil
		end
	end
end

UIWeaponSpawner._handle_input = function (self, input_service, dt)
	self:_mouse_rotation_input(input_service, dt)
end

UIWeaponSpawner._despawn_current_weapon = function (self)
	local weapon_spawn_data = self._weapon_spawn_data

	if weapon_spawn_data then
		local loader = weapon_spawn_data.loader

		self:_despawn_weapon()
		loader:destroy()

		self._weapon_spawn_data = nil
	end
end

UIWeaponSpawner._despawn_weapon = function (self)
	local unit_spawner = self._unit_spawner
	local weapon_spawn_data = self._weapon_spawn_data

	if weapon_spawn_data then
		local item_unit_3p, attachment_units_3p = weapon_spawn_data.item_unit_3p, weapon_spawn_data.attachment_units_3p
		local link_unit = weapon_spawn_data.link_unit

		if attachment_units_3p then
			for ii = #attachment_units_3p, 1, -1 do
				local unit = attachment_units_3p[ii]

				unit_spawner:mark_for_deletion(unit)
			end
		end

		unit_spawner:mark_for_deletion(item_unit_3p)
		unit_spawner:mark_for_deletion(link_unit)

		if unit_spawner.remove_pending_units then
			unit_spawner:remove_pending_units()
		end

		self._weapon_spawn_data = nil
	end
end

UIWeaponSpawner.set_position = function (self, position)
	local weapon_spawn_data = self._weapon_spawn_data

	if weapon_spawn_data then
		local link_unit = weapon_spawn_data.link_unit

		Unit.set_local_position(link_unit, 1, position)
	else
		local loading_weapon_data = self._loading_weapon_data

		if loading_weapon_data then
			loading_weapon_data.position = Vector3.to_array(position)
		end
	end
end

UIWeaponSpawner._spawn_weapon = function (self, item, link_unit_name, loader, position, rotation, scale, force_highest_mip)
	position = position or Vector3.zero()
	rotation = rotation or Quaternion.identity()
	scale = scale or Vector3.zero()

	local world = self._world
	local link_unit = World.spawn_unit_ex(world, link_unit_name, nil, position, rotation)

	Unit.set_local_scale(link_unit, 1, scale)

	local extension_manager = self._extension_manager
	local attach_settings = {
		force_highest_lod_step = true,
		from_script_component = false,
		world = world,
		unit_spawner = self._unit_spawner,
		item_definitions = self._item_definitions,
		extension_manager = extension_manager,
		spawn_with_extensions = extension_manager ~= nil,
	}
	local item_unit_3p, attachment_units_3p = VisualLoadoutCustomization.spawn_item(item, attach_settings, link_unit, nil, nil, nil)
	local spawn_data = {
		streaming_complete = false,
		visible = false,
		loader = loader,
		rotation = rotation and QuaternionBox(rotation),
		item = item,
		link_unit = link_unit,
		item_unit_3p = item_unit_3p,
		attachment_units_3p = attachment_units_3p,
	}

	self._weapon_spawn_data = spawn_data

	local complete_callback = callback(self, "cb_on_unit_3p_streaming_complete", item_unit_3p)

	Unit.force_stream_meshes(item_unit_3p, complete_callback, true, GameParameters.force_stream_mesh_timeout)

	local node_index = Unit.has_node(item_unit_3p, "p_rotation") and Unit.node(item_unit_3p, "p_rotation") or 1
	local node_pos = Unit.local_position(item_unit_3p, node_index)

	Unit.set_local_position(item_unit_3p, 1, -node_pos)

	local link_unit_rot = Unit.local_rotation(link_unit, 1)
	local rotated_pos = Quaternion.rotate(link_unit_rot, node_pos)
	local link_unit_pos = Unit.local_position(link_unit, 1)

	Unit.set_local_position(link_unit, 1, link_unit_pos + rotated_pos)
end

UIWeaponSpawner.cb_on_unit_3p_streaming_complete = function (self, item_unit_3p, timeout)
	if timeout then
		Log.info("UIWeaponSpawner", "[cb_on_unit_3p_streaming_complete] unit: %s", tostring(item_unit_3p))
	end

	local weapon_spawn_data = self._weapon_spawn_data

	if weapon_spawn_data and weapon_spawn_data.item_unit_3p == item_unit_3p then
		weapon_spawn_data.streaming_complete = true

		Unit.set_unit_visibility(item_unit_3p, true, true)
	end
end

UIWeaponSpawner.get_spawn_data = function (self)
	return self._weapon_spawn_data
end

UIWeaponSpawner.spawned = function (self)
	return self._weapon_spawn_data ~= nil
end

UIWeaponSpawner._update_input_rotation = function (self, dt)
	local weapon_spawn_data = self._weapon_spawn_data

	if not weapon_spawn_data then
		return
	end
end

UIWeaponSpawner._set_rotation = function (self, angle)
	self._rotation_angle = angle
end

local mouse_pos_temp = {}

UIWeaponSpawner._mouse_rotation_input = function (self, input_service, dt)
	local mouse = input_service and input_service:get("cursor")

	if not input_service then
		return
	end

	local can_rotate = self._is_rotating or self._force_allow_rotation or self:_is_pressed(input_service) or self._always_allow_rotation

	if can_rotate then
		if input_service:get("left_pressed") then
			self._is_rotating = true
			self._last_mouse_position = nil
		end

		local scroll_axis = input_service:get("scroll_axis")
		local rotation = scroll_axis and scroll_axis[1] or 0

		if math.abs(rotation) > 0.1 then
			self._is_rotating = true
			self._last_mouse_position = nil
		end

		if input_service:get("right_pressed") then
			self:_set_rotation(self._default_rotation_angle)
		end
	end

	local is_moving_camera = self._is_rotating

	if is_moving_camera then
		local mouse_hold = input_service:get("left_hold")

		if InputDevice.gamepad_active then
			local scroll_axis = input_service:get("scroll_axis")
			local rotation = scroll_axis and scroll_axis[1] or 0

			rotation = math.abs(rotation) > math.abs(scroll_axis[2]) and rotation or 0

			if math.abs(rotation) > 0.1 then
				local angle = self._rotation_angle + -rotation * dt * 4

				self:_set_rotation(angle)
			else
				self._is_rotating = false
			end
		elseif mouse_hold then
			if self._last_mouse_position then
				local angle = self._rotation_angle - (mouse.x - self._last_mouse_position[1]) * 0.01

				self:_set_rotation(angle)
			end

			mouse_pos_temp[1] = mouse.x
			mouse_pos_temp[2] = mouse.y
			self._last_mouse_position = mouse_pos_temp
		else
			self._is_rotating = false
		end
	elseif is_moving_camera then
		self._is_rotating = false
	end
end

UIWeaponSpawner.set_forced_pressed = function (self)
	self._forced_pressed = true
end

UIWeaponSpawner._is_pressed = function (self, input_service)
	local input_pressed = input_service:get("left_pressed") or input_service:get("right_pressed")

	if input_pressed then
		if self._forced_pressed then
			self._forced_pressed = nil

			return true
		end

		local physics_world = World.physics_world(self._world)

		if not physics_world then
			return
		end

		local cursor_name = "cursor"
		local cursor = input_service:get(cursor_name) or NilCursor
		local camera = self._camera

		if physics_world and camera then
			local screen_height = RESOLUTION_LOOKUP.height

			cursor[2] = screen_height - cursor[2]

			local from = Camera.screen_to_world(camera, Vector3(cursor[1], cursor[2], 0), 0)
			local direction = Camera.screen_to_world(camera, cursor, 1) - from
			local to = Vector3.normalize(direction)
			local collision_filter = "default"
			local hit = PhysicsWorld.raycast(physics_world, from, to, 100, "closest", "collision_filter", collision_filter)

			if hit then
				return true
			end
		end
	end
end

UIWeaponSpawner.activate_auto_spin = function (self, ignore_randomness)
	self._auto_spin_random_seed = ignore_randomness and 0 or math.random(5, 30000)
end

UIWeaponSpawner._auto_spin_values = function (self, dt, t)
	local start_seed = self._auto_spin_random_seed

	if not start_seed then
		return 0, 0
	end

	local progress_speed = 0.3
	local progress_range = 0.3
	local progress = math.sin((start_seed + t) * progress_speed) * progress_range
	local auto_tilt_angle = -(progress * 0.5)
	local auto_turn_angle = -(progress * math.pi * 0.25)

	return auto_tilt_angle, auto_turn_angle
end

return UIWeaponSpawner
