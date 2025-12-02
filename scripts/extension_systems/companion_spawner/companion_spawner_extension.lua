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
	self._spawned_unit = nil
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

	if not ALIVE[self._spawned_unit] then
		return
	end

	local blackboard = self._blackboard
	local navigation_extension = self._navigation_extension

	if not blackboard or not navigation_extension then
		blackboard = BLACKBOARDS[self._spawned_unit]
		self._blackboard = blackboard
		self._navigation_extension = ScriptUnit.has_extension(self._spawned_unit, "navigation_system")

		return
	end

	local has_path = navigation_extension:has_path()
	local is_following_path = navigation_extension:is_following_path()
	local behavior_component = blackboard.behavior

	if has_path and is_following_path and behavior_component.move_state == "moving" then
		if self._old_position == nil then
			self._old_position = Vector3Box(POSITION_LOOKUP[self._spawned_unit])
		else
			local current_position = POSITION_LOOKUP[self._spawned_unit]
			local distance = Vector3.distance(self._old_position:unbox(), current_position)

			if distance > STUCK_OFFSET then
				self._old_position = Vector3Box(current_position)
				self._unstuck_timer = nil
			else
				local unstuck_timer = self._unstuck_timer

				if unstuck_timer then
					if unstuck_timer < t then
						behavior_component = Blackboard.write_component(blackboard, "behavior")
						behavior_component.is_out_of_bound = true
						self._unstuck_timer = nil
						self._old_position = nil

						return
					end
				else
					self._unstuck_timer = t + STUCK_TIME
				end
			end
		end
	else
		self._unstuck_timer = nil
		self._old_position = nil
	end
end

CompanionSpawnerExtension.spawn_unit = function (self, optional_position, optional_rotation)
	if not self._is_server then
		return
	end

	if not self._initialized then
		self:_initialize()
	end

	if ALIVE[self._spawned_unit] then
		return
	end

	if not self._side_id or not self._companion_breed_name then
		return
	end

	self:_spawn_unit(optional_position, optional_rotation)
end

CompanionSpawnerExtension.despawn_unit = function (self)
	if not self._is_server then
		return
	end

	if not self._initialized then
		return
	end

	if not ALIVE[self._spawned_unit] then
		return
	end

	if not self._side_id or not self._companion_breed_name then
		return
	end

	self:_despawn_unit()
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

	self._spawned_unit = spawned_unit

	if player_unit then
		self:_proc_owner_companion_spawn_event(player_unit, self._companion_breed_name, spawned_unit)
	end

	local blackboard = BLACKBOARDS[spawned_unit]

	self._blackboard = blackboard
	self._navigation_extension = ScriptUnit.has_extension(spawned_unit, "navigation_system")
end

CompanionSpawnerExtension._despawn_unit = function (self)
	local spawned_unit = self._spawned_unit

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

		self._spawned_unit = nil
	end
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
	self._spawned_unit = spawned_unit
end

CompanionSpawnerExtension.companion_unit = function (self)
	return self._spawned_unit
end

CompanionSpawnerExtension.should_have_companion = function (self)
	local archetype = self._archetype
	local companion_breed_name = archetype.companion_breed

	if not companion_breed_name then
		return false
	end

	local owner_player = self._owner_player
	local player_unit = owner_player.player_unit
	local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")
	local has_disable_companion_special_rule = talent_extension and talent_extension:has_special_rule(special_rules.disable_companion)

	if has_disable_companion_special_rule then
		return false
	end

	return true
end

CompanionSpawnerExtension.destroy = function (self)
	if not self._is_server then
		return
	end

	local spawned_unit = self._spawned_unit

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

return CompanionSpawnerExtension
