local DefaultPassValues = {
	texture = "content/ui/materials/base/ui_default_base",
	texture_uv = DefaultPassValues.texture,
	rotated_texture = DefaultPassValues.texture,
	multi_texture = DefaultPassValues.texture,
	text = "placeholder_text",
	slug_icon = "content/ui/vector_textures/default_vector_icon",
	slug_picture = "content/ui/vector_textures/default_vector_icon",
	multi_slug_icon = "content/ui/vector_textures/default_vector_icon",
	rotated_slug_icon = "content/ui/vector_textures/default_vector_icon",
	rotated_slug_picture = "content/ui/vector_textures/default_vector_icon",
	hotspot = nil,
	logic = function ()
		return
	end,
	rect = nil,
	video = "dummy_name"
}

return DefaultPassValues
