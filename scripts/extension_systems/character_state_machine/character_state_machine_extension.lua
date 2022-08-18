local CharacterStateMachine = require("scripts/extension_systems/character_state_machine/character_state_machine")
local IntoxicatedMovement = require("scripts/extension_systems/character_state_machine/character_states/utilities/intoxicated_movement")
local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local CharacterStateMachineExtension = class("CharacterStateMachineExtension")

CharacterStateMachineExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, game_object_id)
	local world = extension_init_context.world
	self._state_class_list = extension_init_data.state_class_list
	self._unit = unit
	self._world = world
	self._is_local_unit = extension_init_data.is_local_unit
	local unit_data = ScriptUnit.extension(unit, "unit_data_system")
	self._character_state_component = unit_data:read_component("character_state")
	local is_server = extension_init_context.is_server
	local ledge_finder_extension_or_nil = ScriptUnit.has_extension(unit, "ledge_finder_system")
	local steering_component, move_state_component, ladder_character_state_component = self:_init_components(unit_data, extension_init_data)
	local context = self:_create_init_context(unit, world, extension_init_context.physics_world, extension_init_context.wwise_world, extension_init_context.nav_world, is_server, extension_init_data, unit_data, ledge_finder_extension_or_nil, steering_component, move_state_component, ladder_character_state_component, game_object_data_or_game_session, game_object_id)
	local dt = GameParameters.fixed_time_step
	local t = extension_init_context.fixed_frame * dt

	self:_create_state_machine(unit, is_server, extension_init_data.start_state, context, dt, t)
end

CharacterStateMachineExtension._init_components = function (self, unit_data, extension_init_data)
	local steering = unit_data:write_component("locomotion_steering")
	steering.velocity_wanted = Vector3.zero()
	steering.local_move_x = 0
	steering.local_move_y = 0
	steering.calculate_fall_velocity = true
	steering.move_method = "script_driven"
	steering.disable_velocity_rotation = false
	steering.disable_minion_collision = false
	local move_state = unit_data:write_component("movement_state")
	move_state.is_dodging = false
	move_state.is_crouching = false
	move_state.is_crouching_transition_start_t = 0
	move_state.can_jump = true
	move_state.method = "idle"
	local ladder_character_state_component = unit_data:write_component("ladder_character_state")
	ladder_character_state_component.ladder_cooldown = 0
	ladder_character_state_component.ladder_unit_id = NetworkConstants.invalid_level_unit_id
	ladder_character_state_component.top_enter_leave_timer = 0
	ladder_character_state_component.end_position = Vector3.zero()
	ladder_character_state_component.start_position = Vector3.zero()
	local stun_state_input = unit_data:write_component("stun_state_input")
	stun_state_input.disorientation_type = "none"
	stun_state_input.push_direction = Vector3.zero()
	stun_state_input.stun_frame = 0
	self._stun_state_input_component = stun_state_input
	local catapulted_state_input = unit_data:write_component("catapulted_state_input")
	catapulted_state_input.new_input = false
	catapulted_state_input.velocity = Vector3.zero()
	self._catapulted_state_input = catapulted_state_input
	local dead_state_input = unit_data:write_component("dead_state_input")
	dead_state_input.die = false
	dead_state_input.despawn_time = 0
	local knocked_down_state_input = unit_data:write_component("knocked_down_state_input")
	knocked_down_state_input.knock_down = false
	local hogtied_state_input = unit_data:write_component("hogtied_state_input")
	hogtied_state_input.hogtie = false
	local disabled_state_input = unit_data:write_component("disabled_state_input")
	disabled_state_input.wants_disable = false
	disabled_state_input.disabling_unit = nil
	disabled_state_input.disabling_type = "none"
	disabled_state_input.trigger_animation = "none"
	self._disabled_state_input = disabled_state_input
	local assisted_state_input = unit_data:write_component("assisted_state_input")
	assisted_state_input.in_progress = false
	assisted_state_input.success = false
	assisted_state_input.force_assist = false
	local debug_state_input = unit_data:write_component("debug_state_input")
	debug_state_input.self_assist = false
	self._lunge_character_state_component = unit_data:read_component("lunge_character_state")
	local character_state_random = unit_data:write_component("character_state_random")
	character_state_random.seed = extension_init_data.initial_seed
	local intoxicated_movement_component = unit_data:write_component("intoxicated_movement")

	IntoxicatedMovement.initialize_component(intoxicated_movement_component)

	local minigame_character_state_component = unit_data:write_component("minigame_character_state")
	minigame_character_state_component.interface_unit_id = NetworkConstants.invalid_level_unit_id

	return steering, move_state, ladder_character_state_component
end

CharacterStateMachineExtension._create_state_machine = function (self, unit, is_server, start_state, state_init_context, dt, t)
	local states = {}
	local state_class_list = self._state_class_list

	for name, class in pairs(state_class_list) do
		local state_instance = class:new(state_init_context, name)

		assert(name and states[name] == nil)

		states[name] = state_instance
	end

	local state_machine = CharacterStateMachine:new(self._unit, is_server, states, start_state, dt, t)
	self._state_machine = state_machine
end

CharacterStateMachineExtension._create_init_context = function (self, unit, world, physics_world, wwise_world, nav_world, is_server, extension_init_data, unit_data, ledge_finder_extension_or_nil, steering_component, move_state_component, ladder_character_state_component, game_session, game_object_id)
	local state_init_context = {
		world = world,
		unit = unit,
		game_session = game_session,
		game_object_id = game_object_id,
		is_server = is_server,
		player = extension_init_data.player,
		is_local_unit = extension_init_data.is_local_unit,
		physics_world = physics_world,
		nav_world = nav_world,
		wwise_world = wwise_world,
		ledge_finder_extension_or_nil = ledge_finder_extension_or_nil,
		unit_data = unit_data,
		locomotion_steering_component = steering_component,
		movement_state_component = move_state_component,
		alternate_fire_component = unit_data:read_component("alternate_fire"),
		character_state_component = unit_data:read_component("character_state"),
		disabled_character_state_component = unit_data:read_component("disabled_character_state"),
		dodge_character_state_component = unit_data:read_component("dodge_character_state"),
		first_person_component = unit_data:read_component("first_person"),
		first_person_mode_component = unit_data:write_component("first_person_mode"),
		inair_state_component = unit_data:write_component("inair_state"),
		interactee_component = unit_data:read_component("interactee"),
		interaction_component = unit_data:read_component("interaction"),
		inventory_component = unit_data:read_component("inventory"),
		ladder_character_state_component = ladder_character_state_component,
		locomotion_component = unit_data:read_component("locomotion"),
		locomotion_force_rotation_component = unit_data:write_component("locomotion_force_rotation"),
		locomotion_force_translation_component = unit_data:write_component("locomotion_force_translation"),
		lunge_character_state_component = unit_data:read_component("lunge_character_state"),
		movement_settings_component = unit_data:read_component("movement_settings"),
		sprint_character_state_component = unit_data:read_component("sprint_character_state"),
		stunned_character_state_component = unit_data:read_component("stunned_character_state"),
		sway_component = unit_data:read_component("sway"),
		weapon_action_component = unit_data:read_component("weapon_action"),
		action_sweep_component = unit_data:read_component("action_sweep"),
		player_character_constants = extension_init_data.player_character_constants,
		breed = extension_init_data.breed,
		archetype = unit_data:archetype()
	}

	return state_init_context
end

CharacterStateMachineExtension.extensions_ready = function (self, world, unit)
	self._state_machine:extensions_ready(world, unit)
end

CharacterStateMachineExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._state_machine:game_object_initialized(game_session, game_object_id)
end

CharacterStateMachineExtension.server_correction_occurred = function (self, unit)
	self._state_machine:server_correction_occurred(unit)
end

CharacterStateMachineExtension.destroy = function (self)
	self._state_machine:exit_current_state()
end

CharacterStateMachineExtension.reset = function (self)
	self._state_machine:reset()
end

CharacterStateMachineExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	self._state_machine:fixed_update(unit, dt, t, fixed_frame)
	self:_clear_state_input_components(fixed_frame)

	if self._is_local_unit then
		self:_on_screen_particles(t)
	end
end

CharacterStateMachineExtension._on_screen_particles = function (self, t)
	local current_state = self._state_machine:current_state()

	if self._dash_particle_effect and current_state ~= "lunging" then
		World.destroy_particles(self._world, self._dash_particle_effect)

		self._dash_particle_effect = nil
	elseif current_state == "lunging" and not self._dash_particle_effect then
		local lunge_template = LungeTemplates[self._lunge_character_state_component.lunge_template]
		local on_screen_effect = lunge_template.on_screen_effect
		local on_screen_effect_delay = on_screen_effect and lunge_template.on_screen_effect_delay or 0
		local should_play_on_screen = on_screen_effect and t >= self._character_state_component.entered_t + on_screen_effect_delay

		if should_play_on_screen then
			self._dash_particle_effect = World.create_particles(self._world, on_screen_effect, Vector3(0, 0, 1))
		end
	end
end

CharacterStateMachineExtension._clear_state_input_components = function (self, fixed_frame)
	local stun_state_input = self._stun_state_input_component

	if stun_state_input.disorientation_type ~= "none" then
		local wanted_frame = stun_state_input.stun_frame + 1

		if fixed_frame >= wanted_frame then
			stun_state_input.disorientation_type = "none"
			stun_state_input.push_direction = Vector3.zero()
			stun_state_input.stun_frame = 0
		end
	end

	local catapulted_state_input = self._catapulted_state_input

	if catapulted_state_input.new_input then
		catapulted_state_input.new_input = false
		catapulted_state_input.velocity = Vector3.zero()
	end

	local disabled_state_input = self._disabled_state_input
	disabled_state_input.wants_disable = false
end

CharacterStateMachineExtension.pre_update = function (self, unit, dt, t)
	self._state_machine:pre_update(unit, dt, t)
end

CharacterStateMachineExtension.update = function (self, unit, dt, t)
	self._state_machine:update(unit, dt, t)
end

CharacterStateMachineExtension.set_state = function (self, unit, dt, t, next_state, params)
	self._state_machine:set_state(unit, dt, t, next_state, params)
end

CharacterStateMachineExtension.current_state = function (self)
	return self._state_machine:current_state()
end

return CharacterStateMachineExtension
