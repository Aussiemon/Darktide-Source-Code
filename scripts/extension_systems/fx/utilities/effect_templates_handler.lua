-- chunkname: @scripts/extension_systems/fx/utilities/effect_templates_handler.lua

local EffectTemplatesHandler = class("EffectTemplatesHandler")

EffectTemplatesHandler.init = function (self, max_num_template_effects, allow_template_effects_life_time)
	self._max_num_template_effects = max_num_template_effects
	self._allow_template_effects_life_time = allow_template_effects_life_time

	local template_effects = Script.new_array(max_num_template_effects)

	for i = 1, max_num_template_effects do
		template_effects[i] = {
			global_effect_id = nil,
			is_running = false,
			optional_node = nil,
			optional_player_owner_unit = nil,
			optional_unit = nil,
			template = nil,
			buffer_index = i,
			template_data = {},
			optional_position = Vector3Box(Vector3.invalid_vector()),
		}
	end

	self._template_effects = template_effects
	self._running_template_effects = Script.new_array(max_num_template_effects)
	self._next_global_effect_id = 0
end

EffectTemplatesHandler.has_running_effect_with_global_id = function (self, global_effect_id)
	local template_effects = self._template_effects
	local buffer_index = global_effect_id % self._max_num_template_effects + 1
	local template_effect = template_effects[buffer_index]

	return template_effect.template ~= nil
end

EffectTemplatesHandler.has_running_template_of_name = function (self, unit, template_name, optional_player_owner_unit)
	local running_template_effects = self._running_template_effects

	for i = 1, #running_template_effects do
		local template_effect = running_template_effects[i]
		local template = template_effect.template

		if template_effect.optional_unit == unit and template.name == template_name and (not optional_player_owner_unit or optional_player_owner_unit == template_effect.optional_player_owner_unit) then
			return true
		end
	end

	return false
end

EffectTemplatesHandler.add_template_effect = function (self, unit_to_particle_group_lookup, template_context, template, optional_unit, optional_node, optional_position, optional_player_owner_unit)
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

	self:start_template_effect(unit_to_particle_group_lookup, template_context, template_effect, template, optional_unit, optional_node, optional_position, optional_player_owner_unit)

	template_effect.global_effect_id = global_effect_id
	self._next_global_effect_id = global_effect_id + 1

	local template_id = NetworkLookup.effect_templates[template_name]
	local optional_unit_id = Managers.state.unit_spawner:game_object_id(optional_unit)
	local optional_player_owner_unit_id = Managers.state.unit_spawner:game_object_id(optional_player_owner_unit)

	Managers.state.game_session:send_rpc_clients("rpc_start_template_effect", buffer_index, template_id, optional_unit_id, optional_node, optional_position, optional_player_owner_unit_id)

	return global_effect_id
end

EffectTemplatesHandler.start_template_effect_from_rpc = function (self, unit_to_particle_group_lookup, template_context, buffer_index, template, optional_unit, optional_node, optional_position, optional_player_owner_unit)
	local template_effects = self._template_effects
	local template_effect = template_effects[buffer_index]

	self:start_template_effect(unit_to_particle_group_lookup, template_context, template_effect, template, optional_unit, optional_node, optional_position, optional_player_owner_unit)
end

EffectTemplatesHandler.start_template_effect = function (self, unit_to_particle_group_lookup, template_context, template_effect, template, optional_unit, optional_node, optional_position, optional_player_owner_unit)
	local template_data = template_effect.template_data

	template_data.unit, template_data.node, template_data.position, template_data.player_owner_unit = optional_unit, optional_node, optional_position, optional_player_owner_unit

	if GameParameters.destroy_unmanaged_particles and optional_unit then
		local particle_group_id_or_nil = unit_to_particle_group_lookup[optional_unit]

		template_data.particle_group = particle_group_id_or_nil
	end

	local owner_unit_or_nil = optional_unit

	template.start(template_data, template_context, owner_unit_or_nil)

	if optional_position then
		template_effect.optional_position:store(optional_position)
	end

	template_effect.optional_unit = optional_unit
	template_effect.optional_node = optional_node
	template_effect.optional_player_owner_unit = optional_player_owner_unit
	template_effect.is_running, template_effect.template = true, template

	local running_template_effects = self._running_template_effects

	running_template_effects[#running_template_effects + 1] = template_effect
end

EffectTemplatesHandler.remove_template_effect = function (self, template_context, global_effect_id)
	local template_effects = self._template_effects
	local buffer_index = global_effect_id % self._max_num_template_effects + 1
	local template_effect = template_effects[buffer_index]

	if template_effect.global_effect_id ~= global_effect_id then
		return
	end

	local template = template_effect.template
	local player_owner_unit = template_effect.optional_player_owner_unit

	self:stop_template_effect(template_context, template_effect, template)

	template_effect.global_effect_id = nil

	Managers.state.game_session:send_rpc_clients("rpc_stop_template_effect", buffer_index, player_owner_unit ~= nil)
end

EffectTemplatesHandler.stop_template_effect_from_rpc = function (self, template_context, buffer_index)
	local template_effects = self._template_effects
	local template_effect = template_effects[buffer_index]
	local template = template_effect.template

	self:stop_template_effect(template_context, template_effect, template)
end

EffectTemplatesHandler.stop_template_effect = function (self, template_context, template_effect, template)
	local template_data = template_effect.template_data

	template.stop(template_data, template_context)
	template_effect.optional_position:store(Vector3.invalid_vector())

	template_effect.optional_unit = nil
	template_effect.optional_node = nil
	template_effect.optional_player_owner_unit = nil

	table.clear(template_data)

	template_effect.is_running, template_effect.template = false

	local running_template_effects = self._running_template_effects
	local index_to_remove = table.index_of(running_template_effects, template_effect)

	table.swap_delete(running_template_effects, index_to_remove)
end

EffectTemplatesHandler.update = function (self, template_context, dt, t)
	local allow_template_effects_life_time = self._allow_template_effects_life_time
	local running_template_effects = self._running_template_effects
	local effects_to_stop = {}

	for i = 1, #running_template_effects do
		local template_effect = running_template_effects[i]
		local template = template_effect.template
		local template_data = template_effect.template_data
		local stop_effect = template.update(template_data, template_context, dt, t)

		if template_context.is_server and allow_template_effects_life_time and stop_effect then
			table.insert(effects_to_stop, template_effect.global_effect_id)
		end
	end

	if template_context.is_server then
		for _, effect_id_to_stop in ipairs(effects_to_stop) do
			self:remove_template_effect(template_context, effect_id_to_stop)
		end
	end
end

EffectTemplatesHandler.hot_join_sync = function (self, sender, channel)
	local running_template_effects = self._running_template_effects

	for i = 1, #running_template_effects do
		local template_effect = running_template_effects[i]
		local buffer_index, template = template_effect.buffer_index, template_effect.template
		local template_name = template.name
		local template_id = NetworkLookup.effect_templates[template_name]
		local optional_unit = template_effect.optional_unit
		local optional_unit_id = Managers.state.unit_spawner:game_object_id(optional_unit)
		local optional_player_owner_unit = template_effect.optional_player_owner_unit
		local optional_player_owner_unit_id = Managers.state.unit_spawner:game_object_id(optional_player_owner_unit)
		local optional_node = template_effect.optional_node
		local position = template_effect.optional_position:unbox()
		local optional_position = Vector3.is_valid(position) and position or nil

		RPC.rpc_start_template_effect(channel, buffer_index, template_id, optional_unit_id, optional_node, optional_position, optional_player_owner_unit_id)
	end
end

EffectTemplatesHandler.remove_effects_on_unit = function (self, template_context, unit)
	local running_template_effects = self._running_template_effects

	for i = #running_template_effects, 1, -1 do
		local template_effect = running_template_effects[i]

		if template_effect.optional_unit == unit then
			local template = template_effect.template

			self:stop_template_effect(template_context, template_effect, template)
		end
	end
end

EffectTemplatesHandler.clear = function (self, template_context)
	local running_template_effects = self._running_template_effects

	for i = #running_template_effects, 1, -1 do
		local template_effect = running_template_effects[i]
		local template = template_effect.template

		self:stop_template_effect(template_context, template_effect, template)
	end
end

return EffectTemplatesHandler
