local AiBrain = require("scripts/extension_systems/behavior/ai_brain")
local Ammo = require("scripts/utilities/ammo")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BotSettings = require("scripts/settings/bot/bot_settings")
local Health = require("scripts/utilities/health")
local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local BotBehaviorExtension = class("BotBehaviorExtension")
local FOLLOW_TIMER_LOWER_BOUND = 1
local FOLLOW_TIMER_UPPER_BOUND = 1.5
local behavior_gestalts = BotSettings.behavior_gestalts

BotBehaviorExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._unit = unit
	self._nav_world = extension_init_context.nav_world
	self._player = extension_init_data.player
	local blackboard = BLACKBOARDS[unit]
	local physics_world = extension_init_context.physics_world
	local gestalts_or_nil = extension_init_data.optional_gestalts

	self:_init_blackboard_components(blackboard, physics_world, gestalts_or_nil)

	self._cover_data = {
		fails = 0,
		cover_position = Vector3Box(Vector3.invalid_vector()),
		threats = {},
		active_threats = {},
		failed_cover_positions = {}
	}
	self._using_navigation_destination_override = false
	self._hold_position = nil
	self._hold_position_max_distance_sq = math.huge
	self._follow_timer = math.lerp(FOLLOW_TIMER_LOWER_BOUND, FOLLOW_TIMER_UPPER_BOUND, math.random())
	self._stay_near_player_range = math.huge
	self._stay_near_player = false
	self._attempted_enemy_paths = {}
	self._attempted_ally_paths = {}
	self._last_health_pickup_attempt = {
		path_failed = false,
		distance = 0,
		index = 1,
		blacklist = false,
		rotation = QuaternionBox(),
		path_position = Vector3Box()
	}
	self._last_mule_pickup_attempt = {
		path_failed = false,
		distance = 0,
		index = 1,
		blacklist = false,
		rotation = QuaternionBox(),
		path_position = Vector3Box()
	}
	self._hit_by_projectile = {}
	local breed = extension_init_data.breed
	local behavior_tree_name = extension_init_data.behavior_tree_name

	self:_init_brain(unit, breed, blackboard, behavior_tree_name)
	self:_set_nav_spawn_points()
end

BotBehaviorExtension.on_gameplay_post_init = function (self, level)
	self:_set_nav_spawn_points()
end

BotBehaviorExtension._set_nav_spawn_points = function (self)
	local main_path_manager = Managers.state.main_path
	local nav_spawn_points = main_path_manager:nav_spawn_points()
	self._nav_spawn_points = nav_spawn_points
end

BotBehaviorExtension._init_brain = function (self, unit, breed, blackboard, behavior_tree_name)
	local behavior_system = Managers.state.extension:system("behavior_system")
	local behavior_tree = behavior_system:behavior_tree(behavior_tree_name)
	self._brain = AiBrain:new(unit, breed, blackboard, behavior_tree)
end

local NO_GESTALTS = {
	melee = behavior_gestalts.none,
	ranged = behavior_gestalts.none
}

local function _gestalts_or_default(gestalts_or_nil)
	local gestalts = gestalts_or_nil or NO_GESTALTS
	gestalts.melee = gestalts.melee or NO_GESTALTS.melee
	gestalts.ranged = gestalts.ranged or NO_GESTALTS.ranged

	return gestalts
end

BotBehaviorExtension._init_blackboard_components = function (self, blackboard, physics_world, gestalts_or_nil)
	local gestalts = _gestalts_or_default(gestalts_or_nil)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.current_interaction_unit = nil
	behavior_component.forced_pickup_unit = nil
	behavior_component.melee_gestalt = gestalts.melee
	behavior_component.interaction_unit = nil
	behavior_component.ranged_gestalt = gestalts.ranged
	behavior_component.revive_with_urgent_target = false

	behavior_component.target_ally_aid_destination:store(0, 0, 0)
	behavior_component.target_level_unit_destination:store(0, 0, 0)

	local follow_component = Blackboard.write_component(blackboard, "follow")

	follow_component.destination:store(0, 0, 0)

	follow_component.has_teleported = false
	follow_component.moving_towards_follow_position = false
	follow_component.needs_destination_refresh = false
	follow_component.level_forced_teleport = false

	follow_component.level_forced_teleport_position:store(Vector3.zero())

	local pickup_component = Blackboard.write_component(blackboard, "pickup")
	pickup_component.allowed_to_take_health_pickup = false
	pickup_component.ammo_pickup = nil
	pickup_component.ammo_pickup_distance = math.huge
	pickup_component.ammo_pickup_valid_until = -math.huge
	pickup_component.force_use_health_pickup = false
	pickup_component.health_deployable = nil
	pickup_component.health_deployable_distance = math.huge
	pickup_component.health_deployable_valid_until = -math.huge
	pickup_component.mule_pickup = nil
	pickup_component.mule_pickup_distance = math.huge
	pickup_component.needs_ammo = false
	pickup_component.needs_non_permanent_health = false
	local health_station_component = Blackboard.write_component(blackboard, "health_station")
	health_station_component.needs_health = false
	health_station_component.needs_health_queue_number = 0
	health_station_component.time_in_proximity = 0
	local ranged_obstructed_by_static_component = Blackboard.write_component(blackboard, "ranged_obstructed_by_static")
	ranged_obstructed_by_static_component.t = -math.huge
	ranged_obstructed_by_static_component.target_unit = nil
	local spawn_component = Blackboard.write_component(blackboard, "spawn")
	spawn_component.physics_world = physics_world
	self._behavior_component = behavior_component
	self._follow_component = follow_component
	self._melee_component = blackboard.melee
	self._perception_component = blackboard.perception
	self._pickup_component = pickup_component
	self._health_station_component = health_station_component
	self._ranged_obstructed_by_static_component = ranged_obstructed_by_static_component
end

BotBehaviorExtension.destroy = function (self)
	local time_manager = Managers.time
	local t = time_manager:time("gameplay")

	self._brain:destroy(t)

	local cover_data = self._cover_data

	if cover_data.cover_hash then
		local bot_group = self._bot_group

		bot_group:set_in_cover(self._unit, nil)
	end
end

BotBehaviorExtension.extensions_ready = function (self, world, unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._character_state_component = unit_data_extension:read_component("character_state")
	self._inair_state_component = unit_data_extension:read_component("inair_state")
	self._interaction_component = unit_data_extension:read_component("interaction")
	self._locomotion_component = unit_data_extension:read_component("locomotion")
	local group_extension = ScriptUnit.extension(unit, "group_system")
	self._group_extension = group_extension
	self._bot_group = group_extension:bot_group()
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	self._navigation_extension = navigation_extension
	self._traverse_logic = navigation_extension:traverse_logic()
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[self._unit]
	self._side = side
end

BotBehaviorExtension.update = function (self, unit, dt, t, ...)
	if self._player:is_human_controlled() then
		return
	end

	if HEALTH_ALIVE[unit] then
		self:_update_ammo(unit)
		self:_update_health_deployables(unit)
		self:_update_health_stations(unit, dt, t)
		self:_verify_target_ally_aid_destination(unit)
		self._brain:update(unit, dt, t)

		local locomotion_component = self._locomotion_component
		local in_air_state_component = self._inair_state_component
		local is_disabled = PlayerUnitStatus.is_disabled(self._character_state_component)
		local is_on_moveable_platform = locomotion_component.parent_unit ~= nil

		if is_disabled or is_on_moveable_platform then
			local self_position = POSITION_LOOKUP[unit]

			self._navigation_extension:teleport(self_position)
		elseif in_air_state_component.on_ground then
			self:_handle_doors(unit)
			self:_update_movement_target(unit, dt, t)
		end

		local hit_by_projectile = self._hit_by_projectile

		for attacking_unit, _ in pairs(hit_by_projectile) do
			if not HEALTH_ALIVE[attacking_unit] then
				hit_by_projectile[attacking_unit] = nil
			end
		end
	end
end

local NEEDS_AMMO_PERCENTAGE = 0.75
local NEEDS_AMMO_PERCENTAGE_COMBAT = 0.1

BotBehaviorExtension._update_ammo = function (self, unit)
	local pickup_component = self._pickup_component
	local ammo_percentage = Ammo.current_total_percentage(unit)

	if ammo_percentage < 1 then
		local bot_group = self._bot_group
		local has_ammo_pickup_order = bot_group:ammo_pickup_order_unit(unit) ~= nil

		if has_ammo_pickup_order then
			pickup_component.needs_ammo = true

			return
		end

		local has_the_least_ammo = true
		local human_player_units = self._side.valid_human_units

		for i = 1, #human_player_units do
			local human_unit = human_player_units[i]
			local human_ammo_percentage = Ammo.current_total_percentage(human_unit)

			if human_ammo_percentage < ammo_percentage then
				has_the_least_ammo = false

				break
			end
		end

		if has_the_least_ammo then
			local perception_component = self._perception_component
			local target_enemy = perception_component.priority_target_enemy or perception_component.target_enemy
			local max_ammo_percentage = target_enemy and NEEDS_AMMO_PERCENTAGE_COMBAT or NEEDS_AMMO_PERCENTAGE
			pickup_component.needs_ammo = ammo_percentage < max_ammo_percentage
		end
	elseif pickup_component.needs_ammo then
		pickup_component.needs_ammo = false
	end
end

BotBehaviorExtension._update_health_deployables = function (self, unit)
	local pickup_component = self._pickup_component
	local damage_taken = Health.damage_taken(unit)
	local permanent_damage_taken = Health.permanent_damage_taken(unit)
	local healable_damage_taken = damage_taken - permanent_damage_taken

	if healable_damage_taken > 0 then
		pickup_component.needs_non_permanent_health = true
	elseif pickup_component.needs_non_permanent_health then
		pickup_component.needs_non_permanent_health = false
	end
end

local DAMAGE_TAKEN_VALUE_REQUIRED = 0.66
local HEALTH_VALUE_PER_PERMANTENT_DAMAGE = 3
local TIME_IN_PROXIMITY_MAX_T = 20
local TIME_IN_PROIXMITY_DAMAGE_TAKEN_VALUE_REQUIRED = 0.25
local PROXIMITY_DISTANCE = 5625

BotBehaviorExtension._update_health_stations = function (self, unit, dt, t)
	local perception_component = self._perception_component
	local health_station_component = self._health_station_component
	local target_level_unit = perception_component.target_level_unit
	local health_station_extension = target_level_unit and ScriptUnit.has_extension(target_level_unit, "health_station_system")

	if not health_station_extension then
		return
	end

	local damage_taken_required = nil
	local distance = perception_component.target_level_unit_distance

	if distance * distance < PROXIMITY_DISTANCE then
		health_station_component.time_in_proximity = health_station_component.time_in_proximity + dt
		local time_in_proximity = health_station_component.time_in_proximity
		local damage_taken_dif = DAMAGE_TAKEN_VALUE_REQUIRED - TIME_IN_PROIXMITY_DAMAGE_TAKEN_VALUE_REQUIRED
		local fraction = math.clamp(time_in_proximity / TIME_IN_PROXIMITY_MAX_T, 0, 1)
		damage_taken_required = DAMAGE_TAKEN_VALUE_REQUIRED - damage_taken_dif * fraction
	else
		damage_taken_required = DAMAGE_TAKEN_VALUE_REQUIRED
		health_station_component.time_in_proximity = 0
	end

	local damage_taken = 1 - Health.current_health_percent(unit)
	local permanent_damage_taken = Health.permanent_damage_taken_percent(unit)
	local players = Managers.player:players()
	local num_grims = 0

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if ALIVE[player_unit] then
			local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
			local has_grim = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(visual_loadout_extension, "slot_pocketable", "grimoire")

			if has_grim then
				num_grims = num_grims + 1
			end
		end
	end

	local projected_grim_damage = 0.33
	local total_damage_value = damage_taken - math.min(num_grims * projected_grim_damage, projected_grim_damage) + math.max((permanent_damage_taken - num_grims * projected_grim_damage) * HEALTH_VALUE_PER_PERMANTENT_DAMAGE, 0)

	if damage_taken_required < total_damage_value then
		local players_with_less_health = 0
		local human_player_units = self._side.valid_human_units

		for i = 1, #human_player_units do
			local human_unit = human_player_units[i]
			local human_damage_taken = 1 - Health.current_health_percent(human_unit)
			local human_permanent_damage_taken = Health.permanent_damage_taken_percent(human_unit)
			local human_total_damage_value = human_damage_taken - math.min(num_grims * projected_grim_damage, projected_grim_damage) + math.max((human_permanent_damage_taken - num_grims * projected_grim_damage) * HEALTH_VALUE_PER_PERMANTENT_DAMAGE, 0)

			if total_damage_value < human_total_damage_value * 2 then
				players_with_less_health = players_with_less_health + 1
			end
		end

		local needs_health_queue_number = players_with_less_health + 1
		health_station_component.needs_health_queue_number = needs_health_queue_number
		health_station_component.needs_health = true
	else
		health_station_component.needs_health = false
	end
end

BotBehaviorExtension._verify_target_ally_aid_destination = function (self, unit)
	local behavior_component = self._behavior_component
	local perception_component = self._perception_component
	local interaction_unit = behavior_component.interaction_unit
	local target_ally = perception_component.target_ally

	if interaction_unit ~= target_ally or interaction_unit == nil and target_ally == nil then
		return
	end

	local target_ally_needs_aid = perception_component.target_ally_needs_aid
	local target_ally_need_type = perception_component.target_ally_need_type

	if target_ally_needs_aid and target_ally_need_type ~= "in_need_of_attention_look" and target_ally_need_type ~= "in_need_of_attention_stop" then
		return
	end

	local target_ally_aid_destination = behavior_component.target_ally_aid_destination:unbox()

	if Vector3.is_valid(target_ally_aid_destination) then
		behavior_component.target_ally_aid_destination:store(Vector3.invalid_vector())
	end
end

BotBehaviorExtension._handle_doors = function (self, unit)
	local navigation_extension = self._navigation_extension

	if not navigation_extension:is_in_transition() or navigation_extension:transition_type() ~= "doors" then
		return
	end

	local door_unit = navigation_extension:transition_unit()
	local door_extension = ScriptUnit.has_extension(door_unit, "door_system")

	if door_extension and door_extension:can_open() then
		door_extension:open(nil, unit)
	end
end

local FLAT_MOVE_TO_EPSILON = BotSettings.flat_move_to_epsilon
local FLAT_MOVE_TO_EPSILON_SQ = FLAT_MOVE_TO_EPSILON^2
local FLAT_MOVE_TO_PREVIOUS_POS_EPSILON = BotSettings.flat_move_to_previous_pos_epsilon
local FLAT_MOVE_TO_PREVIOUS_POS_EPSILON_SQ = FLAT_MOVE_TO_PREVIOUS_POS_EPSILON^2
local Z_MOVE_TO_EPSILON = BotSettings.z_move_to_epsilon

BotBehaviorExtension._update_movement_target = function (self, unit, dt, t)
	local self_position = POSITION_LOOKUP[unit]
	local follow_component = self._follow_component
	local cover_position, cover_hash = self:_update_cover(unit, self_position, follow_component)
	local melee_component = self._melee_component
	local override_melee_destination = melee_component.engage_position_set and melee_component.engage_position:unbox()
	local navigation_extension = self._navigation_extension
	local previous_destination = navigation_extension:destination()
	local hold_position, hold_position_max_distance_sq = self:hold_position()

	if hold_position and not self:_is_within_hold_position_radius(hold_position, hold_position_max_distance_sq, previous_destination) then
		navigation_extension:move_to(hold_position)

		self._using_navigation_destination_override = true
	elseif cover_position or override_melee_destination then
		local override_destination = cover_position or override_melee_destination
		local offset = override_destination - previous_destination
		local override_allowed = hold_position == nil or Vector3.distance_squared(hold_position, override_destination) <= hold_position_max_distance_sq

		if override_allowed and (Z_MOVE_TO_EPSILON < math.abs(offset.z) or FLAT_MOVE_TO_EPSILON < Vector3.length(Vector3.flat(offset))) then
			local should_stop = override_melee_destination and melee_component.stop_at_current_position

			if should_stop then
				navigation_extension:stop()
			else
				local path_callback = cover_position and callback(self, "cb_cover_path_result", cover_hash) or nil

				navigation_extension:move_to(override_destination, path_callback)
			end

			self._using_navigation_destination_override = true
		end
	else
		self._follow_timer = self._follow_timer - dt
		local interaction_component = self._interaction_component
		local perception_component = self._perception_component
		local is_interacting = interaction_component.state == InteractionSettings.states.is_interacting
		local target_ally_need_type = perception_component.target_ally_need_type
		local target_ally_needs_aid = perception_component.target_ally_needs_aid
		local need_to_stop = target_ally_need_type == "in_need_of_attention_stop"

		if not follow_component.needs_destination_refresh and (self._follow_timer < 0 or need_to_stop or target_ally_needs_aid and not is_interacting and navigation_extension:destination_reached()) then
			follow_component.needs_destination_refresh = true
		end

		if follow_component.needs_destination_refresh then
			local group_extension = self._group_extension
			local bot_group_data = group_extension:bot_group_data()

			self:_refresh_destination(t, self_position, previous_destination, hold_position, hold_position_max_distance_sq, bot_group_data, navigation_extension, follow_component, perception_component)
		end

		if self._using_navigation_destination_override then
			local destination = follow_component.destination:unbox()

			navigation_extension:move_to(destination)

			self._using_navigation_destination_override = false
		end
	end
end

local HOLD_POSITION_MAX_ALLOWED_Z = 0.5

BotBehaviorExtension._is_within_hold_position_radius = function (self, hold_position, hold_position_max_distance_sq, new_position)
	local hold_position_offset = hold_position - new_position
	local hold_position_offset_z = math.abs(hold_position_offset.z)
	local flat_hold_position_offset_length_sq = Vector3.length_squared(Vector3.flat(hold_position_offset))
	local is_within_range = hold_position_offset_z <= HOLD_POSITION_MAX_ALLOWED_Z and flat_hold_position_offset_length_sq <= hold_position_max_distance_sq

	return is_within_range
end

local function _to_hash(vector3)
	return vector3.x + vector3.y * 10000 + vector3.z * 0.0001
end

BotBehaviorExtension._update_cover = function (self, unit, self_position, follow_component)
	local cover_position, cover_hash = nil
	local bot_group = self._bot_group
	local cover_data = self._cover_data
	local threats = cover_data.threats
	local active_threats = cover_data.active_threats
	local in_line_of_fire, changed = self:_in_line_of_fire(unit, self_position, threats, active_threats)

	if in_line_of_fire and changed then
		local num_cover_positions, cover_positions = self:_find_cover(active_threats, self_position)
		local found_position, found_hash, occupied_cover_hash, occupied_cover_position = nil

		for i = 1, num_cover_positions do
			local position = cover_positions[i]
			local position_hash = _to_hash(position)

			if not cover_data.failed_cover_positions[position_hash] then
				if bot_group:in_cover(position_hash) then
					occupied_cover_position = occupied_cover_position or position
					occupied_cover_hash = occupied_cover_hash or position_hash
				else
					found_position = position
					found_hash = position_hash

					break
				end
			end
		end

		found_position = found_position or occupied_cover_position
		found_hash = found_hash or occupied_cover_hash

		if found_position then
			cover_hash = found_hash
			cover_position = found_position

			cover_data.cover_position:store(cover_position)

			cover_data.cover_hash = found_hash
			cover_data.fails = 0

			bot_group:set_in_cover(unit, found_hash)
		else
			cover_data.fails = cover_data.fails + 1

			table.clear(active_threats)
		end
	elseif not in_line_of_fire and changed then
		cover_data.cover_position:store(Vector3.invalid_vector())

		cover_data.cover_hash = nil
		cover_data.fails = 0
		follow_component.needs_destination_refresh = true

		bot_group:set_in_cover(unit, nil)
	elseif in_line_of_fire then
		cover_hash = cover_data.cover_hash
		cover_position = cover_data.cover_position:unbox()
	end

	local ranged_obstructed_by_static_component = self._ranged_obstructed_by_static_component
	local target_unit_whilst_obstructed = ranged_obstructed_by_static_component.target_unit

	if cover_data.active_threats[target_unit_whilst_obstructed] then
		ranged_obstructed_by_static_component.target_unit = nil
		ranged_obstructed_by_static_component.t = -math.huge
	end

	return cover_position, cover_hash
end

local function _line_of_fire_check(from, to, position, width, length)
	local diff = position - from
	local direction = Vector3.normalize(to - from)
	local lateral_distance = Vector3.dot(diff, direction)

	if lateral_distance <= 0 or length < lateral_distance then
		return false
	end

	local direct_distance = Vector3.length(diff - lateral_distance * direction)

	if math.min(lateral_distance, width) < direct_distance then
		return false
	else
		return true
	end
end

local LINE_OF_FIRE_CHECK_LENGTH = 40
local LINE_OF_FIRE_CHECK_WIDTH = 2.5
local LINE_OF_FIRE_CHECK_STICKY_WIDTH = 6
local TAKE_COVER_TEMP_TABLE = {}

BotBehaviorExtension._in_line_of_fire = function (self, self_unit, self_position, take_cover_targets, taking_cover_from)
	local changed = false
	local in_line_of_fire = false
	local ALIVE = ALIVE
	local POSITION_LOOKUP = POSITION_LOOKUP

	for attacker_unit, victim_unit in pairs(take_cover_targets) do
		local already_in_cover_from = taking_cover_from[attacker_unit]
		local width = already_in_cover_from and LINE_OF_FIRE_CHECK_STICKY_WIDTH or LINE_OF_FIRE_CHECK_WIDTH

		if ALIVE[victim_unit] and (victim_unit == self_unit or _line_of_fire_check(POSITION_LOOKUP[attacker_unit], POSITION_LOOKUP[victim_unit], self_position, width, LINE_OF_FIRE_CHECK_LENGTH)) then
			TAKE_COVER_TEMP_TABLE[attacker_unit] = victim_unit
			changed = changed or not already_in_cover_from
			in_line_of_fire = true
		end
	end

	for attacker_unit, victim_unit in pairs(taking_cover_from) do
		if not TAKE_COVER_TEMP_TABLE[attacker_unit] then
			changed = true

			break
		end
	end

	table.clear(taking_cover_from)
	table.merge(taking_cover_from, TAKE_COVER_TEMP_TABLE)
	table.clear(TAKE_COVER_TEMP_TABLE)

	return in_line_of_fire, changed
end

local AVOID_POSITIONS_TEMP_TABLE = {}

BotBehaviorExtension._find_cover = function (self, taking_cover_from, self_position)
	local nav_spawn_points = self._nav_spawn_points

	if nav_spawn_points == nil then
		return 0, nil
	end

	for attacker_unit, _ in pairs(taking_cover_from) do
		local unit_position = POSITION_LOOKUP[attacker_unit]
		AVOID_POSITIONS_TEMP_TABLE[#AVOID_POSITIONS_TEMP_TABLE + 1] = unit_position
	end

	local nav_world = self._nav_world
	local group_index = SpawnPointQueries.group_from_position(nav_world, nav_spawn_points, self_position)
	local occluded_positions = SpawnPointQueries.occluded_positions_in_group(nav_world, nav_spawn_points, group_index, AVOID_POSITIONS_TEMP_TABLE)

	table.clear(AVOID_POSITIONS_TEMP_TABLE)

	local num_occluded_positions = #occluded_positions

	return num_occluded_positions, occluded_positions
end

local TARGET_NAV_MESH_ABOVE = 0.5
local TARGET_NAV_MESH_BELOW = 0.5
local TARGET_NAV_MESH_LATERAL = 2.5
local TARGET_DISTANCE_FROM_NAV_MESH = 0.1
local AMMO_NAV_MESH_ABOVE = 0.5
local AMMO_NAV_MESH_BELOW = 1.5
local AMMO_DISTANCE_FROM_NAV_MESH = 0
local HEALTH_DEPLOYABLE_NAV_MESH_ABOVE = 0.5
local HEALTH_DEPLOYABLE_NAV_MESH_BELOW = 1.5
local HEALTH_DEPLOYABLE_DISTANCE_FROM_NAV_MESH = 1
local HEALTH_DEPLOYABLE_OFFSET_DISTANCE = 4
local PICKUP_OFFSET_DISTANCE = 2.7
local HEALTH_STATION_MAX_DISTANCE_SQUARED = 400

BotBehaviorExtension._refresh_destination = function (self, t, self_position, previous_destination, hold_position, hold_position_max_distance_sq, bot_group_data, navigation_extension, follow_component, perception_component)
	local ALIVE = ALIVE
	local target_position, should_stop, path_callback = nil
	local nav_world = self._nav_world
	local traverse_logic = self._traverse_logic
	local target_ally = perception_component.target_ally
	local target_ally_position = POSITION_LOOKUP[target_ally]
	local target_ally_needs_aid = perception_component.target_ally_needs_aid
	local target_ally_need_type = perception_component.target_ally_need_type
	local target_enemy = perception_component.target_enemy
	local priority_target_enemy = perception_component.priority_target_enemy
	local target_level_unit = perception_component.target_level_unit
	local target_level_unit_position = target_level_unit and POSITION_LOOKUP[target_level_unit]
	local target_level_unit_distance = perception_component.target_level_unit_distance
	local behavior_component = self._behavior_component
	local revive_with_urgent_target = behavior_component.revive_with_urgent_target
	local self_unit = self._unit
	local bot_group = self._bot_group
	local health_slot_pickup_order = bot_group:pickup_order(self_unit, "slot_healthkit")
	local health_slot_pickup_order_unit = health_slot_pickup_order and health_slot_pickup_order.unit or nil
	local potion_slot_pickup_order = bot_group:pickup_order(self_unit, "slot_potion")
	local potion_slot_pickup_order_unit = potion_slot_pickup_order and potion_slot_pickup_order.unit or nil
	local pickup_component = self._pickup_component
	local health_pickup = pickup_component.health_deployable
	local mule_pickup = pickup_component.mule_pickup
	local last_health_pickup_attempt = self._last_health_pickup_attempt
	local last_mule_pickup_attempt = self._last_mule_pickup_attempt
	local health_station_component = self._health_station_component
	local needs_health = health_station_component.needs_health
	local needs_health_queue_number = health_station_component.needs_health_queue_number
	local health_station_extension = target_level_unit and ScriptUnit.has_extension(target_level_unit, "health_station_system")
	local health_station_charges = 0

	if health_station_extension then
		health_station_charges = health_station_extension:charge_amount()
	end

	if revive_with_urgent_target and target_ally_needs_aid and target_ally_need_type ~= "in_need_of_attention_look" then
		target_position, should_stop = self:_alter_target_position(nav_world, traverse_logic, perception_component, self_position, target_ally, target_ally_position, target_ally_need_type)
		behavior_component.interaction_unit = target_ally

		behavior_component.target_ally_aid_destination:store(target_position)

		path_callback = callback(self, "cb_ally_path_result", target_ally)
	elseif priority_target_enemy and target_enemy ~= priority_target_enemy and self:_enemy_path_allowed(priority_target_enemy) then
		local wanted_position = POSITION_LOOKUP[priority_target_enemy]
		target_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, wanted_position, TARGET_NAV_MESH_ABOVE, TARGET_NAV_MESH_BELOW, TARGET_NAV_MESH_LATERAL, TARGET_DISTANCE_FROM_NAV_MESH)
		path_callback = callback(self, "cb_enemy_path_result", priority_target_enemy)
	elseif target_enemy and (target_enemy == priority_target_enemy or target_enemy == perception_component.urgent_target_enemy) and self:_enemy_path_allowed(target_enemy) then
		local wanted_position = POSITION_LOOKUP[target_enemy]
		target_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, wanted_position, TARGET_NAV_MESH_ABOVE, TARGET_NAV_MESH_BELOW, TARGET_NAV_MESH_LATERAL, TARGET_DISTANCE_FROM_NAV_MESH)
		path_callback = callback(self, "cb_enemy_path_result", target_enemy)
	elseif target_ally_needs_aid and target_ally_need_type ~= "in_need_of_attention_look" then
		target_position, should_stop = self:_alter_target_position(nav_world, traverse_logic, perception_component, self_position, target_ally, target_ally_position, target_ally_need_type)
		behavior_component.interaction_unit = target_ally

		behavior_component.target_ally_aid_destination:store(target_position)

		path_callback = callback(self, "cb_ally_path_result", target_ally)
	elseif ALIVE[mule_pickup] and (potion_slot_pickup_order_unit == mule_pickup or last_mule_pickup_attempt.unit ~= mule_pickup or not last_mule_pickup_attempt.blacklist) then
		target_position = self:_find_pickup_position_on_nav_mesh(nav_world, traverse_logic, self_position, mule_pickup, last_mule_pickup_attempt)
		local allowed_to_take_without_path = mule_pickup == potion_slot_pickup_order_unit

		if target_position then
			path_callback = callback(self, "cb_mule_pickup_path_result", mule_pickup)
			behavior_component.interaction_unit = mule_pickup
		elseif allowed_to_take_without_path then
			behavior_component.interaction_unit = mule_pickup
			behavior_component.forced_pickup_unit = mule_pickup
		end
	elseif target_level_unit and needs_health and needs_health_queue_number <= health_station_charges and target_level_unit_distance < HEALTH_STATION_MAX_DISTANCE_SQUARED then
		local target_level_unit_transform = Unit.world_pose(target_level_unit, 1)
		local forward_vector = Matrix4x4.forward(target_level_unit_transform)
		local wanted_position = target_level_unit_position - forward_vector
		target_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, wanted_position, TARGET_NAV_MESH_ABOVE, TARGET_NAV_MESH_BELOW, TARGET_NAV_MESH_LATERAL, TARGET_DISTANCE_FROM_NAV_MESH)

		if target_position then
			behavior_component.interaction_unit = target_level_unit

			behavior_component.target_level_unit_destination:store(target_position)
		end
	end

	local health_deployable = pickup_component.health_deployable
	local needs_non_permanent_health = pickup_component.needs_non_permanent_health

	if not target_position and not target_enemy and ALIVE[health_deployable] and needs_non_permanent_health and health_deployable then
		local health_position = POSITION_LOOKUP[health_deployable]
		local direction = Vector3.normalize(self_position - health_position)
		local offset_position = health_position + direction
		target_position = NavQueries.position_on_mesh(nav_world, offset_position, HEALTH_DEPLOYABLE_NAV_MESH_ABOVE, HEALTH_DEPLOYABLE_NAV_MESH_BELOW, traverse_logic)
		target_position = target_position or NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, health_position, HEALTH_DEPLOYABLE_NAV_MESH_ABOVE, HEALTH_DEPLOYABLE_NAV_MESH_BELOW, HEALTH_DEPLOYABLE_OFFSET_DISTANCE, HEALTH_DEPLOYABLE_DISTANCE_FROM_NAV_MESH)
	end

	local ammo_pickup = pickup_component.ammo_pickup
	local needs_ammo = pickup_component.needs_ammo
	local ammo_pickup_valid_until = pickup_component.ammo_pickup_valid_until

	if not target_position and ALIVE[ammo_pickup] and needs_ammo and t < ammo_pickup_valid_until then
		local ammo_position = POSITION_LOOKUP[ammo_pickup]
		local direction = Vector3.normalize(self_position - ammo_position)
		local offset_position = ammo_position + direction
		target_position = NavQueries.position_on_mesh(nav_world, offset_position, AMMO_NAV_MESH_ABOVE, AMMO_NAV_MESH_BELOW, traverse_logic)
		target_position = target_position or NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, ammo_position, AMMO_NAV_MESH_ABOVE, AMMO_NAV_MESH_BELOW, PICKUP_OFFSET_DISTANCE, AMMO_DISTANCE_FROM_NAV_MESH)

		if target_position then
			behavior_component.interaction_unit = ammo_pickup
		end
	end

	if hold_position and target_position and not self:_is_within_hold_position_radius(hold_position, hold_position_max_distance_sq, target_position) then
		target_position = nil
	end

	local moving_towards_follow_position = false
	local follow_position = bot_group_data.follow_position

	if not target_position and follow_position then
		moving_towards_follow_position = true
		target_position = follow_position
	end

	if should_stop then
		navigation_extension:stop()
	elseif target_position then
		self._follow_timer = math.lerp(FOLLOW_TIMER_LOWER_BOUND, FOLLOW_TIMER_UPPER_BOUND, math.random())
		follow_component.moving_towards_follow_position = moving_towards_follow_position
		follow_component.needs_destination_refresh = false

		follow_component.destination:store(target_position)

		if self:new_destination_distance_check(self_position, previous_destination, target_position, navigation_extension) then
			navigation_extension:move_to(target_position, path_callback)
		end

		self._using_navigation_destination_override = false
	end
end

local TARGET_SPEED_SQ = 2.25
local NAV_MESH_ABOVE = 0.5
local NAV_MESH_BELOW = 3
local NAV_MESH_HORIZONTAL = 2
local DISTANCE_FROM_NAV_MESH = 0.1

BotBehaviorExtension._alter_target_position = function (self, nav_world, traverse_logic, perception_component, self_position, target_unit, target_position, reason)
	local wanted_position = nil

	if reason == "ledge" then
		local rotation = Unit.local_rotation(target_unit, 1)
		local forward_vector_flat = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
		wanted_position = target_position - forward_vector_flat * 0.5
	elseif reason == "in_need_of_heal" or reason == "can_accept_grenade" or reason == "can_accept_potion" or reason == "can_accept_heal_item" then
		local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
		local target_locomotion_component = target_unit_data_extension:read_component("locomotion")
		local target_velocity = target_locomotion_component.velocity_current

		if TARGET_SPEED_SQ < Vector3.length_squared(target_velocity) then
			wanted_position = target_position + target_velocity
		else
			wanted_position = target_position + Vector3.normalize(self_position - target_position)
		end
	elseif reason == "knocked_down" and perception_component.aggressive_mode then
		wanted_position = target_position + Vector3.normalize(self_position - target_position)
	elseif reason == "in_need_of_attention_stop" then
		local should_stop = true

		return self_position, should_stop
	else
		wanted_position = Vector3(target_position.x, target_position.y, target_position.z)
	end

	local altitude = GwNavQueries.triangle_from_position(nav_world, wanted_position, NAV_MESH_ABOVE, NAV_MESH_BELOW, traverse_logic)

	if altitude then
		wanted_position.z = altitude

		return wanted_position
	else
		local position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, NAV_MESH_ABOVE, NAV_MESH_BELOW, NAV_MESH_HORIZONTAL, DISTANCE_FROM_NAV_MESH)

		if position then
			return position
		else
			return target_position
		end
	end
end

local ENEMY_PATH_FAILED_REPATH_THRESHOLD_SQ = 9
local ENEMY_PATH_FAILED_REPATH_VERTICAL_THRESHOLD = 0.8

BotBehaviorExtension._enemy_path_allowed = function (self, enemy_unit)
	local path_status = self._attempted_enemy_paths[enemy_unit]

	if not path_status or not path_status.failed then
		return true
	end

	local enemy_position = POSITION_LOOKUP[enemy_unit]
	local last_path_destination = path_status.last_path_destination:unbox()
	local distance_from_last_destination_sq = Vector3.distance_squared(enemy_position, last_path_destination)

	if ENEMY_PATH_FAILED_REPATH_THRESHOLD_SQ <= distance_from_last_destination_sq or ENEMY_PATH_FAILED_REPATH_VERTICAL_THRESHOLD <= math.abs(enemy_position.z - last_path_destination.z) then
		return true
	end

	return false
end

local PICKUP_ROTATIONS = {
	QuaternionBox(Quaternion(Vector3.up(), 0)),
	QuaternionBox(Quaternion(Vector3.up(), math.pi * 0.25)),
	QuaternionBox(Quaternion(Vector3.up(), -math.pi * 0.25)),
	QuaternionBox(Quaternion(Vector3.up(), math.pi * 0.5)),
	QuaternionBox(Quaternion(Vector3.up(), -math.pi * 0.5)),
	QuaternionBox(Quaternion(Vector3.up(), math.pi * 0.75)),
	QuaternionBox(Quaternion(Vector3.up(), -math.pi * 0.75)),
	QuaternionBox(Quaternion(Vector3.up(), math.pi))
}
local PICKUP_NAV_MESH_ABOVE = 1.5
local PICKUP_NAV_MESH_BELOW = 2.2
local PICKUP_ATTEMPT_DISTANCE = 0.1

BotBehaviorExtension._find_pickup_position_on_nav_mesh = function (self, nav_world, traverse_logic, self_position, pickup_unit, pickup_attempt)
	if pickup_attempt.unit == pickup_unit and not pickup_attempt.path_failed then
		return pickup_attempt.path_position:unbox()
	end

	local pickup_position = POSITION_LOOKUP[pickup_unit]

	if pickup_attempt.unit ~= pickup_unit then
		pickup_attempt.unit = pickup_unit
		pickup_attempt.index = 1
		pickup_attempt.distance = 0
		pickup_attempt.path_failed = true

		pickup_attempt.rotation:store(Quaternion.look(Vector3.flat(self_position - pickup_position), Vector3.up()))

		pickup_attempt.blacklist = false
	end

	local GwNavQueries_triangle_from_position = GwNavQueries.triangle_from_position
	local GwNavQueries_raycast = GwNavQueries.raycast
	local Quaternion_multiply = Quaternion.multiply
	local Quaternion_forward = Quaternion.forward
	local Vector3_dot = Vector3.dot
	local Vector3_flat = Vector3.flat
	local found_position = nil
	local attempt_rotation = pickup_attempt.rotation:unbox()
	local distance = pickup_attempt.distance
	local index = pickup_attempt.index
	local max_index = #PICKUP_ROTATIONS

	while index <= max_index and not found_position do
		distance = math.min(distance + PICKUP_ATTEMPT_DISTANCE, 1)
		local iteration_rotation = PICKUP_ROTATIONS[index]:unbox()
		local rotation = Quaternion_multiply(iteration_rotation, attempt_rotation)
		local direction = Quaternion_forward(rotation)
		local position = pickup_position + direction * distance * PICKUP_OFFSET_DISTANCE
		local altitude = GwNavQueries_triangle_from_position(nav_world, position, PICKUP_NAV_MESH_ABOVE, PICKUP_NAV_MESH_BELOW, traverse_logic)

		if altitude then
			position.z = altitude

			if distance >= 0.8 then
				found_position = position
			else
				local ray_end_position = position + direction * (1 - distance) * PICKUP_OFFSET_DISTANCE
				local success, ray_hit_position = GwNavQueries_raycast(nav_world, position, ray_end_position, traverse_logic)

				if success then
					found_position = ray_end_position
					distance = 1
				else
					found_position = 0.1 * position + ray_hit_position * 0.9
					distance = Vector3_dot(Vector3_flat(found_position - pickup_position), direction)
				end
			end
		end

		if distance >= 1 - FLAT_MOVE_TO_EPSILON then
			index = index + 1
			distance = 0
		end
	end

	pickup_attempt.distance = distance
	pickup_attempt.index = index

	if found_position then
		pickup_attempt.path_failed = false

		pickup_attempt.path_position:store(found_position)

		return found_position
	else
		pickup_attempt.blacklist = true

		return nil
	end
end

BotBehaviorExtension.new_destination_distance_check = function (self, self_position, previous_destination, new_destination, navigation_extension)
	local destination_offset = new_destination - previous_destination
	local destination_offset_ok = Z_MOVE_TO_EPSILON < math.abs(destination_offset.z) or FLAT_MOVE_TO_EPSILON_SQ < Vector3.length_squared(Vector3.flat(destination_offset))

	if navigation_extension:destination_reached() then
		local position_when_destination_reached = navigation_extension:position_when_destination_reached()
		local previous_pos_offset = self_position - position_when_destination_reached
		local previous_pos_offset_ok = Z_MOVE_TO_EPSILON < math.abs(previous_pos_offset.z) or FLAT_MOVE_TO_PREVIOUS_POS_EPSILON_SQ < Vector3.length_squared(Vector3.flat(previous_pos_offset))
		local new_destination_offset = new_destination - self_position
		local new_destination_offset_ok = Z_MOVE_TO_EPSILON < math.abs(new_destination_offset.z) or FLAT_MOVE_TO_EPSILON_SQ < Vector3.length_squared(Vector3.flat(new_destination_offset))

		return (previous_pos_offset_ok or destination_offset_ok) and new_destination_offset_ok
	else
		return destination_offset_ok
	end
end

BotBehaviorExtension.clear_failed_paths = function (self)
	table.clear(self._attempted_ally_paths)
	table.clear(self._attempted_enemy_paths)
end

BotBehaviorExtension.cb_cover_path_result = function (self, cover_hash, success, destination)
	if not success then
		local cover_data = self._cover_data
		cover_data.failed_cover_positions[cover_hash] = true

		table.clear(cover_data.active_threats)
	end
end

BotBehaviorExtension.ally_path_status = function (self, ally_unit)
	local path_status = self._attempted_ally_paths[ally_unit]

	return path_status
end

BotBehaviorExtension.cb_ally_path_result = function (self, ally_unit, success, destination)
	local paths = self._attempted_ally_paths
	local path_status = paths[ally_unit]

	if not path_status then
		path_status = {
			last_path_destination = Vector3Box()
		}
		paths[ally_unit] = path_status
	end

	local fail = not success
	path_status.failed = fail

	path_status.last_path_destination:store(destination)

	if fail then
		path_status.ignore_ally_from = Managers.time:time("gameplay")
	else
		path_status.ignore_ally_from = -math.huge
	end

	local ALIVE = ALIVE

	for unit, path in pairs(paths) do
		if not ALIVE[unit] then
			paths[unit] = nil
		end
	end
end

BotBehaviorExtension.cb_enemy_path_result = function (self, enemy_unit, success, destination)
	local paths = self._attempted_enemy_paths
	local path_status = paths[enemy_unit]

	if not path_status then
		path_status = {
			last_path_destination = Vector3Box()
		}
		paths[enemy_unit] = path_status
	end

	local fail = not success

	if fail then
		self._follow_component.needs_destination_refresh = true
	end

	path_status.failed = fail

	path_status.last_path_destination:store(destination)

	local ALIVE = ALIVE

	for unit, path in pairs(paths) do
		if not ALIVE[unit] then
			paths[unit] = nil
		end
	end
end

BotBehaviorExtension.cb_health_pickup_path_result = function (self, pickup_unit, success, destination)
	if pickup_unit == self._last_health_pickup_attempt.unit then
		self._last_health_pickup_attempt.path_failed = not success
	end
end

BotBehaviorExtension.cb_mule_pickup_path_result = function (self, pickup_unit, success, destination)
	if pickup_unit == self._last_mule_pickup_attempt.unit then
		self._last_mule_pickup_attempt.path_failed = not success
	end
end

BotBehaviorExtension.brain = function (self)
	return self._brain
end

BotBehaviorExtension.running_action = function (self)
	return self._brain:running_action()
end

BotBehaviorExtension.hit_by_attacker_projectile = function (self, attacking_unit)
	local hit_by_projectile = self._hit_by_projectile[attacking_unit] or false

	return hit_by_projectile
end

BotBehaviorExtension.set_hit_by_attacker_projectile = function (self, attacking_unit)
	self._hit_by_projectile[attacking_unit] = true
end

local DEFAULT_STAY_NEAR_PLAYER_RANGE = 5

BotBehaviorExtension.set_stay_near_player = function (self, stay_near_player, max_range)
	if stay_near_player then
		self._stay_near_player_range = max_range or DEFAULT_STAY_NEAR_PLAYER_RANGE
	else
		self._stay_near_player_range = math.huge
	end

	self._stay_near_player = stay_near_player
end

BotBehaviorExtension.should_stay_near_player = function (self)
	return self._stay_near_player, self._stay_near_player_range
end

local HOLD_POSITION_EPSILON = 0.05

BotBehaviorExtension.set_hold_position = function (self, hold_position, max_allowed_distance)
	if hold_position then
		local max_allowed_distance_sq = math.max(max_allowed_distance, HOLD_POSITION_EPSILON)^2

		if self._hold_position then
			self._hold_position:store(hold_position)
		else
			self._hold_position = Vector3Box(hold_position)
		end

		self._hold_position_max_distance_sq = max_allowed_distance_sq
	else
		self._hold_position = nil
		self._hold_position_max_distance_sq = nil
	end
end

BotBehaviorExtension.hold_position = function (self)
	local hold_position_box = self._hold_position

	if hold_position_box then
		local hold_position = hold_position_box:unbox()
		local distance_sq = self._hold_position_max_distance_sq

		return hold_position, distance_sq
	else
		return nil, nil
	end
end

BotBehaviorExtension.is_taking_cover = function (self)
	local cover_data = self._cover_data
	local cover_position = cover_data.cover_position:unbox()
	local is_taking_cover = Vector3.is_valid(cover_position)

	return is_taking_cover
end

return BotBehaviorExtension
