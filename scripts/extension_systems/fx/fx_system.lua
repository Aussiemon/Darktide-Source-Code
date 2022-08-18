require("scripts/extension_systems/fx/minion_fx_extension")
require("scripts/extension_systems/fx/player_unit_fx_extension")
require("scripts/extension_systems/fx/projectile_fx_extension")

local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local ImpactEffectSettings = require("scripts/settings/damage/impact_effect_settings")
local MaterialQuery = require("scripts/utilities/material_query")
local FxSystem = class("FxSystem", "ExtensionSystemBase")
local INTERFACE_POSITION_OFFSET_DISTANCE = 2
local IS_DIRECTION_INTERFACE = true
local PI = math.pi
local impact_fx_templates = ImpactEffectSettings.impact_fx_templates
local _create_impact_sfx, _create_impact_vfx, _create_material_switch_sfx, _create_projection_decal, _impact_fx, _play_material_switch_sfx, _play_impact_fx_template = nil
local CLIENT_RPCS = {
	"rpc_play_impact_fx",
	"rpc_play_surface_impact_fx",
	"rpc_start_template_effect",
	"rpc_stop_template_effect",
	"rpc_trigger_vfx",
	"rpc_trigger_2d_wwise_event",
	"rpc_trigger_wwise_event",
	"rpc_trigger_flow_event",
	"rpc_projectile_trigger_fx"
}

FxSystem.init = function (self, extension_system_creation_context, ...)
	FxSystem.super.init(self, extension_system_creation_context, ...)

	self._physics_world = extension_system_creation_context.physics_world
	local max_num_template_effects = NetworkConstants.max_template_effect_buffer_index
	self._max_num_template_effects = max_num_template_effects
	local template_effects = Script.new_array(max_num_template_effects)

	for i = 1, max_num_template_effects do
		template_effects[i] = {
			is_running = false,
			buffer_index = i,
			template_data = {},
			optional_position = Vector3Box(Vector3.invalid_vector())
		}
	end

	self._template_effects = template_effects
	self._running_template_effects = Script.new_array(max_num_template_effects)
	local is_server = self._is_server
	local game_session = extension_system_creation_context.game_session
	self._template_context = {
		is_server = is_server,
		world = self._world,
		wwise_world = self._wwise_world,
		game_session = game_session
	}

	if is_server then
		self._next_global_effect_id = 0
	else
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

FxSystem.on_remove_extension = function (self, unit, extension_name)
	local running_template_effects = self._running_template_effects

	for i = #running_template_effects, 1, -1 do
		local template_effect = running_template_effects[i]

		if template_effect.optional_unit == unit then
			local template = template_effect.template

			self:_stop_template_effect(template_effect, template)
		end
	end

	FxSystem.super.on_remove_extension(self, unit, extension_name)
end

FxSystem.destroy = function (self)
	local running_template_effects = self._running_template_effects

	for i = #running_template_effects, 1, -1 do
		local template_effect = running_template_effects[i]
		local template = template_effect.template

		self:_stop_template_effect(template_effect, template)
	end

	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	FxSystem.super.destroy(self)
end

FxSystem.hot_join_sync = function (self, sender, channel)
	local running_template_effects = self._running_template_effects

	for i = 1, #running_template_effects do
		local template_effect = running_template_effects[i]
		local buffer_index = template_effect.buffer_index
		local template = template_effect.template
		local template_name = template.name
		local template_id = NetworkLookup.effect_templates[template_name]
		local optional_unit = template_effect.optional_unit
		local optional_unit_id = Managers.state.unit_spawner:game_object_id(optional_unit)
		local optional_node = template_effect.optional_node
		local position = template_effect.optional_position:unbox()
		local optional_position = Vector3.is_valid(position) and position or nil

		RPC.rpc_start_template_effect(channel, buffer_index, template_id, optional_unit_id, optional_node, optional_position)
	end

	FxSystem.super.hot_join_sync(self, sender, channel)
end

FxSystem.update = function (self, context, dt, t, ...)
	local template_context = self._template_context
	local running_template_effects = self._running_template_effects

	for i = 1, #running_template_effects do
		local template_effect = running_template_effects[i]
		local template = template_effect.template
		local template_data = template_effect.template_data

		template.update(template_data, template_context, dt, t)
	end

	FxSystem.super.update(self, context, dt, t, ...)
end

FxSystem._has_running_template_of_name = function (self, unit, template_name)
	local running_template_effects = self._running_template_effects

	for i = 1, #running_template_effects do
		local template_effect = running_template_effects[i]
		local template = template_effect.template

		if template_effect.optional_unit == unit and template.name == template_name then
			return true
		end
	end

	return false
end

FxSystem.start_template_effect = function (self, template, optional_unit, optional_node, optional_position)
	local template_name = template.name

	fassert(self._is_server, "[FxSystem] Only server is allowed to call this function.")
	fassert(optional_unit == nil or self._unit_to_extension_map[optional_unit], "[FxSystem] Triggering template effect %s on unit %s without fx extension.", template_name, optional_unit)
	fassert(optional_unit == nil or not self:_has_running_template_of_name(optional_unit, template_name), "[FxSystem] Tried starting duplicate template %s on unit %s.", template_name, optional_unit)

	local buffer_index, template_effect = nil
	local max_num_template_effects = self._max_num_template_effects
	local global_effect_id = self._next_global_effect_id
	local template_effects = self._template_effects

	for i = 1, max_num_template_effects do
		buffer_index = global_effect_id % max_num_template_effects + 1
		template_effect = template_effects[buffer_index]

		if not template_effect.is_running then
			break
		end

		global_effect_id = global_effect_id + 1
	end

	if template_effect.is_running then
		local global_effect_id_to_stop = template_effect.global_effect_id

		self:stop_template_effect(global_effect_id_to_stop)
	end

	self:_start_template_effect(template_effect, template, optional_unit, optional_node, optional_position)

	template_effect.global_effect_id = global_effect_id
	self._next_global_effect_id = global_effect_id + 1
	local template_id = NetworkLookup.effect_templates[template_name]
	local optional_unit_id = Managers.state.unit_spawner:game_object_id(optional_unit)

	Managers.state.game_session:send_rpc_clients("rpc_start_template_effect", buffer_index, template_id, optional_unit_id, optional_node, optional_position)

	return global_effect_id
end

FxSystem._start_template_effect = function (self, template_effect, template, optional_unit, optional_node, optional_position)
	local template_data = template_effect.template_data
	local template_context = self._template_context
	template_data.position = optional_position
	template_data.node = optional_node
	template_data.unit = optional_unit

	template.start(template_data, template_context)

	if optional_position then
		template_effect.optional_position:store(optional_position)
	end

	template_effect.optional_unit = optional_unit
	template_effect.optional_node = optional_node
	template_effect.template = template
	template_effect.is_running = true
	local running_template_effects = self._running_template_effects
	running_template_effects[#running_template_effects + 1] = template_effect
end

FxSystem.stop_template_effect = function (self, global_effect_id)
	fassert(self._is_server, "[FxSystem] Only server is allowed to call this function.")

	local template_effects = self._template_effects
	local buffer_index = global_effect_id % self._max_num_template_effects + 1
	local template_effect = template_effects[buffer_index]

	if template_effect.global_effect_id ~= global_effect_id then
		return
	end

	local template = template_effect.template

	self:_stop_template_effect(template_effect, template)

	template_effect.global_effect_id = nil

	Managers.state.game_session:send_rpc_clients("rpc_stop_template_effect", buffer_index)
end

FxSystem._stop_template_effect = function (self, template_effect, template)
	local template_data = template_effect.template_data
	local template_context = self._template_context

	template.stop(template_data, template_context)
	template_effect.optional_position:store(Vector3.invalid_vector())

	template_effect.optional_unit = nil
	template_effect.optional_node = nil

	table.clear(template_data)

	template_effect.template = nil
	template_effect.is_running = false
	local running_template_effects = self._running_template_effects
	local index_to_remove = table.index_of(running_template_effects, template_effect)

	fassert(index_to_remove ~= -1, "[FxSystem] Couldn't find template effect to stop among running effects!")
	table.swap_delete(running_template_effects, index_to_remove)
end

FxSystem.play_impact_fx = function (self, impact_fx, position, direction, source_parameters, provoking_unit, optional_target_unit, optional_node_index, optional_hit_normal, optional_will_be_predicted)
	_play_impact_fx_template(self._world, self._wwise_world, self._unit_to_extension_map, impact_fx, position, direction, source_parameters, provoking_unit, optional_target_unit, optional_node_index, optional_hit_normal)

	if self._is_server then
		local impact_fx_name = impact_fx.name
		local impact_fx_name_id = NetworkLookup.impact_fx_names[impact_fx_name]

		fassert(provoking_unit, "No provoking_unit passed to FxSystem:play_impact_fx()")

		local provoking_unit_id = Managers.state.unit_spawner:game_object_id(provoking_unit)

		if not provoking_unit_id then
			return
		end

		local optional_target_unit_id = optional_target_unit and Managers.state.unit_spawner:game_object_id(optional_target_unit)

		if optional_will_be_predicted then
			local predicting_player = Managers.state.player_unit_spawn:owner(provoking_unit)

			fassert(predicting_player, "provoking_unit has to be owned by a player if will_be_predicted is set to true.")

			local except = predicting_player:channel_id()

			Managers.state.game_session:send_rpc_clients_except("rpc_play_impact_fx", except, impact_fx_name_id, position, direction, provoking_unit_id, optional_target_unit_id, optional_node_index, optional_hit_normal)
		else
			Managers.state.game_session:send_rpc_clients("rpc_play_impact_fx", impact_fx_name_id, position, direction, provoking_unit_id, optional_target_unit_id, optional_node_index, optional_hit_normal)
		end
	end
end

FxSystem.play_surface_impact_fx = function (self, hit_position, hit_direction, source_parameters, provoking_unit, optional_hit_normal, damage_type, hit_type, optional_will_be_predicted)
	if self._is_server then
		fassert(provoking_unit, "No provoking_unit passed to FxSystem:play_surface_impact_fx()")

		local provoking_unit_id = Managers.state.unit_spawner:game_object_id(provoking_unit)

		if not provoking_unit_id then
			return
		end

		local damage_type_id = NetworkLookup.damage_types[damage_type]
		local hit_type_id = NetworkLookup.surface_hit_types[hit_type]

		if optional_will_be_predicted then
			local predicting_player = Managers.state.player_unit_spawn:owner(provoking_unit)

			fassert(predicting_player, "provoking_unit has to be owned by a player if will_be_predicted is set to true.")

			local except = predicting_player:channel_id()

			Managers.state.game_session:send_rpc_clients_except("rpc_play_surface_impact_fx", except, hit_position, hit_direction, provoking_unit_id, optional_hit_normal, damage_type_id, hit_type_id)
		else
			Managers.state.game_session:send_rpc_clients("rpc_play_surface_impact_fx", hit_position, hit_direction, provoking_unit_id, optional_hit_normal, damage_type_id, hit_type_id)
		end
	end

	if DEDICATED_SERVER then
		return
	end

	local physics_world = self._physics_world
	local surface_impact_fx, hit_unit, hit_actor = ImpactEffect.surface_impact_fx(physics_world, provoking_unit, hit_position, optional_hit_normal, hit_direction, damage_type, hit_type)

	if not surface_impact_fx then
		return
	end

	_play_impact_fx_template(self._world, self._wwise_world, self._unit_to_extension_map, surface_impact_fx, hit_position, hit_direction, source_parameters, provoking_unit, hit_unit, hit_actor, optional_hit_normal)
end

FxSystem.trigger_vfx = function (self, vfx_name, position, optional_rotation)
	fassert(self._is_server, "[FxSystem] Only server is allowed to call this function.")
	World.create_particles(self._world, vfx_name, position, optional_rotation)

	local vfx_id = NetworkLookup.vfx[vfx_name]

	Managers.state.game_session:send_rpc_clients("rpc_trigger_vfx", vfx_id, position, optional_rotation)
end

FxSystem.trigger_wwise_event = function (self, event_name, optional_position, optional_unit, optional_node, optional_parameter_name, optional_parameter_value)
	fassert(self._is_server, "[FxSystem] Only server is allowed to call this function.")

	local wwise_world = self._wwise_world
	local source_id = nil

	if optional_position then
		source_id = WwiseWorld.make_auto_source(wwise_world, optional_position)

		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	elseif optional_unit then
		source_id = WwiseWorld.make_auto_source(wwise_world, optional_unit, optional_node)

		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	else
		WwiseWorld.trigger_resource_event(wwise_world, event_name)
	end

	if source_id and (optional_position or optional_unit) and optional_parameter_name then
		fassert(optional_parameter_value, "[FxSystem] optional_parameter_name requires optional_parameter_value")
		WwiseWorld.set_source_parameter(wwise_world, source_id, optional_parameter_name, optional_parameter_value)
	end

	if optional_position or optional_unit then
		local event_id = NetworkLookup.sound_events[event_name]
		local optional_parameter_id = nil

		if optional_parameter_name then
			optional_parameter_id = NetworkLookup.sound_parameters[optional_parameter_name]
		end

		local optional_unit_id = Managers.state.unit_spawner:game_object_id(optional_unit)

		Managers.state.game_session:send_rpc_clients("rpc_trigger_wwise_event", event_id, optional_position, optional_unit_id, optional_node, optional_parameter_id, optional_parameter_value)
	else
		local event_id = NetworkLookup.sound_events_2d[event_name]

		Managers.state.game_session:send_rpc_clients("rpc_trigger_2d_wwise_event", event_id)
	end
end

FxSystem.trigger_ground_impact_fx = function (self, ground_impact_fx_template, impact_material_or_nil, impact_position, impact_normal)
	fassert(self._is_server, "[FxSystem] Only server is allowed to call this function.")
	assert(ground_impact_fx_template, "[FxSystem] invalid template supplied.")

	local material_fx_templates = ground_impact_fx_template.materials
	local impact_effects = material_fx_templates[impact_material_or_nil]

	if not impact_effects then
		local group = MaterialQuery.groups_lookup[impact_material_or_nil]
		impact_effects = group and material_fx_templates[group]
	end

	if not impact_effects then
		local default = ground_impact_fx_template.default
		impact_effects = material_fx_templates[default]
	end

	if not impact_effects then
		return
	end

	local wwise_event = impact_effects.sfx

	if wwise_event then
		if type(wwise_event) == "table" then
			wwise_event = wwise_event[math.random(1, #wwise_event)]
		end

		self:trigger_wwise_event(wwise_event, impact_position)
	end

	local particle_name = impact_effects.vfx

	if particle_name and impact_normal then
		if type(particle_name) == "table" then
			particle_name = particle_name[math.random(1, #particle_name)]
		end

		local rotation = Quaternion.look(impact_normal)

		self:trigger_vfx(particle_name, impact_position, rotation)
	end
end

FxSystem.trigger_flow_event = function (self, unit, event_name)
	fassert(self._is_server, "[FxSystem] Only server is allowed to call this function.")
	Unit.flow_event(unit, event_name)

	local event_id = NetworkLookup.flow_events[event_name]
	local unit_id = Managers.state.unit_spawner:game_object_id(unit)

	Managers.state.game_session:send_rpc_clients("rpc_trigger_flow_event", unit_id, event_id)
end

FxSystem.rpc_start_template_effect = function (self, channel_id, buffer_index, template_id, optional_unit_id, optional_node, optional_position)
	local template_name = NetworkLookup.effect_templates[template_id]
	local template = EffectTemplates[template_name]
	local optional_unit = Managers.state.unit_spawner:unit(optional_unit_id)
	local template_effects = self._template_effects
	local template_effect = template_effects[buffer_index]

	self:_start_template_effect(template_effect, template, optional_unit, optional_node, optional_position)
end

FxSystem.rpc_stop_template_effect = function (self, channel_id, buffer_index)
	local template_effects = self._template_effects
	local template_effect = template_effects[buffer_index]
	local template = template_effect.template

	self:_stop_template_effect(template_effect, template)
end

local SOURCE_PARAMETERS = {}

FxSystem.rpc_play_impact_fx = function (self, channel_id, impact_fx_name_id, position, direction, provoking_unit_id, optional_target_unit_id, optional_node_index, optional_hit_normal)
	local impact_fx_name = NetworkLookup.impact_fx_names[impact_fx_name_id]
	local impact_fx = impact_fx_templates[impact_fx_name]
	local provoking_unit = Managers.state.unit_spawner:unit(provoking_unit_id)
	local optional_target_unit = optional_target_unit_id and Managers.state.unit_spawner:unit(optional_target_unit_id)
	local optional_will_be_predicted = false
	direction = Vector3.normalize(direction)
	optional_hit_normal = optional_hit_normal and Vector3.normalize(optional_hit_normal)

	self:play_impact_fx(impact_fx, position, direction, SOURCE_PARAMETERS, provoking_unit, optional_target_unit, optional_node_index, optional_hit_normal, optional_will_be_predicted)
end

FxSystem.rpc_play_surface_impact_fx = function (self, channel_id, hit_position, hit_direction, provoking_unit_id, optional_hit_normal, damage_type_id, hit_type_id)
	local provoking_unit = Managers.state.unit_spawner:unit(provoking_unit_id)
	local damage_type = NetworkLookup.damage_types[damage_type_id]
	local hit_type = NetworkLookup.surface_hit_types[hit_type_id]
	local optional_will_be_predicted = false
	optional_hit_normal = optional_hit_normal and Vector3.normalize(optional_hit_normal)

	self:play_surface_impact_fx(hit_position, hit_direction, SOURCE_PARAMETERS, provoking_unit, optional_hit_normal, damage_type, hit_type, optional_will_be_predicted)
end

FxSystem.rpc_trigger_vfx = function (self, channel_id, vfx_id, position, optional_rotation)
	local vfx_name = NetworkLookup.vfx[vfx_id]

	World.create_particles(self._world, vfx_name, position, optional_rotation)
end

FxSystem.rpc_trigger_2d_wwise_event = function (self, channel_id, event_id)
	local event_name = NetworkLookup.sound_events_2d[event_id]

	WwiseWorld.trigger_resource_event(self._wwise_world, event_name)
end

FxSystem.rpc_trigger_wwise_event = function (self, channel_id, event_id, optional_position, optional_unit_id, optional_node, optional_parameter_id, optional_parameter_value)
	local event_name = NetworkLookup.sound_events[event_id]
	local wwise_world = self._wwise_world
	local source_id = nil

	if optional_position then
		source_id = WwiseWorld.make_auto_source(wwise_world, optional_position)

		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	elseif optional_unit_id then
		local unit = Managers.state.unit_spawner:unit(optional_unit_id)
		source_id = WwiseWorld.make_auto_source(wwise_world, unit, optional_node)

		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	end

	if source_id and optional_parameter_id then
		fassert(optional_parameter_value, "[FxSystem] optional_parameter_name requires optional_parameter_value")

		local parameter_name = NetworkLookup.sound_parameters[optional_parameter_id]

		WwiseWorld.set_source_parameter(wwise_world, source_id, parameter_name, optional_parameter_value)
	end
end

FxSystem.rpc_trigger_flow_event = function (self, channel_id, unit_id, event_id)
	local unit = Managers.state.unit_spawner:unit(unit_id)
	local event_name = NetworkLookup.flow_events[event_id]

	Unit.flow_event(unit, event_name)
end

FxSystem.rpc_projectile_trigger_fx = function (self, channel_id, unit_id, event_type_id)
	local effect_type = NetworkLookup.projectile_template_effects[event_type_id]
	local unit = Managers.state.unit_spawner:unit(unit_id)

	if unit then
		local unit_to_extension_map = self._unit_to_extension_map
		local fx_extension = unit_to_extension_map[unit]

		fx_extension:start_fx(effect_type)
	end
end

function _create_impact_vfx(world, vfx, position, direction, normal)
	local num_vfx = #vfx

	if num_vfx > 0 then
		local direction_rotation, normal_rotation, reverse_direction_rotation, reverse_normal_rotation = nil

		for i = 1, num_vfx do
			local entry = vfx[i]
			local effects = entry.effects
			local use_normal_rotation = entry.normal_rotation
			local reverse = entry.reverse
			local effect_name = effects[math.random(1, #effects)]
			local rotation = nil

			if use_normal_rotation and reverse then
				reverse_normal_rotation = reverse_normal_rotation or Quaternion.look(normal and -normal or -direction)
				rotation = reverse_normal_rotation
			elseif use_normal_rotation then
				normal_rotation = normal_rotation or Quaternion.look(normal or direction)
				rotation = normal_rotation
			elseif reverse then
				reverse_direction_rotation = reverse_direction_rotation or Quaternion.look(-direction)
				rotation = reverse_direction_rotation
			else
				direction_rotation = direction_rotation or Quaternion.look(direction)
				rotation = direction_rotation
			end

			World.create_particles(world, effect_name, position, rotation)
		end
	end
end

function _create_impact_sfx(wwise_world, sfx, source_parameters, position, direction, normal, is_direction_interface)
	local num_sfx = #sfx

	if num_sfx > 0 then
		local rotation = Quaternion.look(normal or direction)
		local auto_source_id = WwiseWorld.make_auto_source(wwise_world, position, rotation)

		for name, value in pairs(source_parameters) do
			WwiseWorld.set_source_parameter(wwise_world, auto_source_id, name, value)
		end

		for i = 1, num_sfx do
			local event_name = sfx[i]

			WwiseWorld.trigger_resource_event(wwise_world, event_name, auto_source_id)
		end
	end
end

function _play_material_switch_sfx(wwise_world, material_switch_sfx, position, direction, is_normal_rotated)
	local num_material_switch_sfx = material_switch_sfx and #material_switch_sfx or 0

	if num_material_switch_sfx > 0 then
		local rotation = Quaternion.look(direction)

		for i = 1, num_material_switch_sfx do
			local event_group_state = material_switch_sfx[i]
			local event = event_group_state.event
			local group = event_group_state.group
			local state = event_group_state.state
			local auto_source_id = WwiseWorld.make_auto_source(wwise_world, position, rotation)

			WwiseWorld.set_switch(wwise_world, group, state, auto_source_id)
			WwiseWorld.trigger_resource_event(wwise_world, event, auto_source_id)
		end
	end
end

function _create_material_switch_sfx(wwise_world, material_switch_sfx, position, attack_direction, optional_normal)
	_play_material_switch_sfx(wwise_world, material_switch_sfx.normal_rotation, position, optional_normal, true)
	_play_material_switch_sfx(wwise_world, material_switch_sfx.attack_rotation, position, attack_direction, false)
end

function _impact_fx(impact_fx, provoking_unit, unit_to_extension_map, table_name, husk_table_name, target_player_is_in_1p)
	local fx = impact_fx[table_name]
	local husk_fx = nil

	if not target_player_is_in_1p and husk_table_name then
		local fx_extension = unit_to_extension_map[provoking_unit]

		if fx_extension and fx_extension:should_play_husk_effect() then
			husk_fx = impact_fx[husk_table_name]
		end
	end

	return husk_fx or fx
end

function _create_projection_decal(decal_settings, position, rotation, normal, hit_unit, hit_actor)
	local t = Managers.time:time("gameplay")
	local min_extents = decal_settings.extents.min
	local max_extents = decal_settings.extents.max
	local x = math.random_range(min_extents.x, max_extents.x)
	local y = math.random_range(min_extents.y, max_extents.y)
	local z = math.random_range(min_extents.z, max_extents.z)
	local extents = Vector3(x, y, z)
	local decal_units = decal_settings.units
	local num_decal_units = #decal_units
	local decal_unit_name = decal_units[math.random(1, num_decal_units)]
	local random_rad = math.random() * PI
	local random_rot = Quaternion.axis_angle(Vector3.up(), random_rad)
	rotation = Quaternion.multiply(rotation, random_rot)

	Managers.state.decal:add_projection_decal(decal_unit_name, position, rotation, normal, extents, hit_actor, hit_unit, t)
end

function _play_impact_fx_template(world, wwise_world, unit_to_extension_map, impact_fx, position, direction, source_parameters, provoking_unit, optional_target_unit, optional_node_index, optional_hit_normal)
	local impact_fx_name = impact_fx.name
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local target_player = optional_target_unit and player_unit_spawn_manager:owner(optional_target_unit)
	local target_first_person_extension = optional_target_unit and ScriptUnit.has_extension(optional_target_unit, "first_person_system")
	local provoker_first_person_extension = provoking_unit and ScriptUnit.has_extension(provoking_unit, "first_person_system")
	local target_player_is_in_1p = target_player and target_first_person_extension and target_first_person_extension:is_in_first_person_mode()
	local opposite_direction = -direction
	local sfx = _impact_fx(impact_fx, provoking_unit, unit_to_extension_map, "sfx", "sfx_husk", target_player_is_in_1p)

	if sfx then
		_create_impact_sfx(wwise_world, sfx, source_parameters, position, opposite_direction, optional_hit_normal)
	end

	if provoker_first_person_extension then
		local follow_target = provoker_first_person_extension:is_camera_follow_target()
		local in_first_person = provoker_first_person_extension:is_in_first_person_mode()

		if follow_target and in_first_person then
			local sfx_1p = _impact_fx(impact_fx, provoking_unit, unit_to_extension_map, "sfx_1p")

			if sfx_1p then
				_create_impact_sfx(wwise_world, sfx_1p, source_parameters, position, opposite_direction)
			end
		end
	end

	if target_player_is_in_1p then
		local sfx_1p_direction_interface = _impact_fx(impact_fx, provoking_unit, unit_to_extension_map, "sfx_1p_direction_interface")

		if sfx_1p_direction_interface then
			local interface_position = position + opposite_direction * INTERFACE_POSITION_OFFSET_DISTANCE

			_create_impact_sfx(wwise_world, sfx_1p_direction_interface, source_parameters, interface_position, direction, nil, IS_DIRECTION_INTERFACE)
		end
	end

	local sfx_3p = _impact_fx(impact_fx, provoking_unit, unit_to_extension_map, "sfx_3p", nil, target_player_is_in_1p)

	if sfx_3p and not target_player_is_in_1p then
		_create_impact_sfx(wwise_world, sfx_3p, source_parameters, position, opposite_direction)
	end

	local material_switch_sfx = _impact_fx(impact_fx, provoking_unit, unit_to_extension_map, "material_switch_sfx", "material_switch_sfx_husk")

	if material_switch_sfx and optional_hit_normal then
		_create_material_switch_sfx(wwise_world, material_switch_sfx, position, opposite_direction, optional_hit_normal)
	end

	local play_vfx = not target_player_is_in_1p
	local play_1p_vfx, play_3p_vfx = nil

	if provoker_first_person_extension and not target_player_is_in_1p then
		local in_first_person = provoker_first_person_extension:is_in_first_person_mode()
		play_1p_vfx = in_first_person
		play_3p_vfx = not in_first_person
	else
		play_1p_vfx = false
		play_3p_vfx = not target_player_is_in_1p
	end

	if play_vfx then
		local vfx = _impact_fx(impact_fx, provoking_unit, unit_to_extension_map, "vfx")

		if vfx then
			_create_impact_vfx(world, vfx, position, opposite_direction, optional_hit_normal)
		end
	end

	if play_1p_vfx then
		local vfx_1p = _impact_fx(impact_fx, provoking_unit, unit_to_extension_map, "vfx_1p")

		if vfx_1p then
			_create_impact_vfx(world, vfx_1p, position, opposite_direction, optional_hit_normal)
		end
	end

	if play_3p_vfx then
		local vfx_3p = _impact_fx(impact_fx, provoking_unit, unit_to_extension_map, "vfx_3p")

		if vfx_3p then
			_create_impact_vfx(world, vfx_3p, position, opposite_direction, optional_hit_normal)
		end
	end

	local decal = impact_fx.decal

	if decal and optional_hit_normal then
		local dot_value = Vector3.dot(optional_hit_normal, direction)
		local tangent = Vector3.normalize(direction - dot_value * optional_hit_normal)
		local decal_rotation = Quaternion.look(tangent, optional_hit_normal)

		_create_projection_decal(decal, position, decal_rotation, optional_hit_normal, nil, nil)
	end

	local linked_decal = impact_fx.linked_decal

	if linked_decal and optional_target_unit and optional_node_index then
		local recursive = false
		local use_global_table = true
		local hit_actors = Unit.get_node_actors(optional_target_unit, optional_node_index, recursive, use_global_table)

		if hit_actors then
			local decal_rotation = Quaternion.look(opposite_direction)
			local decal_normal = opposite_direction
			local hit_actor = Unit.actor(optional_target_unit, hit_actors[1])

			_create_projection_decal(linked_decal, position, decal_rotation, decal_normal, optional_target_unit, hit_actor)
		end
	end

	local blood_ball = impact_fx.blood_ball

	if blood_ball then
		local num_blood_ball = #blood_ball

		for i = 1, num_blood_ball do
			local blood_ball_unit = blood_ball[i]
			local impact_fx_damage_type = impact_fx.damage_type

			Managers.state.blood:queue_blood_ball(position, direction, blood_ball_unit, impact_fx_damage_type)
		end
	end
end

return FxSystem
