require("scripts/extension_systems/training_grounds/training_grounds_directional_unit_extension")

local TrainingGroundsServitorHandler = require("scripts/extension_systems/training_grounds/training_grounds_servitor_handler")
local Attack = require("scripts/utilities/attack/attack")
local BotSpawning = require("scripts/managers/bot/bot_spawning")
local Breeds = require("scripts/settings/breed/breeds")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Health = require("scripts/utilities/health")
local PlayerMovement = require("scripts/utilities/player_movement")
local ScriptedScenarios = require("scripts/extension_systems/training_grounds/scripted_scenarios")
local TrainingGroundsSoundEvents = require("scripts/settings/training_grounds/training_grounds_sound_events")
local WoundMaterials = require("scripts/extension_systems/wounds/utilities/wound_materials")
local TrainingGroundsScenarioSystem = class("TrainingGroundsScenarioSystem", "ExtensionSystemBase")
local RAMPING_VFX = "content/fx/particles/weapons/force_staff/force_staff_channel_charge"
local SPAWN_EXPLOSION_VFX = "content/fx/particles/weapons/force_staff/force_staff_explosion"
local WOUND_INDEX = 1
local DISSOLVE_ORIGIN = Vector3Box(0, 0, 3.5)
local MAX_DISSOLVE_RADIUS = Vector3.length(DISSOLVE_ORIGIN:unbox()) * 10 + 5
local MIN_DISSOLVE_RADIUS = 0.01

local function get_shape_scale(radius)
	return 1 / (0.1 * radius) - 0.001
end

local hide_on_spawn_slots = {
	slot_shield = 0.3,
	slot_hair = 0.8,
	slot_ranged_weapon = 0.3,
	slot_melee_weapon = 0.3
}
local hide_on_dissolve_slots = {
	slot_shield = 0.7,
	slot_flesh = 0,
	slot_melee_weapon = 0.7,
	slot_hair = 0.3,
	slot_ranged_weapon = 0.7
}

TrainingGroundsScenarioSystem.init = function (self, extension_system_creation_context, ...)
	TrainingGroundsScenarioSystem.super.init(self, extension_system_creation_context, ...)

	self._world = extension_system_creation_context.world
	self._nav_world = extension_system_creation_context.nav_world
	self._wwise_world = extension_system_creation_context.wwise_world
	self._enabled = false
	self._teleporters = {}
	self._directional_unit_extensions = {}
	self._spawn_groups = {}
	self._scenario_bots = {}
	self._queued_bot_removals = {}
	self._minions_being_dissolved = {}
	self._spawning_minions = {}
	self._spawning_units = {}
	self._current_scenario_name = "none"
	self._current_alias = "none"
	self._queued_scenarios = {}
	self._current_scenario = nil
	self._init_scenario = nil
	self._parallel_scenarios = {}
	self._tracked_events = {}
	self._time_scale_data = nil
	local nav_tag_cost_table = GwNavTagLayerCostTable.create()
	local traverse_logic = GwNavTraverseLogic.create(self._nav_world)

	GwNavTraverseLogic.set_navtag_layer_cost_table(traverse_logic, nav_tag_cost_table)

	self._traverse_logic = traverse_logic
	self._nav_tag_cost_table = nav_tag_cost_table
	self._servitor_handler = TrainingGroundsServitorHandler:new(self)
	local scenario_system = self
	self._objective_marker_data = {
		units = {},
		datas = {},
		remove_when_dead = {},
		cb_set_objective_marker_id = function (marker_id)
			scenario_system._objective_marker_data.marker_id = marker_id
		end
	}

	Managers.event:trigger("training_grounds_scenario_system_initialized", self)
end

TrainingGroundsScenarioSystem.destroy = function (self)
	if Managers.time:has_timer("gameplay") then
		local t = Managers.time:time("gameplay")

		self:stop_scenario(t, nil, true, true)

		local parallel_scenarios = self._parallel_scenarios

		for alias, scenarios in pairs(parallel_scenarios) do
			for name, scenario in pairs(scenarios) do
				self:stop_parallel_scenario(scenario.alias, name, t, true)
			end
		end
	end

	for local_bot_id, _ in pairs(self._scenario_bots) do
		BotSpawning.despawn_bot_character(local_bot_id)

		self._scenario_bots[local_bot_id] = nil
	end

	GwNavTagLayerCostTable.destroy(self._nav_tag_cost_table)

	self._nav_tag_cost_table = nil

	GwNavTraverseLogic.destroy(self._traverse_logic)

	self._traverse_logic = nil

	if self._scenario_handler then
		self._scenario_handler:destroy()
	end

	TrainingGroundsScenarioSystem.super.destroy(self)
end

TrainingGroundsScenarioSystem.on_add_extension = function (self, world, unit, ...)
	local extension = TrainingGroundsScenarioSystem.super.on_add_extension(self, world, unit, ...)

	self:_add_directional_unit(unit, extension)

	return extension
end

TrainingGroundsScenarioSystem.on_remove_extension = function (self, unit, extension_name)
	TrainingGroundsScenarioSystem.super.on_remove_extension(self, unit, extension_name)
	self:_remove_directional_unit(unit)
end

TrainingGroundsScenarioSystem.enabled = function (self)
	return self._enabled
end

TrainingGroundsScenarioSystem.update = function (self, context, dt, t)
	TrainingGroundsScenarioSystem.super.fixed_update(self, context, dt, t)

	if not self._enabled then
		return
	end

	self._servitor_handler:update(dt, t)
	self:_update_objective_marker()
	self:_handle_minion_dissolves(t)
	self:_update_time_scale()
end

TrainingGroundsScenarioSystem.fixed_update = function (self, context, dt, t)
	TrainingGroundsScenarioSystem.super.fixed_update(self, context, dt, t)

	if not self._enabled then
		return
	end

	self:_handle_bot_despawns()
	self:_handle_spawning_minions(t)
	self:_handle_spawning_units(t)

	if self._stop_scenario_t and self._stop_scenario_t < t then
		self._stop_scenario_t = nil

		self:stop_scenario(t)
	elseif self._current_scenario then
		local should_stop = self:_handle_scenario(self._current_scenario, t)

		if should_stop then
			self:stop_scenario(t)
		end
	elseif not table.is_empty(self._queued_scenarios) then
		local scenario_data = table.remove(self._queued_scenarios, 1)
		local alias = scenario_data.alias
		local name = scenario_data.name

		self:start_scenario(alias, name, t)
	end

	self:_handle_parallel_scenarios(t)
end

TrainingGroundsScenarioSystem._handle_bot_despawns = function (self)
	local bot_removals = self._queued_bot_removals
	local scenario_bots = self._scenario_bots

	for bot_local_id, marked_for_deletion in pairs(bot_removals) do
		local peer_id = Network.peer_id()
		local bot_player = Managers.player:player(peer_id, bot_local_id)
		local no_player_object = not bot_player
		local unit_is_valid = bot_player and bot_player.player_unit and not marked_for_deletion
		local unit_deleted = bot_player and not bot_player.player_unit

		if no_player_object then
			bot_removals[bot_local_id] = nil
			scenario_bots[bot_local_id] = nil
		elseif unit_is_valid then
			local unit_spawner = Managers.state.unit_spawner

			unit_spawner:mark_for_deletion(bot_player.player_unit)

			local is_marked_for_deletion = true
			bot_removals[bot_local_id] = is_marked_for_deletion
		elseif unit_deleted then
			BotSpawning.despawn_bot_character(bot_local_id)

			bot_removals[bot_local_id] = nil
			scenario_bots[bot_local_id] = nil
		end
	end
end

TrainingGroundsScenarioSystem._handle_minion_dissolves = function (self, t)
	for unit, dissolve_data in pairs(self._minions_being_dissolved) do
		repeat
			if not ALIVE[unit] then
				self._minions_being_dissolved[unit] = nil
			else
				local from_radius = MIN_DISSOLVE_RADIUS
				local to_radius = MAX_DISSOLVE_RADIUS
				local lerp_t = (t - dissolve_data.start_t) / dissolve_data.duration
				local lerped_radius = math.lerp(from_radius, to_radius, lerp_t)
				local shape_scale = get_shape_scale(lerped_radius)
				dissolve_data.wound.radii[WOUND_INDEX] = lerped_radius
				dissolve_data.wound.shape_scales[WOUND_INDEX] = shape_scale
				local wounds_data = dissolve_data.wounds_data
				local visual_loadout_extension = dissolve_data.visual_loadout_extension

				WoundMaterials.apply(unit, wounds_data, WOUND_INDEX, visual_loadout_extension:slot_items())

				local inventory_slots = dissolve_data.inventory_slots

				for slot_name, _ in pairs(inventory_slots) do
					local hide_percentage_t = hide_on_dissolve_slots[slot_name]

					if hide_percentage_t then
						local hide_t = dissolve_data.start_t + dissolve_data.duration * hide_percentage_t

						if t > hide_t then
							self:_set_slot_visible(visual_loadout_extension, slot_name, false)
						end
					end
				end

				if dissolve_data.done_t < t then
					local health_extension = ScriptUnit.has_extension(unit, "health_system")

					if HEALTH_ALIVE[unit] then
						self:trigger_wwise_event(TrainingGroundsSoundEvents.tg_minion_execute)

						local damage_profile = DamageProfileTemplates.default

						health_extension:set_unkillable(false)
						health_extension:set_invulnerable(false)
						Attack.execute(unit, damage_profile, "instakill", true)
					elseif not health_extension then
						self._minions_being_dissolved[unit] = nil
						local minion_death_manager = Managers.state.minion_death
						local minion_ragdoll = minion_death_manager:minion_ragdoll()

						minion_ragdoll:remove_ragdoll_safe(unit)
					end
				end
			end
		until true
	end
end

TrainingGroundsScenarioSystem._handle_spawning_minions = function (self, t)
	for unit, spawn_data in pairs(self._spawning_minions) do
		repeat
			local exists = ALIVE[unit]
			local is_dissolving = self._minions_being_dissolved[unit]

			if not exists or is_dissolving then
				self._spawning_minions[unit] = nil

				if not spawn_data.vfx_destroyed then
					spawn_data.vfx_destroyed = true
					local world = self._world

					World.destroy_particles(world, spawn_data.vfx_id)
				end
			else
				local from_radius = MAX_DISSOLVE_RADIUS
				local to_radius = MIN_DISSOLVE_RADIUS
				local lerp_t = (t - spawn_data.start_t) / spawn_data.spawn_duration
				lerp_t = math.clamp01(lerp_t)
				local lerped_radius = math.lerp(from_radius, to_radius, lerp_t)
				local shape_scale = get_shape_scale(lerped_radius)
				spawn_data.wound.radii[WOUND_INDEX] = lerped_radius
				spawn_data.wound.shape_scales[WOUND_INDEX] = shape_scale
				local wounds_data = spawn_data.wounds_data
				local visual_loadout_extension = spawn_data.visual_loadout_extension

				WoundMaterials.apply(unit, wounds_data, WOUND_INDEX, visual_loadout_extension:slot_items())

				local slots_shown = spawn_data.slots_shown

				for slot_name, _ in pairs(spawn_data.inventory_slots) do
					local show_percentage_t = hide_on_spawn_slots[slot_name]

					if show_percentage_t and not slots_shown[slot_name] then
						local show_t = spawn_data.start_t + spawn_data.spawn_duration * show_percentage_t

						if t > show_t then
							self:_set_slot_visible(visual_loadout_extension, slot_name, true)

							slots_shown[slot_name] = true
						end
					end
				end

				local flesh_is_visible = visual_loadout_extension:is_slot_visible("slot_flesh")
				spawn_data.show_flesh = spawn_data.show_flesh or flesh_is_visible

				if flesh_is_visible then
					visual_loadout_extension:set_slot_visibility("slot_flesh", false)
				end

				if not spawn_data.vfx_destroyed and spawn_data.destroy_vfx_t < t then
					spawn_data.vfx_destroyed = true
					local world = self._world

					World.destroy_particles(world, spawn_data.vfx_id)
				end

				if t > spawn_data.start_t + spawn_data.spawn_duration then
					if not spawn_data.spawn_vulnerable then
						local health_extension = ScriptUnit.extension(unit, "health_system")

						health_extension:set_invulnerable(false)
					end

					self._spawning_minions[unit] = nil

					if spawn_data.show_flesh then
						visual_loadout_extension:set_slot_visibility("slot_flesh", true)
					end
				end
			end
		until true
	end
end

TrainingGroundsScenarioSystem._handle_spawning_units = function (self, t)
	local spawning_units = self._spawning_units
	local unit_spawner = Managers.state.unit_spawner

	for ramping_spawn_data, _ in pairs(spawning_units) do
		if ramping_spawn_data.done_t < t then
			ramping_spawn_data.done = true
			local unit_name = ramping_spawn_data.unit_name
			local template_name = ramping_spawn_data.template_name
			local position = ramping_spawn_data.position:unbox()
			local rotation = ramping_spawn_data.rotation:unbox()

			if unit_name and template_name then
				ramping_spawn_data.unit = unit_spawner:spawn_network_unit(unit_name, template_name, position, rotation)
			end

			local world = self._world

			World.destroy_particles(world, ramping_spawn_data.ramping_vfx_id)

			ramping_spawn_data.explosion_vfx_id = World.create_particles(world, SPAWN_EXPLOSION_VFX, position, rotation)
			spawning_units[ramping_spawn_data] = nil
		end
	end
end

TrainingGroundsScenarioSystem.set_enabled = function (self, enable)
	self._player = Managers.player:local_player(1)
	self._enabled = enable

	if enable then
		local init_scenario = self._init_scenario

		if init_scenario then
			self:queue_scenario(init_scenario.alias, init_scenario.name)
		end
	elseif ALIVE[self._servitor_handler:unit()] then
		self._servitor_handler:despawn_servitor()
	end
end

TrainingGroundsScenarioSystem.enabled = function (self)
	return self._enabled
end

TrainingGroundsScenarioSystem.on_level_enter = function (self)
	WwiseWorld.trigger_resource_event(self._wwise_world, TrainingGroundsSoundEvents.tg_level_enter)
end

TrainingGroundsScenarioSystem.on_level_exit = function (self)
	WwiseWorld.trigger_resource_event(self._wwise_world, TrainingGroundsSoundEvents.tg_level_exit)
end

TrainingGroundsScenarioSystem._handle_scenario = function (self, scenario, t)
	local player = self._player
	local scenario_data = scenario.scenario_data
	local step_data = scenario_data.step_data
	local success = true
	local step_template = scenario.current_step_template

	if step_template.condition_func then
		success = step_template.condition_func(self, player, scenario_data, step_data, t)
	end

	local should_stop = false

	if success then
		self:_stop_step(scenario, step_template, player, scenario_data, step_data, t)

		scenario.step_index = scenario.step_index + 1
		local next_step_template = scenario.template.steps[scenario.step_index]
		scenario.current_step_template = next_step_template

		if next_step_template then
			should_stop = self:_start_step(scenario, next_step_template, player, scenario_data, step_data, t)
		else
			should_stop = true
		end
	end

	return should_stop
end

TrainingGroundsScenarioSystem._handle_condition_step = function (self, scenario, conditional_step_template, player, scenario_data, step_data, t)
	local current_step_template = conditional_step_template
	local step_index = scenario.step_index
	local condition_type = current_step_template.condition_type

	if condition_type ~= "if" then
		while condition_type ~= "end" do
			step_index = step_index + 1
			current_step_template = scenario.template.steps[step_index]
			condition_type = current_step_template.condition_type
		end
	end

	local condition_success = false

	repeat
		if condition_type == "end" then
			break
		end

		local condition_success = current_step_template.condition_func(self, player, scenario_data, step_data, t)

		if not condition_success then
			local depth = 0

			repeat
				step_index = step_index + 1
				current_step_template = scenario.template.steps[step_index]
				condition_type = current_step_template.condition_type

				if condition_type == "if" then
					depth = depth + 1
				elseif condition_type == "end" or condition_type and depth == 0 then
					depth = depth - 1
				end
			until current_step_template.is_condition and depth < 0
		end
	until condition_success

	step_index = step_index + 1
	scenario.step_index = step_index
	scenario.current_step_template = scenario.template.steps[step_index]

	return scenario.current_step_template
end

TrainingGroundsScenarioSystem.start_scenario = function (self, alias, name, t)
	self:stop_scenario(t)

	self._current_scenario_name = name
	self._current_scenario = self:_create_scenario(alias, name)
	local should_stop = self:_start_scenario(self._current_scenario, t)

	if should_stop then
		self:stop_scenario(t)
	end
end

TrainingGroundsScenarioSystem._create_scenario = function (self, alias, name)
	Log.info("TrainingGrounds", "Scenario started (%s.%s)", alias, name)

	local templates = ScriptedScenarios[alias]
	local scenario_template = templates[name]
	local first_step_template = scenario_template.steps[1]
	local scenario = {
		step_index = 1,
		alias = alias,
		template = scenario_template,
		current_step_template = first_step_template,
		scenario_data = {
			step_data = {}
		}
	}

	return scenario
end

TrainingGroundsScenarioSystem._start_scenario = function (self, scenario, t)
	if scenario.alias == "training_grounds" then
		local scenario_name = scenario.template.name
		local reporter = Managers.telemetry_reporters:reporter("training_grounds")

		if reporter then
			reporter:register_new_scenario_started(scenario_name)
		end
	end

	local first_step_template = scenario.template.steps[1]
	local player = self._player
	local scenario_data = scenario.scenario_data
	local step_data = scenario_data.step_data
	local should_stop = self:_start_step(scenario, first_step_template, player, scenario_data, step_data, t)

	return should_stop
end

TrainingGroundsScenarioSystem.stop_scenario = function (self, t, delay, clear_queued_scenarios, ignore_cleanup_steps)
	if delay then
		self._stop_scenario_t = t + delay

		return
	end

	local current_scenario = self._current_scenario
	self._current_scenario = nil

	if current_scenario then
		self:trigger_wwise_event(TrainingGroundsSoundEvents.tg_scenario_complete)
		self:_stop_scenario(current_scenario, ignore_cleanup_steps, t)
	end

	self._current_scenario_name = "none"
	self._current_alias = "none"

	if clear_queued_scenarios then
		table.clear(self._queued_scenarios)
	end
end

TrainingGroundsScenarioSystem._stop_scenario = function (self, scenario, ignore_cleanup_steps, t)
	Log.info("TrainingGrounds", "Scenario stopped (%s.%s)", scenario.alias, scenario.template.name)

	local player = self._player
	local scenario_data = scenario.scenario_data
	local step_data = scenario_data.step_data
	local current_step_template = scenario.current_step_template

	if current_step_template then
		self:_stop_step(scenario, current_step_template, player, scenario_data, step_data, t)
	end

	if not ignore_cleanup_steps then
		local cleanup_steps = scenario.template.cleanup
		scenario_data.cleaning_up = true

		for i = 1, #cleanup_steps do
			local cleanup_step_template = cleanup_steps[i]

			self:_start_step(scenario, cleanup_step_template, player, scenario_data, step_data, t)
		end
	end
end

TrainingGroundsScenarioSystem._on_event = function (self, event_name, ...)
	Log.info("TrainingGrounds", "Event triggered (%s)", event_name)

	local player = self._player
	local tracked_events = self._tracked_events[event_name]

	for scenario, _ in pairs(tracked_events) do
		local scenario_data = scenario.scenario_data
		local step_data = scenario_data.step_data
		local step_template = scenario.current_step_template

		step_template.on_event(self, player, scenario_data, step_data, event_name, ...)
	end
end

TrainingGroundsScenarioSystem._start_step = function (self, scenario, step_template, player, scenario_data, step_data, t)
	Log.info("TrainingGrounds", "Step started (%s)", step_template.name)

	while step_template.is_condition do
		step_template = self:_handle_condition_step(scenario, step_template, player, scenario_data, step_data, t)

		if not step_template then
			return true
		end

		Log.info("TrainingGrounds", "Step started (%s)", step_template.name)
	end

	table.clear(scenario_data.step_data)

	local events = step_template.events

	if events then
		self:_register_events(scenario, events)
	end

	if step_template.start_func then
		step_template.start_func(self, player, scenario_data, step_data, t)
	end

	return false
end

TrainingGroundsScenarioSystem._stop_step = function (self, scenario, step_template, player, scenario_data, step_data, t)
	Log.info("TrainingGrounds", "Step stopped (%s)", step_template.name)

	if step_template.stop_func then
		step_template.stop_func(self, player, scenario_data, step_data, t)
	end

	local events = step_template.events

	if events then
		self:_unregister_events(scenario, events)
	end
end

TrainingGroundsScenarioSystem._register_events = function (self, scenario, events)
	local tracked_events = self._tracked_events

	for i = 1, #events do
		local event_name = events[i]

		if not tracked_events[event_name] then
			tracked_events[event_name] = {}

			Managers.event:register_with_parameters(self, "_on_event", event_name, event_name)
		end

		Log.info("TrainingGrounds", "Event registered (%s)", event_name)

		tracked_events[event_name][scenario] = true
	end
end

TrainingGroundsScenarioSystem._unregister_events = function (self, scenario, events)
	local tracked_events = self._tracked_events

	for i = 1, #events do
		local event_name = events[i]
		tracked_events[event_name][scenario] = nil

		Log.info("TrainingGrounds", "Event unregistered (%s)", event_name)

		if table.is_empty(tracked_events[event_name]) then
			tracked_events[event_name] = nil

			Managers.event:unregister(self, event_name)
		end
	end
end

TrainingGroundsScenarioSystem.flow_cb_register_teleporter = function (self, teleporter_unit, teleporter_name)
	self._teleporters[teleporter_name] = teleporter_unit
end

TrainingGroundsScenarioSystem.flow_cb_teleport_player = function (self, source_teleporter_name, target_teleporter_name)
	local teleporters = self._teleporters
	local from_unit = teleporters[source_teleporter_name]
	local to_unit = teleporters[target_teleporter_name]
	local player = Managers.player:local_player(1)
	local player_unit = player.player_unit
	local from_unit_pose = Unit.local_pose(from_unit, 1)
	local to_unit_pose = Unit.local_pose(to_unit, 1)
	local player_pose = Unit.local_pose(player_unit, 1)
	local relative_to_source = Matrix4x4.multiply(player_pose, Matrix4x4.inverse(from_unit_pose))
	local new_player_pose = Matrix4x4.multiply(relative_to_source, to_unit_pose)
	local position = Matrix4x4.translation(new_player_pose)
	local rotation = Matrix4x4.rotation(new_player_pose)

	PlayerMovement.teleport(player, position, rotation)
end

TrainingGroundsScenarioSystem.queue_bot_removal = function (self, bot_local_id)
	local is_marked_for_deletion = false
	self._queued_bot_removals[bot_local_id] = is_marked_for_deletion
end

TrainingGroundsScenarioSystem.queue_bot_addition = function (self)
	local profile_name = "bot_training_grounds"
	local bot_local_id = BotSpawning.spawn_bot_character(profile_name)
	self._scenario_bots[bot_local_id] = true

	return bot_local_id
end

TrainingGroundsScenarioSystem._set_slot_visible = function (self, visual_loadout_extension, slot_name, visible)
	local has_equipped_slot = visual_loadout_extension:can_unequip_slot(slot_name)
	local is_not = has_equipped_slot and visible ~= visual_loadout_extension:is_slot_visible(slot_name)

	if is_not then
		visual_loadout_extension:set_slot_visibility(slot_name, visible)
	end
end

TrainingGroundsScenarioSystem.dissolve_unit = function (self, unit, t)
	if self._minions_being_dissolved[unit] then
		return self._minions_being_dissolved[unit].done_t
	end

	if ALIVE[unit] then
		local duration = 2
		local wounds_extension = ScriptUnit.extension(unit, "wounds_system")
		local wounds_data = wounds_extension:wounds_data()
		wounds_data.last_write_index = math.max(WOUND_INDEX, wounds_data.last_write_index)
		wounds_data.num_wounds = math.max(WOUND_INDEX, wounds_data.num_wounds)
		local wound = wounds_data[WOUND_INDEX]

		wound.color_brightness_value:store(Vector3(0.6, 1, 0))
		wound.hit_shader_vector:store(DISSOLVE_ORIGIN:unbox())

		wound.radii[WOUND_INDEX] = MIN_DISSOLVE_RADIUS
		wound.radius_index = WOUND_INDEX
		wound.radius_material_key = "wound_radius_0" .. WOUND_INDEX

		wound.shape_mask_uv_offset:store(Vector2(0.75, 0.75))

		wound.shape_scale_index = WOUND_INDEX
		wound.shape_scale_material_key = "wound_shape_scaling_0" .. WOUND_INDEX
		wound.shape_scales[WOUND_INDEX] = get_shape_scale(MIN_DISSOLVE_RADIUS)

		wound.color_time_duration:store(Vector2(World.time(self._world), duration))

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		WoundMaterials.apply(unit, wounds_data, WOUND_INDEX, visual_loadout_extension:slot_items())
		self:trigger_wwise_event(TrainingGroundsSoundEvents.tg_enemy_dissolve_start, Unit.local_position(unit, 1))

		for slot_name, _ in pairs(hide_on_spawn_slots) do
			self:_set_slot_visible(visual_loadout_extension, slot_name, true)
		end

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local inventory = breed.inventory.default[1]
		local inventory_slots = inventory.slots
		local start_t = t
		local delete_t = t + duration
		local spawn_data = self._spawning_minions[unit]

		if spawn_data then
			local percentage_done = math.clamp01((t - spawn_data.start_t) / spawn_data.spawn_duration)
			local new_percentage_done = 1 - percentage_done
			start_t = start_t - duration * new_percentage_done
			delete_t = start_t + duration
		end

		local dissolve_data = {
			start_t = start_t,
			duration = duration,
			done_t = delete_t,
			inventory_slots = inventory_slots,
			visual_loadout_extension = visual_loadout_extension,
			wounds_data = wounds_data,
			wound = wound
		}
		self._minions_being_dissolved[unit] = dissolve_data

		return delete_t
	end

	return t
end

TrainingGroundsScenarioSystem.spawn_breed_ramping = function (self, breed_name, position, rotation, t, duration, side_id, spawn_vulnerable, optional_delay)
	local unit = Managers.state.minion_spawn:spawn_minion(breed_name, position, rotation, side_id)
	local delay = optional_delay or 0
	local wounds_extension = ScriptUnit.extension(unit, "wounds_system")
	local wounds_data = wounds_extension:wounds_data()
	wounds_data.last_write_index = math.max(WOUND_INDEX, wounds_data.last_write_index)
	wounds_data.num_wounds = math.max(WOUND_INDEX, wounds_data.num_wounds)
	local wound = wounds_data[WOUND_INDEX]

	wound.color_brightness_value:store(0.6, 1, 0)
	wound.hit_shader_vector:store(DISSOLVE_ORIGIN:unbox())

	wound.radii[WOUND_INDEX] = MAX_DISSOLVE_RADIUS
	wound.radius_index = WOUND_INDEX
	wound.radius_material_key = "wound_radius_0" .. WOUND_INDEX

	wound.shape_mask_uv_offset:store(Vector2(0.75, 0.75))

	wound.shape_scale_index = WOUND_INDEX
	wound.shape_scale_material_key = "wound_shape_scaling_0" .. WOUND_INDEX
	wound.shape_scales[WOUND_INDEX] = get_shape_scale(MAX_DISSOLVE_RADIUS)

	wound.color_time_duration:store(Vector2(World.time(self._world) + delay, duration))

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	WoundMaterials.apply(unit, wounds_data, WOUND_INDEX, visual_loadout_extension:slot_items())

	local breed = Breeds[breed_name]
	local inventory = breed.inventory.default[1]
	local inventory_slots = inventory.slots

	for slot_name, _ in pairs(inventory_slots) do
		if hide_on_spawn_slots[slot_name] then
			self:_set_slot_visible(visual_loadout_extension, slot_name, false)
		end
	end

	if not spawn_vulnerable then
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:set_invulnerable(true)
	end

	local world = self._world
	local vfx_id = World.create_particles(world, RAMPING_VFX, position, rotation)

	self:trigger_wwise_event(TrainingGroundsSoundEvents.tg_enemy_dissolve_start, position)

	local spawn_data = {
		start_t = t + delay,
		spawn_duration = duration,
		inventory_slots = inventory_slots,
		slots_shown = {},
		position = Vector3Box(position),
		rotation = QuaternionBox(rotation),
		visual_loadout_extension = visual_loadout_extension,
		wounds_data = wounds_data,
		wound = wound,
		breed_name = breed_name,
		spawn_vulnerable = spawn_vulnerable,
		destroy_vfx_t = t + math.min(1.2, duration) + delay,
		vfx_id = vfx_id
	}
	self._spawning_minions[unit] = spawn_data

	return unit
end

TrainingGroundsScenarioSystem.nav_world = function (self)
	return self._nav_world
end

TrainingGroundsScenarioSystem.traverse_logic = function (self)
	return self._traverse_logic
end

TrainingGroundsScenarioSystem.queue_scenario = function (self, alias, name)
	local queued_scenarios = self._queued_scenarios
	queued_scenarios[#queued_scenarios + 1] = {
		alias = alias,
		name = name
	}
end

TrainingGroundsScenarioSystem.reset_scenario = function (self, t, delay)
	local current_scenario = self._current_scenario

	if current_scenario then
		local name = current_scenario.template.name
		local alias = current_scenario.alias

		table.insert(self._queued_scenarios, 1, {
			name = name,
			alias = alias
		})
		self:stop_scenario(t, delay or 0)
	end
end

TrainingGroundsScenarioSystem._add_directional_unit = function (self, unit, extension)
	local identifier = Unit.get_data(unit, "directional_unit_identifier")

	if identifier ~= "default" then
		local id_string = Unit.level_id_string(unit)
		self._directional_unit_extensions[identifier] = extension
	end

	local spawn_group = Unit.get_data(unit, "attached_unit", "spawn_group") or ""

	if spawn_group ~= "" then
		self._spawn_groups[spawn_group] = self._spawn_groups[spawn_group] or {}
		self._spawn_groups[spawn_group][unit] = extension
	end
end

TrainingGroundsScenarioSystem._remove_directional_unit = function (self, unit)
	local identifier = Unit.get_data(unit, "directional_unit_identifier")
	self._directional_unit_extensions[identifier] = nil
	local spawn_group = Unit.get_data(unit, "attached_unit", "spawn_group")

	if spawn_group and spawn_group ~= "" then
		self._spawn_groups[spawn_group][unit] = nil
	end
end

TrainingGroundsScenarioSystem.get_directional_unit = function (self, identifier)
	local ext = self._directional_unit_extensions[identifier]

	return ext:unit()
end

TrainingGroundsScenarioSystem.get_directional_unit_extension = function (self, identifier)
	return self._directional_unit_extensions[identifier]
end

TrainingGroundsScenarioSystem.get_spawn_group = function (self, spawn_group_name)
	return self._spawn_groups[spawn_group_name]
end

TrainingGroundsScenarioSystem.spawn_attached_units_in_spawn_group = function (self, spawn_group_name)
	for _, extension in pairs(self:get_spawn_group(spawn_group_name)) do
		extension:spawn_attached_unit()
	end
end

TrainingGroundsScenarioSystem.unspawn_attached_units_in_spawn_group = function (self, spawn_group_name)
	for _, extension in pairs(self:get_spawn_group(spawn_group_name)) do
		extension:unspawn_attached_unit()
	end
end

TrainingGroundsScenarioSystem.world = function (self)
	return self._world
end

TrainingGroundsScenarioSystem.spawn_unit_ramping = function (self, ramping_spawn_data, t, spawn_duration)
	local world = self._world
	local position = ramping_spawn_data.position:unbox()
	local rotation = ramping_spawn_data.rotation:unbox()
	local vfx_id = World.create_particles(world, RAMPING_VFX, position, rotation)

	self:trigger_wwise_event(TrainingGroundsSoundEvents.tg_enemy_dissolve_start, position)

	ramping_spawn_data.done_t = t + spawn_duration
	ramping_spawn_data.ramping_vfx_id = vfx_id
	self._spawning_units[ramping_spawn_data] = true
end

TrainingGroundsScenarioSystem.trigger_wwise_event = function (self, event_name, optional_position)
	local wwise_world = self._wwise_world

	if optional_position then
		local source = WwiseWorld.make_auto_source(wwise_world, optional_position)

		return WwiseWorld.trigger_resource_event(wwise_world, event_name, source)
	else
		return WwiseWorld.trigger_resource_event(wwise_world, event_name)
	end
end

TrainingGroundsScenarioSystem.servitor_handler = function (self)
	return self._servitor_handler
end

TrainingGroundsScenarioSystem.get_current_scenario_name = function (self)
	return self._current_scenario_name
end

TrainingGroundsScenarioSystem.has_queued_scenario = function (self)
	return not table.is_empty(self._queued_scenarios)
end

TrainingGroundsScenarioSystem.add_unit_marker = function (self, unit, marker_type, remove_when_dead, optional_data)
	self._objective_marker_data.units[unit] = marker_type
	self._objective_marker_data.datas[unit] = optional_data
	self._objective_marker_data.remove_when_dead[unit] = remove_when_dead
end

TrainingGroundsScenarioSystem._update_objective_marker = function (self)
	local marker_data = self._objective_marker_data
	local best_unit = nil
	local best_distance_sq = math.huge
	local units = marker_data.units

	for unit, marker_type in pairs(units) do
		if not ALIVE[unit] or marker_data.remove_when_dead[unit] and not HEALTH_ALIVE[unit] then
			units[unit] = nil
		else
			local unit_position = POSITION_LOOKUP[unit]
			local player_position = POSITION_LOOKUP[self._player.player_unit]
			local dist_sq = Vector3.distance_squared(unit_position, player_position)

			if dist_sq < best_distance_sq then
				best_distance_sq = dist_sq
				best_unit = unit
			end
		end
	end

	local current_unit = marker_data.current_unit

	if current_unit ~= best_unit then
		marker_data.current_unit = best_unit

		if marker_data.marker_id then
			Managers.event:trigger("remove_world_marker", marker_data.marker_id)

			marker_data.marker_id = nil
		end

		if best_unit then
			local marker_type = units[best_unit]

			Managers.event:trigger("add_world_marker_unit", marker_type, best_unit, marker_data.cb_set_objective_marker_id, marker_data.datas[best_unit] or {})
		end
	end
end

TrainingGroundsScenarioSystem.current_scenario = function (self)
	return self._current_scenario
end

TrainingGroundsScenarioSystem.start_time_scale = function (self, from_scale, to_scale, transition_time, optional_revert_scale_condition_func)
	local data = {}
	local time_manager = Managers.time
	local current_scale = time_manager:local_scale("gameplay")
	local current_lerp_t = math.ilerp(from_scale, to_scale, current_scale)
	data.raw_t = time_manager:time("main")
	data.lerp_t = current_lerp_t
	data.from_scale = from_scale
	data.to_scale = to_scale
	data.transition_time = transition_time
	data.revert_scale_condition_func = optional_revert_scale_condition_func
	self._time_scale_data = data
end

TrainingGroundsScenarioSystem._update_time_scale = function (self)
	local data = self._time_scale_data

	if not data then
		return
	end

	local time_manager = Managers.time

	if data.revert_scale_condition_func then
		local should_revert, duration = data.revert_scale_condition_func()

		if should_revert then
			self:start_time_scale(data.to_scale, data.from_scale, duration)

			return
		end
	end

	if data.done then
		return
	end

	local raw_t = time_manager:time("main")
	local dt = raw_t - data.raw_t
	data.lerp_t = data.lerp_t + dt / data.transition_time
	local smooth_lerp_t = math.smoothstep(data.lerp_t, 0, 1)
	local new_scale = math.lerp(data.from_scale, data.to_scale, smooth_lerp_t)
	new_scale = math.min(new_scale, math.max(data.to_scale, data.from_scale))
	new_scale = math.max(new_scale, math.min(data.to_scale, data.from_scale))
	data.raw_t = raw_t

	if math.abs(new_scale - data.to_scale) < 0.01 then
		time_manager:set_local_scale("gameplay", data.to_scale)

		data.done = true

		if not data.revert_scale_condition_func then
			self._time_scale_data = nil
		end
	else
		time_manager:set_local_scale("gameplay", new_scale)
	end
end

TrainingGroundsScenarioSystem.reset_time_scale = function (self)
	Managers.time:set_local_scale("gameplay", 1)

	self._time_scale_data = nil
end

TrainingGroundsScenarioSystem.set_init_scenario = function (self, alias, name)
	self._init_scenario = alias and name and {
		alias = alias,
		name = name
	} or nil
end

TrainingGroundsScenarioSystem.trigger_training_complete = function (self)
	local level = Managers.state.mission:mission_level()

	Level.trigger_event(level, "event_complete_basic_training_01")
end

TrainingGroundsScenarioSystem._handle_parallel_scenarios = function (self, t)
	for alias, scenario_names in pairs(self._parallel_scenarios) do
		for name, scenario in pairs(scenario_names) do
			local should_stop = self:_handle_scenario(scenario, t)

			if should_stop then
				self:stop_parallel_scenario(scenario.alias, scenario.template.name, t, false)
			end
		end
	end
end

TrainingGroundsScenarioSystem.start_parallel_scenario = function (self, alias, name, t)
	local scenario_template = ScriptedScenarios[alias][name]
	local first_step_template = scenario_template.steps[1]
	local parallel_scenarios = self._parallel_scenarios
	parallel_scenarios[alias] = parallel_scenarios[alias] or {}
	local scenario = self:_create_scenario(alias, name)
	parallel_scenarios[alias][name] = scenario
	local should_stop = self:_start_scenario(scenario, t)

	if should_stop then
		stop_parallel_scenario(alias, name, t)
	end
end

TrainingGroundsScenarioSystem.stop_parallel_scenario = function (self, alias, name, t, ignore_cleanup_steps)
	local parallel_scenarios = self._parallel_scenarios
	local scenario = parallel_scenarios[alias][name]
	parallel_scenarios[alias][name] = nil

	self:_stop_scenario(scenario, ignore_cleanup_steps, t)
end

return TrainingGroundsScenarioSystem
