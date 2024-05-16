-- chunkname: @scripts/extension_systems/coherency/coherency_utils.lua

local CoherencyUtils = {}

CoherencyUtils.add_buff_to_all_in_coherency = function (unit, buff_name, t, exclude_self)
	local coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")

	if not coherency_extension then
		return
	end

	local in_coherence_unit = coherency_extension:in_coherence_units()

	for coherency_unit, _ in pairs(in_coherence_unit) do
		local should_exclude = exclude_self and coherency_unit == unit

		if not should_exclude then
			local buff_extension = ScriptUnit.has_extension(coherency_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff(buff_name, t)
			end
		end
	end
end

return CoherencyUtils
