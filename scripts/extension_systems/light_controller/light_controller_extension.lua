local LightControllerUtilities = require("core/scripts/common/light_controller_utilities")
local LightControllerExtension = class("LightControllerExtension")

LightControllerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local has_game_object = Managers.state.unit_spawner and Managers.state.unit_spawner:game_object_id(unit)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._is_setup = false
	self._enabled = nil
	self._deterministic_setup_only = true
	self._light_groups = nil
	self._fake_light = false
	self._flicker_enabled = false
	self._flicker_configuration = ""
	self._allow_enable_disable = true
	self._destructible_extension = nil
end

LightControllerExtension.is_enabled = function (self)
	return self._enabled
end

LightControllerExtension.is_flicker_enabled = function (self)
	return self._flicker_enabled
end

LightControllerExtension.setup_from_component = function (self, is_enabled, fake_light, light_groups, flicker_start_enabled, flicker_config)
	self._fake_light = fake_light
	local deterministic_update = true

	self:set_enabled(is_enabled, deterministic_update)

	self._light_groups = light_groups

	self:set_flicker_state(flicker_start_enabled, flicker_config, deterministic_update)

	self._is_setup = true
end

LightControllerExtension.connect_to_destructible_extension = function (self)
	if ScriptUnit.has_extension(self._unit, "destructible_system") then
		local destructible_extension = ScriptUnit.extension(self._unit, "destructible_system")

		if not destructible_extension:physics_disabled() then
			destructible_extension:light_controller_setup(self._enabled, self._fake_light)

			self._destructible_extension = destructible_extension
		end
	end
end

LightControllerExtension.light_groups = function (self)
	return self._light_groups
end

LightControllerExtension._share_network_enabled_state = function (self, is_enabled)
	local unit_level_index = Managers.state.unit_spawner:level_index(self._unit)
	local game_session_manager = Managers.state.game_session

	game_session_manager:send_rpc_clients("rpc_light_controller_set_enabled", unit_level_index, is_enabled)
end

LightControllerExtension.set_enabled = function (self, is_enabled, is_deterministic)
	if self._enabled ~= is_enabled then
		if self._destructible_extension then
			self._destructible_extension:set_lights_enabled(is_enabled)
		else
			LightControllerUtilities.set_enabled(self._unit, is_enabled, self._fake_light)
		end

		if self._is_server and not is_deterministic then
			self:_share_network_enabled_state(is_enabled)
		end

		self._enabled = is_enabled

		if is_enabled then
			Unit.flow_event(self._unit, "lua_light_controller_enabled")
		else
			Unit.flow_event(self._unit, "lua_light_controller_disabled")
		end
	end

	if self._deterministic_setup_only then
		self._deterministic_setup_only = is_deterministic
	end
end

LightControllerExtension.set_flicker_state = function (self, flicker_enabled, configuration, is_deterministic)
	if configuration == nil or configuration == "" then
		configuration = self._flicker_configuration
	end

	if self._flicker_enabled ~= flicker_enabled or self._flicker_configuration ~= configuration then
		LightControllerUtilities.set_flicker(self._unit, flicker_enabled, configuration)

		if self._is_server and not is_deterministic then
			self:_share_network_flicker_state(flicker_enabled, configuration)
		end
	end

	self._flicker_enabled = flicker_enabled
	self._flicker_configuration = configuration

	if self._deterministic_setup_only then
		self._deterministic_setup_only = is_deterministic
	end
end

LightControllerExtension._share_network_flicker_state = function (self, flicker_enabled, configuration)
	local unit_level_index = Managers.state.unit_spawner:level_index(self._unit)
	local game_session_manager = Managers.state.game_session
	local configuration_id = NetworkLookup.light_controller_flicker_settings[configuration]

	game_session_manager:send_rpc_clients("rpc_light_controller_set_flicker_state", unit_level_index, flicker_enabled, configuration_id)
end

LightControllerExtension.hot_join_sync = function (self, sender, channel_id)
	local unit = self._unit

	if not self._deterministic_setup_only then
		local level_unit_id = Managers.state.unit_spawner:level_index(unit)
		local configuration_id = NetworkLookup.light_controller_flicker_settings[self._flicker_configuration]

		RPC.rpc_light_controller_hot_join(channel_id, level_unit_id, self._enabled, self._flicker_enabled, configuration_id)
	end
end

LightControllerExtension.apply_hot_join_sync = function (self, is_enabled, flicker_enabled, configuration)
	local deterministic_update = false

	self:set_enabled(is_enabled, deterministic_update)
	self:set_flicker_state(flicker_enabled, configuration, deterministic_update)
end

return LightControllerExtension
