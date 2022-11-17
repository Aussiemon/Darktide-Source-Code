require("scripts/extension_systems/behavior/nodes/bt_node")

local Armor = require("scripts/utilities/attack/armor")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Trajectory = require("scripts/utilities/trajectory")
local BtBotShootAction = class("BtBotShootAction", "BtNode")
local DEFAULT_AIM_DATA = {
	min_radius_pseudo_random_c = 0.0557,
	max_radius_pseudo_random_c = 0.01475,
	min_radius = math.pi / 72,
	max_radius = math.pi / 16
}
local AIM_TIME = 0.2
local EMPTY_TABLE = {}

BtBotShootAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local input_extension = ScriptUnit.extension(unit, "input_system")
	local bot_unit_input = input_extension:bot_unit_input()
	local soft_aiming = false

	bot_unit_input:set_aiming(true, soft_aiming, true)

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local weapon_template = PlayerUnitVisualLoadout.wielded_weapon_template(visual_loadout_extension, inventory_component)
	local attack_meta_data = weapon_template.attack_meta_data or EMPTY_TABLE
	local weapon_actions = weapon_template.actions
	local aim_action = weapon_actions[attack_meta_data.aim_action_name or "action_zoom"] or EMPTY_TABLE
	local unaim_action = weapon_actions[attack_meta_data.unaim_action_name or "action_unzoom"] or EMPTY_TABLE
	local attack_action = weapon_actions[attack_meta_data.fire_action_name or "action_shoot"] or EMPTY_TABLE
	local aim_attack_action = weapon_actions[attack_meta_data.aim_fire_action_name or "action_shoot_zoomed"] or EMPTY_TABLE
	local fire_configuration = attack_action.fire_configuration or EMPTY_TABLE
	local projectile_template = fire_configuration.projectile
	local charged_attack_action = attack_action[attack_meta_data.charged_attack_action_name or "action_shoot_charged"] or attack_action
	local charged_fire_configuration = charged_attack_action.fire_configuration or EMPTY_TABLE
	local projectile_template_charged = charged_fire_configuration.projectile
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local perception_component = blackboard.perception
	local spawn_component = blackboard.spawn
	local behavior_component = blackboard.behavior
	scratchpad.action_input_extension = ScriptUnit.extension(unit, "action_input_system")
	scratchpad.aim_data = attack_meta_data.aim_data or DEFAULT_AIM_DATA
	scratchpad.aim_data_charged = attack_meta_data.aim_data_charged or scratchpad.aim_data
	scratchpad.aim_at_node = attack_meta_data.aim_at_node or "j_spine"
	scratchpad.aim_at_node_charged = attack_meta_data.aim_at_node_charged or attack_meta_data.aim_at_node or "j_spine"
	scratchpad.aim_speed_yaw = 0
	scratchpad.always_charge_before_firing = attack_meta_data.always_charge_before_firing
	scratchpad.attack_meta_data = attack_meta_data
	scratchpad.bot_unit_input = bot_unit_input
	scratchpad.can_charge_shot = attack_meta_data.can_charge_shot
	scratchpad.charge_action_input = attack_meta_data.charge_action_input or "brace"
	scratchpad.charge_against_armored_enemy = attack_meta_data.charge_against_armored_enemy
	scratchpad.charge_range_sq = attack_meta_data.charge_above_range and attack_meta_data.charge_above_range^2 or nil
	scratchpad.charge_shot_delay = attack_meta_data.charge_shot_delay
	scratchpad.charge_start_time = nil
	scratchpad.charge_when_obstructed = attack_meta_data.charge_when_obstructed or false
	scratchpad.charge_when_outside_max_range = attack_meta_data.charge_when_outside_max_range
	scratchpad.charge_when_outside_max_range_charged = attack_meta_data.charge_when_outside_max_range_charged == nil or attack_meta_data.charge_when_outside_max_range_charged
	scratchpad.charging_shot = false
	scratchpad.collision_filter = nil
	scratchpad.collision_filter_charged = nil
	scratchpad.unaim_action_input = attack_meta_data.unaim_action_input or unaim_action.start_input or "unzoom"
	scratchpad.aim_action_input = attack_meta_data.aim_action_input or aim_action.start_input or "zoom"
	scratchpad.fire_action_input = attack_meta_data.fire_action_input or attack_action.start_input or "shoot"
	scratchpad.aim_fire_action_input = attack_meta_data.aim_fire_action_input or aim_attack_action.start_input or "zoom_shoot"
	scratchpad.fired = false
	scratchpad.first_person_component = unit_data_extension:read_component("first_person")
	scratchpad.max_range_sq = attack_meta_data.max_range and attack_meta_data.max_range^2 or math.huge
	scratchpad.max_range_sq_charged = attack_meta_data.max_range_charged and attack_meta_data.max_range_charged^2 or scratchpad.max_range_sq
	scratchpad.minimum_charge_time = attack_meta_data.minimum_charge_time
	scratchpad.next_charge_shot_t = t
	scratchpad.next_evaluate = t + action_data.evaluation_duration
	scratchpad.next_evaluate_without_firing = t + action_data.evaluation_duration_without_firing
	scratchpad.num_aim_rolls = 0
	scratchpad.obstructed = false
	scratchpad.obstruction_fuzzyness_range = attack_meta_data.obstruction_fuzzyness_range
	scratchpad.obstruction_fuzzyness_range_charged = attack_meta_data.obstruction_fuzzyness_range_charged or scratchpad.obstruction_fuzzyness_range
	scratchpad.perception_component = perception_component
	scratchpad.physics_world = spawn_component.physics_world
	scratchpad.projectile_template = projectile_template
	scratchpad.projectile_template_charged = projectile_template_charged
	scratchpad.reevaluate_aim_time = t
	scratchpad.reevaluate_obstruction_time = t
	scratchpad.side = side
	scratchpad.target_unit = nil
	scratchpad.target_breed = nil
	scratchpad.weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	scratchpad.ranged_gestalt = behavior_component.ranged_gestalt
	scratchpad.aiming_shot = false
	scratchpad.aim_done_t = 0
	local ranged_obstructed_by_static_component = Blackboard.write_component(blackboard, "ranged_obstructed_by_static")
	ranged_obstructed_by_static_component.t = -math.huge
	ranged_obstructed_by_static_component.target_unit = nil
	scratchpad.ranged_obstructed_by_static_component = ranged_obstructed_by_static_component
	local target_unit = perception_component.target_enemy

	self:_set_new_aim_target(t, target_unit, scratchpad, action_data)
end

BtBotShootAction._set_new_aim_target = function (self, t, target_unit, scratchpad, action_data)
	local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")

	if target_unit_data_extension then
		local breed = target_unit_data_extension:breed()
		scratchpad.target_breed = breed
	end

	scratchpad.aim_speed_yaw = 0
	scratchpad.target_unit = target_unit
	scratchpad.obstructed = false
	scratchpad.reevaluate_obstruction_time = t

	if self:_should_aim(t, scratchpad, action_data) then
		self:_start_aiming(t, scratchpad)
	else
		self:_stop_aiming(scratchpad)
	end
end

BtBotShootAction._should_aim = function (self, t, scratchpad, action_data)
	local ranged_gestalt = scratchpad.ranged_gestalt
	local gestalt_behavior = action_data.gestalt_behaviors[ranged_gestalt]

	return gestalt_behavior.wants_aim
end

BtBotShootAction._start_aiming = function (self, t, scratchpad)
	if not scratchpad.aiming_shot then
		scratchpad.aiming_shot = true
		scratchpad.aim_done_t = t + AIM_TIME
		local action_input_extension = scratchpad.action_input_extension
		local aim_action_input = scratchpad.aim_action_input
		local raw_input = nil

		action_input_extension:bot_queue_action_input("weapon_action", aim_action_input, raw_input)
	end
end

BtBotShootAction._stop_aiming = function (self, scratchpad)
	if scratchpad.aiming_shot then
		scratchpad.aiming_shot = false
		scratchpad.aim_done_t = 0
		local action_input_extension = scratchpad.action_input_extension
		local unaim_action_input = scratchpad.unaim_action_input
		local raw_input = nil

		action_input_extension:bot_queue_action_input("weapon_action", unaim_action_input, raw_input)
	end
end

BtBotShootAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local bot_unit_input = scratchpad.bot_unit_input

	bot_unit_input:set_aiming(false)
	self:_clear_pending_attack(scratchpad)
	self:_stop_aiming(scratchpad)
end

BtBotShootAction._clear_pending_attack = function (self, scratchpad)
	local action_input_extension = scratchpad.action_input_extension

	action_input_extension:bot_queue_clear_requests("weapon_action")
	action_input_extension:clear_input_queue_and_sequences("weapon_action")

	local weapon_extension = scratchpad.weapon_extension
	local interrupt_data = {}
	local fixed_t = FixedFrame.get_latest_fixed_time()

	weapon_extension:stop_action("bot_left_node", interrupt_data, fixed_t)
end

BtBotShootAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local done, evaluate = self:_update_aim(unit, scratchpad, action_data, dt, t)

	if done then
		return "done"
	else
		return "running", evaluate
	end
end

BtBotShootAction._update_aim = function (self, unit, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_enemy

	if target_unit ~= scratchpad.target_unit then
		self:_set_new_aim_target(t, target_unit, scratchpad, action_data)
	end

	local first_person_component = scratchpad.first_person_component
	local camera_position = first_person_component.position
	local camera_rotation = first_person_component.rotation
	local yaw_offset, pitch_offset, wanted_aim_rotation, actual_aim_rotation, actual_aim_position = self:_aim_position(unit, scratchpad, dt, camera_position, camera_rotation, target_unit)

	if scratchpad.reevaluate_obstruction_time <= t then
		local ranged_obstructed_by_static_component = scratchpad.ranged_obstructed_by_static_component

		if self:_reevaluate_obstruction(unit, scratchpad, action_data, t, camera_position, wanted_aim_rotation, actual_aim_position, target_unit) then
			ranged_obstructed_by_static_component.t = t
			ranged_obstructed_by_static_component.target_unit = target_unit
		else
			ranged_obstructed_by_static_component.t = -math.huge
			ranged_obstructed_by_static_component.target_unit = nil
		end
	end

	local bot_unit_input = scratchpad.bot_unit_input
	local range_squared = Vector3.distance_squared(camera_position, actual_aim_position)

	if self:_should_charge(scratchpad, range_squared, target_unit, t) then
		self:_charge_shot(scratchpad, action_data, bot_unit_input, t)
	end

	bot_unit_input:set_aim_rotation(actual_aim_rotation)

	local fire_input_request_id = scratchpad.fire_input_request_id

	if fire_input_request_id then
		local action_input_extension = scratchpad.action_input_extension

		if action_input_extension:bot_queue_request_is_consumed("weapon_action", fire_input_request_id) then
			scratchpad.fire_input_request_id = nil
		end
	end

	if self:_aim_good_enough(unit, dt, t, scratchpad, yaw_offset, pitch_offset) and self:_may_fire(unit, scratchpad, range_squared, t) then
		self:_fire(scratchpad, action_data, bot_unit_input, t)
	end

	local evaluate = scratchpad.fired and scratchpad.next_evaluate < t or scratchpad.next_evaluate_without_firing < t

	if evaluate then
		scratchpad.next_evaluate = t + action_data.evaluation_duration
		scratchpad.next_evaluate_without_firing = t + action_data.evaluation_duration_without_firing
		scratchpad.fired = false
	end

	return false, evaluate
end

local PI = math.pi
local TWO_PI = math.two_pi

BtBotShootAction._aim_position = function (self, self_unit, scratchpad, dt, current_position, current_rotation, target_unit)
	local projectile_template, aim_at_node = nil
	local target_breed = scratchpad.target_breed

	if scratchpad.charging_shot then
		projectile_template = scratchpad.projectile_template_charged
		aim_at_node = target_breed and target_breed.override_bot_target_node or scratchpad.aim_at_node_charged
	else
		projectile_template = scratchpad.projectile_template
		aim_at_node = target_breed and target_breed.override_bot_target_node or scratchpad.aim_at_node
	end

	local wanted_rotation, aim_position = self:_wanted_aim_rotation(self_unit, target_unit, target_breed, current_position, projectile_template, aim_at_node)
	local current_yaw, current_pitch, _ = Quaternion.to_yaw_pitch_roll(current_rotation)
	local wanted_yaw, wanted_pitch, _ = Quaternion.to_yaw_pitch_roll(wanted_rotation)
	local yaw_speed, pitch_speed = self:_calculate_aim_speed(dt, current_yaw, current_pitch, wanted_yaw, wanted_pitch, scratchpad.aim_speed_yaw)
	scratchpad.aim_speed_yaw = yaw_speed
	local new_yaw = current_yaw + yaw_speed * dt
	local new_pitch = current_pitch + pitch_speed * dt
	local actual_rotation = Quaternion.from_yaw_pitch_roll(new_yaw, new_pitch, 0)
	local yaw_offset = (new_yaw - wanted_yaw + PI) % TWO_PI - PI
	local pitch_offset = new_pitch - wanted_pitch

	return yaw_offset, pitch_offset, wanted_rotation, actual_rotation, aim_position
end

local ACCEPTABLE_ACCURACY = 0.1

BtBotShootAction._wanted_aim_rotation = function (self, self_unit, target_unit, target_breed, current_position, projectile_template, aim_at_node)
	local target_node = Unit.node(target_unit, aim_at_node)
	local target_node_position = Unit.world_position(target_unit, target_node)
	local target_rotation, target_position = nil

	if projectile_template and projectile_template.gravity then
		local angle = nil
		local target_current_velocity = self:_target_velocity(target_unit, target_breed)
		local projectile_speed = projectile_template.speed
		local projectile_gravity = projectile_template.gravity
		angle, target_position = Trajectory.angle_to_hit_moving_target(current_position, target_node_position, projectile_speed, target_current_velocity, projectile_gravity, ACCEPTABLE_ACCURACY, false)
		angle = angle or math.pi * 0.25
		target_rotation = Quaternion.multiply(Quaternion.look(Vector3.normalize(Vector3.flat(target_position - current_position)), Vector3.up()), Quaternion(Vector3.right(), angle))
	else
		target_position = target_node_position
		target_rotation = Quaternion.look(Vector3.normalize(target_position - current_position), Vector3.up())
	end

	return target_rotation, target_position
end

BtBotShootAction._target_velocity = function (self, target_unit, target_breed)
	local target_velocity = nil

	if Breed.is_player(target_breed) then
		local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
		local locomotion_component = target_unit_data_extension:read_component("locomotion")
		target_velocity = locomotion_component.velocity_current
	elseif target_breed then
		local target_locomotion_extension = ScriptUnit.extension(target_unit, "locomotion_system")
		target_velocity = target_locomotion_extension:current_velocity()
	else
		target_velocity = Vector3.zero()
	end

	return target_velocity
end

local YAW_ACCELERATION = 7.5
local YAW_DECELERATION = 25

BtBotShootAction._calculate_aim_speed = function (self, dt, current_yaw, current_pitch, wanted_yaw, wanted_pitch, current_yaw_speed)
	local yaw_offset = (wanted_yaw - current_yaw + PI) % TWO_PI - PI
	local wanted_yaw_speed = yaw_offset * math.pi * 10
	local new_yaw_speed = nil
	local yaw_offset_sign = math.sign(yaw_offset)
	local yaw_speed_sign = math.sign(current_yaw_speed)
	local has_overshot = yaw_speed_sign ~= 0 and yaw_offset_sign ~= yaw_speed_sign

	if has_overshot and yaw_offset_sign > 0 then
		new_yaw_speed = math.min(current_yaw_speed + YAW_DECELERATION * dt, 0)
	elseif has_overshot then
		new_yaw_speed = math.max(current_yaw_speed - YAW_DECELERATION * dt, 0)
	elseif yaw_offset_sign > 0 then
		if current_yaw_speed <= wanted_yaw_speed then
			new_yaw_speed = math.min(current_yaw_speed + YAW_ACCELERATION * dt, wanted_yaw_speed)
		else
			new_yaw_speed = math.max(current_yaw_speed - YAW_DECELERATION * dt, wanted_yaw_speed)
		end
	elseif wanted_yaw_speed <= current_yaw_speed then
		new_yaw_speed = math.max(current_yaw_speed - YAW_ACCELERATION * dt, wanted_yaw_speed)
	else
		new_yaw_speed = math.min(current_yaw_speed + YAW_DECELERATION * dt, wanted_yaw_speed)
	end

	local pitch_offset = wanted_pitch - current_pitch
	local lerped_pitch_speed = pitch_offset / dt

	return new_yaw_speed, lerped_pitch_speed
end

BtBotShootAction._reevaluate_obstruction = function (self, self_unit, scratchpad, action_data, t, ray_from, wanted_aim_rotation, actual_aim_position, target_unit)
	self:_update_collision_filter(target_unit, scratchpad)

	local charging_shot = scratchpad.charging_shot
	local ignore_allies = charging_shot and scratchpad.ignore_hitting_allies_charged or not charging_shot and scratchpad.ignore_hitting_allies
	local ignore_enemies = charging_shot and scratchpad.ignore_hitting_enemies_charged or not charging_shot and scratchpad.ignore_hitting_enemies
	local direction = Quaternion.forward(wanted_aim_rotation)
	local collision_filter = charging_shot and scratchpad.collision_filter_charged or scratchpad.collision_filter
	local obstructed, distance_from_target, obstructed_by_static = self:_is_shot_obstructed(self_unit, scratchpad, collision_filter, ray_from, direction, target_unit, actual_aim_position, ignore_allies, ignore_enemies)
	local fuzzyness = nil

	if obstructed then
		fuzzyness = charging_shot and scratchpad.obstruction_fuzzyness_range_charged or scratchpad.obstruction_fuzzyness_range

		if fuzzyness and distance_from_target <= fuzzyness then
			obstructed = false
		end
	end

	local min = action_data.minimum_obstruction_reevaluation_time
	local max = action_data.maximum_obstruction_reevaluation_time
	scratchpad.obstructed = obstructed
	scratchpad.reevaluate_obstruction_time = t + math.random_range(min, max)

	return obstructed_by_static
end

BtBotShootAction._update_collision_filter = function (self, target_unit, scratchpad)
	local perception_component = scratchpad.perception_component
	local target_ally_unit = perception_component.target_ally
	local target_ally_need_type = perception_component.target_ally_need_type
	local priority_target_enemy = perception_component.priority_target_enemy
	local target_blackboard = BLACKBOARDS[target_unit]
	local target_perception_component = target_blackboard and target_blackboard.perception
	local has_important_target = target_unit == priority_target_enemy or target_perception_component and target_perception_component.target_unit == target_ally_unit and (target_ally_need_type == "knocked_down" or target_ally_need_type == "ledge")

	if has_important_target then
		scratchpad.collision_filter = "filter_player_character_shooting_raycast_statics"
		scratchpad.collision_filter_charged = "filter_player_character_shooting_raycast_statics"

		return
	end

	local attack_meta_data = scratchpad.attack_meta_data
	local ignore_enemies_for_obstruction = attack_meta_data.ignore_enemies_for_obstruction
	local ignore_enemies_for_obstruction_charged = attack_meta_data.ignore_enemies_for_obstruction_charged == nil and ignore_enemies_for_obstruction or attack_meta_data.ignore_enemies_for_obstruction_charged
	local ff_ranged = true
	local ignore_hitting_allies, ignore_hitting_allies_charged = nil

	if ff_ranged then
		ignore_hitting_allies_charged = attack_meta_data.ignore_allies_for_obstruction_charged
		ignore_hitting_allies = attack_meta_data.ignore_allies_for_obstruction
	else
		ignore_hitting_allies_charged = true
		ignore_hitting_allies = true
	end

	scratchpad.ignore_hitting_allies_charged = ignore_hitting_allies_charged
	scratchpad.ignore_hitting_allies = ignore_hitting_allies
	scratchpad.ignore_hitting_enemies_charged = ignore_enemies_for_obstruction_charged
	scratchpad.ignore_hitting_enemies = ignore_enemies_for_obstruction
	scratchpad.collision_filter = ignore_enemies_for_obstruction and ignore_hitting_allies and "filter_player_character_shooting_raycast_statics" or "filter_player_character_shooting_raycast"
	scratchpad.collision_filter_charged = ignore_enemies_for_obstruction_charged and ignore_hitting_allies_charged and "filter_player_character_shooting_raycast_statics" or "filter_player_character_shooting_raycast"
end

local INDEX_DISTANCE = 2
local INDEX_ACTOR = 4
local AFRO_HITZONE = HitZone.hit_zone_names.afro

BtBotShootAction._is_shot_obstructed = function (self, self_unit, scratchpad, collision_filter, from, direction, target_unit, actual_aim_position, ignore_allies, ignore_enemies)
	local physics_world = scratchpad.physics_world
	local max_distance = Vector3.distance(from, actual_aim_position)
	local raycast_hits = PhysicsWorld.raycast(physics_world, from, direction, max_distance, "all", "collision_filter", collision_filter)

	if not raycast_hits then
		return false
	end

	local side = scratchpad.side
	local allied_units_lookup = side.allied_units_lookup
	local enemy_units_lookup = side.enemy_units_lookup
	local Actor_unit = Actor.unit
	local HitZone_get_name = HitZone.get_name
	local Health_is_ragdolled = Health.is_ragdolled
	local num_hits = #raycast_hits

	for i = 1, num_hits do
		repeat
			local hit = raycast_hits[i]
			local hit_actor = hit[INDEX_ACTOR]
			local hit_unit = Actor_unit(hit_actor)
			local hit_zone_name_or_nil = HitZone_get_name(hit_unit, hit_actor)

			if hit_zone_name_or_nil ~= AFRO_HITZONE and (not allied_units_lookup[hit_unit] or not ignore_allies) then
				if enemy_units_lookup[hit_unit] and ignore_enemies then
					break
					break
				end

				if hit_unit == target_unit then
					return false
				elseif hit_unit ~= self_unit and not Health_is_ragdolled(hit_unit) then
					local obstructed_by_static = Actor.is_static(hit_actor)

					return true, max_distance - hit[INDEX_DISTANCE], obstructed_by_static
				end
			end
		until true
	end

	return false
end

local ARMORED = ArmorSettings.types.armored

BtBotShootAction._should_charge = function (self, scratchpad, range_squared, target_unit, t)
	local next_charge_shot_t = scratchpad.next_charge_shot_t

	if not scratchpad.can_charge_shot or t < next_charge_shot_t then
		return false
	end

	local max_range_sq_charged = scratchpad.max_range_sq_charged

	if max_range_sq_charged < range_squared and not scratchpad.charge_when_outside_max_range_charged then
		return false
	end

	if scratchpad.obstructed then
		return scratchpad.charge_when_obstructed
	end

	local max_range_sq = scratchpad.max_range_sq

	if max_range_sq < range_squared then
		return scratchpad.charge_when_outside_max_range
	end

	if scratchpad.charging_shot then
		return true
	end

	local weapon_extension = scratchpad.weapon_extension
	local charge_action_input = scratchpad.charge_action_input
	local used_input = nil
	local fixed_t = FixedFrame.get_latest_fixed_time()
	local action_input_is_valid = weapon_extension:action_input_is_currently_valid("weapon_action", charge_action_input, used_input, fixed_t)

	if not action_input_is_valid then
		return false
	end

	if scratchpad.always_charge_before_firing or scratchpad.charge_range_sq and scratchpad.charge_range_sq <= range_squared then
		return true
	end

	local target_breed = scratchpad.target_breed
	local target_armor = Armor.armor_type(target_unit, target_breed)

	return scratchpad.charge_against_armored_enemy and target_armor == ARMORED
end

BtBotShootAction._charge_shot = function (self, scratchpad, action_data, bot_unit_input, t)
	if not scratchpad.charging_shot then
		scratchpad.charge_start_time = t
		scratchpad.charging_shot = true
		local action_input_extension = scratchpad.action_input_extension
		local charge_action_input = scratchpad.charge_action_input
		local raw_input = nil

		action_input_extension:bot_queue_action_input("weapon_action", charge_action_input, raw_input)
	end
end

local AIM_REEVALUATION_INTERVAL = 0.1

BtBotShootAction._aim_good_enough = function (self, unit, dt, t, scratchpad, yaw_offset, pitch_offset)
	if scratchpad.reevaluate_aim_time < t then
		local aim_data = scratchpad.charging_shot and scratchpad.aim_data_charged or scratchpad.aim_data
		local offset = math.sqrt(pitch_offset * pitch_offset + yaw_offset * yaw_offset)

		if aim_data.max_radius < offset then
			scratchpad.aim_good_enough = false
		else
			local success = nil
			local num_rolls = scratchpad.num_aim_rolls + 1

			if offset < aim_data.min_radius then
				success = math.random() < aim_data.min_radius_pseudo_random_c * num_rolls
			else
				local prob = math.auto_lerp(aim_data.min_radius, aim_data.max_radius, aim_data.min_radius_pseudo_random_c, aim_data.max_radius_pseudo_random_c, offset) * num_rolls
				success = math.random() < prob
			end

			if success then
				scratchpad.num_aim_rolls = 0
				scratchpad.aim_good_enough = true
			else
				scratchpad.num_aim_rolls = num_rolls
				scratchpad.aim_good_enough = false
			end
		end

		scratchpad.reevaluate_aim_time = t + AIM_REEVALUATION_INTERVAL
	end

	return scratchpad.aim_good_enough
end

BtBotShootAction._may_fire = function (self, unit, scratchpad, range_squared, t)
	if scratchpad.fire_input_request_id then
		return false
	end

	if scratchpad.obstructed then
		return false
	end

	if scratchpad.aiming_shot and t < scratchpad.aim_done_t then
		return false
	end

	local charging = scratchpad.charging_shot
	local minimum_charge_time = scratchpad.minimum_charge_time
	local sufficiently_charged = not minimum_charge_time or not scratchpad.always_charge_before_firing and not charging or charging and minimum_charge_time <= t - scratchpad.charge_start_time
	local max_range_sq = charging and scratchpad.max_range_sq_charged or scratchpad.max_range_sq
	local may_fire = sufficiently_charged and range_squared < max_range_sq

	if not may_fire then
		return false
	end

	local weapon_extension = scratchpad.weapon_extension
	local fire_action_input = scratchpad.fire_action_input
	local used_input = nil
	local fixed_t = FixedFrame.get_latest_fixed_time()
	local action_input_is_valid = weapon_extension:action_input_is_currently_valid("weapon_action", fire_action_input, used_input, fixed_t)

	return action_input_is_valid
end

BtBotShootAction._fire = function (self, scratchpad, action_data, bot_unit_input, t)
	scratchpad.fired = true
	scratchpad.charge_start_time = nil
	scratchpad.charging_shot = false
	local action_input_extension = scratchpad.action_input_extension
	local aiming_shot = scratchpad.aiming_shot
	local fire_action_input = scratchpad.fire_action_input
	local aim_fire_action_input = scratchpad.aim_fire_action_input
	local action_input = aiming_shot and aim_fire_action_input or fire_action_input
	local raw_input = nil
	scratchpad.fire_input_request_id = action_input_extension:bot_queue_action_input("weapon_action", action_input, raw_input)

	if scratchpad.charge_shot_delay then
		scratchpad.next_charge_shot_t = t + scratchpad.charge_shot_delay
	end
end

return BtBotShootAction
