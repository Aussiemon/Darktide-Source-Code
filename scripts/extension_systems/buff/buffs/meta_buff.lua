-- chunkname: @scripts/extension_systems/buff/buffs/meta_buff.lua

require("scripts/extension_systems/buff/buffs/buff")

local MetaBuff = class("MetaBuff", "Buff")

MetaBuff.init = function (self, context, template, start_time, instance_id, ...)
	MetaBuff.super.init(self, context, template, start_time, instance_id, ...)

	local meta_stat_buffs = {}

	for key, value in pairs(template.meta_stat_buffs) do
		local final_value

		if type(value) == "number" then
			final_value = value
		else
			local min = value.min
			local max = value.max
			local lerp_value = self._template_context.buff_lerp_value
			local lerped_value = math.lerp(min, max, lerp_value)

			final_value = math.round_down_with_precision(lerped_value, 2)
		end

		meta_stat_buffs[key] = final_value
	end

	local player = context.player

	self._player_id = player:unique_id()
	self._meta_stat_buffs = meta_stat_buffs
end

MetaBuff.update_stat_buffs = function (self, current_stat_buffs, t)
	self:_calculate_stat_buffs(current_stat_buffs, self._meta_stat_buffs)
end

MetaBuff.player_id = function (self)
	return self._player_id
end

return MetaBuff
