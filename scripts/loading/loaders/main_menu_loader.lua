-- chunkname: @scripts/loading/loaders/main_menu_loader.lua

local views_to_load = {
	"main_menu_view",
	"main_menu_background_view",
	"character_appearance_view",
	"class_selection_view",
	"options_view",
	"news_view",
	"system_view"
}
local MainMenuLoader = class("MainMenuLoader")

MainMenuLoader.init = function (self)
	self._load_done = false
end

MainMenuLoader.destroy = function (self)
	self:cleanup()
end

MainMenuLoader.start_loading = function (self)
	local ui_manager = Managers.ui

	if ui_manager then
		self._num_views_loading = #views_to_load

		local function callback()
			self._num_views_loading = self._num_views_loading - 1

			if self._num_views_loading == 0 then
				self:_load_done_callback()
			end
		end

		for i = 1, #views_to_load do
			local view_name = views_to_load[i]

			ui_manager:load_view(view_name, "MainMenuLoader - " .. view_name, callback)
		end
	else
		self:_load_done_callback()
	end
end

MainMenuLoader.is_loading_done = function (self)
	return self._load_done
end

MainMenuLoader.cleanup = function (self)
	if not self._unloaded then
		self._unloaded = true

		local ui_manager = Managers.ui

		if ui_manager then
			for i = 1, #views_to_load do
				local view_name = views_to_load[i]

				ui_manager:unload_view(view_name, "MainMenuLoader - " .. view_name)
			end
		end
	end

	self._load_done = false
end

MainMenuLoader._load_done_callback = function (self)
	self._load_done = true
end

return MainMenuLoader
