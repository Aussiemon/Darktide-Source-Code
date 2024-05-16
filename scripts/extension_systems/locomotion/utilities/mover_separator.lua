-- chunkname: @scripts/extension_systems/locomotion/utilities/mover_separator.lua

local MoverSeparator = {}

MoverSeparator.try_separate = function (mover, distance)
	local is_colliding, _, _, new_position = Mover.separate(mover, distance)

	if is_colliding and new_position then
		Mover.set_position(mover, new_position)
	end

	local success = not is_colliding or new_position ~= nil

	return success, new_position or Mover.position(mover)
end

return MoverSeparator
