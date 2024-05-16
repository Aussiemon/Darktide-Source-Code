-- chunkname: @scripts/components/spline_follower.lua

local SplineFollower = component("SplineFollower")

SplineFollower.init = function (self, unit)
	return
end

SplineFollower.editor_validate = function (self, unit)
	return true, ""
end

SplineFollower.enable = function (self, unit)
	return
end

SplineFollower.disable = function (self, unit)
	return
end

SplineFollower.destroy = function (self, unit)
	return
end

SplineFollower.component_data = {
	extensions = {
		"SplineFollowerExtension",
	},
}

return SplineFollower
