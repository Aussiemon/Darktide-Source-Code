local ErrorInterface = require("scripts/managers/error/errors/error_interface")
local Promise = require("scripts/foundation/utilities/promise")
local StateError = require("scripts/game_states/game/state_error")
local ErrorManager = class("ErrorManager")
local ERROR_QUEUE_MAX_SIZE = 3
local ERROR_LEVEL = {
	warning = 2,
	fatal = 5,
	log = 1,
	warning_popup = 3,
	error = 4
}
ErrorManager.ERROR_LEVEL = ERROR_LEVEL
local _, MAX_ERROR_LEVEL = table.max(ERROR_LEVEL)

ErrorManager.init = function (self)
	self._error_queue = {}
end

local function _log_error(error_object)
	local original_traceback = nil

	if error_object.__traceback then
		original_traceback = "\noriginal traceback: \n" .. error_object.__traceback .. "\n"
	else
		original_traceback = ""
	end

	local log_message = error_object:log_message() or "No log message"

	Log.warning("ErrorManager", "Error %q\n%s\n%s, message: %s", error_object.__class_name, debug.traceback(), original_traceback, log_message)
end

local function _notify_error(error_object)
	local notification_text = nil
	local loc_title = error_object:loc_title()

	if loc_title then
		local title = Localize(loc_title)
		local loc_description, loc_description_params, string_format = error_object:loc_description()
		string_format = string_format or "%s: %s"
		local description = Localize(loc_description, loc_description_params ~= nil, loc_description_params)
		notification_text = string.format(string_format, title, description)
	else
		local loc_description, loc_description_params, _ = error_object:loc_description()
		notification_text = Localize(loc_description, loc_description_params ~= nil, loc_description_params)
	end

	local sound_event = error_object.sound_event and error_object:sound_event()

	Managers.event:trigger("event_add_notification_message", "alert", {
		text = notification_text
	}, nil, sound_event)
end

local function _notify_popup(error_object)
	local loc_title = error_object:loc_title()
	local loc_description, loc_description_params = error_object:loc_description()
	local options = error_object:options() or {}
	options[#options + 1] = {
		close_on_pressed = true,
		text = "loc_popup_button_close"
	}

	Managers.event:trigger("event_show_ui_popup", {
		title_text = loc_title,
		description_text = loc_description,
		description_text_params = loc_description_params,
		options = options
	})
end

local function _enqueue_error(error_object, queue)
	if #queue == ERROR_QUEUE_MAX_SIZE then
		local level = error_object:level()

		for i = 1, #queue do
			if queue[i]:level() < level then
				queue[i] = error_object

				break
			end
		end
	else
		queue[#queue + 1] = error_object
	end
end

local function _dequeue_error(queue, queue_empty_promise)
	local error_object = table.remove(queue, 1)

	if not error_object then
		queue_empty_promise:resolve()

		return
	end

	local level = error_object:level()
	local loc_title = error_object:loc_title()
	local loc_description, loc_description_params = error_object:loc_description()
	local options = error_object:options() or {}

	if level == ERROR_LEVEL.fatal then
		if PLATFORM == "win32" then
			options[#options + 1] = {
				text = "loc_popup_button_quit_game",
				callback = function ()
					Application.quit()
				end
			}
		end
	else
		options[#options + 1] = {
			text = "loc_popup_button_close",
			close_on_pressed = true,
			callback = function ()
				_dequeue_error(queue, queue_empty_promise)
			end
		}
	end

	Managers.event:trigger("event_show_ui_popup", {
		title_text = loc_title,
		description_text = loc_description,
		description_text_params = loc_description_params,
		options = options
	})
end

ErrorManager.report_error = function (self, error_object)
	assert_interface(error_object, ErrorInterface)

	local level = error_object:level()

	_log_error(error_object)

	if DEDICATED_SERVER then
		return
	end

	if level == ERROR_LEVEL.warning then
		_notify_error(error_object)
	elseif level == ERROR_LEVEL.warning_popup then
		_notify_popup(error_object)
	elseif level == ERROR_LEVEL.error or level == ERROR_LEVEL.fatal then
		_enqueue_error(error_object, self._error_queue)
	end

	return level
end

ErrorManager.show_errors = function (self)
	local queue_empty_promise = Promise:new()

	_dequeue_error(self._error_queue, queue_empty_promise)

	return queue_empty_promise
end

ErrorManager.has_error = function (self)
	return #self._error_queue > 0
end

ErrorManager.wanted_transition = function (self)
	local queue = self._error_queue

	if #queue > 0 then
		return StateError, {}
	end
end

ErrorManager.destroy = function (self)
	local queue = self._error_queue

	for i = 1, #queue do
		queue[i]:delete()
	end

	self._error_queue = nil
end

return ErrorManager
