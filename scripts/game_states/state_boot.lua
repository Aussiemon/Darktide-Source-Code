-- chunkname: @scripts/game_states/state_boot.lua

local GameStateMachine = require("scripts/foundation/utilities/game_state_machine")
local StateBoot = class("StateBoot")

StateBoot.on_enter = function (self, parent, params)
	self._debug_texts = {}

	do
		local Application = s3d.Application
		local application_settings = Application.settings()
		local game_version = application_settings.game_version
		local content_revision = application_settings.content_revision or LOCAL_CONTENT_REVISION
		local build = Application.build()
		local engine_revision = Application.build_identifier()

		self:boot_printf("[DEVELOPER MODE]")
		self:boot_printf("Darktide %s | Content %s | Engine %s/%s", game_version, content_revision, build, engine_revision)

		if rawget(_G, "Steam") then
			self:boot_printf("Steam : ON | AppId %s | SteamID %s", Steam.app_id(), Steam.user_id())
		end

		self:boot_printf("")
		self:boot_printf("Running %d boot steps...", #params.boot_state_paths)
		self:boot_printf("")
	end

	self._done = false
	self._next_state_class_name = params.next_state_class_name

	local initialized_steps = {}

	self._initialized_steps = initialized_steps

	local boot_states = {}

	for i, path in ipairs(params.boot_state_paths) do
		boot_states[i] = require(path)
	end

	local start_params = {
		boot_state_index = 1,
		boot_states = boot_states,
		initialized_steps = initialized_steps,
	}
	local start_state = boot_states[1]

	self._sm = GameStateMachine:new(self, start_state, start_params, nil, nil, "Main", "Boot", true)
end

StateBoot.update = function (self, dt)
	self._sm:update(dt)

	if self._boot_ui then
		self._boot_ui:update(dt, self._debug_texts)
	end

	if self._done then
		local next_state = CLASSES[self._next_state_class_name]
		local next_params

		return next_state, next_params
	end
end

StateBoot.render = function (self)
	if self._boot_ui then
		self._boot_ui:render()
	end
end

StateBoot.boot_printf = function (self, ...)
	self._debug_texts[#self._debug_texts + 1] = string.format(...)
end

StateBoot.set_boot_ui = function (self, boot_ui)
	self._boot_ui = boot_ui
end

StateBoot.sub_states_done = function (self)
	self:boot_printf("Done!")

	self._done = true
end

StateBoot.on_exit = function (self, exit_params)
	self._sm:destroy(exit_params)

	local initialized_steps = self._initialized_steps

	for i = #initialized_steps, 1, -1 do
		local state = initialized_steps[i]

		state:delete(exit_params)
	end

	table.clear(initialized_steps)

	self._boot_ui = nil
end

return StateBoot
