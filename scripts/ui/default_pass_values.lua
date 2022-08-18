local DefaultPassValues = {
	texture = "content/ui/materials/base/ui_default_base"
}
DefaultPassValues.texture_uv = DefaultPassValues.texture
DefaultPassValues.rotated_texture = DefaultPassValues.texture
DefaultPassValues.multi_texture = DefaultPassValues.texture
DefaultPassValues.text = "placeholder_text"
DefaultPassValues.slug_icon = "content/ui/vector_textures/default_vector_icon"
DefaultPassValues.slug_picture = "content/ui/vector_textures/default_vector_icon"
DefaultPassValues.multi_slug_icon = "content/ui/vector_textures/default_vector_icon"
DefaultPassValues.rotated_slug_icon = "content/ui/vector_textures/default_vector_icon"
DefaultPassValues.rotated_slug_picture = "content/ui/vector_textures/default_vector_icon"
DefaultPassValues.hotspot = nil

DefaultPassValues.logic = function ()
	return
end

DefaultPassValues.rect = nil
DefaultPassValues.video = "dummy_name"

return DefaultPassValues
