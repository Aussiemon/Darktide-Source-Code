local ProtoUI = require("scripts/ui/proto_ui/proto_ui")

ProtoUI.cursor_is_inside = function (pos, size)
	local delta = ProtoUI.mouse_cursor - ProtoUI.transform_position(pos)
	local scale = ProtoUI.scale

	return delta[1] >= 0 and delta[1] <= scale * size[1] and delta[2] >= 0 and delta[2] <= scale * size[2]
end

ProtoUI.input_get = function (action)
	return ProtoUI.input_service:get(action)
end

return
