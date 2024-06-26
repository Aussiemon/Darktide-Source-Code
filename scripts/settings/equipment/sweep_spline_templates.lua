﻿-- chunkname: @scripts/settings/equipment/sweep_spline_templates.lua

local templates = {}

templates.horizontal_left = {
	points = {
		{
			0.6,
			0.5,
			0,
		},
		{
			0.45,
			0.76,
			0,
		},
		{
			0,
			1.06,
			0,
		},
		{
			-0.45,
			0.76,
			0,
		},
		{
			-0.6,
			0.5,
			0,
		},
	},
}
templates.horizontal_right = {
	points = {
		{
			-0.6,
			0.5,
			0,
		},
		{
			-0.45,
			0.76,
			0,
		},
		{
			0,
			1.06,
			0,
		},
		{
			0.45,
			0.76,
			0,
		},
		{
			0.6,
			0.5,
			0,
		},
	},
}
templates.diagonal_left = {
	points = {
		{
			0.47,
			0.77,
			0.49,
		},
		{
			0.27,
			0.9,
			0.27,
		},
		{
			0,
			1,
			0,
		},
		{
			-0.27,
			0.9,
			-0.27,
		},
		{
			-0.47,
			0.77,
			-0.49,
		},
	},
}
templates.diagonal_right = {
	points = {
		{
			-0.78,
			0.53,
			0.46,
		},
		{
			-0.42,
			0.9,
			0.24,
		},
		{
			0,
			1,
			0,
		},
		{
			0.35,
			0.96,
			-0.26,
		},
		{
			0.64,
			0.77,
			-0.49,
		},
	},
}
templates.stab = {
	points = {
		{
			0,
			0.2,
			0,
		},
		{
			0,
			3,
			0,
		},
	},
}

return templates
