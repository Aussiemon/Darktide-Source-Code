-- chunkname: @scripts/extension_systems/smoke_fog/smoke_fog_extension.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local MinionState = require("scripts/utilities/minion_state")
local proc_events = BuffSettings.proc_events
local SmokeFogExtension = class("SmokeFogExtension")
local DEFAULT_INNER_RADIUS = 4.5
local DEFAULT_OUTER_RADIUS = 4.5
local DEFAULT_DURATION = 30
local DEFAULT_HEIGHT = 2

SmokeFogExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data, ...)
	self.units_inside = {}
	self.broadphase_results = {}
	self.num_results = 0
	self._unit = unit
	self._world = extension_init_context.world
	self._wwise_world = extension_init_context.wwise_world
	self._is_server = extension_init_context.is_server

	local owner_unit = extension_init_data.owner_unit

	self.owner_unit = owner_unit

	local owner_buff_extension = ScriptUnit.has_extension(owner_unit, "buff_system")

	self._owner_buff_extension = owner_buff_extension

	local stat_buffs = owner_buff_extension and owner_buff_extension:stat_buffs()
	local smoke_fog_duration_modifier = 1

	if stat_buffs then
		smoke_fog_duration_modifier = stat_buffs.smoke_fog_duration_modifier or 1
	end

	self._max_duration = (extension_init_data.duration or DEFAULT_DURATION) * smoke_fog_duration_modifier

	local t = Managers.time:time("gameplay")

	self._duration = t + self._max_duration
	self._smoke_start_t = t
	self._smoke_fade_t = t + self._max_duration

	local block_line_of_sight = extension_init_data.block_line_of_sight

	if block_line_of_sight == nil then
		block_line_of_sight = true
	end

	self.block_line_of_sight = block_line_of_sight
	self.is_expired = false

	local inner_radius = extension_init_data.inner_radius or DEFAULT_INNER_RADIUS
	local outer_radius = extension_init_data.outer_radius or DEFAULT_OUTER_RADIUS

	self.inner_radius = inner_radius
	self.outer_radius = outer_radius
	self.inner_radius_squared = inner_radius * inner_radius
	self.outer_radius_squared = outer_radius * outer_radius
	self._in_fog_buff_template_name = extension_init_data.in_fog_buff_template_name
	self._leaving_fog_buff_template_name = extension_init_data.leaving_fog_buff_template_name
	self.has_buffs = self._in_fog_buff_template_name ~= nil or self._leaving_fog_buff_template_name ~= nil
	self.buff_affected_units = {}
	self._line_of_sight_affected_minions = {}
	self._number_of_line_of_sight_affected_minions = 0

	if owner_unit then
		local side_system = Managers.state.extension:system("side_system")

		self.side = side_system.side_by_unit[owner_unit]
		self.side_names = self.side:relation_side_names("enemy")
	else
		local side_system = Managers.state.extension:system("side_system")

		self.side = side_system:get_side_from_name("heroes")
		self.side_names = self.side:relation_side_names("enemy")
	end

	local fade_frame = math.ceil(self._smoke_fade_t / Managers.state.game_session.fixed_time_step)

	game_object_data.smoke_fade_frame = fade_frame
end

SmokeFogExtension.destroy = function (self)
	local t = FixedFrame.get_latest_fixed_time()

	for inside_unit, _ in pairs(self.units_inside) do
		self:on_unit_exit(inside_unit, t)
	end

	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(self.owner_unit)

	if player then
		Managers.stats:record_private("hook_veteran_units_engulfed_smoke", player, self._number_of_line_of_sight_affected_minions)
	end
end

SmokeFogExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
end

SmokeFogExtension.extensions_ready = function (self, world, unit)
	return
end

SmokeFogExtension.remaining_duration = function (self, t)
	return self._smoke_fade_t - t
end

SmokeFogExtension.is_unit_inside = function (self, unit_pos, handle_height)
	if self.is_expired then
		return false
	end

	if not unit_pos then
		return false
	end

	local position = POSITION_LOOKUP[self._unit]

	if handle_height then
		local height_dif = unit_pos.z - position.z

		if height_dif > 0 and height_dif < DEFAULT_HEIGHT then
			unit_pos.z = position.z
		end
	end

	local radius_sq = self.outer_radius_squared
	local distance = Vector3.distance_squared(unit_pos, position)

	if distance < radius_sq then
		return true
	end

	return false
end

SmokeFogExtension.on_unit_enter = function (self, unit, t)
	local unit_buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not unit_buff_extension then
		return
	end

	local buff_affected_units = self.buff_affected_units
	local fog_unit = self._unit
	local in_fog_buff_template_name = self._in_fog_buff_template_name

	if in_fog_buff_template_name then
		local _, local_index, component_index = unit_buff_extension:add_externally_controlled_buff(in_fog_buff_template_name, t, "owner_unit", fog_unit)

		buff_affected_units[unit] = {
			local_index = local_index,
			component_index = component_index
		}
	end

	local owner_unit = self.owner_unit
	local owner_buff_extension = self._owner_buff_extension
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = owner_unit and player_unit_spawn_manager:owner(owner_unit)

	if player and owner_buff_extension then
		local param_table = owner_buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.fog_owner_unit = self.owner_unit
			param_table.target_unit = unit

			owner_buff_extension:add_proc_event(proc_events.on_unit_enter_fog, param_table)
		end
	end

	self:on_unit_engulfed_by_fog(unit)
end

SmokeFogExtension.on_unit_exit = function (self, unit, t)
	local unit_buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not unit_buff_extension then
		return
	end

	local buff_affected_units = self.buff_affected_units
	local buff_indices = buff_affected_units[unit]

	if buff_indices then
		local local_index = buff_indices.local_index
		local component_index = buff_indices.component_index

		unit_buff_extension:remove_externally_controlled_buff(local_index, component_index)

		buff_affected_units[unit] = nil
	end

	local owner_unit = self.owner_unit
	local owner_buff_extension = self._owner_buff_extension
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = owner_unit and player_unit_spawn_manager:owner(owner_unit)

	if player and owner_buff_extension then
		local param_table = owner_buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.fog_owner_unit = self.owner_unit
			param_table.target_unit = unit

			owner_buff_extension:add_proc_event(proc_events.on_unit_exit_fog, param_table)
		end
	end

	local leaving_fog_buff_template_name = self._leaving_fog_buff_template_name

	if leaving_fog_buff_template_name then
		unit_buff_extension:add_internally_controlled_buff(leaving_fog_buff_template_name, t, "owner_unit", unit)
	end
end

SmokeFogExtension.on_unit_engulfed_by_fog = function (self, unit)
	local line_of_sight_affected_minions = self._line_of_sight_affected_minions

	if not line_of_sight_affected_minions[unit] then
		self._number_of_line_of_sight_affected_minions = self._number_of_line_of_sight_affected_minions + 1
	end

	line_of_sight_affected_minions[unit] = true
end

return SmokeFogExtension
