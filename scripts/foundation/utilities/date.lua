-- chunkname: @scripts/foundation/utilities/date.lua

local Date = {}

Date.seconds_in_a_minute = 60
Date.seconds_in_an_hour = 60 * Date.seconds_in_a_minute
Date.seconds_in_a_day = 24 * Date.seconds_in_an_hour
Date.seconds_in_a_week = 7 * Date.seconds_in_a_day
Date.denominations = {
	{
		length_in_seconds = Date.seconds_in_a_week,
	},
	{
		name = "wday",
		length_in_seconds = Date.seconds_in_a_day,
	},
	{
		name = "hour",
		length_in_seconds = Date.seconds_in_an_hour,
	},
	{
		name = "min",
		length_in_seconds = Date.seconds_in_a_minute,
	},
	{
		length_in_seconds = 1,
		name = "sec",
	},
}

Date.to_seconds = function (days, hours, minutes, seconds)
	return days * Date.seconds_in_a_day + hours * Date.seconds_in_an_hour + minutes * Date.seconds_in_a_minute + seconds
end

Date.seconds_until_time = function (current_epoch_time, target_time_table)
	local denominations = Date.denominations

	for i = 2, #denominations do
		if not target_time_table[denominations[i].name] then
			-- Nothing
		else
			local current_time_table = os.date("!*t", current_epoch_time)
			local target_epoch_time = current_epoch_time

			for j = i, #denominations do
				local denomination = denominations[j]
				local current_denomination_count = current_time_table[denomination.name]

				target_epoch_time = target_epoch_time - (current_denomination_count or 0) * denomination.length_in_seconds

				local target_denomination_count = target_time_table[denomination.name]

				target_epoch_time = target_epoch_time + (target_denomination_count or 0) * denomination.length_in_seconds
			end

			local epoch_diff = target_epoch_time - current_epoch_time

			if epoch_diff < 0 then
				epoch_diff = epoch_diff + denominations[i - 1].length_in_seconds
			end

			return epoch_diff
		end
	end
end

return Date
