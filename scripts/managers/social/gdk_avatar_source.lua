-- chunkname: @scripts/managers/social/gdk_avatar_source.lua

local XboxLiveUtils = require("scripts/foundation/utilities/xbox_live_utils")
local GDKAvatarSource = class("GDKAvatarSource")

GDKAvatarSource.init = function (self)
	self._pending = {}
end

GDKAvatarSource.fetch = function (self, xuids, on_result)
	local pending = self._pending
	local entries = {}

	for i = 1, #xuids do
		entries[i] = {
			on_result = on_result,
		}
		pending[xuids[i]] = entries[i]
	end

	XboxLiveUtils.get_user_profiles(xuids):next(function (profiles)
		local url_by_xuid = {}

		profiles = profiles or {}

		for i = 1, #profiles do
			local profile = profiles[i]

			if profile.xuid then
				url_by_xuid[profile.xuid] = profile.gameDisplayPictureResizeUri or profile.appDisplayPictureResizeUri
			end
		end

		for i = 1, #xuids do
			self:_load_texture(xuids[i], entries[i], url_by_xuid[xuids[i]])
		end
	end, function (error_data)
		for i = 1, #xuids do
			self:_fail(xuids[i], entries[i], "request_failed")
		end
	end)
end

GDKAvatarSource._load_texture = function (self, xuid, entry, url)
	if self._pending[xuid] ~= entry then
		return
	end

	if entry.cancelled then
		self._pending[xuid] = nil

		return
	end

	if not url then
		self:_fail(xuid, entry, "no_avatar")

		return
	end

	entry.url = url

	Managers.url_loader:load_texture(url, false, "social"):next(function (texture_data)
		if self._pending[xuid] ~= entry then
			return
		end

		self._pending[xuid] = nil

		entry.on_result(xuid, texture_data)
	end, function (texture_data)
		self:_fail(xuid, entry, "image_failed")
	end)
end

GDKAvatarSource._fail = function (self, xuid, entry, reason)
	if self._pending[xuid] ~= entry then
		return
	end

	self._pending[xuid] = nil

	if entry.url then
		Managers.url_loader:unload_texture(entry.url)
	end

	if not entry.cancelled then
		entry.on_result(xuid, nil, reason)
	end
end

GDKAvatarSource.free = function (self, xuid, data)
	Managers.url_loader:unload_texture(data.url)
end

GDKAvatarSource.cancel = function (self, xuid)
	local entry = self._pending[xuid]

	if not entry then
		return
	end

	if entry.url then
		self._pending[xuid] = nil

		Managers.url_loader:unload_texture(entry.url)
	else
		entry.cancelled = true
	end
end

GDKAvatarSource.destroy = function (self)
	self._pending = {}
end

return GDKAvatarSource
