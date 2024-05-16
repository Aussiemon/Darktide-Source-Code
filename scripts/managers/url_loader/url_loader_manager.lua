-- chunkname: @scripts/managers/url_loader/url_loader_manager.lua

local UrlLoaderManager = class("UrlLoaderManager")

UrlLoaderManager.init = function (self)
	self.ref_count = {}
end

UrlLoaderManager.load_texture = function (self, url, require_auth)
	return Managers.backend:url_request(url, {
		require_auth = require_auth or true,
	}):next(function (data)
		local count = self.ref_count[url]

		count = not count and 1 or count + 1
		self.ref_count[url] = count

		return {
			destroyed = false,
			url = url,
			texture = data.texture,
			width = data.texture_width,
			height = data.texture_height,
			destroy = function (self)
				Managers.url_loader:unload_texture(self)
			end,
		}
	end)
end

UrlLoaderManager.load_local_texture = function (self, texture_data)
	local url = texture_data.url
	local count = self.ref_count[url]

	if not count then
		-- Nothing
	else
		count = count + 1
	end

	self.ref_count[url] = count
end

UrlLoaderManager.unload_texture = function (self, texture)
	local count = self.ref_count[texture.url]

	count = count - 1

	if count == 0 then
		count = nil

		Backend.unload_texture(texture.texture)

		texture.destroyed = true
	end

	self.ref_count[texture.url] = count
end

UrlLoaderManager.destroy = function (self)
	return
end

return UrlLoaderManager
