local Action = require("scripts/utilities/weapon/action")
local Component = require("scripts/utilities/component")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local Scanning = require("scripts/utilities/scanning")
local FX_SOURCE_NAME = "_speaker"
local WWISE_PARAMETER_NAME_DISTANCE = "scanner_distance"
local WWISE_PARAMETER_NAME_ANGLE = "scanner_orientation"
local WWISE_PARAMETER_NAME_BEEP_VOLUME = "scanner_beep_volume"
local SEARCH_LOOP_ALIAS = "ranged_shooting"
local CONFIRM_LOOP_ALIAS = "ranged_braced_shooting"
local PLAYER_HOLO_UNIT_NAME = "content/weapons/player/pickups/pup_auspex_scanner/auspex_scanner_holo_drop_01"
local SCAN_HOLO_UNIT_NAME = "content/weapons/player/pickups/pup_auspex_scanner/auspex_scanner_holo_ball_01"
local HOLO_SCREEN_VISIBILITY_GROUP = "display_solid"
local HOLO_SCREEN_CONE_VISIBILITY_GROUP = "display_cone"
local OTHER_SCREEN_VISIBILITY_GROUP = "display"
local HOLO_INACTIVE_SIZE = 0.5
local HOLO_MIN_SIZE = 0.5
local HOLO_MAX_SIZE = 1.5
local HOLO_BASE_HIGHT = 0.025
local EMISSIVE_SCREEN_MATERIAL_VARIABLE_NAME = "intensity"
local EMISSIVE_SCREEN_ON = 0.3
local EMISSIVE_SCREEN_OFF = 0.05
local AuspexScanningEffects = class("AuspexScanningEffects")

AuspexScanningEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._is_local_unit = context.is_local_unit
	self._first_person_unit = context.first_person_unit
	self._wwise_world = context.wwise_world
	self._world = context.world
	self._is_server = context.is_server
	local is_husk = context.is_husk
	self._is_husk = is_husk
	local is_local_unit = context.is_local_unit
	self._is_local_unit = is_local_unit
	local owner_unit = context.owner_unit
	local item_unit_1p = slot.unit_1p
	local item_unit_3p = slot.unit_3p
	self._owner_unit = owner_unit
	self._item_unit_1p = item_unit_1p
	self._item_unit_3p = item_unit_3p
	local screen_mesh_1p = Unit.mesh(item_unit_1p, "auspex_scanner_display_solid")
	local screen_mesh_3p = Unit.mesh(item_unit_3p, "auspex_scanner_display_solid")
	self._screen_material_1p = Mesh.material(screen_mesh_1p, 1)
	self._screen_material_3p = Mesh.material(screen_mesh_3p, 1)
	self._weapon_actions = weapon_template.actions
	self._scanner_light_components_1p = Component.get_components_by_name(item_unit_1p, "ScannerLight")
	self._scanner_light_components_3p = Component.get_components_by_name(item_unit_3p, "ScannerLight")
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._first_person_extension = ScriptUnit.has_extension(owner_unit, "first_person_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._scanning_component = unit_data_extension:read_component("scanning")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")

	if not is_husk then
		local search_looping_sound_component_name = PlayerUnitData.looping_sound_component_name(SEARCH_LOOP_ALIAS)
		self._seach_loop_sound_component = unit_data_extension:read_component(search_looping_sound_component_name)
		local confirm_looping_sound_component_name = PlayerUnitData.looping_sound_component_name(CONFIRM_LOOP_ALIAS)
		self._confirm_loop_sound_component = unit_data_extension:read_component(confirm_looping_sound_component_name)
	end

	if is_local_unit then
		self._scanner_display_extension = ScriptUnit.has_extension(item_unit_1p, "scanner_display_system")
	end

	local fx_sources_name = fx_sources[FX_SOURCE_NAME]
	self._fx_source_name = fx_sources_name
	self._high_light_timer = 0
	self._current_distance_paramater = 0
	self._current_angle_parameter = 0
	self._holo_lerps = {}
	self._holo_units = {}
	self._holo_materials = {}
	self._last_active_unit = nil

	if Unit.has_visibility_group(self._item_unit_1p, HOLO_SCREEN_VISIBILITY_GROUP) then
		Unit.set_visibility(self._item_unit_1p, HOLO_SCREEN_VISIBILITY_GROUP, true)
	end

	if Unit.has_visibility_group(self._item_unit_1p, OTHER_SCREEN_VISIBILITY_GROUP) then
		Unit.set_visibility(self._item_unit_1p, OTHER_SCREEN_VISIBILITY_GROUP, false)
	end

	if Unit.has_visibility_group(self._item_unit_3p, HOLO_SCREEN_VISIBILITY_GROUP) then
		Unit.set_visibility(self._item_unit_3p, HOLO_SCREEN_VISIBILITY_GROUP, true)
	end

	if Unit.has_visibility_group(self._item_unit_3p, OTHER_SCREEN_VISIBILITY_GROUP) then
		Unit.set_visibility(self._item_unit_3p, OTHER_SCREEN_VISIBILITY_GROUP, false)
	end
end

AuspexScanningEffects.destroy = function (self)
	self:_stop_searching_sfx_loop()
	self:_set_outline_unit(self._outline_unit, false)

	self._outline_unit = nil
	local player_holo_unit = self._player_holo_unit

	if player_holo_unit then
		World.destroy_unit(self._world, player_holo_unit)
	end

	for i = 1, #self._holo_units do
		World.destroy_unit(self._world, self._holo_units[i])
	end

	table.clear(self._holo_units)
end

AuspexScanningEffects.wield = function (self)
	return
end

AuspexScanningEffects.unwield = function (self)
	self:_set_scanner_light(false)
	self:_stop_searching_sfx_loop()
	self:_stop_confirm_sfx_loop()
	self:_set_outline_unit(self._outline_unit, false)

	self._outline_unit = nil

	self:_stop_scan_units_effects()
end

AuspexScanningEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

AuspexScanningEffects.update_unit_position = function (self, unit, dt, t)
	local is_server = self._is_server
	local is_husk = self._is_husk
	local weapon_action_component = self._weapon_action_component
	local scanning_component = self._scanning_component
	local first_person_component = self._first_person_component
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local scan_settings = action_settings and action_settings.scan_settings
	local is_active, line_of_sight, total_score, angle_score, distance_score, scannable_unit, angle, distance = Scanning.calculate_current_scores(scanning_component, weapon_action_component, first_person_component)
	local scanning_progression = Scanning.scan_confirm_progression(scanning_component, weapon_action_component, t)
	local is_confirming_scanning = scanning_progression ~= nil
	local parameter_max = line_of_sight and 1 or 0.85
	local parameter_min = scannable_unit and 0.4 or 0
	local target_distance = math.lerp(parameter_min, parameter_max, distance_score)
	local target_angle = math.lerp(parameter_min, parameter_max, angle_score)
	local current_distance = math.move_towards(self._current_distance_paramater, target_distance, dt * 6)
	local current_angle = math.move_towards(self._current_angle_parameter, target_angle, dt * 6)
	self._current_distance_paramater = current_distance
	self._current_angle_parameter = current_angle

	if not is_husk then
		if is_active and not is_confirming_scanning then
			self:_start_searching_sfx_loop()
		else
			self:_stop_searching_sfx_loop()
		end

		if is_confirming_scanning then
			self:_start_confirm_sfx_loop()
		else
			self:_stop_confirm_sfx_loop()
		end
	end

	if DEDICATED_SERVER then
		return
	end

	local fx_source = self._fx_extension:sound_source(self._fx_source_name)

	WwiseWorld.set_source_parameter(self._wwise_world, fx_source, WWISE_PARAMETER_NAME_DISTANCE, current_distance)
	WwiseWorld.set_source_parameter(self._wwise_world, fx_source, WWISE_PARAMETER_NAME_ANGLE, current_angle)

	local current_beep = WwiseWorld.get_source_parameter(self._wwise_world, WWISE_PARAMETER_NAME_BEEP_VOLUME, fx_source)
	local current_beep_normalized = 1 - math.clamp01(current_beep / -48)
	local should_light_be_on = is_active and current_beep_normalized > 0.7

	self:_set_scanner_light(should_light_be_on)

	local line_of_sight_unit = line_of_sight and scannable_unit
	local outline_time = self._outline_time or 0
	local outline_unit = self._outline_unit

	if line_of_sight_unit and line_of_sight_unit == outline_unit then
		outline_time = outline_time + dt
	else
		self:_set_outline_unit(outline_unit, false)

		outline_unit = line_of_sight_unit
		outline_time = 0
	end

	local outline_time_theshold = scan_settings and scan_settings.outline_time or 0

	if outline_unit and (outline_time_theshold < outline_time or is_confirming_scanning) then
		self:_set_outline_unit(outline_unit, true)
	end

	self._outline_unit = outline_unit
	self._outline_time = outline_time
	local confirm_unit = is_confirming_scanning and scannable_unit or nil
	local highlight_unit = self._highlight_unit

	if confirm_unit ~= highlight_unit then
		self:_set_highlight_unit(highlight_unit, false)
		self:_set_highlight_unit(confirm_unit, true)

		self._highlight_unit = confirm_unit
	end

	if not scan_settings then
		self:_stop_scan_units_effects()

		return
	end

	self:_set_screen_active(true)

	local first_person_extension = self._first_person_extension
	local is_camera_following = first_person_extension and first_person_extension:is_camera_follow_target()
	local is_in_first_person_mode = first_person_extension and first_person_extension:is_in_first_person_mode()
	local active_unit = is_in_first_person_mode and is_camera_following and self._item_unit_1p or self._item_unit_3p
	local scanner_world_position = Unit.world_position(active_unit, 1)
	local holo_origin_world_pose = Unit.world_pose(active_unit, 2)
	local new_origin = Matrix4x4.translation(holo_origin_world_pose, Vector3.zero()) + Matrix4x4.forward(holo_origin_world_pose) * 0.08
	local new_look = Quaternion.look(Matrix4x4.up(holo_origin_world_pose), -Matrix4x4.forward(holo_origin_world_pose))
	local holo_world_pose = Matrix4x4.from_quaternion_position_scale(new_look, new_origin, Vector3.one())
	local holo_world_pose_inv = Matrix4x4.inverse(holo_world_pose)
	local holo_rotation = Matrix4x4.rotation(holo_world_pose)
	local active_size_lerp_t = not is_confirming_scanning and current_beep_normalized or 1
	local active_size = math.lerp(HOLO_INACTIVE_SIZE, HOLO_MAX_SIZE, active_size_lerp_t)
	local near = scan_settings.distance.near
	local far = scan_settings.distance.far
	local holo_up = Matrix4x4.up(holo_world_pose)
	local holo_foward = Matrix4x4.forward(holo_world_pose)
	local player_horizotal_angle = Vector3.angle(holo_foward, Vector3.flat(holo_foward), true) * math.sign(holo_foward.z)
	local angle_check_vector = holo_foward
	local angle_test = Vector3.angle(holo_foward, Vector3.up())

	if angle_test < math.pi * 0.25 then
		angle_check_vector = -holo_up
	end

	local player_holo_position = Vector3.up() * HOLO_BASE_HIGHT
	local world_player_holo_position = Matrix4x4.transform(holo_world_pose, player_holo_position)
	local is_in_first_person = self._is_in_first_person
	local player_holo_unit = self._player_holo_unit

	if not player_holo_unit then
		player_holo_unit = World.spawn_unit_ex(self._world, PLAYER_HOLO_UNIT_NAME)
		self._player_holo_unit = player_holo_unit

		Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(player_holo_unit, "custom_fov", is_in_first_person)

		local player_holo_mesh = Unit.mesh(player_holo_unit, "g_auspex_scanner_holo_drop_01")
		self._player_holo_material = Mesh.material(player_holo_mesh, 1)
	end

	local player_pose = Matrix4x4.from_quaternion_position_scale(holo_rotation, world_player_holo_position, Vector3.one())

	Unit.set_local_pose(player_holo_unit, 1, player_pose)
	Unit.set_unit_visibility(player_holo_unit, true)
	World.update_unit(self._world, player_holo_unit)

	local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
	local current_scan_mission_zone = mission_objective_zone_system:current_active_zone()
	local holo_units = self._holo_units
	local current_holo_unit = 1

	if current_scan_mission_zone then
		local scanable_units = current_scan_mission_zone:scannable_units()

		for i = 1, #scanable_units do
			local current_scanable_unit = scanable_units[i]
			local scannable_extension = ScriptUnit.has_extension(current_scanable_unit, "mission_objective_zone_scannable_system")
			local is_current_active = scannable_extension:is_active()

			if is_current_active then
				local is_current_scanable_unit = current_scanable_unit == scannable_unit
				local scannable_position = Unit.world_position(current_scanable_unit, 1)
				local to_scannable = scannable_position - scanner_world_position
				local scan_angle = Vector3.angle(to_scannable, Vector3.flat(to_scannable), true) * math.sign(to_scannable.z)
				local diff = scan_angle - player_horizotal_angle
				local normalized_angle_diff = math.clamp(diff / (math.pi * 0.33), -1, 1)
				local distance_to_scannable = Vector3.length(to_scannable)
				local normalized_distance = math.clamp01(math.ilerp(0, far * 0.5, distance_to_scannable))
				local holo_distance = math.lerp(0.02, 0.035, normalized_distance)
				local holo_angle = Vector3.flat_angle(angle_check_vector, to_scannable)
				local rotation = Quaternion.axis_angle(holo_up, holo_angle)
				local to_scannable_on_holo_plane = Quaternion.rotate(rotation, holo_foward) * distance_to_scannable
				local local_hight_scaler = Matrix4x4.transform_without_translation(holo_world_pose_inv, to_scannable_on_holo_plane).y
				local normalized_height_scaler = math.clamp01(math.ilerp(-far * 0.5, far * 0.5, local_hight_scaler))
				local current_height = HOLO_BASE_HIGHT + math.lerp(-0.25 * HOLO_BASE_HIGHT, 0.25 * HOLO_BASE_HIGHT, normalized_height_scaler) + 0.33 * HOLO_BASE_HIGHT * normalized_angle_diff
				local direction_on_holo_plane = Vector3.normalize(to_scannable_on_holo_plane)
				local world_holo_position = new_origin + direction_on_holo_plane * holo_distance + holo_up * current_height
				local normalized_alpha_distance = math.clamp01(math.ilerp(far, near * 0.25, distance_to_scannable))
				local current_lerp = math.lerp(0.2, 1, normalized_alpha_distance)
				local scaled_size = math.lerp(HOLO_MIN_SIZE, HOLO_INACTIVE_SIZE, current_lerp)
				local size = is_current_scanable_unit and active_size or scaled_size
				local holo_unit = holo_units[current_holo_unit]
				current_holo_unit = current_holo_unit + 1

				if not holo_unit then
					holo_unit = World.spawn_unit_ex(self._world, SCAN_HOLO_UNIT_NAME)
					holo_units[#holo_units + 1] = holo_unit
					local holo_mesh = Unit.mesh(holo_unit, "g_auspex_scanner_holo_ball_01")
					local holo_material = Mesh.material(holo_mesh, 1)
					self._holo_materials[holo_unit] = holo_material
				end

				local local_holo_pose = Matrix4x4.from_quaternion_position_scale(Quaternion.identity(), world_holo_position, Vector3.one() * size)

				Unit.set_local_pose(holo_unit, 1, local_holo_pose)
				Unit.set_unit_visibility(holo_unit, true)
				World.update_unit(self._world, holo_unit)
				Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(holo_unit, "custom_fov", is_in_first_person)
			end
		end
	end

	for i = current_holo_unit, #holo_units do
		Unit.set_unit_visibility(holo_units[i], false)
	end
end

AuspexScanningEffects._stop_scan_units_effects = function (self)
	table.clear(self._holo_lerps)

	local player_holo_unit = self._player_holo_unit

	if player_holo_unit then
		Unit.set_unit_visibility(player_holo_unit, false)
	end

	for i = 1, #self._holo_units do
		Unit.set_unit_visibility(self._holo_units[i], false)
	end

	self:_set_screen_active(false)
end

AuspexScanningEffects.update_first_person_mode = function (self, first_person_mode)
	if first_person_mode ~= self._is_in_first_person then
		local holo_units = self._holo_units

		for i = 1, #holo_units do
			local holo_unit = holo_units[i]

			Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(holo_unit, "custom_fov", first_person_mode)
		end

		local player_holo_unit = self._player_holo_unit

		if player_holo_unit then
			Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(player_holo_unit, "custom_fov", first_person_mode)
		end
	end

	self._is_in_first_person = first_person_mode
end

AuspexScanningEffects._start_searching_sfx_loop = function (self)
	if self._is_husk then
		return
	end

	if not self._seach_loop_sound_component.is_playing then
		self._fx_extension:trigger_looping_wwise_event(SEARCH_LOOP_ALIAS, self._fx_source_name)
	end
end

AuspexScanningEffects._stop_searching_sfx_loop = function (self)
	if self._is_husk then
		return
	end

	if self._seach_loop_sound_component.is_playing then
		self._fx_extension:stop_looping_wwise_event(SEARCH_LOOP_ALIAS)
	end
end

AuspexScanningEffects._start_confirm_sfx_loop = function (self)
	if self._is_husk then
		return
	end

	if not self._confirm_loop_sound_component.is_playing then
		self._fx_extension:trigger_looping_wwise_event(CONFIRM_LOOP_ALIAS, self._fx_source_name)
	end
end

AuspexScanningEffects._stop_confirm_sfx_loop = function (self)
	if self._is_husk then
		return
	end

	if self._confirm_loop_sound_component.is_playing then
		self._fx_extension:stop_looping_wwise_event(CONFIRM_LOOP_ALIAS)
	end
end

AuspexScanningEffects._set_outline_unit = function (self, unit, active)
	local scannable_unit_extension = unit and ScriptUnit.has_extension(unit, "mission_objective_zone_scannable_system")

	if scannable_unit_extension then
		scannable_unit_extension:set_scanning_outline(active)
	end

	self._has_outline_unit = active
end

AuspexScanningEffects.has_outline_unit = function (self, unit, active)
	return self._has_outline_unit
end

AuspexScanningEffects._set_highlight_unit = function (self, unit, active)
	local scannable_unit_extension = unit and ScriptUnit.has_extension(unit, "mission_objective_zone_scannable_system")

	if scannable_unit_extension then
		scannable_unit_extension:set_scanning_highlight(active)
	end
end

AuspexScanningEffects.__set_scanner_light = function (self, enebeled, scanner_light_components)
	if not scanner_light_components then
		return
	end

	for i = 1, #scanner_light_components do
		local scanner_light_component = scanner_light_components[i]

		scanner_light_component:enable_lights(enebeled)
	end
end

AuspexScanningEffects._set_scanner_light = function (self, enebeled, color)
	self:__set_scanner_light(enebeled, self._scanner_light_components_1p)
	self:__set_scanner_light(enebeled, self._scanner_light_components_3p)
end

AuspexScanningEffects._set_screen_active = function (self, enabled)
	if self._is_screen_enabled ~= enabled then
		if Unit.has_visibility_group(self._item_unit_1p, HOLO_SCREEN_CONE_VISIBILITY_GROUP) then
			Unit.set_visibility(self._item_unit_1p, HOLO_SCREEN_CONE_VISIBILITY_GROUP, enabled)
		end

		if Unit.has_visibility_group(self._item_unit_3p, HOLO_SCREEN_CONE_VISIBILITY_GROUP) then
			Unit.set_visibility(self._item_unit_3p, HOLO_SCREEN_CONE_VISIBILITY_GROUP, enabled)
		end

		self._is_screen_enabled = enabled
		local emissive_value = enabled and EMISSIVE_SCREEN_ON or EMISSIVE_SCREEN_OFF

		Material.set_scalar(self._screen_material_1p, EMISSIVE_SCREEN_MATERIAL_VARIABLE_NAME, emissive_value)
		Material.set_scalar(self._screen_material_3p, EMISSIVE_SCREEN_MATERIAL_VARIABLE_NAME, emissive_value)
	end
end

return AuspexScanningEffects
