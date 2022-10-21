local UrlLoaderManager = class("UrlLoaderManager")

UrlLoaderManager.load_texture = function (self, url, require_auth)
	return Managers.backend:url_request(url, {
		require_auth = require_auth or true
	}):next(function (data)
		return {
			destroyed = false,
			url = url,
			texture = data.texture,
			width = data.texture_width,
			height = data.texture_height,
			destroy = function (self)
				Managers.url_loader:unload_texture(self)
			end
		}
	end)
end

UrlLoaderManager.unload_texture = function (self, texture)
	Backend.unload_texture(texture.texture)

	texture.destroyed = true
end

UrlLoaderManager.destroy = function (self)
	return
end

return UrlLoaderManager
