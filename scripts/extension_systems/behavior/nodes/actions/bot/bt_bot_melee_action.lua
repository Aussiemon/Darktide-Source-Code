require("scripts/extension_systems/behavior/nodes/bt_node")

local Armor = require("scripts/utilities/attack/armor")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local FixedFrame = require("scripts/utilities/fixed_frame")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Stamina = require("scripts/utilities/attack/stamina")
local BtBotMeleeAction = class("BtBotMeleeAction", "BtNode")

BtBotMeleeAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.engaging = false
	scratchpad.engage_change_time = 0
	scratchpad.engage_update_time = 0
	scratchpad.last_evaluate_t = t
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local inventory_component = unit_data_extension:read_component("inventory")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_template = PlayerUnitVisualLoadout.wielded_weapon_template(visual_loadout_extension, inventory_component)
	scratchpad.weapon_template = weapon_template
	local input_extension = ScriptUnit.extension(unit, "input_system")
	local bot_unit_input = input_extension:bot_unit_input()
	local soft_aiming = true

	bot_unit_input:set_aiming(true, soft_aiming)

	local group_extension = ScriptUnit.extension(unit, "group_system")
	local bot_group = group_extension:bot_group()
	local bot_group_data = group_extension:bot_group_data()
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.behavior_extension = ScriptUnit.extension(unit, "behavior_system")
	scratchpad.bot_group = bot_group
	scratchpad.bot_group_data = bot_group_data
	scratchpad.bot_unit_input = bot_unit_input
	scratchpad.darkness_system = Managers.state.extension:system("darkness_system")
	scratchpad.first_person_component = unit_data_extension:read_component("first_person")
	scratchpad.follow_component = blackboard.follow
	scratchpad.locomotion_component = unit_data_extension:read_component("locomotion")
	scratchpad.melee_component = Blackboard.write_component(blackboard, "melee")
	scratchpad.nav_world = navigation_extension:nav_world()
	scratchpad.perception_component = blackboard.perception
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.stamina_component = unit_data_extension:read_component("stamina")
	scratchpad.traverse_logic = navigation_extension:traverse_logic()
	scratchpad.weapon_action_component = unit_data_extension:read_component("weapon_action")
	scratchpad.weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	scratchpad.action_input_extension = ScriptUnit.extension(unit, "action_input_system")
	scratchpad.slot_extension = ScriptUnit.extension(unit, "slot_system")
	local archetype = unit_data_extension:archetype()
	scratchpad.archetype_stamina_template = archetype.stamina
end

BtBotMeleeAction.init_values = function (self, blackboard)
	local melee_component = Blackboard.write_component(blackboard, "melee")

	melee_component.engage_position:store(0, 0, 0)

	melee_component.engage_position_set = false
	melee_component.stop_at_current_position = false
end

BtBotMeleeAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local bot_unit_input = scratchpad.bot_unit_input

	bot_unit_input:set_aiming(false)

	if scratchpad.engaging then
		self:_disengage(scratchpad, t)
	end

	self:_clear_pending_attack(scratchpad)
end

BtBotMeleeAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local done, evaluate = self:_update_melee(unit, scratchpad, action_data, t)

	if done then
		return "done"
	else
		return "running", evaluate
	end
end

local ENGAGE_TIME_WINDOW_MELEE = 5
local ENGAGE_TIME_WINDOW_DEFAULT = 0
local EVAL_TIMER_MELEE = 2
local EVAL_TIMER_ENGAGE = 1
local EVAL_TIMER_DEFAULT = 3
local DEFAULT_DEFENSE_META_DATA = {
	push_action_input = "push",
	stop_action_input = "block_release",
	push = "heavy",
	start_action_input = "block"
}

BtBotMeleeAction._update_melee = function (self, unit, scratchpad, action_data, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_enemy
	local perception_extension = scratchpad.perception_extension
	local enemies_in_proximity = perception_extension:enemies_in_proximity()
	scratchpad.enemies_in_proximity = enemies_in_proximity
	scratchpad.num_enemies_in_proximity = #enemies_in_proximity
	local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local target_breed = target_unit_data_extension and target_unit_data_extension:breed()
	local aim_position = self:_aim_position(target_unit, target_breed)
	local bot_unit_input = scratchpad.bot_unit_input

	bot_unit_input:set_aim_position(aim_position)

	local first_person_component = scratchpad.first_person_component
	local current_position = first_person_component.position
	local follow_component = scratchpad.follow_component
	local follow_position = follow_component.destination:unbox()
	local attack_performed = false
	local wants_engage, eval_timer = nil
	local already_engaged = scratchpad.engaging
	local engage_change_time = scratchpad.engage_change_time
	local locomotion_component = scratchpad.locomotion_component
	local current_velocity = locomotion_component.velocity_current
	local target_velocity = self:_target_velocity(target_unit, target_breed)
	local self_position = POSITION_LOOKUP[unit]
	local nav_world = scratchpad.nav_world
	local traverse_logic = scratchpad.traverse_logic
	local target_position = self:_target_unit_position(self_position, target_unit, action_data, nav_world, traverse_logic)
	local attack_meta_data = self:_choose_attack(target_unit, target_breed, scratchpad)
	local melee_range = self:_calculate_melee_range(target_breed, attack_meta_data)
	local is_in_melee_range = self:_is_in_melee_range(current_position, aim_position, melee_range, current_velocity, target_velocity, scratchpad, t)
	local should_defend = self:_should_defend(unit, target_unit, scratchpad)
	local is_defending = scratchpad.is_defending
	local weapon_template = scratchpad.weapon_template
	local defense_meta_data = weapon_template.defense_meta_data or DEFAULT_DEFENSE_META_DATA

	if should_defend and not is_defending then
		self:_update_start_defend(scratchpad, defense_meta_data)

		eval_timer = EVAL_TIMER_MELEE
	elseif is_defending then
		local latest_fixed_t = FixedFrame.get_latest_fixed_time()

		self:_update_defend(should_defend, defense_meta_data, scratchpad, is_in_melee_range, target_unit, target_breed, latest_fixed_t)

		scratchpad.start_defend_request_id = nil
		eval_timer = EVAL_TIMER_MELEE
	elseif scratchpad.is_attacking then
		self:_update_attack(scratchpad, t)

		eval_timer = math.huge
	elseif is_in_melee_range then
		local weapon_extension = scratchpad.weapon_extension

		if self:_can_start_attack(attack_meta_data, weapon_extension) then
			self:_start_attack(attack_meta_data, scratchpad, t)

			attack_performed = true
		end

		wants_engage = perception_component.aggressive_mode or (already_engaged and t - engage_change_time < ENGAGE_TIME_WINDOW_MELEE)
		eval_timer = EVAL_TIMER_MELEE
	elseif self:_is_in_engage_range(self_position, target_position, action_data, follow_position) then
		wants_engage = true
		eval_timer = EVAL_TIMER_ENGAGE
	else
		wants_engage = already_engaged and t - engage_change_time <= ENGAGE_TIME_WINDOW_DEFAULT
		eval_timer = EVAL_TIMER_DEFAULT
	end

	local engage = wants_engage and self:_allow_engage(unit, target_unit, target_position, target_breed, scratchpad, action_data, already_engaged, aim_position, follow_position)

	if engage and not already_engaged then
		self:_engage(scratchpad, t)

		already_engaged = true
	elseif not engage and already_engaged then
		self:_disengage(scratchpad, t)

		already_engaged = false
	end

	if already_engaged and not action_data.do_not_update_engage_position and scratchpad.engage_update_time < t then
		self:_update_engage_position(unit, self_position, target_unit, target_position, target_velocity, target_breed, scratchpad, t, melee_range, nav_world, traverse_logic)
	end

	return false, self:_evaluation_timer(scratchpad, t, eval_timer)
end

BtBotMeleeAction._can_start_attack = function (self, attack_meta_data, weapon_extension)
	local action_input = attack_meta_data.action_inputs[1].action_input
	local raw_input = nil
	local fixed_t = FixedFrame.get_latest_fixed_time()

	return weapon_extension:action_input_is_currently_valid("weapon_action", action_input, raw_input, fixed_t)
end

BtBotMeleeAction._update_attack = function (self, scratchpad, t)
	if scratchpad.next_attack_action_input_t <= t then
		local attack_meta_data = scratchpad.executing_attack_meta_data
		local action_input_i = scratchpad.next_action_input_i
		local action_inputs = attack_meta_data.action_inputs
		local action_input_config = action_inputs[action_input_i]
		local action_input_extension = scratchpad.action_input_extension
		local action_input = action_input_config.action_input
		local raw_input = nil

		action_input_extension:bot_queue_action_input("weapon_action", action_input, raw_input)

		local next_action_input_i = action_input_i + 1
		local next_action_input_config = action_inputs[next_action_input_i]

		if next_action_input_config then
			scratchpad.next_attack_action_input_t = t + next_action_input_config.timing
			scratchpad.next_action_input_i = next_action_input_i
		else
			scratchpad.is_attacking = false
		end
	end
end

BtBotMeleeAction._aim_position = function (self, target_unit, target_breed)
	local aim_node_name = nil

	if target_breed then
		aim_node_name = target_breed.bot_melee_aim_node or "j_spine"
	end

	local aim_position = nil

	if Unit.has_node(target_unit, aim_node_name) then
		local aim_node = Unit.node(target_unit, aim_node_name)
		aim_position = Unit.world_position(target_unit, aim_node)
	else
		aim_position = POSITION_LOOKUP[target_unit]
	end

	return aim_position
end

local DEFAULT_MAXIMAL_MELEE_RANGE = 2.5
local DEFAULT_ATTACK_META_DATA = {
	light_attack = {
		penetrating = false,
		arc = 0,
		max_range = DEFAULT_MAXIMAL_MELEE_RANGE,
		action_inputs = {
			{
				timing = 0,
				action_input = "start_attack"
			},
			{
				timing = 0,
				action_input = "light_attack"
			}
		}
	}
}
local ARMORED = ArmorSettings.types.armored

BtBotMeleeAction._choose_attack = function (self, target_unit, target_breed, scratchpad)
	local num_enemies = scratchpad.num_enemies_in_proximity
	local outnumbered = num_enemies > 1
	local massively_outnumbered = num_enemies > 3
	local target_armor = Armor.armor_type(target_unit, target_breed)
	local weapon_template = scratchpad.weapon_template
	local weapon_meta_data = weapon_template.attack_meta_data or DEFAULT_ATTACK_META_DATA
	local best_attack_meta_data = nil
	local best_utility = -math.huge

	for attack_input, attack_meta_data in pairs(weapon_meta_data) do
		local utility = 0

		if outnumbered and attack_meta_data.arc == 1 then
			utility = utility + 1
		elseif attack_meta_data.no_damage and massively_outnumbered and attack_meta_data.arc > 1 then
			utility = utility + 2
		elseif not attack_meta_data.no_damage and ((outnumbered and attack_meta_data.arc > 1) or (not outnumbered and attack_meta_data.arc == 0)) then
			utility = utility + 4
		end

		if target_armor ~= ARMORED or attack_meta_data.penetrating then
			utility = utility + 8
		end

		if best_utility < utility then
			best_utility = utility
			best_attack_meta_data = attack_meta_data
		end
	end

	return best_attack_meta_data
end

local DEFAULT_ENEMY_HITBOX_RADIUS_APPROXIMATION = 0.5

BtBotMeleeAction._calculate_melee_range = function (self, target_breed, attack_meta_data)
	local target_hitbox_radius_approximation = nil

	if target_breed then
		target_hitbox_radius_approximation = target_breed.bot_hitbox_radius_approximation or DEFAULT_ENEMY_HITBOX_RADIUS_APPROXIMATION
	else
		target_hitbox_radius_approximation = 0
	end

	local attack_range = attack_meta_data.max_range
	local melee_range = attack_range + target_hitbox_radius_approximation

	return melee_range
end

BtBotMeleeAction._target_velocity = function (self, target_unit, target_breed)
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

BtBotMeleeAction._is_in_melee_range = function (self, self_position, aim_position, melee_range, self_velocitiy, target_velocity, scratchpad, t)
	local time_to_next_attack = self:_time_to_next_attack(scratchpad, t)
	local relative_velocity = self_velocitiy - target_velocity
	local check_position = self_position + relative_velocity * time_to_next_attack
	local melee_range_sq = melee_range^2

	return Vector3.distance_squared(aim_position, check_position) < melee_range_sq
end

BtBotMeleeAction._time_to_next_attack = function (self, scratchpad, t)
	if scratchpad.is_attacking then
		local attack_meta_data = scratchpad.executing_attack_meta_data
		local action_inputs = attack_meta_data.action_inputs
		local next_action_input_i = scratchpad.next_action_input_i
		local remaining_action_input_time = 0
		local num_action_inputs = #action_inputs

		for i = next_action_input_i + 1, num_action_inputs, 1 do
			local config = action_inputs[i]
			remaining_action_input_time = remaining_action_input_time + config.timing
		end

		local current_action_input_time = scratchpad.next_attack_action_input_t - t

		return current_action_input_time + remaining_action_input_time
	else
		return 0
	end
end

BtBotMeleeAction._should_defend = function (self, unit, target_unit, scratchpad)
	local slot_extension = scratchpad.slot_extension
	local all_slots = slot_extension.all_slots

	for slot_type, slots in pairs(all_slots) do
		local num_slots = #slots

		for i = 1, num_slots, 1 do
			local slot = slots[i]
			local user_unit = slot.user_unit

			if ALIVE[user_unit] then
				return self:_is_attacking_me(unit, user_unit)
			end
		end
	end

	return self:_is_attacking_me(unit, target_unit)
end

BtBotMeleeAction._update_start_defend = function (self, scratchpad, defense_meta_data)
	local start_defend_request_id = scratchpad.start_defend_request_id

	if not start_defend_request_id then
		local start_action_input = defense_meta_data.start_action_input
		local raw_input = nil
		local fixed_t = FixedFrame.get_latest_fixed_time()
		local weapon_extension = scratchpad.weapon_extension

		if weapon_extension:action_input_is_currently_valid("weapon_action", start_action_input, raw_input, fixed_t) then
			self:_start_defend(start_action_input, scratchpad)
		end
	else
		local action_input_extension = scratchpad.action_input_extension

		if action_input_extension:bot_queue_request_is_consumed("weapon_action", start_defend_request_id) then
			scratchpad.is_defending = true
			scratchpad.defend_request_id = nil
		end
	end
end

BtBotMeleeAction._start_defend = function (self, action_input, scratchpad)
	fassert(not scratchpad.is_defending, "Tried to start defend when already defending.")

	local action_input_extension = scratchpad.action_input_extension
	local raw_input = nil
	scratchpad.start_defend_request_id = action_input_extension:bot_queue_action_input("weapon_action", action_input, raw_input)
end

BtBotMeleeAction._stop_defend = function (self, scratchpad, defense_meta_data)
	fassert(scratchpad.is_defending, "Tried to stop defend when not defending.")

	local action_input_extension = scratchpad.action_input_extension
	local stop_action_input = defense_meta_data.stop_action_input
	local raw_input = nil

	action_input_extension:bot_queue_action_input("weapon_action", stop_action_input, raw_input)
end

BtBotMeleeAction._update_defend = function (self, should_defend, defense_meta_data, scratchpad, in_melee_range, target_unit, target_breed, fixed_t)
	local action_input_extension = scratchpad.action_input_extension
	local push_request_id = scratchpad.push_request_id

	if push_request_id then
		if action_input_extension:bot_queue_request_is_consumed("weapon_action", push_request_id) then
			scratchpad.push_request_id = nil
			scratchpad.is_defending = false
		end

		return
	end

	if should_defend then
		local should_push, push_action_input = self:_should_push(defense_meta_data, scratchpad, in_melee_range, target_unit, target_breed, fixed_t)

		if should_push then
			local raw_input = nil
			scratchpad.push_request_id = action_input_extension:bot_queue_action_input("weapon_action", push_action_input, raw_input)
		end
	else
		self:_stop_defend(scratchpad, defense_meta_data)

		scratchpad.is_defending = false
	end
end

BtBotMeleeAction._should_push = function (self, defense_meta_data, scratchpad, in_melee_range, target_unit, target_breed, fixed_t)
	local num_enemies = scratchpad.num_enemies_in_proximity
	local stamina_component = scratchpad.stamina_component
	local archetype_stamina_template = scratchpad.archetype_stamina_template
	local current_stamina, _ = Stamina.current_and_max_value(target_unit, stamina_component, archetype_stamina_template)
	local push_type = defense_meta_data.push
	local low_stamina = (push_type == "light" and current_stamina <= 2) or current_stamina <= 3
	local armor_type = Armor.armor_type(target_unit, target_breed)
	local breed_is_pushable = true

	if not target_breed then
		breed_is_pushable = false
	elseif target_breed.tags.monster then
		breed_is_pushable = false
	elseif armor_type == ARMORED and push_type ~= "heavy" then
		breed_is_pushable = false
	end

	local outnumbered = push_type == "light" and num_enemies > 2
	local push_action_input = defense_meta_data.push_action_input
	local weapon_extension = scratchpad.weapon_extension
	local raw_input = nil
	local push_action_is_available = weapon_extension:action_input_is_currently_valid("weapon_action", push_action_input, raw_input, fixed_t)

	if in_melee_range and push_action_is_available and breed_is_pushable and not outnumbered and not low_stamina then
		return true, push_action_input
	else
		return false, nil
	end
end

BtBotMeleeAction._is_attacking_me = function (self, self_unit, enemy_unit)
	local target_blackboard = BLACKBOARDS[enemy_unit]

	if target_blackboard == nil then
		return false
	end

	local target_perception_component = target_blackboard.perception
	local behavior_component = target_blackboard.behavior
	local move_state = behavior_component.move_state
	local is_attacking_me = target_perception_component.target_unit == self_unit and move_state == "attacking"

	return is_attacking_me
end

local STOP_ACTION_INTERRUPT_DATA = {}

BtBotMeleeAction._clear_pending_attack = function (self, scratchpad)
	local action_input_extension = scratchpad.action_input_extension

	action_input_extension:bot_queue_clear_requests("weapon_action")
	action_input_extension:clear_input_queue_and_sequences("weapon_action")

	local weapon_extension = scratchpad.weapon_extension
	local fixed_t = FixedFrame.get_latest_fixed_time()

	weapon_extension:stop_action("bot_left_node", STOP_ACTION_INTERRUPT_DATA, fixed_t)
end

BtBotMeleeAction._start_attack = function (self, attack_meta_data, scratchpad, t)
	fassert(not scratchpad.is_attacking, "Bot trying to start a melee attack when already attacking.")

	scratchpad.is_attacking = true
	scratchpad.executing_attack_meta_data = attack_meta_data
	scratchpad.next_action_input_i = 1
	scratchpad.next_attack_action_input_t = t
end

local NEAR_FOLLOW_POSITION_RANGE_SQ = 25

BtBotMeleeAction._is_in_engage_range = function (self, self_position, target_position, action_data, follow_position)
	local engage_range_sq = nil

	if Vector3.distance_squared(self_position, follow_position) < NEAR_FOLLOW_POSITION_RANGE_SQ then
		engage_range_sq = action_data.engage_range_near_follow_position^2
	else
		engage_range_sq = action_data.engage_range^2
	end

	return Vector3.distance_squared(self_position, target_position) < engage_range_sq
end

local TARGET_NAV_MESH_ABOVE = 0.5
local TARGET_NAV_MESH_BELOW = 2

BtBotMeleeAction._target_unit_position = function (self, self_position, target_unit, action_data, nav_world, traverse_logic)
	local target_unit_position = nil

	if action_data.destroy_object then
		local smart_objects = nil
		local nav_graph_extension = ScriptUnit.has_extension(target_unit, "nav_graph_system")

		if nav_graph_extension then
			smart_objects = nav_graph_extension:smart_objects()
		end

		if smart_objects then
			local smart_object = smart_objects[1]
			local entrance_position, exit_position = smart_object:get_entrance_exit_positions()
			target_unit_position = math.closest_position(self_position, entrance_position, exit_position)
		else
			local node_name = "rp_center"
			local node = (Unit.has_node(target_unit, node_name) and Unit.node(target_unit, node_name)) or 1
			local node_position = Unit.world_position(target_unit, node)
			target_unit_position = NavQueries.position_on_mesh(nav_world, node_position, TARGET_NAV_MESH_ABOVE, TARGET_NAV_MESH_BELOW, traverse_logic) or node_position
		end
	else
		target_unit_position = POSITION_LOOKUP[target_unit]
	end

	return target_unit_position
end

local START_CHALLENGE_VALUE = 10
local MAX_CHALLENGE_VALUE = 30
local ALREADY_ENGAGED_STICKINESS = 3

BtBotMeleeAction._allow_engage = function (self, self_unit, target_unit, target_position, target_breed, scratchpad, action_data, already_engaged, aim_position, follow_position)
	local challenge_rating = 0
	local override_range_default = action_data.override_engage_range_to_follow_position
	local challenge_override_range = action_data.override_engage_range_to_follow_position_challenge
	local lerp_t = (challenge_rating - START_CHALLENGE_VALUE) / (MAX_CHALLENGE_VALUE - START_CHALLENGE_VALUE)
	local override_range = nil

	if lerp_t <= 0 then
		override_range = override_range_default
	elseif lerp_t >= 1 then
		override_range = challenge_override_range
	else
		override_range = math.lerp(override_range_default, challenge_override_range, lerp_t * lerp_t)
	end

	local distance_to_follow_position = Vector3.distance(aim_position, follow_position)
	local stickiness = (already_engaged and ALREADY_ENGAGED_STICKINESS) or 0

	if override_range < distance_to_follow_position - stickiness then
		return false
	end

	local main_path_manager = Managers.state.main_path
	local perception_component = scratchpad.perception_component
	local bot_group_data = scratchpad.bot_group_data
	local target_ally = perception_component.target_ally
	local target_ally_needs_aid = perception_component.target_ally_needs_aid
	local follow_unit = (target_ally_needs_aid and target_ally) or bot_group_data.follow_unit

	if follow_unit and main_path_manager:is_main_path_ready() then
		local self_segment = main_path_manager:segment_index_by_unit(self_unit)
		local target_segment = main_path_manager:segment_index_by_unit(follow_unit)

		if self_segment < target_segment then
			return false
		end
	end

	local bot_group = scratchpad.bot_group

	if target_ally_needs_aid and bot_group:is_prioritized_ally(self_unit, target_ally) then
		local perception_extension = scratchpad.perception_extension

		if not perception_extension:within_aid_range(self_unit, perception_component) then
			return false
		end

		local force_aid = perception_component.force_aid
		local health = ScriptUnit.extension(target_ally, "health_system"):current_health_percent()
		local threat_to_aid = health > 0.3 and self:_is_targeting_me(self_unit, target_unit) and (not force_aid or target_breed.is_bot_aid_threat)

		if not threat_to_aid then
			return false
		end

		local target_in_proximity = false
		local enemies_in_proximity = scratchpad.enemies_in_proximity
		local num_enemies_in_proximity = scratchpad.num_enemies_in_proximity

		for i = 1, num_enemies_in_proximity, 1 do
			local enemy_unit = enemies_in_proximity[i]

			if enemy_unit == target_unit then
				target_in_proximity = true

				break
			end
		end

		if not target_in_proximity then
			return false
		end
	end

	local priority_target = perception_component.priority_target_enemy

	if priority_target and target_unit ~= priority_target then
		return false
	end

	local behavior_extension = scratchpad.behavior_extension
	local stay_near_player, max_allowed_distance = behavior_extension:should_stay_near_player()

	if stay_near_player and max_allowed_distance < distance_to_follow_position then
		return false
	end

	local darkness_system = scratchpad.darkness_system
	local in_total_darkness = darkness_system:is_in_darkness(target_position, darkness_system.TOTAL_DARKNESS_THRESHOLD)

	if in_total_darkness and not target_ally_needs_aid and not perception_component.aggressive_mode and target_unit ~= perception_component.urgent_target_enemy and target_unit ~= perception_component.opportunity_target_enemy then
		return false
	end

	return true
end

BtBotMeleeAction._is_targeting_me = function (self, self_unit, enemy_unit)
	local target_blackboard = BLACKBOARDS[enemy_unit]

	if not target_blackboard then
		return false
	end

	local target_perception_component = target_blackboard.perception
	local is_targeting_me = target_perception_component.target_unit == self_unit

	return is_targeting_me
end

BtBotMeleeAction._engage = function (self, scratchpad, t)
	scratchpad.engaging = true
	scratchpad.engage_change_time = t
end

BtBotMeleeAction._disengage = function (self, scratchpad, t)
	scratchpad.engaging = false
	scratchpad.engage_change_time = t
	local melee_component = scratchpad.melee_component
	melee_component.engage_position_set = false
end

local ENGAGE_NAV_MESH_ABOVE = 0.5
local ENGAGE_NAV_MESH_BELOW = 0.5

local function _check_angle(nav_world, traverse_logic, target_position, start_direction, angle, distance)
	local direction = Quaternion.rotate(Quaternion(Vector3.up(), angle), start_direction)
	local check_position = target_position - direction * distance
	local position = NavQueries.position_on_mesh(nav_world, check_position, ENGAGE_NAV_MESH_ABOVE, ENGAGE_NAV_MESH_BELOW, traverse_logic)

	return position
end

local SUBDIVISIONS_PER_SIDE = 3
local ANGLE_INCREMENT = math.pi / (SUBDIVISIONS_PER_SIDE + 1)

local function _calculate_engage_position(nav_world, traverse_logic, target_position, engage_from, melee_distance)
	local start_direction = Vector3.normalize(Vector3.flat(engage_from))
	local position = _check_angle(nav_world, traverse_logic, target_position, start_direction, 0, melee_distance)

	if position then
		return position
	end

	for i = 1, SUBDIVISIONS_PER_SIDE, 1 do
		local angle = ANGLE_INCREMENT * i
		position = _check_angle(nav_world, traverse_logic, target_position, start_direction, angle, melee_distance)

		if position then
			return position
		end

		position = _check_angle(nav_world, traverse_logic, target_position, start_direction, -angle, melee_distance)

		if position then
			return position
		end
	end

	position = _check_angle(nav_world, traverse_logic, target_position, start_direction, math.pi, melee_distance)

	return position
end

local TARGET_MOVING_SPEED_THRESHOLD_SQ = 4
local FACING_DOT = -0.25
local ENGAGE_OFFSET_ANGLE = math.pi / 8
local ENGAGE_POSITION_MIN_DISTANCE_SQ = 0.010000000000000002
local ENGAGE_UPDATE_MIN_DISTANCE = 3
local ENGAGE_UPDATE_MAX_DISTANCE = 7
local ENGAGE_UPDATE_MIN_INTERVAL = 0.2
local ENGAGE_UPDATE_MAX_INTERVAL = 2

BtBotMeleeAction._update_engage_position = function (self, unit, self_position, target_unit, target_unit_position, target_velocity, target_breed, scratchpad, t, melee_range, nav_world, traverse_logic)
	local melee_distance = nil
	local target_speed_sq = Vector3.length_squared(target_velocity)

	if TARGET_MOVING_SPEED_THRESHOLD_SQ < target_speed_sq then
		melee_distance = 0
	else
		melee_distance = melee_range - 0.5
	end

	local melee_distance_sq = melee_distance^2
	local targeting_me = self:_is_targeting_me(unit, target_unit)
	local enemy_offset = target_unit_position - self_position
	local should_stop = false
	local engage_position = nil

	if target_breed and target_breed.bots_should_flank and (not targeting_me or target_breed.bots_flank_while_targeted) then
		local enemy_rotation = Unit.local_rotation(target_unit, 1)
		local enemy_direction = Quaternion.forward(enemy_rotation)
		local engage_from = nil

		if FACING_DOT < Vector3.dot(enemy_direction, enemy_offset) then
			engage_from = enemy_offset
		else
			local normalized_enemy_offset = Vector3.normalize(Vector3.flat(enemy_offset))
			local normalized_enemy_direction = Vector3.normalize(Vector3.flat(enemy_direction))
			local offset_angle = Vector3.flat_angle(-normalized_enemy_offset, normalized_enemy_direction)
			local new_angle = nil

			if offset_angle > 0 then
				new_angle = offset_angle + ENGAGE_OFFSET_ANGLE
			else
				new_angle = offset_angle - ENGAGE_OFFSET_ANGLE
			end

			local new_rotation = Quaternion.multiply(Quaternion(Vector3.up(), -new_angle), enemy_rotation)
			engage_from = -Quaternion.forward(new_rotation)
		end

		engage_position = _calculate_engage_position(nav_world, traverse_logic, target_unit_position, engage_from, melee_distance)
	elseif Vector3.distance_squared(self_position, target_unit_position) <= melee_distance_sq then
		should_stop = true
		engage_position = self_position
	else
		engage_position = _calculate_engage_position(nav_world, traverse_logic, target_unit_position, enemy_offset, melee_distance)
	end

	if engage_position then
		local melee_component = scratchpad.melee_component
		local previous_engage_position = melee_component.engage_position:unbox()
		local engage_position_set = melee_component.engage_position_set

		if not engage_position_set or ENGAGE_POSITION_MIN_DISTANCE_SQ < Vector3.distance_squared(engage_position, previous_engage_position) then
			melee_component.engage_position:store(engage_position)

			melee_component.engage_position_set = true
			melee_component.stop_at_current_position = should_stop
		end

		local distance = Vector3.distance(self_position, engage_position)
		local lerp_t = math.clamp(distance, ENGAGE_UPDATE_MIN_DISTANCE, ENGAGE_UPDATE_MAX_DISTANCE)
		local interval = math.auto_lerp(ENGAGE_UPDATE_MIN_DISTANCE, ENGAGE_UPDATE_MAX_DISTANCE, ENGAGE_UPDATE_MIN_INTERVAL, ENGAGE_UPDATE_MAX_INTERVAL, lerp_t)
		scratchpad.engage_update_time = t + interval
	end
end

BtBotMeleeAction._evaluation_timer = function (self, scratchpad, t, timer_value)
	local last_evaluate_t = scratchpad.last_evaluate_t
	local evaluate = timer_value < t - last_evaluate_t

	if evaluate then
		scratchpad.last_evaluate_t = t

		return true
	else
		return false
	end
end

return BtBotMeleeAction
