-- chunkname: @scripts/settings/vector_fields/vector_fields_definitions.lua

local VectorFieldDefinitions = {}

VectorFieldDefinitions.direction = {
	global = {
		effect_resource = "content/vector_fields/global_direction",
		required_paramters = {
			"direction",
			"speed",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			parameters.speed = Vector3.multiply(params.direction, params.speed)
			settings.duration = params.duration

			return parameters, settings
		end,
	},
	box = {
		effect_resource = "content/vector_fields/box_direction",
		required_paramters = {
			"position",
			"rotation",
			"extents",
			"direction",
			"speed",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			parameters.center = params.position
			parameters.rotation = params.rotation
			parameters.extents = params.extents
			parameters.direction = params.direction
			parameters.speed = params.speed
			settings.duration = params.duration

			return parameters, settings
		end,
	},
	sphere = {
		effect_resource = "content/vector_fields/sphere_direction",
		required_paramters = {
			"position",
			"extents",
			"direction",
			"speed",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			parameters.center = params.position
			parameters.direction = Vector3.multiply(params.direction, params.speed)
			parameters.radius = params.extents[2]
			settings.duration = params.duration

			return parameters, settings
		end,
	},
	cylinder = {
		effect_resource = "content/vector_fields/cylinder_direction",
		required_paramters = {
			"position",
			"rotation",
			"extents",
			"direction",
			"speed",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			parameters.top = params.position + params.direction * params.extents[3]
			parameters.bottom = params.position - params.direction * params.extents[3]
			parameters.rotation = params.rotation
			parameters.direction = params.direction
			parameters.speed = params.speed
			parameters.radius = params.extents[2]
			settings.duration = params.duration

			return parameters, settings
		end,
	},
}
VectorFieldDefinitions.swirl = {
	global = {
		effect_resource = "content/vector_fields/whirl",
		required_paramters = {
			"whirl_speed",
			"pull_speed",
			"position",
			"extents",
			"rotation",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			parameters.whirl_speed = params.whirl_speed
			parameters.pull_speed = params.pull_speed
			parameters.center = params.position
			parameters.radius = params.extents[2] * 0.5
			parameters.up = Quaternion.up(params.rotation)
			settings.duration = params.duration

			return parameters, settings
		end,
	},
}
VectorFieldDefinitions.sine = {
	global = {
		effect_resource = "content/vector_fields/box_direction",
		required_paramters = {
			"amplitude",
			"frequency",
			"phase",
			"rotation",
			"direction",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			params.amplitude = Quaternion.rotate(params.rotation, params.amplitude)
			params.direction = params.direction
			params.frequency = params.frequency
			params.phase = params.phase
			settings.duration = params.duration

			return parameters, settings
		end,
	},
	box = {
		effect_resource = "content/vector_fields/box_direction",
		required_paramters = {
			"amplitude",
			"frequency",
			"phase",
			"position",
			"rotation",
			"extents",
			"direction",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			params.amplitude = Quaternion.rotate(params.rotation, params.amplitude)
			params.direction = params.direction
			params.frequency = params.frequency
			params.phase = params.phase
			params.center = params.position
			params.rotation = params.rotation
			parameters.extents = params.extents
			settings.duration = params.duration

			return parameters, settings
		end,
	},
	cylinder = {
		effect_resource = "content/vector_fields/box_direction",
		required_paramters = {
			"amplitude",
			"frequency",
			"phase",
			"position",
			"rotation",
			"extents",
			"direction",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			parameters.amplitude = Quaternion.rotate(params.rotation, params.amplitude)
			parameters.direction = params.direction
			parameters.frequency = params.frequency
			parameters.phase = params.phase
			parameters.bottom = params.position - params.direction * params.extents[3]
			parameters.top = params.position + params.direction * params.extents[3]
			parameters.rotation = params.rotation
			parameters.radius = params.extents[2]
			settings.duration = params.duration

			return parameters, settings
		end,
	},
	sphere = {
		effect_resource = "content/vector_fields/box_direction",
		required_paramters = {
			"amplitude",
			"frequency",
			"phase",
			"position",
			"rotation",
			"extents",
			"direction",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			params.amplitude = Quaternion.rotate(params.rotation, params.amplitude)
			params.direction = params.direction
			params.frequency = params.frequency
			params.phase = params.phase
			params.center = params.position
			params.radius = params.extents[2]
			settings.duration = params.duration

			return parameters, settings
		end,
	},
}
VectorFieldDefinitions.pusher = {
	global = {
		required_paramters = {
			"position",
			"extents",
			"speed",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			parameters.center = params.position
			parameters.radius = params.extents[2] * 0.5
			parameters.speed = params.speed
			settings.duration = params.duration

			return parameters, settings
		end,
	},
}
VectorFieldDefinitions.tornado = {
	cylinder = {
		effect_resource = "content/vector_fields/cylinder_tornado",
		required_paramters = {
			"position",
			"rotation",
			"extents",
			"direction",
			"whirl_speed",
			"pull_speed",
			"launch_speed",
			"launch_radius",
		},
		required_settings = {
			"duration",
		},
		create_parameter = function (params)
			local parameters, settings = {}, {}

			parameters.top = params.position + params.direction * params.extents[3]
			parameters.bottom = params.position - params.direction * params.extents[3]
			parameters.radius = params.extents[2]
			parameters.whirl_speed = params.whirl_speed
			parameters.pull_speed = params.pull_speed
			parameters.launch_speed = params.launch_speed
			parameters.launch_radius = params.launch_radius
			settings.duration = params.duration

			return parameters, settings
		end,
	},
}
VectorFieldDefinitions.ARGS = {
	{
		name = "vector_type",
	},
	{
		name = "shape",
	},
	{
		name = "position",
	},
	{
		name = "rotation",
	},
	{
		name = "extents",
	},
	{
		name = "direction",
	},
	{
		name = "speed",
	},
	{
		name = "amplitude",
	},
	{
		name = "frequency",
	},
	{
		name = "phase",
	},
	{
		name = "pull_speed",
	},
	{
		name = "whirl_speed",
	},
	{
		name = "launch_speed",
	},
	{
		name = "launch_radius",
	},
	{
		name = "duration",
	},
}
VectorFieldDefinitions.NUM_ARGS = #VectorFieldDefinitions.ARGS
NUM_ARGS = VectorFieldDefinitions.NUM_ARGS

for i = 1, NUM_ARGS do
	local argument = VectorFieldDefinitions.ARGS[i]
	local arg_name = argument.name

	VectorFieldDefinitions.ARGS[arg_name] = i
end

return VectorFieldDefinitions
