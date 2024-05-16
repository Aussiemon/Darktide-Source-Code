-- chunkname: @scripts/settings/camera/camera_settings.lua

local CameraTransitionTemplates = require("scripts/settings/camera/camera_transition_templates")

CameraSettings = CameraSettings or {}
CameraSettings.world = {
	_node = {
		class = "RootCamera",
		far_range = 800,
		name = "root_node",
		near_range = 0.08,
		vertical_fov = 65,
		tree_transitions = {
			default = CameraTransitionTemplates.instant_cut,
		},
		node_transitions = {},
		safe_position_offset = Vector3Box(0, 0, 0),
	},
	{
		_node = {
			class = "TransformCamera",
			name = "up_translation",
			offset_position = {
				x = 0,
				y = 0,
				z = 10,
			},
		},
		{
			_node = {
				class = "RotationCamera",
				name = "world",
				offset_pitch = -90,
			},
		},
	},
}
CameraSettings.cinematic = {
	_node = {
		class = "CinematicLinkCamera",
		disable_collision = true,
		far_range = 1000,
		name = "story_slave",
		near_range = 0.08,
		vertical_fov = 45,
		tree_transitions = {
			default = CameraTransitionTemplates.instant_cut,
		},
		node_transitions = {},
		safe_position_offset = Vector3Box(0, 0, 0),
	},
}
CameraSettings.cinematic_gameplay = {
	_node = {
		class = "CinematicLinkCamera",
		disable_collision = true,
		far_range = 1000,
		name = "story_slave",
		near_range = 0.08,
		vertical_fov = 45,
		tree_transitions = {
			default = CameraTransitionTemplates.instant_cut,
			first_person = CameraTransitionTemplates.to_first_person,
			third_person = CameraTransitionTemplates.to_third_person,
			third_person_hub = CameraTransitionTemplates.to_third_person,
		},
		node_transitions = {},
		safe_position_offset = Vector3Box(0, 0, 0),
	},
}
CameraSettings.testify_camera = {
	_node = {
		class = "TestifyCamera",
		disable_collision = true,
		far_range = 1000,
		name = "testify",
		near_range = 0.08,
		vertical_fov = 65,
		tree_transitions = {
			default = CameraTransitionTemplates.instant_cut,
		},
		node_transitions = {},
		safe_position_offset = Vector3Box(0, 0, 0),
	},
}
CameraSettings.player_third_person = {
	_node = {
		class = "RootCamera",
		far_range = 800,
		name = "root_node",
		near_range = 0.08,
		root_object_name = "j_camera_attach",
		vertical_fov = 65,
		tree_transitions = {
			world = CameraTransitionTemplates.instant_cut,
			first_person = CameraTransitionTemplates.to_first_person,
			grabbed = CameraTransitionTemplates.to_grabbed,
			dead = CameraTransitionTemplates.dead,
		},
		node_transitions = {
			default = CameraTransitionTemplates.to_third_person,
			grabbed = CameraTransitionTemplates.to_grabbed,
		},
		safe_position_offset = Vector3Box(0, 0, 1.65),
	},
	{
		_node = {
			class = "ScalableTransformCamera",
			name = "up_translation",
			scale_variable = "character_height",
			offset_position = {
				x = 0,
				y = 0,
				z = 1,
			},
			scale_function = function (height)
				return height * 1.1
			end,
		},
		{
			_node = {
				class = "AimCamera",
				name = "third_person_aim",
			},
			{
				_node = {
					class = "TransformCamera",
					custom_vertical_fov = 65,
					name = "third_person",
					should_apply_fov_multiplier = true,
					vertical_fov = 65,
					offset_position = {
						x = 0,
						y = -2,
						z = 0,
					},
				},
				{
					_node = {
						class = "TransformCamera",
						custom_vertical_fov = 65,
						name = "pounced",
						near_range = 0.025,
						vertical_fov = 65,
						offset_position = {
							x = 0,
							y = -2,
							z = -1,
						},
					},
				},
				{
					_node = {
						class = "TransformCamera",
						custom_vertical_fov = 65,
						name = "consumed",
						near_range = 0.025,
						vertical_fov = 65,
						offset_position = {
							x = 0,
							y = -4,
							z = 0,
						},
					},
				},
				{
					_node = {
						class = "TransformCamera",
						custom_vertical_fov = 65,
						name = "grabbed",
						near_range = 0.025,
						vertical_fov = 65,
						offset_position = {
							x = 0,
							y = -1.97,
							z = -0.1,
						},
					},
				},
				{
					_node = {
						class = "TransformCamera",
						name = "disabled",
						near_range = 0.025,
						offset_position = {
							x = 0,
							y = -2,
							z = -0.5,
						},
					},
				},
				{
					_node = {
						class = "TransformCamera",
						name = "hogtied",
						near_range = 0.025,
						offset_position = {
							x = 0,
							y = -2,
							z = -0.5,
						},
						tree_transitions = {
							first_person = CameraTransitionTemplates.instant_cut,
						},
					},
				},
				{
					_node = {
						class = "TransformCamera",
						custom_vertical_fov = 65,
						name = "ledge_hanging",
						near_range = 0.025,
						vertical_fov = 65,
						offset_position = {
							x = 0,
							y = -2,
							z = -1,
						},
					},
				},
			},
		},
	},
}
CameraSettings.player_third_person_hub = {
	_node = {
		class = "RootCamera",
		far_range = 800,
		name = "root_node",
		near_range = 0.08,
		root_object_name = "j_camera_attach",
		vertical_fov = 55,
		tree_transitions = {
			world = CameraTransitionTemplates.instant_cut,
			first_person = CameraTransitionTemplates.to_first_person,
		},
		node_transitions = {
			default = CameraTransitionTemplates.to_third_person,
		},
		safe_position_offset = Vector3Box(0, 0, 1.65),
	},
	{
		_node = {
			class = "ScalableTransformCamera",
			name = "up_translation",
			scale_variable = "character_height",
			offset_position = {
				x = 0,
				y = 0,
				z = 1,
			},
			scale_function = function (height)
				return height * 1.1
			end,
		},
		{
			_node = {
				class = "DampenedStringTransformCamera",
				halflife = 0.05,
				name = "dampened_string_transform",
			},
			{
				_node = {
					class = "AimCamera",
					name = "third_person_aim",
				},
				{
					_node = {
						class = "ScalableTransformCamera",
						name = "hub_idle_offset",
						scale_variable = "hub_idle_offset",
						offset_position = {
							x = 0.5,
							y = 1,
							z = -0,
						},
						scale_function = function (hub_idle_offset)
							return hub_idle_offset
						end,
					},
					{
						_node = {
							class = "ScalableTransformCamera",
							name = "hub_speed_zoom",
							scale_variable = "hub_speed_zoom",
							offset_position = {
								x = 0,
								y = -0.6,
								z = 0,
							},
							scale_function = function (hub_speed_zoom)
								return hub_speed_zoom
							end,
						},
						{
							_node = {
								class = "ScalableTransformCamera",
								name = "hub_back_look_offset",
								scale_variable = "hub_back_look_offset",
								offset_position = {
									x = -0.25,
									y = -0.2,
									z = -0.1,
								},
								scale_function = function (hub_back_look_offset)
									return hub_back_look_offset
								end,
							},
							{
								_node = {
									class = "ScalableTransformCamera",
									name = "hub_up_look_offset",
									scale_variable = "hub_up_look_offset",
									offset_position = {
										x = 0,
										y = 0,
										z = 0,
									},
									scale_function = function (hub_up_look_offset)
										return hub_up_look_offset
									end,
								},
								{
									_node = {
										class = "ScalableTransformCamera",
										name = "hub_down_back_look_offset",
										scale_variable = "hub_down_back_look_offset",
										offset_position = {
											x = 0,
											y = 0.4,
											z = -0.1,
										},
										scale_function = function (hub_down_back_look_offset)
											return hub_down_back_look_offset
										end,
									},
									{
										_node = {
											class = "ScalableTransformCamera",
											name = "hub_up_back_look_offset",
											scale_variable = "hub_up_back_look_offset",
											offset_position = {
												x = 0,
												y = 0.6,
												z = 0.2,
											},
											scale_function = function (hub_up_back_look_offset)
												return math.max(hub_up_back_look_offset, 0)
											end,
										},
										{
											_node = {
												class = "ScalableTransformCamera",
												name = "hub_up_forward_look_offset",
												scale_variable = "hub_up_forward_look_offset",
												offset_position = {
													x = 0,
													y = 0,
													z = 0,
												},
												scale_function = function (hub_up_forward_look_offset)
													return math.max(hub_up_forward_look_offset, 0)
												end,
											},
											{
												_node = {
													class = "TransformCamera",
													name = "third_person_human",
													offset_position = {
														x = 0,
														y = -2.5,
														z = -0.3,
													},
												},
											},
										},
									},
								},
							},
						},
					},
				},
				{
					_node = {
						class = "ScalableTransformCamera",
						name = "hub_idle_offset",
						scale_variable = "hub_idle_offset",
						offset_position = {
							x = 0.95,
							y = 0.5,
							z = -0.1,
						},
						scale_function = function (hub_idle_offset)
							return hub_idle_offset
						end,
					},
					{
						_node = {
							class = "ScalableTransformCamera",
							name = "hub_speed_zoom",
							scale_variable = "hub_speed_zoom",
							offset_position = {
								x = 0,
								y = -0.8,
								z = -0.1,
							},
							scale_function = function (hub_speed_zoom)
								return hub_speed_zoom
							end,
						},
						{
							_node = {
								class = "ScalableTransformCamera",
								name = "hub_back_look_offset",
								scale_variable = "hub_back_look_offset",
								offset_position = {
									x = -0.6,
									y = -0.4,
									z = -0,
								},
								scale_function = function (hub_back_look_offset)
									return hub_back_look_offset
								end,
							},
							{
								_node = {
									class = "ScalableTransformCamera",
									name = "hub_up_look_offset",
									scale_variable = "hub_up_look_offset",
									offset_position = {
										x = 0,
										y = -0.5,
										z = -0.1,
									},
									scale_function = function (hub_up_look_offset)
										return hub_up_look_offset
									end,
								},
								{
									_node = {
										class = "ScalableTransformCamera",
										name = "hub_down_back_look_offset",
										scale_variable = "hub_down_back_look_offset",
										offset_position = {
											x = 0,
											y = 0.8,
											z = 0.7,
										},
										scale_function = function (hub_down_back_look_offset)
											return hub_down_back_look_offset
										end,
									},
									{
										_node = {
											class = "ScalableTransformCamera",
											name = "hub_up_back_look_offset",
											scale_variable = "hub_up_back_look_offset",
											offset_position = {
												x = 0,
												y = 1.4,
												z = 0.8,
											},
											scale_function = function (hub_up_back_look_offset)
												return hub_up_back_look_offset
											end,
										},
										{
											_node = {
												class = "ScalableTransformCamera",
												name = "hub_up_forward_look_offset",
												scale_variable = "hub_up_forward_look_offset",
												offset_position = {
													x = 0.2,
													y = -0.2,
													z = 0.5,
												},
												scale_function = function (hub_up_forward_look_offset)
													return math.max(hub_up_forward_look_offset, 0)
												end,
											},
											{
												_node = {
													class = "TransformCamera",
													name = "third_person_ogryn",
													offset_position = {
														x = 0,
														y = -2.5,
														z = -0.4,
													},
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	},
}
CameraSettings.player_first_person = {
	_node = {
		class = "RootCamera",
		custom_vertical_fov = 55,
		disable_collision = true,
		far_range = 1000,
		name = "root_node",
		near_range = 0.08,
		should_apply_fov_multiplier = true,
		vertical_fov = 65,
		tree_transitions = {
			world = CameraTransitionTemplates.instant_cut,
			third_person = CameraTransitionTemplates.to_third_person,
			pounced = CameraTransitionTemplates.to_third_person,
			consumed = CameraTransitionTemplates.to_consumed,
			grabbed = CameraTransitionTemplates.to_grabbed,
			dead = CameraTransitionTemplates.dead,
		},
		node_transitions = {
			default = CameraTransitionTemplates.zoom,
		},
	},
	{
		_node = {
			class = "ScalableZAxisCamera",
			name = "up_translation",
			scale_variable = "character_height",
			z_offset = 1,
			scale_function = function (height)
				return height
			end,
		},
		{
			_node = {
				class = "AimCamera",
				name = "first_person_aim",
				offset_position = {
					x = 0,
					y = 0,
					z = 0,
				},
			},
			{
				_node = {
					animation_object = "ap_camera_node",
					class = "FirstPersonAnimationCamera",
					name = "first_person_assisted",
					offset_position = {
						x = 0,
						y = 0,
						z = 0,
					},
					node_transitions = {
						first_person = CameraTransitionTemplates.instant_cut,
					},
				},
			},
			{
				_node = {
					animation_object = "ap_camera_node",
					class = "FirstPersonAnimationCamera",
					name = "first_person",
					offset_position = {
						x = 0,
						y = 0,
						z = 0,
					},
					node_transitions = {
						sprint = CameraTransitionTemplates.to_sprint,
						lunge = CameraTransitionTemplates.to_lunge,
						default = CameraTransitionTemplates.zoom,
						grabbed = CameraTransitionTemplates.to_grabbed,
					},
					tree_transitions = {
						third_person = CameraTransitionTemplates.to_third_person,
					},
				},
				{
					_node = {
						class = "AimDownSightCamera",
						custom_vertical_fov_variable = "zoom_custom_vertical_fov",
						default_custom_vertical_fov = 55,
						default_near_range = 0.025,
						default_vertical_fov = 65,
						name = "aim_down_sight",
						near_range_variable = "zoom_near_range",
						vertical_fov_variable = "zoom_vertical_fov",
						offset_position = {
							x = 0,
							y = 0,
							z = 0,
						},
						node_transitions = {
							default = CameraTransitionTemplates.zoom,
						},
					},
				},
				{
					_node = {
						class = "TransformCamera",
						name = "sprint",
						vertical_fov = 75,
						offset_position = {
							x = 0,
							y = 0,
							z = -0,
						},
						node_transitions = {
							first_person = CameraTransitionTemplates.from_sprint,
							aim_down_sight = CameraTransitionTemplates.from_sprint,
							sprint_overtime = CameraTransitionTemplates.from_sprint,
						},
					},
				},
				{
					_node = {
						class = "TransformCamera",
						name = "sprint_overtime",
						vertical_fov = 70,
						offset_position = {
							x = 0,
							y = 0,
							z = -0,
						},
						node_transitions = {
							first_person = CameraTransitionTemplates.from_sprint,
							aim_down_sight = CameraTransitionTemplates.from_sprint,
							sprint = CameraTransitionTemplates.from_sprint,
						},
					},
				},
				{
					_node = {
						class = "TransformCamera",
						name = "lunge",
						vertical_fov = 75,
						offset_position = {
							x = 0,
							y = 0.08,
							z = 0,
						},
						node_transitions = {
							default = CameraTransitionTemplates.from_lunge,
						},
					},
				},
				{
					_node = {
						class = "ScanningCamera",
						name = "scanning",
						offset_position = {
							x = 0,
							y = 0.08,
							z = 0,
						},
						angle_tolerance = math.pi / 10,
						node_transitions = {
							default = CameraTransitionTemplates.from_scanning,
						},
					},
				},
			},
		},
	},
}
CameraSettings.player_dead = {
	_node = {
		class = "RootCamera",
		far_range = 800,
		name = "root_node",
		near_range = 0.08,
		root_object_name = "j_camera_attach",
		vertical_fov = 65,
		tree_transitions = {},
		node_transitions = {
			default = CameraTransitionTemplates.dead,
		},
		safe_position_offset = Vector3Box(0, 0, 1.65),
	},
	{
		_node = {
			class = "AimCamera",
			ignore_aim_pitch = true,
			name = "dead_aim",
			offset_pitch = -35,
		},
		{
			_node = {
				class = "TransformCamera",
				name = "up_translation",
				offset_position = {
					x = 0,
					y = 0,
					z = 0.25,
				},
			},
			{
				_node = {
					class = "TransformCamera",
					name = "back_translation",
					offset_position = {
						x = 0,
						y = -2.75,
						z = 0,
					},
				},
				{
					_node = {
						class = "TransformCamera",
						name = "dead",
						offset_position = {
							x = 0,
							y = 0,
							z = 0,
						},
					},
				},
			},
		},
	},
}

return settings("CameraSettings", CameraSettings)
