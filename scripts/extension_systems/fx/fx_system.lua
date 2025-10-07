-- chunkname: @scripts/extension_systems/fx/fx_system.lua

require("scripts/extension_systems/fx/minion_fx_extension")
require("scripts/extension_systems/fx/player_unit_fx_extension")
require("scripts/extension_systems/fx/projectile_fx_extension")

local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local ImpactEffectSettings = require("scripts/settings/damage/impact_effect_settings")
local MaterialQuerySettings = require("scripts/settings/material_query_settings")
local FxSystem = class("FxSystem", "ExtensionSystemBase")
local INTERFACE_POSITION_OFFSET_DISTANCE = 2
local IS_DIRECTION_INTERFACE = true
local PI = math.pi
local impact_fx_templates = ImpactEffectSettings.impact_fx_templates
local surface_material_groups_lookup = MaterialQuerySettings.surface_material_groups_lookup
local _create_impact_sfx, _create_impact_vfx, _create_material_switch_sfx, _create_projection_decal, _impact_fx, _play_material_switch_sfx, _play_impact_fx_template
local CLIENT_RPCS = {
	"rpc_play_impact_fx",
	"rpc_play_surface_impact_fx",
	"rpc_play_shotshell_surface_impact_fx",
	"rpc_start_template_effect",
	"rpc_stop_template_effect",
	"rpc_trigger_vfx",
	"rpc_trigger_2d_wwise_event",
	"rpc_trigger_wwise_event",
	"rpc_trigger_flow_event",
	"rpc_projectile_trigger_fx",
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
			optional_position = Vector3Box(Vector3.invalid_vector()),
		}
	end

	self._template_effects = template_effects
	self._running_template_effects = Script.new_array(max_num_template_effects)

	local is_server, game_session = self._is_server, extension_system_creation_context.game_session

	self._template_context = {
		is_server = is_server,
		world = self._world,
		wwise_world = self._wwise_world,
		game_session = game_session,
	}
	self._latest_player_particle_group_id = 0
	self.unit_to_particle_group_lookup = Script.new_map(256)
	self._spawned_impact_fx_units = Script.new_map(8)

	local ambisonics_manual_source_id = WwiseWorld.make_manual_source(self._wwise_world, Vector3(0, 0, 0), Quaternion.identity())

	self._ambisonics_manual_source_id = ambisonics_manual_source_id

	if is_server then
		self._next_global_effect_id = 0
	else
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

FxSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	if extension_name == "PlayerUnitFxExtension" then
		local player_particle_group_id = self._latest_player_particle_group_id + 1

		self._latest_player_particle_group_id = player_particle_group_id
		extension_init_data.player_particle_group_id = player_particle_group_id
		self.unit_to_particle_group_lookup[unit] = player_particle_group_id
	end

	if extension_name == "ProjectileFxExtension" then
		local owner_unit = extension_init_data.owner_unit
		local player_particle_group_id = owner_unit and self.unit_to_particle_group_lookup[owner_unit]

		if player_particle_group_id then
			self.unit_to_particle_group_lookup[unit] = player_particle_group_id
		end
	end

	return FxSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
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

	local unit_to_particle_group_lookup = self.unit_to_particle_group_lookup

	if extension_name == "PlayerUnitFxExtension" then
		local unit_to_particle_group_id = unit_to_particle_group_lookup[unit]

		self:_delete_units_belonging_to_particle_group(unit_to_particle_group_id)

		unit_to_particle_group_lookup[unit] = nil
	end

	if extension_name == "ProjectileFxExtension" then
		unit_to_particle_group_lookup[unit] = nil
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

	WwiseWorld.destroy_manual_source(self._wwise_world, self._ambisonics_manual_source_id)
	FxSystem.super.destroy(self)
end

FxSystem.hot_join_sync = function (self, sender, channel)
	local running_template_effects = self._running_template_effects

	for i = 1, #running_template_effects do
		local template_effect = running_template_effects[i]
		local buffer_index, template = template_effect.buffer_index, template_effect.template
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

FxSystem.has_running_template_of_name = function (self, unit, template_name)
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
	local buffer_index, template_effect
	local max_num_template_effects = self._max_num_template_effects
	local global_effect_id, template_effects = self._next_global_effect_id, self._template_effects

	for i = 1, max_num_template_effects do
		buffer_index = global_effect_id % max_num_template_effects + 1
		template_effect = template_effects[buffer_index]

		if not template_effect.is_running then
			break
		elseif i < max_num_template_effects then
			global_effect_id = global_effect_id + 1
		end
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
	local template_data, template_context = template_effect.template_data, self._template_context

	template_data.unit, template_data.node, template_data.position = optional_unit, optional_node, optional_position

	template.start(template_data, template_context)

	if optional_position then
		template_effect.optional_position:store(optional_position)
	end

	template_effect.optional_unit = optional_unit
	template_effect.optional_node = optional_node
	template_effect.is_running, template_effect.template = true, template

	local running_template_effects = self._running_template_effects

	running_template_effects[#running_template_effects + 1] = template_effect
end

FxSystem.stop_template_effect = function (self, global_effect_id)
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

FxSystem.has_running_global_effect_id = function (self, global_effect_id)
	local template_effects = self._template_effects
	local buffer_index = global_effect_id % self._max_num_template_effects + 1
	local template_effect = template_effects[buffer_index]

	return template_effect.template ~= nil
end

FxSystem._stop_template_effect = function (self, template_effect, template)
	local template_data, template_context = template_effect.template_data, self._template_context

	template.stop(template_data, template_context)
	template_effect.optional_position:store(Vector3.invalid_vector())

	template_effect.optional_unit = nil
	template_effect.optional_node = nil

	table.clear(template_data)

	template_effect.is_running, template_effect.template = false

	local running_template_effects = self._running_template_effects
	local index_to_remove = table.index_of(running_template_effects, template_effect)

	table.swap_delete(running_template_effects, index_to_remove)
end

FxSystem.play_impact_fx = function (self, impact_fx, position, direction, source_parameters, attacking_unit, optional_target_unit, optional_node_index, optional_hit_normal, optional_will_be_predicted, local_only_or_nil)
	local world = self._world
	local t = World.time(world)
	local particle_group_id_or_nil = self.unit_to_particle_group_lookup[attacking_unit]

	_play_impact_fx_template(t, world, self._wwise_world, self._unit_to_extension_map, self._spawned_impact_fx_units, impact_fx, position, direction, source_parameters, attacking_unit, particle_group_id_or_nil, optional_target_unit, optional_node_index, optional_hit_normal)

	if self._is_server then
		local impact_fx_name = impact_fx.name
		local impact_fx_name_id = NetworkLookup.impact_fx_names[impact_fx_name]
		local attacking_unit_id = Managers.state.unit_spawner:game_object_id(attacking_unit)

		if not attacking_unit_id then
			return
		end

		local optional_target_unit_id = optional_target_unit and Managers.state.unit_spawner:game_object_id(optional_target_unit)
		local attacking_unit_has_particle_id = self.unit_to_particle_group_lookup[attacking_unit] ~= nil

		if not local_only_or_nil then
			if optional_will_be_predicted then
				local predicting_player = Managers.state.player_unit_spawn:owner(attacking_unit)
				local except = predicting_player:channel_id()

				Managers.state.game_session:send_rpc_clients_except("rpc_play_impact_fx", except, impact_fx_name_id, position, direction, attacking_unit_id, optional_target_unit_id, optional_node_index, optional_hit_normal, attacking_unit_has_particle_id)
			else
				Managers.state.game_session:send_rpc_clients("rpc_play_impact_fx", impact_fx_name_id, position, direction, attacking_unit_id, optional_target_unit_id, optional_node_index, optional_hit_normal, attacking_unit_has_particle_id)
			end
		end
	end
end

FxSystem.play_surface_impact_fx = function (self, hit_position, hit_direction, source_parameters, attacking_unit, optional_hit_normal, damage_type, hit_type, optional_will_be_predicted)
	if self._is_server then
		local attacking_unit_id = Managers.state.unit_spawner:game_object_id(attacking_unit)

		if not attacking_unit_id then
			return
		end

		local damage_type_id = NetworkLookup.damage_types[damage_type]
		local hit_type_id = NetworkLookup.surface_hit_types[hit_type]
		local attacking_unit_has_particle_id = self.unit_to_particle_group_lookup[attacking_unit] ~= nil

		if optional_will_be_predicted then
			local predicting_player = Managers.state.player_unit_spawn:owner(attacking_unit)
			local except = predicting_player:channel_id()

			Managers.state.game_session:send_rpc_clients_except("rpc_play_surface_impact_fx", except, hit_position, hit_direction, attacking_unit_id, optional_hit_normal, damage_type_id, hit_type_id, attacking_unit_has_particle_id)
		else
			Managers.state.game_session:send_rpc_clients("rpc_play_surface_impact_fx", hit_position, hit_direction, attacking_unit_id, optional_hit_normal, damage_type_id, hit_type_id, attacking_unit_has_particle_id)
		end
	end

	if DEDICATED_SERVER then
		return
	end

	local physics_world = self._physics_world
	local surface_impact_fx, hit_unit, hit_actor = ImpactEffect.surface_impact_fx(physics_world, attacking_unit, hit_position, optional_hit_normal, hit_direction, damage_type, hit_type)

	if not surface_impact_fx then
		return
	end

	local world = self._world
	local t = World.time(world)
	local particle_group_id_or_nil = self.unit_to_particle_group_lookup[attacking_unit]

	_play_impact_fx_template(t, world, self._wwise_world, self._unit_to_extension_map, self._spawned_impact_fx_units, surface_impact_fx, hit_position, hit_direction, source_parameters, attacking_unit, particle_group_id_or_nil, hit_unit, hit_actor, optional_hit_normal)
end

FxSystem.play_shotshell_surface_impact_fx = function (self, fire_position, hit_positions, hit_normals, source_parameters, attacking_unit, damage_type, hit_type, optional_will_be_predicted)
	if self._is_server then
		local attacking_unit_id = Managers.state.unit_spawner:game_object_id(attacking_unit)

		if not attacking_unit_id then
			return
		end

		local damage_type_id = NetworkLookup.damage_types[damage_type]
		local hit_type_id = NetworkLookup.surface_hit_types[hit_type]
		local attacking_unit_has_particle_id = self.unit_to_particle_group_lookup[attacking_unit] ~= nil

		if optional_will_be_predicted then
			local predicting_player = Managers.state.player_unit_spawn:owner(attacking_unit)
			local except = predicting_player:channel_id()

			Managers.state.game_session:send_rpc_clients_except("rpc_play_shotshell_surface_impact_fx", except, fire_position, hit_positions, hit_normals, attacking_unit_id, damage_type_id, hit_type_id, attacking_unit_has_particle_id)
		else
			Managers.state.game_session:send_rpc_clients("rpc_play_shotshell_surface_impact_fx", fire_position, hit_positions, hit_normals, attacking_unit_id, damage_type_id, hit_type_id, attacking_unit_has_particle_id)
		end
	end

	if DEDICATED_SERVER then
		return
	end

	local physics_world = self._physics_world
	local surface_impact_fxs = ImpactEffect.shotshell_surface_impact_fx(physics_world, fire_position, attacking_unit, hit_positions, hit_normals, damage_type, hit_type)

	if not surface_impact_fxs then
		return
	end

	local world = self._world
	local wwise_world = self._wwise_world
	local unit_to_extension_map = self._unit_to_extension_map
	local spawned_impact_fx_units = self._spawned_impact_fx_units
	local t = World.time(world)
	local particle_group_id_or_nil = self.unit_to_particle_group_lookup[attacking_unit]

	for ii = 1, #surface_impact_fxs, 7 do
		local surface_impact_fx = surface_impact_fxs[ii]
		local hit_position = surface_impact_fxs[ii + 1]
		local hit_normal = surface_impact_fxs[ii + 2]
		local hit_direction = surface_impact_fxs[ii + 3]
		local hit_unit = surface_impact_fxs[ii + 4]
		local hit_actor = surface_impact_fxs[ii + 5]
		local only_decal = surface_impact_fxs[ii + 6]

		_play_impact_fx_template(t, world, wwise_world, unit_to_extension_map, spawned_impact_fx_units, surface_impact_fx, hit_position, hit_direction, source_parameters, attacking_unit, particle_group_id_or_nil, hit_unit, hit_actor, hit_normal, only_decal)
	end
end

FxSystem.trigger_vfx = function (self, vfx_name, position, optional_rotation)
	World.create_particles(self._world, vfx_name, position, optional_rotation)

	local vfx_id = NetworkLookup.vfx[vfx_name]

	Managers.state.game_session:send_rpc_clients("rpc_trigger_vfx", vfx_id, position, optional_rotation)
end

FxSystem.trigger_wwise_event = function (self, event_name, optional_position, optional_unit, optional_node, optional_parameter_name, optional_parameter_value, optional_ambisonics)
	local wwise_world = self._wwise_world
	local source_id

	if optional_position then
		source_id = WwiseWorld.make_auto_source(wwise_world, optional_position)

		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	elseif optional_unit then
		source_id = WwiseWorld.make_auto_source(wwise_world, optional_unit, optional_node)

		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	elseif optional_ambisonics then
		local ambisonics_manual_source_id = self._ambisonics_manual_source_id

		WwiseWorld.trigger_resource_event(wwise_world, event_name, ambisonics_manual_source_id)
	else
		WwiseWorld.trigger_resource_event(wwise_world, event_name)
	end

	if source_id and (optional_position or optional_unit) and optional_parameter_name then
		WwiseWorld.set_source_parameter(wwise_world, source_id, optional_parameter_name, optional_parameter_value)
	end

	if optional_position or optional_unit or optional_ambisonics then
		local event_id = NetworkLookup.sound_events[event_name]
		local optional_parameter_id = optional_parameter_name and NetworkLookup.sound_parameters[optional_parameter_name]
		local optional_unit_id = Managers.state.unit_spawner:game_object_id(optional_unit)

		Managers.state.game_session:send_rpc_clients("rpc_trigger_wwise_event", event_id, optional_position, optional_unit_id, optional_node, optional_parameter_id, optional_parameter_value, not not optional_ambisonics)
	else
		local event_id = NetworkLookup.sound_events_2d[event_name]

		Managers.state.game_session:send_rpc_clients("rpc_trigger_2d_wwise_event", event_id)
	end
end

FxSystem.trigger_ground_impact_fx = function (self, ground_impact_fx_template, impact_material_or_nil, impact_position, impact_normal)
	local material_fx_templates = ground_impact_fx_template.materials
	local impact_effects = material_fx_templates[impact_material_or_nil]

	if not impact_effects then
		local group = surface_material_groups_lookup[impact_material_or_nil]

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

FxSystem._delete_units_belonging_to_particle_group = function (self, particle_group_id)
	local spawned_impact_fx_units = self._spawned_impact_fx_units

	for unit, unit_particle_group_id in pairs(spawned_impact_fx_units) do
		if particle_group_id == unit_particle_group_id then
			World.destroy_unit(self._world, unit)

			spawned_impact_fx_units[unit] = nil
		end
	end
end

FxSystem.delete_impact_fx_unit = function (self, unit)
	if self._spawned_impact_fx_units[unit] then
		World.destroy_unit(self._world, unit)

		self._spawned_impact_fx_units[unit] = nil
	end
end

FxSystem.delete_units = function (self)
	for unit, _ in pairs(self._spawned_impact_fx_units) do
		World.destroy_unit(self._world, unit)
	end

	table.clear(self._spawned_impact_fx_units)
end

FxSystem.trigger_flow_event = function (self, unit, event_name)
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

FxSystem.rpc_play_impact_fx = function (self, channel_id, impact_fx_name_id, position, direction, attacking_unit_id, optional_target_unit_id, optional_node_index, optional_hit_normal, attacking_unit_has_particle_group)
	local impact_fx_name = NetworkLookup.impact_fx_names[impact_fx_name_id]
	local impact_fx = impact_fx_templates[impact_fx_name]
	local attacking_unit = Managers.state.unit_spawner:unit(attacking_unit_id)

	if attacking_unit_has_particle_group and not attacking_unit then
		return
	end

	local optional_target_unit = optional_target_unit_id and Managers.state.unit_spawner:unit(optional_target_unit_id)
	local optional_will_be_predicted = false

	direction = Vector3.normalize(direction)
	optional_hit_normal = optional_hit_normal and Vector3.normalize(optional_hit_normal)

	self:play_impact_fx(impact_fx, position, direction, SOURCE_PARAMETERS, attacking_unit, optional_target_unit, optional_node_index, optional_hit_normal, optional_will_be_predicted)
end

FxSystem.rpc_play_surface_impact_fx = function (self, channel_id, hit_position, hit_direction, attacking_unit_id, optional_hit_normal, damage_type_id, hit_type_id, attacking_unit_has_particle_group)
	local attacking_unit = Managers.state.unit_spawner:unit(attacking_unit_id)

	if attacking_unit_has_particle_group and not attacking_unit then
		return
	end

	local damage_type = NetworkLookup.damage_types[damage_type_id]
	local hit_type = NetworkLookup.surface_hit_types[hit_type_id]
	local optional_will_be_predicted = false

	optional_hit_normal = optional_hit_normal and Vector3.normalize(optional_hit_normal)

	self:play_surface_impact_fx(hit_position, hit_direction, SOURCE_PARAMETERS, attacking_unit, optional_hit_normal, damage_type, hit_type, optional_will_be_predicted)
end

FxSystem.rpc_play_shotshell_surface_impact_fx = function (self, channel_id, fire_position, hit_positions, hit_normals, attacking_unit_id, damage_type_id, hit_type_id, attacking_unit_has_particle_group)
	local attacking_unit = Managers.state.unit_spawner:unit(attacking_unit_id)

	if attacking_unit_has_particle_group and not attacking_unit then
		return
	end

	local damage_type = NetworkLookup.damage_types[damage_type_id]
	local hit_type = NetworkLookup.surface_hit_types[hit_type_id]
	local optional_will_be_predicted = false

	self:play_shotshell_surface_impact_fx(fire_position, hit_positions, hit_normals, SOURCE_PARAMETERS, attacking_unit, damage_type, hit_type, optional_will_be_predicted)
end

FxSystem.rpc_trigger_vfx = function (self, channel_id, vfx_id, position, optional_rotation)
	local vfx_name = NetworkLookup.vfx[vfx_id]

	World.create_particles(self._world, vfx_name, position, optional_rotation)
end

FxSystem.rpc_trigger_2d_wwise_event = function (self, channel_id, event_id)
	local event_name = NetworkLookup.sound_events_2d[event_id]

	WwiseWorld.trigger_resource_event(self._wwise_world, event_name)
end

FxSystem.rpc_trigger_wwise_event = function (self, channel_id, event_id, optional_position, optional_unit_id, optional_node, optional_parameter_id, optional_parameter_value, optional_ambisonics)
	local event_name = NetworkLookup.sound_events[event_id]
	local wwise_world = self._wwise_world
	local source_id

	if optional_position then
		source_id = WwiseWorld.make_auto_source(wwise_world, optional_position)

		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	elseif optional_unit_id then
		local unit = Managers.state.unit_spawner:unit(optional_unit_id)

		source_id = WwiseWorld.make_auto_source(wwise_world, unit, optional_node)

		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	elseif optional_ambisonics then
		local ambisonics_manual_source_id = self._ambisonics_manual_source_id

		WwiseWorld.trigger_resource_event(wwise_world, event_name, ambisonics_manual_source_id)
	end

	if source_id and optional_parameter_id then
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

function _create_impact_vfx(world, vfx, position, direction, normal, optional_particle_group_id)
	local num_vfx = #vfx

	if num_vfx > 0 then
		local direction_rotation, normal_rotation, reverse_direction_rotation, reverse_normal_rotation

		for i = 1, num_vfx do
			local entry = vfx[i]
			local effects = entry.effects
			local use_normal_rotation = entry.normal_rotation
			local reverse = entry.reverse
			local effect_name = effects[math.random(1, #effects)]
			local rotation

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

			World.create_particles(world, effect_name, position, rotation, nil, optional_particle_group_id)
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

function _impact_fx(impact_fx, attacking_unit, unit_to_extension_map, table_name, husk_table_name, target_player_is_in_1p)
	local fx = impact_fx[table_name]
	local husk_fx

	if not target_player_is_in_1p and husk_table_name then
		local fx_extension = unit_to_extension_map[attacking_unit]

		if fx_extension and fx_extension:should_play_husk_effect() then
			husk_fx = impact_fx[husk_table_name]
		end
	end

	return husk_fx or fx
end

local LINKED_DECAL_Z = 0.05
local DECAL_Z = 0.5

function _create_projection_decal(t, decal_settings, position, rotation, normal, hit_unit, hit_actor, impact_fx_name)
	local extents = decal_settings.extents
	local uniform_extents = decal_settings.uniform_extents
	local x, y, z

	if extents then
		local min = extents.min
		local max = extents.max

		x = math.random_range(min.x, max.x)
		y = math.random_range(min.y, max.y)

		if hit_actor then
			z = LINKED_DECAL_Z
		else
			z = DECAL_Z
		end
	elseif uniform_extents then
		local min = uniform_extents.min
		local max = uniform_extents.max
		local scale = math.random_range(min, max)

		x = scale
		y = scale

		if hit_actor then
			z = LINKED_DECAL_Z
		else
			z = DECAL_Z
		end
	end

	local decal_extents = Vector3(x, y, z)
	local decal_units = decal_settings.units
	local num_decal_units = #decal_units

	if num_decal_units == 0 then
		return
	end

	local decal_unit_name = decal_units[math.random(1, num_decal_units)]
	local random_rad = math.random() * PI
	local random_rot = Quaternion.axis_angle(Vector3.up(), random_rad)

	rotation = Quaternion.multiply(rotation, random_rot)

	Managers.state.decal:add_projection_decal(decal_unit_name, position, rotation, normal, decal_extents, hit_actor, hit_unit, t)
end

function _play_impact_fx_template(t, world, wwise_world, unit_to_extension_map, spawned_impact_fx_units, impact_fx, position, direction, source_parameters, attacking_unit, optional_particle_group_id, optional_target_unit, optional_node_index, optional_hit_normal, only_decal)
	local impact_fx_name = impact_fx.name
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local target_player = optional_target_unit and player_unit_spawn_manager:owner(optional_target_unit)
	local target_first_person_extension = optional_target_unit and ScriptUnit.has_extension(optional_target_unit, "first_person_system")
	local attacker_first_person_extension = attacking_unit and ScriptUnit.has_extension(attacking_unit, "first_person_system")
	local target_player_is_in_1p = target_player and target_first_person_extension and target_first_person_extension:is_in_first_person_mode()
	local opposite_direction = -direction

	if not only_decal then
		local sfx = _impact_fx(impact_fx, attacking_unit, unit_to_extension_map, "sfx", "sfx_husk", target_player_is_in_1p)

		if sfx then
			_create_impact_sfx(wwise_world, sfx, source_parameters, position, opposite_direction, optional_hit_normal)
		end

		if attacker_first_person_extension then
			local follow_target = attacker_first_person_extension:is_camera_follow_target()
			local in_first_person = attacker_first_person_extension:is_in_first_person_mode()

			if follow_target and in_first_person then
				local sfx_1p = _impact_fx(impact_fx, attacking_unit, unit_to_extension_map, "sfx_1p")

				if sfx_1p then
					_create_impact_sfx(wwise_world, sfx_1p, source_parameters, position, opposite_direction)
				end
			end
		end

		if target_player_is_in_1p then
			local sfx_1p_direction_interface = _impact_fx(impact_fx, attacking_unit, unit_to_extension_map, "sfx_1p_direction_interface")

			if sfx_1p_direction_interface then
				local interface_position = position + opposite_direction * INTERFACE_POSITION_OFFSET_DISTANCE

				_create_impact_sfx(wwise_world, sfx_1p_direction_interface, source_parameters, interface_position, direction, nil, IS_DIRECTION_INTERFACE)
			end
		end

		local sfx_3p = _impact_fx(impact_fx, attacking_unit, unit_to_extension_map, "sfx_3p", nil, target_player_is_in_1p)

		if sfx_3p and not target_player_is_in_1p then
			_create_impact_sfx(wwise_world, sfx_3p, source_parameters, position, opposite_direction)
		end

		local material_switch_sfx = _impact_fx(impact_fx, attacking_unit, unit_to_extension_map, "material_switch_sfx", "material_switch_sfx_husk")

		if material_switch_sfx and optional_hit_normal then
			_create_material_switch_sfx(wwise_world, material_switch_sfx, position, opposite_direction, optional_hit_normal)
		end

		local play_vfx = not target_player_is_in_1p
		local play_1p_vfx, play_3p_vfx

		if attacker_first_person_extension and not target_player_is_in_1p then
			local in_first_person = attacker_first_person_extension:is_in_first_person_mode()

			play_1p_vfx = in_first_person
			play_3p_vfx = not in_first_person
		else
			play_1p_vfx = false
			play_3p_vfx = not target_player_is_in_1p
		end

		if play_vfx then
			local vfx = _impact_fx(impact_fx, attacking_unit, unit_to_extension_map, "vfx")

			if vfx then
				_create_impact_vfx(world, vfx, position, opposite_direction, optional_hit_normal, optional_particle_group_id)
			end
		end

		if play_1p_vfx then
			local vfx_1p = _impact_fx(impact_fx, attacking_unit, unit_to_extension_map, "vfx_1p")

			if vfx_1p then
				_create_impact_vfx(world, vfx_1p, position, opposite_direction, optional_hit_normal, optional_particle_group_id)
			end
		end

		if play_3p_vfx then
			local vfx_3p = _impact_fx(impact_fx, attacking_unit, unit_to_extension_map, "vfx_3p")

			if vfx_3p then
				_create_impact_vfx(world, vfx_3p, position, opposite_direction, optional_hit_normal, optional_particle_group_id)
			end
		end
	end

	local decal = impact_fx.decal

	if decal and optional_hit_normal then
		local dot_value = Vector3.dot(optional_hit_normal, direction)
		local tangent = Vector3.normalize(direction - dot_value * optional_hit_normal)
		local decal_rotation = Quaternion.look(tangent, optional_hit_normal)

		_create_projection_decal(t, decal, position, decal_rotation, optional_hit_normal, nil, nil, impact_fx_name)
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

			_create_projection_decal(t, linked_decal, position, decal_rotation, decal_normal, optional_target_unit, hit_actor, impact_fx_name)
		end
	end

	local blood_ball = impact_fx.blood_ball

	if blood_ball then
		local num_blood_ball = #blood_ball

		for ii = 1, num_blood_ball do
			local blood_ball_unit = blood_ball[ii]
			local impact_fx_damage_type = impact_fx.damage_type

			Managers.state.blood:queue_blood_ball(position, direction, blood_ball_unit, impact_fx_damage_type)
		end
	end

	local unit = impact_fx.unit

	if unit then
		local num_unit = #unit

		for ii = 1, num_unit do
			local unit_settings = unit[ii]
			local unit_name = unit_settings.unit_name
			local flow_event = unit_settings.flow_event
			local random_rotation = Quaternion.from_yaw_pitch_roll(math.random() * PI, math.random() * PI, math.random() * PI)
			local fx_unit = World.spawn_unit_ex(world, unit_name, nil, position, random_rotation)

			if flow_event then
				Unit.flow_event(fx_unit, flow_event)
			end

			spawned_impact_fx_units[fx_unit] = optional_particle_group_id or 0
		end
	end
end

return FxSystem
