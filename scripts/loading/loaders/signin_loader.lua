-- chunkname: @scripts/loading/loaders/signin_loader.lua

local PACKAGES_TO_LOAD = {
	"packages/ui/ui_signin_assets",
}
local Loader = require("scripts/loading/loader")
local SigninLoader = class("SigninLoader")

SigninLoader.init = function (self)
	self._load_done = false
	self._package_ids = {}
	self._package_loading_reference_counter = {}
end

SigninLoader.destroy = function (self)
	return
end

SigninLoader.start_loading = function (self, context)
	local package_manager = Managers.package
	local package_ids = self._package_ids

	for _, package_name in pairs(PACKAGES_TO_LOAD) do
		self._package_loading_reference_counter[package_name] = (self._package_loading_reference_counter[package_name] or 0) + 1

		local function load_callback(id)
			self:_package_load_done_callback(package_name)
		end

		local id = package_manager:load(package_name, "SigninLoader", load_callback)

		package_ids[id] = package_name
	end
end

SigninLoader._package_load_done_callback = function (self, package_name)
	self._package_loading_reference_counter[package_name] = self._package_loading_reference_counter[package_name] - 1

	for ref_key, counter in pairs(self._package_loading_reference_counter) do
		if counter > 0 then
			return
		end
	end

	self._load_done = true
end

SigninLoader.is_loading_done = function (self)
	return self._load_done
end

SigninLoader.cleanup = function (self)
	local package_manager = Managers.package
	local package_ids = self._package_ids

	for id, package_name in pairs(package_ids) do
		package_manager:release(id)

		package_ids[id] = nil
	end

	self._load_done = false
end

SigninLoader.dont_destroy = function (self)
	return false
end

implements(SigninLoader, Loader)

return SigninLoader
