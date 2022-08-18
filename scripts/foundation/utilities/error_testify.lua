local ErrorTestify = class("ErrorTestify")

ErrorTestify.log_size_assert = function (condition, message)
	fassert(condition, message)
end

ErrorTestify.num_peers_assert = function (condition, message)
	fassert(condition, message)
end

ErrorTestify.performance_cameras_assert = function (condition, message)
	fassert(condition, message)
end

ErrorTestify.player_died_assert = function (condition, message)
	fassert(condition, message)
end

return ErrorTestify
