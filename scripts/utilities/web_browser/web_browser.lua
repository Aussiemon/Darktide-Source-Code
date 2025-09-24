-- chunkname: @scripts/utilities/web_browser/web_browser.lua

local Promise = require("scripts/foundation/utilities/promise")
local WebBrowser = class("WebBrowser")

WebBrowser._open_on_device = function (url)
	pcall(Application.open_url_in_browser, url)

	return Promise.resolved({
		success = true,
	})
end

WebBrowser._open_on_steam = function (url)
	if not Steam.is_overlay_enabled() then
		return WebBrowser._open_on_device(url)
	end

	Steam.open_url(url, Steam.BROWSER_MODE_MODAL)

	local did_open = false

	return Promise.until_value_is_true(function ()
		if Managers.steam:is_overlay_active() then
			did_open = true
		end

		local should_return = did_open and not Managers.steam:is_overlay_active()

		if not should_return then
			return false
		end

		return {
			success = true,
		}
	end)
end

WebBrowser.open = function (url)
	if IS_GDK then
		return WebBrowser._open_on_device(url)
	end

	if HAS_STEAM then
		return WebBrowser._open_on_steam(url)
	end

	return WebBrowser._open_on_device(url)
end

return WebBrowser
