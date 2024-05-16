-- chunkname: @scripts/settings/wounds/wounds_settings.lua

local shapes = table.enum("vertical_slash", "left_45_slash", "right_45_slash", "horizontal_slash", "vertical_slash_clean", "left_45_slash_clean", "right_45_slash_clean", "horizontal_slash_clean", "vertical_slash_coarse", "left_45_slash_coarse", "right_45_slash_coarse", "horizontal_slash_coarse", "lasgun", "shotgun", "sphere", "default")
local shape_inversions = {}

table.add_mirrored_entry(shape_inversions, shapes.left_45_slash, shapes.right_45_slash)
table.add_mirrored_entry(shape_inversions, shapes.left_45_slash_clean, shapes.right_45_slash_clean)
table.add_mirrored_entry(shape_inversions, shapes.left_45_slash_coarse, shapes.right_45_slash_coarse)

local masks = {
	[shapes.vertical_slash] = {
		0,
		0,
	},
	[shapes.left_45_slash] = {
		0.25,
		0,
	},
	[shapes.right_45_slash] = {
		0.5,
		0,
	},
	[shapes.horizontal_slash] = {
		0.75,
		0,
	},
	[shapes.vertical_slash_clean] = {
		0,
		0.25,
	},
	[shapes.left_45_slash_clean] = {
		0.25,
		0.25,
	},
	[shapes.right_45_slash_clean] = {
		0.5,
		0.25,
	},
	[shapes.horizontal_slash_clean] = {
		0.75,
		0.25,
	},
	[shapes.vertical_slash_coarse] = {
		0,
		0.5,
	},
	[shapes.left_45_slash_coarse] = {
		0.25,
		0.5,
	},
	[shapes.right_45_slash_coarse] = {
		0.5,
		0.5,
	},
	[shapes.horizontal_slash_coarse] = {
		0.75,
		0.5,
	},
	[shapes.lasgun] = {
		0,
		0.75,
	},
	[shapes.shotgun] = {
		0.25,
		0.75,
	},
	[shapes.sphere] = {
		0.5,
		0.75,
	},
	[shapes.default] = {
		0.75,
		0.75,
	},
}
local wounds_settings = {
	shapes = shapes,
	shape_inversions = shape_inversions,
	masks = masks,
}

return settings("WoundsSettings", wounds_settings)
