local _rename_states = {
	initial = {
		text = "loc_rename_account_state_initial_label",
		color = Color.text_default(255, true)
	},
	pending = {
		text = "loc_rename_account_state_pending_label",
		color = Color.text_default(255, true)
	},
	error = {
		text = "loc_rename_account_state_error_label",
		color = Color.ui_red_medium(255, true)
	}
}

local function show_failure()
	local context = {
		title_text = "loc_rename_failure_title",
		description_text = "loc_rename_failure_description",
		options = {
			{
				text = "loc_rename_account_cancel_label",
				close_on_pressed = true
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context)
end

local function local_check(s)
	return type(s) == "string" and string.len(s) >= 3
end

local function show_popup(on_success, is_forced)
	local next_state = "initial"
	local popup_id = nil
	local options = {
		{
			margin_bottom = -4,
			template_type = "terminal_input_field",
			keyboard_title = "loc_rename_account_virtual_keyboard_label",
			max_length = 18,
			width = 512
		},
		{
			template_type = "text",
			margin_bottom = 20,
			font_name = "body_small",
			update = function ()
				if next_state ~= nil then
					local _next = _rename_states[next_state]
					local _text = _next.text
					local _color = _next.color

					return _text, _color
				end
			end
		},
		{
			text = "loc_popup_button_confirm",
			template_type = "terminal_button_hold_small",
			callback = function (text_input)
				if not local_check(text_input) then
					next_state = "error"

					return
				end

				Managers.ui:event_pause_popup_input(popup_id, true)

				next_state = "pending"
				local promise = Managers.backend.interfaces.account:rename_account(text_input)

				promise:next(function ()
					on_success()
					Managers.ui:event_remove_ui_popup(popup_id)
				end, function (error)
					Managers.ui:event_pause_popup_input(popup_id, false)
					Log.warning("RenamePopups", "Failed to rename account, error: %s", table.tostring(error, 3))

					next_state = "error"
				end)
			end
		}
	}

	if not is_forced then
		options[#options + 1] = {
			text = "loc_rename_account_cancel_label",
			close_on_pressed = true,
			force_same_row = true
		}
	else
		options[#options + 1] = {
			text = "loc_forced_rename_note",
			template_type = "text",
			margin_bottom = 20
		}
	end

	local title_text, description_text = nil

	if is_forced then
		title_text = "loc_forced_rename_account_title"
		description_text = "loc_forced_rename_account_description"
	else
		title_text = "loc_rename_account_title"
		description_text = "loc_rename_account_description"
	end

	local context = {
		title_text = title_text,
		description_text = description_text,
		options = options
	}

	Managers.event:trigger("event_show_ui_popup", context, function (_popup_id)
		popup_id = _popup_id
	end)
end

local function rename_popup(on_success, is_forced)
	if not is_forced then
		Managers.backend.interfaces.account:get():next(function (account_data)
			local rename_status = account_data.rename
			local optional_available = rename_status and rename_status.optional

			if optional_available then
				show_popup(on_success, is_forced)
			else
				show_failure()
			end
		end, function (error)
			Log.warning("RenamePopups", "Can't read online data, error: %s", table.tostring(error, 3))
			show_failure()
		end)
	else
		show_popup(on_success, is_forced)
	end
end

return rename_popup
