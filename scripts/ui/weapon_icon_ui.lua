﻿-- chunkname: @scripts/ui/weapon_icon_ui.lua

local UIWeaponSpawner = require("scripts/managers/ui/ui_weapon_spawner")
local UISettings = require("scripts/settings/ui/ui_settings")

require("scripts/ui/render_target_icon_generator_base")

local WeaponIconUI = class("WeaponIconUI", "RenderTargetIconGeneratorBase")

WeaponIconUI.init = function (self, render_settings)
	local new_render_settings = {
		width = render_settings and render_settings.width or UISettings.weapon_icon_size[1],
		height = render_settings and render_settings.height or UISettings.weapon_icon_size[2],
		world_name = render_settings and render_settings.world_name or "weapon_icon_world_" .. tostring(math.uuid()),
		world_layer = render_settings and render_settings.world_layer or 800,
		timer_name = render_settings and render_settings.timer_name or "ui",
		viewport_layer = render_settings and render_settings.viewport_layer or 900,
		viewport_type = render_settings and render_settings.viewport_type or "default_with_alpha",
		viewport_name = render_settings and render_settings.viewport_name or "weapon_viewport",
		level_name = render_settings and render_settings.level_name or "content/levels/ui/weapon_icon/weapon_icon",
		shading_environment = render_settings and render_settings.shading_environment or "content/shading_environments/ui/weapon_icons"
	}

	WeaponIconUI.super.init(self, new_render_settings)

	self._default_camera_settings_key = "human"
	self._breed_camera_settings = {}
end

WeaponIconUI.weapon_icon_updated = function (self, item, prioritized)
	local id = item.gear_id or item.name
	local request = self:_request_by_id(id)

	if request then
		self:_update_request(request, item, prioritized)
	end
end

WeaponIconUI.unload_weapon_icon = function (self, reference_id)
	self:unload_request_reference(reference_id)
end

WeaponIconUI.load_weapon_icon = function (self, item, on_load_callback, optional_render_context, prioritized, on_unload_callback)
	local gear_id = item.gear_id or item.name
	local request_id_prefix = gear_id or math.uuid()
	local request_data = item
	local reference_id = self:_generate_icon_request(request_id_prefix, request_data, on_load_callback, optional_render_context, prioritized, on_unload_callback)

	return reference_id
end

WeaponIconUI.destroy = function (self)
	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end

	WeaponIconUI.super.destroy(self)
end

WeaponIconUI.update = function (self, dt, t)
	WeaponIconUI.super.update(self, dt, t)

	local ui_weapon_spawner = self._ui_weapon_spawner

	if ui_weapon_spawner then
		ui_weapon_spawner:update(dt, t)
	end
end

WeaponIconUI._should_render = function (self)
	local ui_weapon_spawner = self._ui_weapon_spawner
	local should_render = ui_weapon_spawner and ui_weapon_spawner:spawned()

	return should_render
end

WeaponIconUI._prepare_request_capture = function (self, request)
	local data = request.data
	local render_context = request.render_context

	self:_spawn_weapon(data, render_context)
end

WeaponIconUI._is_ready_to_capture_request = function (self)
	local ui_weapon_spawner = self._ui_weapon_spawner

	if ui_weapon_spawner then
		return ui_weapon_spawner:spawned()
	end

	return false
end

WeaponIconUI._on_capture_complete = function (self, active_request)
	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end
end

WeaponIconUI._initialize_world = function (self)
	Managers.event:register(self, "event_register_portrait_camera_human", "event_register_portrait_camera_human")
	Managers.event:register(self, "event_register_portrait_camera_ogryn", "event_register_portrait_camera_ogryn")
	Managers.event:register(self, "event_register_spawn_point_character_portrait", "event_register_spawn_point_character_portrait")
	WeaponIconUI.super._initialize_world(self)
end

WeaponIconUI.event_register_spawn_point_character_portrait = function (self, spawn_point_unit)
	Managers.event:unregister(self, "event_register_spawn_point_character_portrait")

	self._spawn_point_unit = spawn_point_unit
end

WeaponIconUI.event_register_portrait_camera_human = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_portrait_camera_human")

	local camera_position = Unit.world_position(camera_unit, 1)
	local camera_rotation = Unit.world_rotation(camera_unit, 1)

	self._breed_camera_settings.human = {
		camera_unit = camera_unit,
		boxed_camera_start_position = Vector3.to_array(camera_position),
		boxed_camera_start_rotation = QuaternionBox(camera_rotation)
	}
end

WeaponIconUI.event_register_portrait_camera_ogryn = function (self, camera_unit)
	Managers.event:unregister(self, "event_register_portrait_camera_ogryn")

	local camera_position = Unit.world_position(camera_unit, 1)
	local camera_rotation = Unit.world_rotation(camera_unit, 1)

	self._breed_camera_settings.ogryn = {
		camera_unit = camera_unit,
		boxed_camera_start_position = Vector3.to_array(camera_position),
		boxed_camera_start_rotation = QuaternionBox(camera_rotation)
	}
end

WeaponIconUI._get_unit_by_value_key = function (self, key, value)
	local world_spawner = self._world_spawner
	local level = world_spawner:level()
	local level_units = Level.units(level)

	for i = 1, #level_units do
		local unit = level_units[i]

		if Unit.get_data(unit, key) == value then
			return unit
		end
	end
end

WeaponIconUI._reset_active_spawning = function (self)
	WeaponIconUI.super._reset_active_spawning(self)

	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end
end

WeaponIconUI._camera_unit = function (self)
	local default_camera_settings_key = self._default_camera_settings_key
	local camera_settings = self._breed_camera_settings[default_camera_settings_key]
	local camera_unit = camera_settings.camera_unit

	return camera_unit
end

WeaponIconUI._spawn_weapon = function (self, item, render_context)
	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end

	local world_spawner = self._world_spawner
	local world = world_spawner:world()
	local camera = world_spawner:camera()
	local unit_spawner = world_spawner:unit_spawner()
	local ui_weapon_spawner = UIWeaponSpawner:new("WeaponIconUI", world, camera, unit_spawner)

	self._ui_weapon_spawner = ui_weapon_spawner

	local alignment_key = "weapon_alignment_tag"

	if render_context and render_context.alignment_key then
		alignment_key = render_context.alignment_key
	end

	local item_base_unit_name = item.base_unit
	local item_level_link_unit = self:_get_unit_by_value_key(alignment_key, item_base_unit_name)
	local spawn_point_unit = item_level_link_unit or self._spawn_point_unit
	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)
	local spawn_scale = Unit.world_scale(spawn_point_unit, 1)
	local force_highest_mip = true

	ui_weapon_spawner:start_presentation(item, spawn_position, spawn_rotation, spawn_scale, nil, force_highest_mip)

	local breed = "human"
	local camera_settings = self._breed_camera_settings[breed]

	if camera_settings then
		local camera_position = Vector3.from_array(camera_settings.boxed_camera_start_position)
		local camera_rotation = camera_settings.boxed_camera_start_rotation:unbox()

		world_spawner:set_camera_position(camera_position)
		world_spawner:set_camera_rotation(camera_rotation)
	end
end

return WeaponIconUI
