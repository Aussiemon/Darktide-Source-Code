local AttackSettings = require("scripts/settings/damage/attack_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local WoundsSettings = require("scripts/settings/wounds/wounds_settings")
local shapes = WoundsSettings.shapes
local hit_zone_names = HitZone.hit_zone_names
local attack_results = AttackSettings.attack_results
local wounds_templates = {
	lasgun = {
		[attack_results.damaged] = {
			default = {
				default_shape = shapes.lasgun,
				[shapes.lasgun] = {
					shape_scaling = false,
					duration = 2.5,
					radius = {
						4,
						5
					},
					color_brightness = {
						1,
						0.09
					}
				}
			}
		}
	}
}
wounds_templates.lasgun[attack_results.died] = table.clone(wounds_templates.lasgun[attack_results.damaged])
wounds_templates.lasgun[attack_results.died].default[shapes.lasgun].radius = {
	6,
	8
}
wounds_templates.lasgun[attack_results.died].default[shapes.lasgun].duration = {
	3.5,
	4
}
wounds_templates.autogun = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.lasgun,
			[shapes.lasgun] = {
				shape_scaling = false,
				duration = 0.75,
				radius = {
					2.5,
					3.25
				},
				color_brightness = {
					0.045,
					0.25
				}
			}
		}
	}
}
wounds_templates.autogun[attack_results.died] = table.clone(wounds_templates.autogun[attack_results.damaged])
wounds_templates.autogun[attack_results.died].default[shapes.lasgun].radius = {
	1.75,
	2.25
}
wounds_templates.autogun[attack_results.died].default[shapes.lasgun].duration = {
	0.8,
	0
}
wounds_templates.stubgun = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.lasgun,
			[shapes.lasgun] = {
				shape_scaling = false,
				duration = 0.25,
				radius = {
					1.9,
					2.25
				},
				color_brightness = {
					0.03,
					0.12
				}
			}
		}
	}
}
wounds_templates.stubgun[attack_results.died] = table.clone(wounds_templates.stubgun[attack_results.damaged])
wounds_templates.stubgun[attack_results.died].default[shapes.lasgun].radius = {
	1.9,
	2.25
}
wounds_templates.stubgun[attack_results.died].default[shapes.lasgun].duration = {
	0.3,
	0.4
}
wounds_templates.plasma_rifle = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				duration = 2,
				radius = {
					5,
					6.5
				},
				color_brightness = {
					0.6,
					0.8
				}
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = true,
				duration = 2,
				radius = {
					5,
					6.5
				},
				color_brightness = {
					0.6,
					0.8
				}
			}
		}
	}
}
wounds_templates.plasma_rifle_small = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				duration = 2,
				radius = {
					3,
					3.75
				},
				color_brightness = {
					0.6,
					0.8
				}
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = true,
				duration = 2,
				radius = {
					3,
					3.75
				},
				color_brightness = {
					0.6,
					0.8
				}
			}
		}
	}
}
wounds_templates.psyker_ball = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.sphere,
			[shapes.sphere] = {
				duration = 6,
				radius = {
					5,
					6
				},
				color_brightness = {
					0.5,
					0.7
				}
			}
		}
	}
}
wounds_templates.psyker_ball[attack_results.died] = table.clone(wounds_templates.psyker_ball[attack_results.damaged])
wounds_templates.chainsword = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					1.5,
					1.75
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.left_45_slash_coarse] = {
				radius = {
					2.5,
					3
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.right_45_slash_coarse] = {
				radius = {
					2.5,
					3
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.horizontal_slash_coarse] = {
				radius = {
					2.5,
					3
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.vertical_slash_coarse] = {
				radius = {
					2.5,
					3
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					2.5,
					3
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.left_45_slash_coarse] = {
				radius = {
					3.5,
					4
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.right_45_slash_coarse] = {
				radius = {
					3.5,
					4
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.horizontal_slash_coarse] = {
				radius = {
					3.5,
					4
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.vertical_slash_coarse] = {
				radius = {
					3.5,
					4
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			}
		}
	}
}
wounds_templates.chainsword_sawing = {
	[attack_results.damaged] = {
		head = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					2,
					2
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.left_45_slash_coarse] = {
				radius = {
					2,
					2
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.right_45_slash_coarse] = {
				radius = {
					2,
					2
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.horizontal_slash_coarse] = {
				radius = {
					2,
					2
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.vertical_slash_coarse] = {
				radius = {
					2,
					2
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			}
		},
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					7,
					8
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.left_45_slash_coarse] = {
				radius = {
					7,
					8
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.right_45_slash_coarse] = {
				radius = {
					7,
					8
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.horizontal_slash_coarse] = {
				radius = {
					7,
					8
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.vertical_slash_coarse] = {
				radius = {
					7,
					8
				},
				color_brightness = {
					0.04,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			}
		}
	}
}
wounds_templates.chainsword_sawing[attack_results.died] = table.clone(wounds_templates.chainsword_sawing[attack_results.damaged])
wounds_templates.chainsword_sawing[attack_results.died].head = {
	default_shape = shapes.default,
	[shapes.default] = {
		radius = {
			2,
			2.5
		},
		color_brightness = {
			0.04,
			0.01
		},
		duration = {
			0.1,
			0.2
		}
	},
	[shapes.left_45_slash_coarse] = {
		radius = {
			5,
			5
		},
		color_brightness = {
			0.04,
			0.01
		},
		duration = {
			0.3,
			0.5
		}
	},
	[shapes.right_45_slash_coarse] = {
		shape_scaling = true,
		radius = {
			5,
			5
		},
		color_brightness = {
			0.04,
			0.01
		},
		duration = {
			0.3,
			0.5
		}
	},
	[shapes.horizontal_slash_coarse] = {
		shape_scaling = true,
		radius = {
			5,
			5
		},
		color_brightness = {
			0.04,
			0.01
		},
		duration = {
			0.3,
			0.5
		}
	},
	[shapes.vertical_slash_coarse] = {
		shape_scaling = true,
		radius = {
			5,
			5
		},
		color_brightness = {
			0.04,
			0.01
		},
		duration = {
			0.3,
			0.5
		}
	}
}
wounds_templates.blunt = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					1.5,
					1.75
				},
				color_brightness = {
					0.02,
					0.05
				},
				duration = {
					0.25,
					0.3
				}
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					1.75,
					2.25
				},
				color_brightness = {
					0.02,
					0.05
				},
				duration = {
					0.25,
					0.3
				}
			}
		}
	}
}
wounds_templates.thunder_hammer = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = false,
				radius = {
					1.75,
					2
				},
				color_brightness = {
					0.05,
					1
				},
				duration = {
					0.175,
					0.2
				}
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = true,
				radius = {
					2.5,
					3.25
				},
				color_brightness = {
					0.05,
					1
				},
				duration = {
					0.175,
					0.2
				}
			}
		}
	}
}
wounds_templates.thunder_hammer_active = table.clone(wounds_templates.thunder_hammer)
wounds_templates.thunder_hammer_active[attack_results.damaged].default[shapes.default].radius = {
	4,
	5
}
wounds_templates.thunder_hammer_active[attack_results.damaged].default[shapes.default].shape_scaling = true
wounds_templates.thunder_hammer_active[attack_results.damaged].default[shapes.default].color_brightness = {
	0.5,
	1
}
wounds_templates.thunder_hammer_active[attack_results.damaged].default[shapes.default].duration = {
	0.35,
	0.4
}
wounds_templates.thunder_hammer_active[attack_results.died] = table.clone(wounds_templates.thunder_hammer_active[attack_results.damaged])
wounds_templates.power_sword = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					4.55,
					5.25
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.left_45_slash_clean] = {
				radius = {
					4,
					5.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.right_45_slash_clean] = {
				radius = {
					4,
					5.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.horizontal_slash_clean] = {
				radius = {
					4,
					5.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.vertical_slash_clean] = {
				radius = {
					4,
					5.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			}
		}
	}
}
wounds_templates.power_sword[attack_results.died] = table.clone(wounds_templates.power_sword[attack_results.damaged])
wounds_templates.power_sword_active = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					4.55,
					5.25
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.2,
					0.3
				}
			},
			[shapes.left_45_slash] = {
				radius = {
					5,
					5.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.right_45_slash] = {
				radius = {
					5,
					5.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.horizontal_slash] = {
				radius = {
					5,
					5.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.vertical_slash] = {
				radius = {
					5,
					5.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			}
		}
	}
}
wounds_templates.power_sword_active[attack_results.died] = table.clone(wounds_templates.power_sword_active[attack_results.damaged])
wounds_templates.force_sword = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					4.55,
					5.25
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.2,
					0.3
				}
			},
			[shapes.left_45_slash_clean] = {
				radius = {
					5,
					5.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.right_45_slash_clean] = {
				radius = {
					5,
					5.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.horizontal_slash_clean] = {
				radius = {
					5,
					5.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.vertical_slash_clean] = {
				radius = {
					5,
					5.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			}
		}
	}
}
wounds_templates.force_sword[attack_results.died] = table.clone(wounds_templates.force_sword[attack_results.damaged])
wounds_templates.force_sword_active = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					1.75,
					2
				},
				color_brightness = {
					0.6,
					0.9
				},
				duration = {
					0.3,
					0.4
				}
			},
			[shapes.left_45_slash] = {
				radius = {
					6,
					7.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.right_45_slash] = {
				radius = {
					6,
					7.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.horizontal_slash] = {
				radius = {
					6,
					7.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.vertical_slash] = {
				radius = {
					6,
					7.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = true,
				radius = {
					5,
					6
				},
				color_brightness = {
					0.6,
					0.9
				},
				duration = {
					0.3,
					0.4
				}
			},
			[shapes.left_45_slash] = {
				radius = {
					6,
					7.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.right_45_slash] = {
				radius = {
					6,
					7.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.horizontal_slash] = {
				radius = {
					6,
					7.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			},
			[shapes.vertical_slash] = {
				radius = {
					6,
					7.5
				},
				color_brightness = {
					0.6,
					0.7
				},
				duration = {
					0.5,
					0.6
				}
			}
		}
	}
}
wounds_templates.combat_sword = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				shape_scaling = true,
				radius = {
					2.5,
					2.75
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.left_45_slash] = {
				shape_scaling = true,
				radius = {
					2.5,
					2.75
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.right_45_slash] = {
				shape_scaling = true,
				radius = {
					2.5,
					2.75
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.horizontal_slash] = {
				shape_scaling = true,
				radius = {
					2.5,
					2.75
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.vertical_slash] = {
				shape_scaling = true,
				radius = {
					2.5,
					2.75
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					4.55,
					5.25
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.left_45_slash] = {
				radius = {
					4,
					5.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.right_45_slash] = {
				radius = {
					4,
					5.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.horizontal_slash] = {
				radius = {
					4,
					5.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.vertical_slash] = {
				radius = {
					4,
					5.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			}
		}
	}
}
wounds_templates.combat_axe = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					2.75,
					3.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.1,
					0.2
				}
			},
			[shapes.left_45_slash] = {
				radius = {
					2.75,
					3.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.right_45_slash] = {
				radius = {
					2.75,
					3.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.horizontal_slash] = {
				radius = {
					2.75,
					3.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.vertical_slash] = {
				radius = {
					2.75,
					3.5
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			}
		}
	}
}
wounds_templates.combat_axe[attack_results.died] = table.clone(wounds_templates.combat_axe[attack_results.damaged])
wounds_templates.combat_blade = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.default,
			[shapes.default] = {
				radius = {
					6,
					7
				},
				color_brightness = {
					0.08,
					0.15
				},
				duration = {
					0.3,
					0.6
				}
			},
			[shapes.left_45_slash] = {
				radius = {
					3,
					4
				},
				color_brightness = {
					0.08,
					0.15
				},
				duration = {
					0.3,
					0.6
				}
			},
			[shapes.right_45_slash] = {
				radius = {
					3,
					4
				},
				color_brightness = {
					0.08,
					0.15
				},
				duration = {
					0.3,
					0.6
				}
			},
			[shapes.horizontal_slash] = {
				radius = {
					5,
					6
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			},
			[shapes.vertical_slash] = {
				radius = {
					5,
					6
				},
				color_brightness = {
					0.6,
					0.01
				},
				duration = {
					0.3,
					0.5
				}
			}
		}
	}
}
wounds_templates.combat_blade[attack_results.died] = table.clone(wounds_templates.combat_blade[attack_results.damaged])
wounds_templates.rippergun = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.shotgun,
			[shapes.shotgun] = {
				shape_scaling = true,
				duration = 0.3,
				radius = {
					3,
					3.5
				},
				color_brightness = {
					0.03,
					0.7
				}
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.shotgun,
			[shapes.shotgun] = {
				shape_scaling = true,
				duration = 0.3,
				radius = {
					6,
					7
				},
				color_brightness = {
					0.03,
					0.7
				}
			}
		}
	}
}
wounds_templates.shotgun = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.shotgun,
			[shapes.shotgun] = {
				shape_scaling = true,
				duration = 0.5,
				radius = {
					3,
					3.25
				},
				color_brightness = {
					0.02,
					0.09
				}
			}
		}
	}
}
wounds_templates.shotgun[attack_results.died] = table.clone(wounds_templates.shotgun[attack_results.damaged])
wounds_templates.shotgun[attack_results.died].default[shapes.shotgun].radius = {
	3.5,
	4
}
wounds_templates.bolter = {
	[attack_results.damaged] = {
		default = {
			default_shape = shapes.sphere,
			[shapes.sphere] = {
				shape_scaling = true,
				duration = 1.5,
				radius = {
					1,
					2
				},
				color_brightness = {
					0.02,
					0.09
				}
			}
		}
	},
	[attack_results.died] = {
		default = {
			default_shape = shapes.sphere,
			[shapes.sphere] = {
				shape_scaling = true,
				duration = 1.5,
				radius = {
					2,
					4
				},
				color_brightness = {
					0.02,
					0.09
				}
			}
		}
	}
}

for template_name, template in pairs(wounds_templates) do
	template.name = template_name
end

return settings("WoundsTemplates", wounds_templates)
