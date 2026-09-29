-- chunkname: @scripts/managers/ui/ui_manager_testify.lua

local Views = require("scripts/ui/views/views")
local IN_FLIGHT_CAP = 8
local STALL_FRAME_BUDGET = 1800
local _gen
local UIManagerTestify = {
	all_views = function (ui_manager)
		return Views
	end,
	close_view = function (ui_manager, view_name)
		ui_manager:close_view(view_name)
	end,
	is_view_active = function (ui_manager, view_name)
		return ui_manager:view_active(view_name)
	end,
	close_view_if_active = function (ui_manager, view_name)
		if ui_manager:view_active(view_name) then
			ui_manager:close_view(view_name)

			return true
		end

		return false
	end,
	wait_until_view_is_done_closing = function (ui_manager, view_name)
		if ui_manager:is_view_closing(view_name) then
			return Testify.RETRY
		end
	end,
	wait_until_no_views_closing = function (ui_manager)
		for view_name in pairs(Views) do
			if ui_manager:is_view_closing(view_name) then
				return Testify.RETRY
			end
		end
	end,
	open_view = function (ui_manager, view)
		local context = view.dummy_data or {
			can_exit = true,
			debug_preview = true,
		}

		ui_manager:open_view(view.view_name, nil, nil, nil, nil, context)
	end,
	wait_for_view = function (ui_manager, view_name)
		if not ui_manager:view_active(view_name) then
			return Testify.RETRY
		end
	end,
	wait_for_view_to_close = function (ui_manager, view_name)
		if ui_manager:view_active(view_name) then
			return Testify.RETRY
		end
	end,
	generate_all_item_icons = function (ui_manager, items_by_name)
		if not _gen then
			local items = {}

			for item_id, item in pairs(items_by_name or {}) do
				items[#items + 1] = {
					id = item_id,
					item = item,
				}
			end

			local total_passes = 1

			_gen = {
				frames_since_progress = 0,
				next = 1,
				pass = 1,
				succeeded = 0,
				items = items,
				total_passes = total_passes,
				in_flight = {},
				failing = {},
			}
		end

		local g = _gen

		for i = #g.in_flight, 1, -1 do
			local entry = g.in_flight[i]

			if entry.done then
				if entry.load_id then
					ui_manager:unload_item_icon(entry.load_id)
				end

				table.remove(g.in_flight, i)

				g.frames_since_progress = 0
			end
		end

		while #g.in_flight < IN_FLIGHT_CAP and g.next <= #g.items do
			local record = g.items[g.next]

			g.next = g.next + 1

			local entry = {
				done = false,
				name = record.id,
			}

			g.in_flight[#g.in_flight + 1] = entry

			local render_context = {}
			local ok, load_id = pcall(function ()
				return ui_manager:load_item_icon(record.item, function ()
					entry.done = true
					g.succeeded = g.succeeded + 1
				end, render_context)
			end)

			if not ok or not load_id then
				entry.done = true
				g.failing[record.id] = true
			else
				entry.load_id = load_id
			end

			if not g.sample_name then
				g.sample_name = record.id
				g.sample_ctx = render_context
			end
		end

		if g.next > #g.items and #g.in_flight == 0 then
			if g.pass < g.total_passes then
				g.pass = g.pass + 1
				g.next = 1
				g.succeeded = 0
				g.frames_since_progress = 0

				return Testify.RETRY
			end

			local failing_names = table.keys(g.failing)
			local result = {
				total = #g.items,
				succeeded = g.succeeded,
				failed = #failing_names,
				failing_names = failing_names,
				sample_name = g.sample_name,
				cache_path = g.cache_path,
				cache_exists = g.cache_exists == true,
			}

			_gen = nil

			return result
		end

		g.frames_since_progress = g.frames_since_progress + 1

		if g.frames_since_progress > STALL_FRAME_BUDGET then
			for i = 1, #g.in_flight do
				local entry = g.in_flight[i]

				if not entry.done then
					g.failing[entry.name] = true

					if entry.load_id then
						ui_manager:unload_item_icon(entry.load_id)
					end
				end
			end

			local failing_names = table.keys(g.failing)
			local result = {
				stalled = true,
				total = #g.items,
				succeeded = g.succeeded,
				failed = #failing_names,
				failing_names = failing_names,
				sample_name = g.sample_name,
				cache_path = g.cache_path,
				cache_exists = g.cache_exists == true,
			}

			_gen = nil

			return result
		end

		return Testify.RETRY
	end,
}

return UIManagerTestify
