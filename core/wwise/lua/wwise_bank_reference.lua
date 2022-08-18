WwiseBankReference = WwiseBankReference or {}

local function lazy_init(self)
	if not self.references then
		self.references = {}
	end
end

WwiseBankReference.add = function (self, bank_resource_name)
	lazy_init(self)

	self.references[bank_resource_name] = (self.references[bank_resource_name] or 0) + 1
end

WwiseBankReference.remove = function (self, bank_resource_name)
	lazy_init(self)

	local new_count = (self.references[bank_resource_name] or 0) - 1

	if new_count <= 0 then
		self.references[bank_resource_name] = nil
	end
end

WwiseBankReference.count = function (self, bank_resource_name)
	lazy_init(self)

	return self.references[bank_resource_name] or 0
end

return WwiseBankReference
