-- Decompilation Error: _run_step(_unwarp_expressions, node)

-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local UrlLoaderManager = class("UrlLoaderManager")

UrlLoaderManager.load_texture = function (self, url, require_auth)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	slot4 = Managers.backend
	slot3 = Managers.backend.url_request
	slot5 = url
	slot6 = {}
	slot7 = require_auth or true
	slot6.require_auth = slot7

	return slot3(Managers.backend, slot5, slot6):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-13, warpins: 1 ---
		return {
			destroyed = false,
			url = url,
			texture = data.texture,
			width = data.texture_width,
			height = data.texture_height,
			destroy = function (self)

				-- Decompilation error in this vicinity:
				--- BLOCK #0 1-7, warpins: 1 ---
				Managers.url_loader:unload_texture(self)

				return
				--- END OF BLOCK #0 ---



			end
		}
		--- END OF BLOCK #0 ---



	end)

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #1 9-9, warpins: 1 ---
	slot7 = true
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 10-16, warpins: 2 ---
	--- END OF BLOCK #2 ---



end

UrlLoaderManager.unload_texture = function (self, texture)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-17, warpins: 1 ---
	fassert(texture.url, "Expected property texture.url to be set")
	fassert(not texture.destroyed, "Texture with url: %s already destroyed", self.url)
	Backend.unload_texture(texture.texture)

	texture.destroyed = true

	return
	--- END OF BLOCK #0 ---



end

UrlLoaderManager.destroy = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-1, warpins: 1 ---
	return
	--- END OF BLOCK #0 ---



end

return UrlLoaderManager
