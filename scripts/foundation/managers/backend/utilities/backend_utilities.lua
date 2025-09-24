-- chunkname: @scripts/foundation/managers/backend/utilities/backend_utilities.lua

local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendUtilities = {}
local TEMPLATE_PATTERN = "{(%a+)}"

BackendUtilities.prefered_mission_region = ""
BackendUtilities.ERROR_METATABLE = {
	__tostring = function (t)
		local msg = "Backend error:\n"

		msg = msg .. "Code: " .. t.code .. "\n"

		if t.description then
			msg = msg .. "Description: " .. t.description .. "\n"
		end

		if t.body then
			msg = msg .. "Body:\n"

			if type(t.body) == "table" then
				msg = msg .. table.tostring(t.body, 5)
			else
				msg = msg .. tostring(t.body)
			end

			msg = msg .. "\n"
		end

		if t.headers then
			msg = msg .. "Headers:\n" .. table.tostring(t.headers, 5) .. "\n"
		end

		if t.__traceback then
			msg = msg .. "Traceback:\n" .. t.__traceback
		end

		return msg
	end,
}

local function page_from_link(paged, link, prev_links)
	return Managers.backend:title_request(link):next(function (data)
		return data.body
	end):next(function (result)
		return BackendUtilities.wrap_paged_response(result, prev_links)
	end)
end

local function page_from_hal_link(paged, hal_link, prev_links)
	local link = BackendUtilities.fetch_link(paged, hal_link)

	return page_from_link(paged, link, paged._links.prev == nil and prev_links)
end

BackendUtilities.fetch_embedded_links = function (body)
	local items = body._embedded.items
	local len = #items
	local promises = {}

	for i = 1, len do
		local item = items[i]

		table.insert(promises, Managers.backend:title_request(BackendUtilities.fetch_link(item, "self")))
	end

	return Promise.all(unpack(promises))
end

BackendUtilities.wrap_paged_response = function (paged, prev_links)
	prev_links = prev_links or {}

	return {
		items = paged._embedded.items,
		page_size = paged.page.size,
		has_prev = paged._links.prev ~= nil or #prev_links > 0,
		prev_page = function ()
			if paged._links.prev ~= nil then
				return page_from_hal_link(paged, "prev", {})
			elseif #prev_links > 0 then
				local prev_link = table.remove(prev_links)

				return page_from_link(paged, prev_link, prev_links)
			else
				error("No prev link")
			end
		end,
		has_next = paged._links.next ~= nil,
		next_page = function ()
			table.insert(prev_links, paged._links.self.href)

			return page_from_hal_link(paged, "next", prev_links)
		end,
		first_page = function ()
			return page_from_hal_link(paged, "first", {})
		end,
	}
end

BackendUtilities.collect_all_paged_data = function (at_promise, items)
	items = items or {}

	return at_promise:next(function (paged)
		for _, item in pairs(paged.items) do
			table.insert(items, item)
		end

		if paged.has_next then
			return BackendUtilities.collect_all_paged_data(paged.next_page(), items)
		else
			return items
		end
	end)
end

BackendUtilities.create_error = function (code, description)
	local t = {
		code = code,
		description = tostring(description),
	}

	setmetatable(t, BackendUtilities.ERROR_METATABLE)

	return t
end

BackendUtilities.fetch_link = function (data, link_name, template_data)
	local link = data._links[link_name]

	if link == nil then
		error(BackendUtilities.create_error(BackendError.UnknownError, "No such link " .. link_name))
	end

	local href

	if link.templated == true then
		local template_error = false

		if not template_data then
			template_error = "Missing template date"
		else
			local template_keys = {}

			for match in string.gmatch(link.href, TEMPLATE_PATTERN) do
				if template_data[match] == nil then
					template_error = "Missing template key " .. match
				else
					table.insert(template_keys, match)
				end
			end

			if not template_error then
				href = link.href

				for i = 1, #template_keys do
					local key = template_keys[i]

					href = href:gsub("%{" .. key .. "%}", template_data[key])
				end
			end
		end

		if template_error then
			error(BackendUtilities.create_error(BackendError.BadRequest, template_error))
		end
	else
		href = link.href
	end

	if not string.starts_with(href, "/") then
		local self_href = data._links.self.href

		href = self_href .. "/" .. href
	end

	return href
end

local UrlBuilder = class("UrlBuilder")

UrlBuilder.init = function (self, start_path)
	self.the_path = start_path or ""
	self.params = {}
end

UrlBuilder.prefix_path = function (self, part)
	part = tostring(part)

	if self.the_path == "" then
		self.the_path = part
	elseif part and not string.ends_with(part, "/") and not string.starts_with(self.the_path, "/") then
		self.the_path = part .. "/" .. self.the_path
	else
		self.the_path = part .. self.the_path
	end

	return self
end

UrlBuilder.path = function (self, part)
	self.the_path = self.the_path .. tostring(part)

	return self
end

UrlBuilder.query = function (self, param, value)
	if type(value) == "table" then
		self.params[param] = table.concat(value, "|")
	else
		self.params[param] = value
	end

	return self
end

UrlBuilder.to_string = function (self)
	local final_url = self.the_path

	if next(self.params) then
		final_url = final_url .. "?"

		for k, v in pairs(self.params) do
			final_url = final_url .. k .. "=" .. tostring(v) .. "&"
		end

		final_url = final_url:sub(1, -2)
	end

	return final_url
end

BackendUtilities.url_builder = function (start_path)
	return UrlBuilder:new(start_path and tostring(start_path))
end

BackendUtilities.make_account_title_request = function (hal_link, url_builder, options, requested_account_id, optional_top_node)
	return BackendUtilities.build_account_path(hal_link, requested_account_id, optional_top_node):next(function (link)
		url_builder:prefix_path(link)

		return Managers.backend:title_request(url_builder:to_string(), options)
	end)
end

local function _fetch_root(optional_top_node)
	if optional_top_node then
		return Managers.backend:title_request("/" .. optional_top_node)
	else
		return Promise.resolved({
			body = {
				_links = {
					self = {
						href = "/data",
					},
					characters = {
						href = "{accountSub}/characters",
						templated = true,
					},
					progression = {
						href = "{accountSub}/progression",
						templated = true,
					},
					account = {
						href = "{accountSub}/account",
						templated = true,
					},
				},
			},
		})
	end
end

BackendUtilities.build_account_path = function (hal_link, requested_account_id, optional_top_node)
	return Managers.backend:authenticate():next(function (account)
		return account.sub
	end):next(function (account_id)
		return _fetch_root(optional_top_node):next(function (data)
			return BackendUtilities.fetch_link(data.body, hal_link, {
				accountSub = requested_account_id or account_id,
			})
		end)
	end)
end

local function calc_time_to_expire(request_headers)
	local cache_control = request_headers["cache-control"]

	if cache_control then
		local max_age = string.gmatch(cache_control, "max%-age=(%d+)")()

		if max_age then
			local age = tonumber(request_headers.age) or 0

			return max_age - age
		end
	end

	return 0
end

BackendUtilities.on_expiry_do = function (request_headers, on_expiry, pause_time)
	local expire_in = calc_time_to_expire(request_headers) + (pause_time or 0)

	if on_expiry then
		Promise.delay(math.max(expire_in, 0)):next(function ()
			return on_expiry()
		end)
	end

	return expire_in
end

return BackendUtilities
