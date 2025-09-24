-- chunkname: @scripts/extension_systems/minigame/minigame_extension.lua

local LevelProps = require("scripts/settings/level_prop/level_props")
local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local MinigameClasses = require("scripts/settings/minigame/minigame_classes")
local MinigameExtension = class("MinigameExtension")

MinigameExtension.UPDATE_DISABLED_BY_DEFAULT = true

MinigameExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_session, prop_settings_or_game_object_id)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._seed = nil
	self._minigame_type = MinigameSettings.types.none
	self._minigame = nil
	self._active = false
	self._owner_system = extension_init_context.owner_system
	self._is_game_object = game_object_data_or_session ~= nil
	self._is_side_mission = false
	self._mutator_on_minigame_complete = nil

	local wwise_world = extension_init_context.wwise_world

	self._wwise_world = wwise_world

	if prop_settings_or_game_object_id then
		if self._is_server then
			local prop_settings = prop_settings_or_game_object_id

			if prop_settings.is_side_mission_prop then
				self._is_side_mission = true
			end

			if prop_settings.minigame_angle_check ~= nil then
				-- Nothing
			end

			if prop_settings.mutator_on_minigame_complete then
				self._mutator_on_minigame_complete = prop_settings.mutator_on_minigame_complete
			end
		else
			local game_object_id = prop_settings_or_game_object_id
			local session = game_object_data_or_session
			local prop_id = GameSession.game_object_field(session, game_object_id, "prop_id")
			local prop_name = NetworkLookup.level_props_names[prop_id]
			local prop_settings = LevelProps[prop_name]

			if prop_settings.is_side_mission_prop then
				self._is_side_mission = true
			end

			if prop_settings.minigame_angle_check ~= nil then
				-- Nothing
			end
		end
	end
end

MinigameExtension.hot_join_sync = function (self, unit, sender, channel)
	self._minigame:hot_join_sync(sender, channel)

	local unit_spawner_manager = Managers.state.unit_spawner
	local is_level_unit, unit_id = unit_spawner_manager:game_object_id_or_level_index(unit)

	RPC.rpc_minigame_extension_sync_active(channel, unit_id, is_level_unit, self._active)
end

MinigameExtension.on_add_extension = function (self, seed)
	self._seed = seed
end

MinigameExtension.setup_from_component = function (self, minigame_type)
	if minigame_type == "default" then
		minigame_type = self._owner_system:default_minigame_type()
	end

	self._minigame_type = minigame_type

	if not self._is_game_object then
		self:setup_minigame()
	end
end

MinigameExtension.game_object_initialized = function (self, session, object_id)
	if self._is_game_object then
		self:setup_minigame()
	end
end

MinigameExtension.on_game_object_created = function (self, game_object_id)
	self:setup_minigame()
end

MinigameExtension.setup_minigame = function (self)
	local minigame_class = MinigameClasses[self._minigame_type]

	self._minigame = minigame_class:new(self._unit, self._is_server, self._seed, self._wwise_world)
end

MinigameExtension.update = function (self, unit, dt, t)
	self._minigame:update(dt, t)
end

MinigameExtension.minigame_type = function (self)
	return self._minigame_type
end

MinigameExtension.minigame = function (self, type)
	return self._minigame
end

MinigameExtension.is_active = function (self)
	return self._active
end

MinigameExtension.unit = function (self)
	return self._unit
end

MinigameExtension.angle_check = function (self)
	return self._minigame_angle_check
end

MinigameExtension.decode_interrupt = function (self)
	self._minigame:decode_interrupt()
end

MinigameExtension.set_active = function (self, enabled)
	if self._active ~= enabled then
		if enabled then
			self._owner_system:enable_update_function(self.__class_name, "update", self._unit, self)
		else
			self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
		end
	end

	self._active = enabled
end

return MinigameExtension
