﻿-- chunkname: @scripts/settings/deployables/deployables.lua

local deployables = {}

local function _require_deployable(name)
	local path = "scripts/settings/deployables/templates/" .. name
	local deployable = require(path)

	deployables[name] = deployable
	deployable.name = name
end

_require_deployable("medical_crate")

return settings("Deployables", deployables)
