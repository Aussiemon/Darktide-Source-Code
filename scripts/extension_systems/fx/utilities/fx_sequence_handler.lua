-- chunkname: @scripts/extension_systems/fx/utilities/fx_sequence_handler.lua

local sequence_templates = {
	wizard_vanish = require("scripts/utilities/fx_sequence/wizard_vanish_sequence"),
}
local FxSequenceHandler = class("FxSequenceHandler")

FxSequenceHandler.init = function (self)
	self._running_sequences = {}
end

FxSequenceHandler.update = function (self, context, dt, t)
	local running_sequences = self._running_sequences

	if table.is_empty(running_sequences) then
		return
	end

	for unit, template in pairs(running_sequences) do
		local template_data = self:_grab_template_data(template)
		local should_exit

		should_exit = not Unit.alive(unit) and true or template.update(template_data, dt, t)

		if should_exit then
			template.exit(template_data)

			running_sequences[unit] = nil
		end
	end
end

FxSequenceHandler.clear = function (self, context)
	table.clear(self._running_sequences)
end

FxSequenceHandler.start_sequence = function (self, unit, sequence_name, ...)
	local running_sequences = self._running_sequences
	local template = sequence_templates[sequence_name]

	running_sequences[unit] = template

	local template_data = self:_grab_template_data(template)

	template_data.unit = unit

	template.init(template_data, ...)
end

FxSequenceHandler._grab_template_data = function (self, template)
	local template_data = template.template_data

	if not template_data then
		template_data = {}
		template.template_data = template_data
	end

	return template_data
end

FxSequenceHandler.hot_join_sync = function (self, sender, channel)
	return
end

return FxSequenceHandler
