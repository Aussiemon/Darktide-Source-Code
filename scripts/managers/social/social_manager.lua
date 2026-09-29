-- chunkname: @scripts/managers/social/social_manager.lua

local ProfileImageCache = require("scripts/managers/social/profile_image_cache")
local GDKAvatarSource = require("scripts/managers/social/gdk_avatar_source")
local SocialManager = class("SocialManager")

SocialManager.init = function (self)
	self._steam_pending = nil

	if HAS_STEAM and rawget(_G, "Friends") ~= nil and Friends.request_avatar ~= nil then
		self._steam_pending = {}
		self._cache = ProfileImageCache:new("steam", callback(self, "_steam_fetch"), callback(self, "_steam_free"), callback(self, "_steam_cancel"))
	elseif IS_GDK then
		self._xbox_source = GDKAvatarSource:new()
		self._cache = ProfileImageCache:new("xbox", callback(self._xbox_source, "fetch"), callback(self._xbox_source, "free"), callback(self._xbox_source, "cancel"))
	else
		self._cache = ProfileImageCache:new(AUTH_PLATFORM or "unknown", function (ids, on_result)
			for i = 1, #ids do
				on_result(ids[i], nil, "unsupported_platform")
			end
		end, function ()
			return
		end)
	end
end

SocialManager.load_avatar = function (self, platform, platform_user_id)
	return self._cache:load(platform, platform_user_id)
end

SocialManager.unload_avatar = function (self, platform, platform_user_id)
	self._cache:unload(platform, platform_user_id)
end

SocialManager._steam_fetch = function (self, ids, on_result)
	local pending = self._steam_pending

	for i = 1, #ids do
		Friends.request_avatar(ids[i])

		pending[ids[i]] = on_result
	end
end

SocialManager._steam_free = function (self, id, data)
	Friends.destroy_avatar_resource(data.texture)
end

SocialManager._steam_cancel = function (self, id)
	self._steam_pending[id] = nil
end

SocialManager._steam_update = function (self)
	local pending = self._steam_pending

	if not pending then
		return
	end

	for id, on_result in pairs(pending) do
		local fetching = Friends.request_avatar(id)
		local has_avatar = not fetching and Friends.has_avatar(id)

		if not fetching and has_avatar ~= nil then
			pending[id] = nil

			local texture, width, height

			if has_avatar then
				texture, width, height = Friends.create_avatar_resource(id)
			end

			if texture then
				on_result(id, {
					texture = texture,
					width = width,
					height = height,
				})
			else
				on_result(id, nil, "no_avatar")
			end
		end
	end
end

SocialManager.update = function (self, dt, t)
	self:_steam_update()
	self._cache:update(dt)
end

SocialManager.destroy = function (self)
	self._cache:destroy()

	if self._xbox_source then
		self._xbox_source:destroy()
	end
end

return SocialManager
