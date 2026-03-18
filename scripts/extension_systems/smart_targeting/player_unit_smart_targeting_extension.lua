-- chunkname: @scripts/extension_systems/smart_targeting/player_unit_smart_targeting_extension.lua

require("scripts/extension_systems/smart_targeting/precision_target_finder")

local Recoil = require("scripts/utilities/recoil")
local SmartTargeting = require("scripts/utilities/smart_targeting")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local Sway = require("scripts/utilities/sway")
local SMART_TAG_TARGETING_DELAY = 0.2
local PlayerUnitSmartTargetingExtension = class("PlayerUnitSmartTargetingExtension")

PlayerUnitSmartTargetingExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._unit = unit
	self._world = extension_init_context.world
	self._player = extension_init_data.player
	self._is_server = extension_init_data.is_server
	self._is_local_unit = extension_init_data.is_local_unit
	self._is_social_hub = extension_init_data.is_social_hub

	local physics_world = extension_init_context.physics_world

	self._physics_world = physics_world
	self._latest_fixed_frame = extension_init_context.fixed_frame
	self._targeting_data = {}
	self._target_unit = nil
	self._smart_tag_targeting_data = {}
	self._smart_tag_targeting_time = 0
	self._precision_target_aim_assist = CLASSES.PrecisionTargetFinder:new(self._is_server, self._is_local_unit, self._player, self._physics_world, unit)

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._unit_data_extension = unit_data_extension
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._inair_state_component = unit_data_extension:read_component("inair_state")
	self._inventory_component = unit_data_extension:read_component("inventory")
	self._locomotion_component = unit_data_extension:read_component("locomotion")
	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._recoil_component = unit_data_extension:read_component("recoil")
	self._recoil_control_component = unit_data_extension:read_component("recoil_control")
	self._sway_component = unit_data_extension:read_component("sway")
	self._sway_control_component = unit_data_extension:read_component("sway_control")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._combat_ability_action_component = unit_data_extension:read_component("combat_ability_action")
	self._grenade_ability_action_component = unit_data_extension:read_component("grenade_ability_action")
	self._target_position_box = Vector3Box(Vector3.zero())
	self._target_rotation_box = QuaternionBox(Quaternion.identity())
	self._visibility_raycast_object = PhysicsWorld.make_raycast(physics_world, "closest", "types", "statics", "collision_filter", "filter_ray_aim_assist_line_of_sight")
	self._line_of_sight_cache = {}
	self._visibility_cache = {}
	self._visibility_check_frame = {}
end

PlayerUnitSmartTargetingExtension.extensions_ready = function (self)
	local unit = self._unit

	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")

	self._precision_target_aim_assist:extensions_ready()
end

PlayerUnitSmartTargetingExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	self._latest_fixed_frame = fixed_frame

	if self._unit_data_extension.is_resimulating then
		table.clear(self._targeting_data)
		table.clear(self._smart_tag_targeting_data)

		return
	end

	if not self._player:is_human_controlled() then
		return
	end

	local smart_targeting_template = SmartTargeting.smart_targeting_template(t, self._weapon_action_component, self._combat_ability_action_component, self._grenade_ability_action_component)

	self._num_visibility_checks_this_frame = 0

	local ray_origin, forward, right, up = self:_targeting_parameters()
	local line_of_sight_cache = self._line_of_sight_cache

	for los_unit, time in pairs(line_of_sight_cache) do
		time = time - dt

		if time < 0 then
			line_of_sight_cache[los_unit] = nil
		else
			line_of_sight_cache[los_unit] = time
		end
	end

	self._precision_target_aim_assist:update_precision_target(unit, smart_targeting_template, ray_origin, forward, right, up, self._targeting_data, fixed_frame, self._visibility_cache, self._visibility_check_frame, line_of_sight_cache)
	self:_update_proximity(unit, smart_targeting_template, ray_origin, forward, right, up)

	if not DEDICATED_SERVER and self._is_local_unit and not self._is_social_hub then
		local update_tag_targets = t >= self._smart_tag_targeting_time

		if update_tag_targets then
			self._precision_target_aim_assist:update_precision_target(unit, SmartTargetingTemplates.smart_tag_target, ray_origin, forward, right, up, self._smart_tag_targeting_data, fixed_frame, self._visibility_cache, self._visibility_check_frame)

			self._smart_tag_targeting_time = t + SMART_TAG_TARGETING_DELAY
		end
	end

	if fixed_frame % 20 == 0 then
		local visibility_check_frame, visibility_cache = self._visibility_check_frame, self._visibility_cache

		for cached_unit, check_frame in pairs(visibility_check_frame) do
			if fixed_frame - check_frame > 5 then
				visibility_cache[cached_unit] = nil
				visibility_check_frame[cached_unit] = nil
			end
		end
	end
end

PlayerUnitSmartTargetingExtension._targeting_parameters = function (self)
	local first_person_component = self._first_person_component
	local ray_origin = first_person_component.position
	local rotation_1p = first_person_component.rotation
	local ray_rotation = first_person_component.rotation
	local weapon_extension = self._weapon_extension
	local recoil_template = weapon_extension:recoil_template()
	local sway_template = weapon_extension:sway_template()
	local movement_state_component = self._movement_state_component
	local locomotion_component = self._locomotion_component
	local inair_state_component = self._inair_state_component

	ray_rotation = Recoil.apply_weapon_recoil_rotation(recoil_template, self._recoil_component, movement_state_component, locomotion_component, inair_state_component, ray_rotation)
	ray_rotation = Sway.apply_sway_rotation(sway_template, self._sway_component, ray_rotation)

	local forward = Quaternion.forward(ray_rotation)
	local right = Quaternion.right(rotation_1p)
	local up = Quaternion.up(rotation_1p)

	return ray_origin, forward, right, up
end

local nearby_target_units = {}
local nearby_target_positions = {}
local nearby_target_distances = {}

PlayerUnitSmartTargetingExtension._update_proximity = function (self, unit, smart_targeting_template, ray_origin, forward, right, up)
	table.clear(nearby_target_units)
	table.clear(nearby_target_positions)
	table.clear(nearby_target_distances)

	local proximity_settings = smart_targeting_template and smart_targeting_template.proximity

	if not proximity_settings then
		return
	end

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local min_range = proximity_settings.min_range
	local max_range = proximity_settings.max_range
	local max_angle = proximity_settings.max_angle
	local distance_weight = proximity_settings.distance_weight
	local angle_weight = proximity_settings.angle_weight
	local max_results = proximity_settings.max_results
	local num_nearby_target_units = EngineOptimized.smart_targeting_query(broadphase, "enemy_aim_target_02", ray_origin, forward, min_range, max_range, max_angle, distance_weight, angle_weight, max_results, nearby_target_units, nearby_target_positions, nearby_target_distances, enemy_side_names)
	local targeting_data = self._targeting_data

	targeting_data.targets_within_range = num_nearby_target_units > 0
end

PlayerUnitSmartTargetingExtension.assisted_hitscan_trajectory = function (self, smart_targeting_template, weapon_template, raw_aim_rotation)
	local targeting_data = self._targeting_data

	return self._precision_target_aim_assist:assisted_hitscan_trajectory(targeting_data, smart_targeting_template, weapon_template, raw_aim_rotation)
end

PlayerUnitSmartTargetingExtension.targeting_data = function (self)
	return self._targeting_data
end

PlayerUnitSmartTargetingExtension.smart_tag_targeting_data = function (self)
	return self._smart_tag_targeting_data
end

PlayerUnitSmartTargetingExtension.has_line_of_sight = function (self, unit)
	return self._line_of_sight_cache[unit] ~= nil
end

PlayerUnitSmartTargetingExtension.force_update_smart_tag_targets = function (self)
	local ray_origin, forward, right, up = self:_targeting_parameters()

	self._precision_target_aim_assist:update_precision_target(self._unit, SmartTargetingTemplates.smart_tag_target, ray_origin, forward, right, up, self._smart_tag_targeting_data, self._latest_fixed_frame, self._visibility_cache, self._visibility_check_frame)
end

return PlayerUnitSmartTargetingExtension
