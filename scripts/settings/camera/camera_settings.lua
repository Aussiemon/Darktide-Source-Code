-- chunkname: @scripts/settings/camera/camera_settings.lua

local CameraTransitionTemplates = require("scripts/settings/camera/camera_transition_templates")

CameraSettings = CameraSettings or {}
CameraSettings.world = {
	_node = {
		far_range = 800,
		name = "root_node",
		class = "RootCamera",
		near_range = 0.08,
		vertical_fov = 65,
		tree_transitions = {
			default = CameraTransitionTemplates.instant_cut
		},
		node_transitions = {},
		safe_position_offset = Vector3Box(0, 0, 0)
	},
	{
		_node = {
			name = "up_translation",
			class = "TransformCamera",
			offset_position = {
				z = 10,
				x = 0,
				y = 0
			}
		},
		{
			_node = {
				offset_pitch = -90,
				name = "world",
				class = "RotationCamera"
			}
		}
	}
}
CameraSettings.cinematic = {
	_node = {
		near_range = 0.08,
		name = "story_slave",
		far_range = 1000,
		disable_collision = true,
		class = "CinematicLinkCamera",
		vertical_fov = 45,
		tree_transitions = {
			default = CameraTransitionTemplates.instant_cut
		},
		node_transitions = {},
		safe_position_offset = Vector3Box(0, 0, 0)
	}
}
CameraSettings.cinematic_gameplay = {
	_node = {
		near_range = 0.08,
		name = "story_slave",
		far_range = 1000,
		disable_collision = true,
		class = "CinematicLinkCamera",
		vertical_fov = 45,
		tree_transitions = {
			default = CameraTransitionTemplates.instant_cut,
			first_person = CameraTransitionTemplates.to_first_person,
			third_person = CameraTransitionTemplates.to_third_person,
			third_person_hub = CameraTransitionTemplates.to_third_person
		},
		node_transitions = {},
		safe_position_offset = Vector3Box(0, 0, 0)
	}
}
CameraSettings.testify_camera = {
	_node = {
		near_range = 0.08,
		name = "testify",
		far_range = 1000,
		disable_collision = true,
		class = "TestifyCamera",
		vertical_fov = 65,
		tree_transitions = {
			default = CameraTransitionTemplates.instant_cut
		},
		node_transitions = {},
		safe_position_offset = Vector3Box(0, 0, 0)
	}
}
CameraSettings.player_third_person = {
	_node = {
		far_range = 800,
		name = "root_node",
		near_range = 0.08,
		class = "RootCamera",
		vertical_fov = 65,
		root_object_name = "j_camera_attach",
		tree_transitions = {
			world = CameraTransitionTemplates.instant_cut,
			first_person = CameraTransitionTemplates.to_first_person,
			grabbed = CameraTransitionTemplates.to_grabbed,
			dead = CameraTransitionTemplates.dead
		},
		node_transitions = {
			default = CameraTransitionTemplates.to_third_person,
			grabbed = CameraTransitionTemplates.to_grabbed
		},
		safe_position_offset = Vector3Box(0, 0, 1.65)
	},
	{
		_node = {
			name = "up_translation",
			class = "ScalableTransformCamera",
			scale_variable = "character_height",
			offset_position = {
				z = 1,
				x = 0,
				y = 0
			},
			scale_function = function (height)
				return height * 1.1
			end
		},
		{
			_node = {
				class = "AimCamera",
				name = "third_person_aim"
			},
			{
				_node = {
					should_apply_fov_multiplier = true,
					name = "third_person",
					class = "TransformCamera",
					custom_vertical_fov = 65,
					vertical_fov = 65,
					offset_position = {
						z = 0,
						x = 0,
						y = -2
					}
				},
				{
					_node = {
						near_range = 0.025,
						name = "pounced",
						class = "TransformCamera",
						custom_vertical_fov = 65,
						vertical_fov = 65,
						offset_position = {
							z = -1,
							x = 0,
							y = -2
						}
					}
				},
				{
					_node = {
						near_range = 0.025,
						name = "consumed",
						class = "TransformCamera",
						custom_vertical_fov = 65,
						vertical_fov = 65,
						offset_position = {
							z = 0,
							x = 0,
							y = -4
						}
					}
				},
				{
					_node = {
						near_range = 0.025,
						name = "grabbed",
						class = "TransformCamera",
						custom_vertical_fov = 65,
						vertical_fov = 65,
						offset_position = {
							z = -0.1,
							x = 0,
							y = -1.97
						}
					}
				},
				{
					_node = {
						near_range = 0.025,
						name = "disabled",
						class = "TransformCamera",
						offset_position = {
							z = -0.5,
							x = 0,
							y = -2
						}
					}
				},
				{
					_node = {
						near_range = 0.025,
						name = "hogtied",
						class = "TransformCamera",
						offset_position = {
							z = -0.5,
							x = 0,
							y = -2
						},
						tree_transitions = {
							first_person = CameraTransitionTemplates.instant_cut
						}
					}
				},
				{
					_node = {
						near_range = 0.025,
						name = "ledge_hanging",
						class = "TransformCamera",
						custom_vertical_fov = 65,
						vertical_fov = 65,
						offset_position = {
							z = -1,
							x = 0,
							y = -2
						}
					}
				}
			}
		}
	}
}
CameraSettings.player_third_person_hub = {
	_node = {
		far_range = 800,
		name = "root_node",
		near_range = 0.08,
		class = "RootCamera",
		vertical_fov = 55,
		root_object_name = "j_camera_attach",
		tree_transitions = {
			world = CameraTransitionTemplates.instant_cut,
			first_person = CameraTransitionTemplates.to_first_person
		},
		node_transitions = {
			default = CameraTransitionTemplates.to_third_person
		},
		safe_position_offset = Vector3Box(0, 0, 1.65)
	},
	{
		_node = {
			name = "up_translation",
			class = "ScalableTransformCamera",
			scale_variable = "character_height",
			offset_position = {
				z = 1,
				x = 0,
				y = 0
			},
			scale_function = function (height)
				return height * 1.1
			end
		},
		{
			_node = {
				halflife = 0.05,
				name = "dampened_string_transform",
				class = "DampenedStringTransformCamera"
			},
			{
				_node = {
					class = "AimCamera",
					name = "third_person_aim"
				},
				{
					_node = {
						name = "hub_idle_offset",
						class = "ScalableTransformCamera",
						scale_variable = "hub_idle_offset",
						offset_position = {
							x = 0.5,
							y = 1,
							z = -0
						},
						scale_function = function (hub_idle_offset)
							return hub_idle_offset
						end
					},
					{
						_node = {
							name = "hub_speed_zoom",
							class = "ScalableTransformCamera",
							scale_variable = "hub_speed_zoom",
							offset_position = {
								z = 0,
								x = 0,
								y = -0.6
							},
							scale_function = function (hub_speed_zoom)
								return hub_speed_zoom
							end
						},
						{
							_node = {
								name = "hub_back_look_offset",
								class = "ScalableTransformCamera",
								scale_variable = "hub_back_look_offset",
								offset_position = {
									z = -0.1,
									x = -0.25,
									y = -0.2
								},
								scale_function = function (hub_back_look_offset)
									return hub_back_look_offset
								end
							},
							{
								_node = {
									name = "hub_up_look_offset",
									class = "ScalableTransformCamera",
									scale_variable = "hub_up_look_offset",
									offset_position = {
										z = 0,
										x = 0,
										y = 0
									},
									scale_function = function (hub_up_look_offset)
										return hub_up_look_offset
									end
								},
								{
									_node = {
										name = "hub_down_back_look_offset",
										class = "ScalableTransformCamera",
										scale_variable = "hub_down_back_look_offset",
										offset_position = {
											z = -0.1,
											x = 0,
											y = 0.4
										},
										scale_function = function (hub_down_back_look_offset)
											return hub_down_back_look_offset
										end
									},
									{
										_node = {
											name = "hub_up_back_look_offset",
											class = "ScalableTransformCamera",
											scale_variable = "hub_up_back_look_offset",
											offset_position = {
												z = 0.2,
												x = 0,
												y = 0.6
											},
											scale_function = function (hub_up_back_look_offset)
												return math.max(hub_up_back_look_offset, 0)
											end
										},
										{
											_node = {
												name = "hub_up_forward_look_offset",
												class = "ScalableTransformCamera",
												scale_variable = "hub_up_forward_look_offset",
												offset_position = {
													z = 0,
													x = 0,
													y = 0
												},
												scale_function = function (hub_up_forward_look_offset)
													return math.max(hub_up_forward_look_offset, 0)
												end
											},
											{
												_node = {
													name = "third_person_human",
													class = "TransformCamera",
													offset_position = {
														z = -0.3,
														x = 0,
														y = -2.5
													}
												}
											}
										}
									}
								}
							}
						}
					}
				},
				{
					_node = {
						name = "hub_idle_offset",
						class = "ScalableTransformCamera",
						scale_variable = "hub_idle_offset",
						offset_position = {
							z = -0.1,
							x = 0.95,
							y = 0.5
						},
						scale_function = function (hub_idle_offset)
							return hub_idle_offset
						end
					},
					{
						_node = {
							name = "hub_speed_zoom",
							class = "ScalableTransformCamera",
							scale_variable = "hub_speed_zoom",
							offset_position = {
								z = -0.1,
								x = 0,
								y = -0.8
							},
							scale_function = function (hub_speed_zoom)
								return hub_speed_zoom
							end
						},
						{
							_node = {
								name = "hub_back_look_offset",
								class = "ScalableTransformCamera",
								scale_variable = "hub_back_look_offset",
								offset_position = {
									x = -0.6,
									y = -0.4,
									z = -0
								},
								scale_function = function (hub_back_look_offset)
									return hub_back_look_offset
								end
							},
							{
								_node = {
									name = "hub_up_look_offset",
									class = "ScalableTransformCamera",
									scale_variable = "hub_up_look_offset",
									offset_position = {
										z = -0.1,
										x = 0,
										y = -0.5
									},
									scale_function = function (hub_up_look_offset)
										return hub_up_look_offset
									end
								},
								{
									_node = {
										name = "hub_down_back_look_offset",
										class = "ScalableTransformCamera",
										scale_variable = "hub_down_back_look_offset",
										offset_position = {
											z = 0.7,
											x = 0,
											y = 0.8
										},
										scale_function = function (hub_down_back_look_offset)
											return hub_down_back_look_offset
										end
									},
									{
										_node = {
											name = "hub_up_back_look_offset",
											class = "ScalableTransformCamera",
											scale_variable = "hub_up_back_look_offset",
											offset_position = {
												z = 0.8,
												x = 0,
												y = 1.4
											},
											scale_function = function (hub_up_back_look_offset)
												return hub_up_back_look_offset
											end
										},
										{
											_node = {
												name = "hub_up_forward_look_offset",
												class = "ScalableTransformCamera",
												scale_variable = "hub_up_forward_look_offset",
												offset_position = {
													z = 0.5,
													x = 0.2,
													y = -0.2
												},
												scale_function = function (hub_up_forward_look_offset)
													return math.max(hub_up_forward_look_offset, 0)
												end
											},
											{
												_node = {
													name = "third_person_ogryn",
													class = "TransformCamera",
													offset_position = {
														z = -0.4,
														x = 0,
														y = -2.5
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
CameraSettings.player_first_person = {
	_node = {
		near_range = 0.08,
		name = "root_node",
		far_range = 1000,
		disable_collision = true,
		custom_vertical_fov = 55,
		should_apply_fov_multiplier = true,
		class = "RootCamera",
		vertical_fov = 65,
		tree_transitions = {
			world = CameraTransitionTemplates.instant_cut,
			third_person = CameraTransitionTemplates.to_third_person,
			pounced = CameraTransitionTemplates.to_third_person,
			consumed = CameraTransitionTemplates.to_consumed,
			grabbed = CameraTransitionTemplates.to_grabbed,
			dead = CameraTransitionTemplates.dead
		},
		node_transitions = {
			default = CameraTransitionTemplates.zoom
		}
	},
	{
		_node = {
			name = "up_translation",
			class = "ScalableZAxisCamera",
			z_offset = 1,
			scale_variable = "character_height",
			scale_function = function (height)
				return height
			end
		},
		{
			_node = {
				name = "first_person_aim",
				class = "AimCamera",
				offset_position = {
					z = 0,
					x = 0,
					y = 0
				}
			},
			{
				_node = {
					name = "first_person_assisted",
					class = "FirstPersonAnimationCamera",
					animation_object = "ap_camera_node",
					offset_position = {
						z = 0,
						x = 0,
						y = 0
					},
					node_transitions = {
						first_person = CameraTransitionTemplates.instant_cut
					}
				}
			},
			{
				_node = {
					name = "first_person",
					class = "FirstPersonAnimationCamera",
					animation_object = "ap_camera_node",
					offset_position = {
						z = 0,
						x = 0,
						y = 0
					},
					node_transitions = {
						sprint = CameraTransitionTemplates.to_sprint,
						lunge = CameraTransitionTemplates.to_lunge,
						default = CameraTransitionTemplates.zoom,
						grabbed = CameraTransitionTemplates.to_grabbed
					},
					tree_transitions = {
						third_person = CameraTransitionTemplates.to_third_person
					}
				},
				{
					_node = {
						default_custom_vertical_fov = 55,
						name = "aim_down_sight",
						default_near_range = 0.025,
						default_vertical_fov = 65,
						class = "AimDownSightCamera",
						vertical_fov_variable = "zoom_vertical_fov",
						custom_vertical_fov_variable = "zoom_custom_vertical_fov",
						near_range_variable = "zoom_near_range",
						offset_position = {
							z = 0,
							x = 0,
							y = 0
						},
						node_transitions = {
							default = CameraTransitionTemplates.zoom
						}
					}
				},
				{
					_node = {
						name = "sprint",
						class = "TransformCamera",
						vertical_fov = 75,
						offset_position = {
							x = 0,
							y = 0,
							z = -0
						},
						node_transitions = {
							first_person = CameraTransitionTemplates.from_sprint,
							aim_down_sight = CameraTransitionTemplates.from_sprint,
							sprint_overtime = CameraTransitionTemplates.from_sprint
						}
					}
				},
				{
					_node = {
						name = "sprint_overtime",
						class = "TransformCamera",
						vertical_fov = 70,
						offset_position = {
							x = 0,
							y = 0,
							z = -0
						},
						node_transitions = {
							first_person = CameraTransitionTemplates.from_sprint,
							aim_down_sight = CameraTransitionTemplates.from_sprint,
							sprint = CameraTransitionTemplates.from_sprint
						}
					}
				},
				{
					_node = {
						name = "lunge",
						class = "TransformCamera",
						vertical_fov = 75,
						offset_position = {
							z = 0,
							x = 0,
							y = 0.08
						},
						node_transitions = {
							default = CameraTransitionTemplates.from_lunge
						}
					}
				},
				{
					_node = {
						class = "ScanningCamera",
						name = "scanning",
						offset_position = {
							z = 0,
							x = 0,
							y = 0.08
						},
						angle_tolerance = math.pi / 10,
						node_transitions = {
							default = CameraTransitionTemplates.from_scanning
						}
					}
				}
			}
		}
	}
}
CameraSettings.player_dead = {
	_node = {
		far_range = 800,
		name = "root_node",
		near_range = 0.08,
		class = "RootCamera",
		vertical_fov = 65,
		root_object_name = "j_camera_attach",
		tree_transitions = {},
		node_transitions = {
			default = CameraTransitionTemplates.dead
		},
		safe_position_offset = Vector3Box(0, 0, 1.65)
	},
	{
		_node = {
			offset_pitch = -35,
			name = "dead_aim",
			class = "AimCamera",
			ignore_aim_pitch = true
		},
		{
			_node = {
				name = "up_translation",
				class = "TransformCamera",
				offset_position = {
					z = 0.25,
					x = 0,
					y = 0
				}
			},
			{
				_node = {
					name = "back_translation",
					class = "TransformCamera",
					offset_position = {
						z = 0,
						x = 0,
						y = -2.75
					}
				},
				{
					_node = {
						name = "dead",
						class = "TransformCamera",
						offset_position = {
							z = 0,
							x = 0,
							y = 0
						}
					}
				}
			}
		}
	}
}

return settings("CameraSettings", CameraSettings)
