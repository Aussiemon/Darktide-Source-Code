local CameraTransitionTemplates = {}
local CameraTransitionSettings = {
	perspective_transition_time = 0.6,
	pull_up_animation_time = 2.83
}
local DURATION = 0.25
CameraTransitionTemplates.instant_cut = {
	exposure_snap = {
		class = "CameraTransitionExposureSnap"
	}
}
CameraTransitionTemplates.dead = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.perspective_transition_time,
		transition_func = function (t)
			return math.sin(0.5 * t * math.pi) * 0.8 + 0.2
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = CameraTransitionSettings.perspective_transition_time * 0.8
	}
}
CameraTransitionTemplates.reviving = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.perspective_transition_time,
		transition_func = function (t)
			return math.sin(0.5 * t * math.pi) * 0.8 + 0.2
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = CameraTransitionSettings.perspective_transition_time * 0.8
	}
}
CameraTransitionTemplates.to_first_person = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.perspective_transition_time,
		transition_func = function (t)
			return t^2 * 0.8
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = CameraTransitionSettings.perspective_transition_time * 0.8
	}
}
CameraTransitionTemplates.to_third_person = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.perspective_transition_time,
		transition_func = function (t)
			return t^2
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = CameraTransitionSettings.perspective_transition_time
	}
}
CameraTransitionTemplates.to_consumed = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.perspective_transition_time,
		transition_func = function (t)
			return 0.1
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = CameraTransitionSettings.perspective_transition_time
	}
}
CameraTransitionTemplates.zoom = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = DURATION,
		transition_func = function (t)
			return math.sin(0.5 * t * math.pi)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = DURATION * 0.25
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = DURATION,
		transition_func = function (t)
			return math.smoothstep(t, 0, 1)
		end
	},
	custom_vertical_fov = {
		parameter = "custom_vertical_fov",
		class = "CameraTransitionGeneric",
		duration = DURATION,
		transition_func = function (t)
			return math.smoothstep(t, 0, 1)
		end
	},
	near_range = {
		parameter = "near_range",
		class = "CameraTransitionGeneric",
		duration = DURATION,
		transition_func = function (t)
			return math.smoothstep(t, 0, 1)
		end
	}
}
CameraTransitionTemplates.to_sprint = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = DURATION,
		transition_func = function (t)
			return math.sin(0.5 * t * math.pi)
		end
	},
	vertical_fov = {
		parameter = "vertical_fov",
		duration = 0.3,
		class = "CameraTransitionGeneric",
		transition_func = function (t)
			return math.smoothstep(t, 0, 1)
		end
	}
}
CameraTransitionTemplates.from_sprint = {
	position = {
		duration = 0.5,
		class = "CameraTransitionPositionLinear",
		transition_func = function (t)
			return math.sin(0.5 * t * math.pi)
		end
	},
	vertical_fov = {
		parameter = "vertical_fov",
		duration = 0.5,
		class = "CameraTransitionGeneric",
		transition_func = function (t)
			return 1 - (t - 1)^2
		end
	}
}
CameraTransitionTemplates.to_lunge = {
	vertical_fov = {
		parameter = "vertical_fov",
		duration = 0.8,
		class = "CameraTransitionGeneric",
		transition_func = function (t)
			return math.smoothstep(t, 0, 1)
		end
	},
	position = {
		duration = 0.5,
		class = "CameraTransitionPositionLinear",
		transition_func = function (t)
			return math.smoothstep(t, 0, 1)
		end
	}
}
CameraTransitionTemplates.from_lunge = {
	vertical_fov = {
		parameter = "vertical_fov",
		duration = 0.3,
		class = "CameraTransitionGeneric",
		transition_func = function (t)
			return 1 - (t - 1)^2
		end
	},
	position = {
		duration = 0.3,
		class = "CameraTransitionPositionLinear",
		transition_func = function (t)
			return t^2 * 0.8
		end
	}
}
CameraTransitionTemplates.to_third_person_hanging = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.perspective_transition_time,
		transition_func = function (t)
			return math.sqrt(t)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = CameraTransitionSettings.perspective_transition_time
	}
}
CameraTransitionTemplates.from_third_person_hanging = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = CameraTransitionSettings.pull_up_animation_time,
		transition_func = function (t)
			return math.smoothstep(t, 0, 1)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = CameraTransitionSettings.pull_up_animation_time,
		transition_func = function (t)
			return math.smoothstep(t, 0, 1)
		end
	}
}
CameraTransitionTemplates.from_scanning = {
	position = {
		duration = 0.5,
		class = "CameraTransitionPositionLinear",
		transition_func = function (t)
			return math.smoothstep(t, 0, 1)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = 0.2
	},
	vertical_fov = {
		parameter = "vertical_fov",
		duration = 0.2,
		class = "CameraTransitionGeneric",
		transition_func = function (t)
			return 1 - (t - 1)^2
		end
	}
}

return settings("CameraTransitionTemplates", CameraTransitionTemplates)
