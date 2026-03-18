-- chunkname: @scripts/extension_systems/companion_spawner/companion_spawner_extension.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Breeds = require("scripts/settings/breed/breeds")
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSettings.special_rules
local CompanionSpawnerExtension = class("CompanionSpawnerExtension")

CompanionSpawnerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local is_server = extension_init_context.is_server

	self._is_server = is_server
	self._player_spawner_system = extension_init_context.owner_system
	self._owner_player = extension_init_data.player
	self._archetype = extension_init_data.archetype
	self._is_local_unit = extension_init_data.is_local_unit
	self._spawned_units = {}
	self._spawned_units_look_up = {}
	self._world = extension_init_context.world
	self._current_position = nil
	self._unstuck_timer = nil
	self._initialized = false
end

CompanionSpawnerExtension.game_object_initialized = function (self, session, object_id)
	if not self._is_server then
		return
	end

	self:_initialize()
end

CompanionSpawnerExtension._initialize = function (self)
	local owner_player = self._owner_player
	local player_unit = owner_player.player_unit
	local profile = owner_player:profile()
	local archetype = profile.archetype
	local companion_breed_name = archetype.companion_breed

	self._companion_breed_name = companion_breed_name
	self._companion_breed = Breeds[companion_breed_name]

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local side_id = side and side.side_id

	self._side_id = side_id
	self._initialized = true
end

local STUCK_TIME = 3
local STUCK_OFFSET = 0.01

CompanionSpawnerExtension.update = function (self, unit, dt, t)
	if not self._is_server then
		return
	end

	if not self._initialized then
		return
	end

	local spawned_units = self._spawned_units

	for i = 1, #spawned_units do
		repeat
			local spawned_unit = spawned_units[i]

			if not ALIVE[spawned_unit] then
				break
			end

			local blackboard = BLACKBOARDS[spawned_unit]
			local navigation_extension = ScriptUnit.has_extension(spawned_unit, "navigation_system")

			if not blackboard or not navigation_extension then
				break
			end

			local has_path = navigation_extension:has_path()
			local is_following_path = navigation_extension:is_following_path()
			local behavior_component = blackboard.behavior

			if has_path and is_following_path and behavior_component.move_state == "moving" then
				if self._old_position == nil then
					self._old_position = Vector3Box(POSITION_LOOKUP[spawned_unit])

					break
				end

				do
					local current_position = POSITION_LOOKUP[spawned_unit]
					local distance = Vector3.distance(self._old_position:unbox(), current_position)

					if distance > STUCK_OFFSET then
						self._old_position = Vector3Box(current_position)
						self._unstuck_timer = nil

						break
					end

					local unstuck_timer = self._unstuck_timer

					if unstuck_timer then
						if unstuck_timer < t then
							behavior_component = Blackboard.write_component(blackboard, "behavior")
							behavior_component.is_out_of_bound = true
							self._unstuck_timer = nil
							self._old_position = nil

							return
						end

						break
					end

					self._unstuck_timer = t + STUCK_TIME
				end

				break
			end

			self._unstuck_timer = nil
			self._old_position = nil
		until true
	end
end

CompanionSpawnerExtension.spawn_units = function (self, optional_position, optional_rotation)
	local archetype = self._archetype
	local companions_number = archetype.companions_number

	for i = 1, companions_number do
		self:spawn_unit(optional_position, optional_rotation)
	end

	local owner_player = self._owner_player
	local player_unit = owner_player.player_unit
	local spawn_companions_from_talent_func = archetype.spawn_companions_from_talent_func

	if spawn_companions_from_talent_func then
		spawn_companions_from_talent_func(player_unit)
	end
end

CompanionSpawnerExtension.spawn_unit = function (self, optional_position, optional_rotation, optional_look_up_key)
	if not self._is_server then
		return
	end

	if not self._initialized then
		self:_initialize()
	end

	if not self._side_id or not self._companion_breed_name then
		return
	end

	local spawned_unit = self:_spawn_unit(optional_position, optional_rotation)
	local spawned_unit_id = Managers.state.unit_spawner:game_object_id(spawned_unit)

	if optional_look_up_key then
		self:_add_spawned_unit_lookup(optional_look_up_key, spawned_unit)
	end

	local owner_player = self._owner_player
	local player_unit = owner_player.player_unit
	local unit_spawner_manager = Managers.state.unit_spawner
	local owner_unit_id = unit_spawner_manager:game_object_id(player_unit)
	local game_session_manager = Managers.state.game_session

	game_session_manager:send_rpc_clients("rpc_companion_spawn_unit", owner_unit_id, spawned_unit_id, optional_look_up_key)

	return spawned_unit
end

CompanionSpawnerExtension.despawn_units = function (self)
	if not self._is_server then
		local spawned_units = self._spawned_units
		local spawned_units_look_up = self._spawned_units_look_up

		table.clear(spawned_units)
		table.clear(spawned_units_look_up)

		return
	end

	if not self._initialized then
		return
	end

	if not self:have_companions() then
		return
	end

	if not self._side_id or not self._companion_breed_name then
		return
	end

	self:_despawn_units()

	local owner_player = self._owner_player
	local player_unit = owner_player.player_unit
	local unit_spawner_manager = Managers.state.unit_spawner
	local owner_unit_id = unit_spawner_manager:game_object_id(player_unit)
	local game_session_manager = Managers.state.game_session

	game_session_manager:send_rpc_clients("rpc_companion_despawn_units", owner_unit_id)
end

CompanionSpawnerExtension._spawn_unit = function (self, optional_position, optional_rotation)
	local owner_player = self._owner_player
	local player_unit = owner_player.player_unit
	local position = optional_position or POSITION_LOOKUP[player_unit]
	local rotation = optional_rotation or Unit.world_rotation(player_unit, 1)
	local minion_spawn_manager = Managers.state.minion_spawn
	local param_table = minion_spawn_manager:request_param_table()

	param_table.optional_owner_player_unit = player_unit
	param_table.optional_owner_player = owner_player

	local spawned_unit = minion_spawn_manager:spawn_minion(self._companion_breed_name, position, rotation, self._side_id, param_table)

	if player_unit then
		self:_proc_owner_companion_spawn_event(player_unit, self._companion_breed_name, spawned_unit)
	end

	return spawned_unit
end

CompanionSpawnerExtension._despawn_units = function (self)
	local spawned_units = self._spawned_units
	local spawned_units_look_up = self._spawned_units_look_up

	for i = 1, #spawned_units do
		local spawned_unit = spawned_units[i]

		if spawned_unit then
			local unit_blackboard = BLACKBOARDS[spawned_unit]

			if unit_blackboard then
				local behavior_extension = ScriptUnit.extension(spawned_unit, "behavior_system")
				local spawned_unit_brain = behavior_extension:brain()
				local t = Managers.time:time("gameplay")

				spawned_unit_brain:shutdown_behavior_tree(t, true)
				spawned_unit_brain:set_active(false)
				Managers.state.minion_spawn:unregister_unit(spawned_unit)
				Managers.state.unit_spawner:mark_for_deletion(spawned_unit)

				local player_unit_spawn_manager = Managers.state.player_unit_spawn
				local has_owner = player_unit_spawn_manager and player_unit_spawn_manager:owner(spawned_unit) ~= nil

				if has_owner then
					player_unit_spawn_manager:relinquish_unit_ownership(spawned_unit)
				end
			end
		end
	end

	table.clear(spawned_units)
	table.clear(spawned_units_look_up)
end

CompanionSpawnerExtension._proc_owner_companion_spawn_event = function (self, player_unit, companion_breed_name, spawned_unit)
	if not self._is_server then
		return
	end

	local player_unit_buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")
	local proc_event_param_table = player_unit_buff_extension and player_unit_buff_extension:request_proc_event_param_table()

	if proc_event_param_table then
		proc_event_param_table.owner_unit = player_unit
		proc_event_param_table.companion_breed_name = companion_breed_name
		proc_event_param_table.companion_unit = spawned_unit

		player_unit_buff_extension:add_proc_event(proc_events.on_player_companion_spawn, proc_event_param_table)
	end
end

CompanionSpawnerExtension.register_spawned_companion_unit = function (self, spawned_unit)
	if table.contains(self._spawned_units, spawned_unit) then
		return
	end

	table.insert(self._spawned_units, spawned_unit)
end

CompanionSpawnerExtension.companion_units = function (self)
	return self._spawned_units
end

CompanionSpawnerExtension.number_of_companion_units = function (self)
	return self._spawned_units and #self._spawned_units or 0
end

CompanionSpawnerExtension.have_companions = function (self)
	return #self._spawned_units > 0
end

CompanionSpawnerExtension.unit_is_companion = function (self, unit)
	local spawned_units = self._spawned_units

	for i = 1, #spawned_units do
		if spawned_units[i] == unit then
			return true
		end
	end

	return false
end

CompanionSpawnerExtension.should_have_companion = function (self)
	local archetype = self._archetype
	local companion_breed_name = archetype.companion_breed

	if not companion_breed_name then
		return false
	end

	local owner_player = self._owner_player
	local player_unit = owner_player.player_unit
	local companions_spawn_condition_func = archetype.companions_spawn_condition_func

	if not companions_spawn_condition_func or not companions_spawn_condition_func(player_unit) then
		return false
	end

	return true
end

CompanionSpawnerExtension.companion_can_tag_order = function (self)
	local should_have_companion = self:should_have_companion()

	if not should_have_companion then
		return false
	end

	local archetype = self._archetype
	local companion_breed_name = archetype.companion_breed
	local breed_settings = Breeds[companion_breed_name]

	return breed_settings.can_tag_order
end

CompanionSpawnerExtension._add_spawned_unit_lookup = function (self, key, value)
	self._spawned_units_look_up[key] = value
end

CompanionSpawnerExtension.rpc_add_spawned_unit_lookup = function (self, key, value)
	self:_add_spawned_unit_lookup(key, value)
end

CompanionSpawnerExtension.get_spawned_unit_lookup = function (self, key)
	return self._spawned_units_look_up[key]
end

CompanionSpawnerExtension.destroy = function (self)
	local spawned_units = self._spawned_units
	local spawned_units_look_up = self._spawned_units_look_up

	if not self._is_server then
		table.clear(spawned_units)
		table.clear(spawned_units_look_up)

		return
	end

	for i = 1, #spawned_units do
		local spawned_unit = spawned_units[i]

		if spawned_unit then
			local unit_blackboard = BLACKBOARDS[spawned_unit]

			if unit_blackboard then
				local behavior_extension = ScriptUnit.extension(spawned_unit, "behavior_system")
				local spawned_unit_brain = behavior_extension:brain()
				local t = Managers.time:time("gameplay")

				spawned_unit_brain:shutdown_behavior_tree(t, true)
				spawned_unit_brain:set_active(false)
				Managers.state.minion_spawn:unregister_unit(spawned_unit)
				Managers.state.unit_spawner:mark_for_deletion(spawned_unit)

				local player_unit_spawn_manager = Managers.state.player_unit_spawn
				local has_owner = player_unit_spawn_manager and player_unit_spawn_manager:owner(spawned_unit) ~= nil

				if has_owner then
					player_unit_spawn_manager:relinquish_unit_ownership(spawned_unit)
				end
			end
		end
	end

	table.clear(spawned_units)
	table.clear(spawned_units_look_up)
end

return CompanionSpawnerExtension
