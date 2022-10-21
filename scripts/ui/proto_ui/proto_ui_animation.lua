local ProtoUI = require("scripts/ui/proto_ui/proto_ui")

ProtoUI.anim_delay = function (t, delay)
	return t < delay and 0 or 1
end

ProtoUI.anim_interval = function (t, delay, duration)
	return delay <= t and t < delay + duration and 1 or 0
end

ProtoUI.anim_lerp = function (t, delay, duration)
	return math.clamp((t - delay) / duration, 0, 1)
end
