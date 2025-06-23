-- chunkname: @scripts/extension_systems/dialogue/dialogue_context_system.lua

local DialogueContextExtension = require("scripts/extension_systems/dialogue/dialogue_context_extension")
local extensions = {
	"DialogueContextExtension"
}
local DialogueContextSystem = class("DialogueContextSystem", "ExtensionSystemBase")

DialogueContextSystem.init = function (self, extension_system_creation_context, system_init_data, system_name)
	local extension_manager = extension_system_creation_context.extension_manager

	extension_manager:register_system(self, system_name, extensions)

	self._is_server = extension_system_creation_context.is_server
	self._next_player_key = nil
	self._unit_extension_data = {}
	self._start_dialogue_modifier = nil

	local mission = system_init_data.mission

	if mission and mission.dialogue_settings and mission.dialogue_settings.on_start_dialogue_modifier then
		self._start_dialogue_modifier = system_init_data.mission.dialogue_settings.on_start_dialogue_modifier
	end
end

DialogueContextSystem.destroy = function (self)
	self._unit_extension_data = nil
end

DialogueContextSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data)
	local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
	local context = dialogue_extension:get_context()
	local extension = DialogueContextExtension:new(self, unit, extension_init_data, context)

	ScriptUnit.set_extension(unit, "dialogue_context_system", extension)

	return extension
end

DialogueContextSystem.register_extension_update = function (self, unit, extension_name, extension)
	self._unit_extension_data[unit] = extension
end

DialogueContextSystem.on_remove_extension = function (self, unit, extension_name)
	if self._next_player_key == unit then
		self._next_player_key = next(self._unit_extension_data, self._next_player_key)
	end

	local extension = self._unit_extension_data[unit]

	if extension then
		self._unit_extension_data[unit] = nil
	end

	ScriptUnit.remove_extension(unit, "dialogue_context_system")
end

DialogueContextSystem.update = function (self, system_context, t)
	if not self._is_server then
		return
	end

	local next_player_key, extension = next(self._unit_extension_data, self._next_player_key)

	self._next_player_key = next_player_key

	if not next_player_key then
		return
	end

	extension:update(t)
end

DialogueContextSystem.hot_join_sync = function (self, sender, channel)
	return
end

DialogueContextSystem.get_start_dialogue_modifier = function (self)
	return self._start_dialogue_modifier
end

return DialogueContextSystem
