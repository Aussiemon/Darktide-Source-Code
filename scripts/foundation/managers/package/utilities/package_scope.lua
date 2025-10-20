-- chunkname: @scripts/foundation/managers/package/utilities/package_scope.lua

local PackageScope = class("PackageScope")

PackageScope.init = function (self, reference_name)
	self._reference_name = reference_name
	self._packages_in_scope = {}
end

PackageScope.add_package = function (self, package_name)
	if self._packages_in_scope[package_name] then
		return
	end

	self._packages_in_scope[package_name] = Managers.package:load(package_name, self._reference_name, nil, false, false)

	return self._packages_in_scope[package_name]
end

PackageScope.release = function (self, package_name)
	local id = self._packages_in_scope[package_name]

	if not id then
		return
	end

	Managers.package:release(id)

	self._packages_in_scope[package_name] = nil
end

PackageScope.release_all = function (self)
	for package_name, _ in pairs(self._packages_in_scope) do
		self:release(package_name)
	end
end

PackageScope.destroy = function (self)
	self:release_all()
end

PackageScope.are_all_packages_loaded = function (self)
	for package_name, _ in pairs(self._packages_in_scope) do
		if not Managers.package:has_loaded(package_name) then
			return false
		end
	end

	return true
end

return PackageScope
