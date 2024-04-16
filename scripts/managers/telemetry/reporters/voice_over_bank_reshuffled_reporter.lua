local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local VoiceOverBankReshuffledReporter = class("VoiceOverBankReshuffledReporter")

VoiceOverBankReshuffledReporter.init = function (self)
	self._report = {}
	self._vo_name_to_index = {}
end

VoiceOverBankReshuffledReporter.update = function (self, dt, t)
	return
end

VoiceOverBankReshuffledReporter.report = function (self)
	if table.is_empty(self._report) then
		return
	end

	Managers.telemetry_events:voice_over_bank_reshuffled_report(self._report)
end

VoiceOverBankReshuffledReporter.register_event = function (self, bank_name)
	local index = self._vo_name_to_index[bank_name]

	if not index then
		index = #self._report + 1
		self._report[index] = {
			observations = 1,
			vo_name = bank_name
		}
		self._vo_name_to_index[bank_name] = index
	else
		self._report[index].observations = self._report[index].observations + 1
	end
end

VoiceOverBankReshuffledReporter.destroy = function (self)
	return
end

implements(VoiceOverBankReshuffledReporter, ReporterInterface)

return VoiceOverBankReshuffledReporter
