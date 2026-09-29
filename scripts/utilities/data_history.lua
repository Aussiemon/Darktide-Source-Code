-- chunkname: @scripts/utilities/data_history.lua

local EDIT_TYPES = table.enum("change_field", "add_reference", "remove_reference")
local DIFF_APPLICATION_TYPES = table.enum("apply", "revert")

local function _copy_value(value)
	if type(value) == "table" then
		return table.clone_instance(value)
	end

	return value
end

local HistoryEntry = class("HistoryEntry")

HistoryEntry.init = function (self, diffs)
	self._diffs = diffs
	self._next = {}
	self._previous = nil
end

HistoryEntry.root = function ()
	local entry = HistoryEntry:new({})

	entry._previous = entry

	return entry
end

HistoryEntry.diffs = function (self)
	return self._diffs
end

HistoryEntry.set_next = function (self, history_entry)
	table.insert(self._next, 1, history_entry)

	history_entry._previous = self
end

HistoryEntry.previous = function (self)
	return self._previous
end

HistoryEntry.next = function (self, idx)
	return self._next[idx]
end

local function _create_commit_data(data_id_or_val, reference_by_id)
	return {
		data_id_or_val = data_id_or_val,
		reference_by_id = _copy_value(reference_by_id),
	}
end

local DataHistory = class("DataHistory")

DataHistory.init = function (self, data)
	self._data = data
	self._id_by_reference = {}
	self._reference_by_id = {}
	self._instance_by_id = {}
	self._history_entry = HistoryEntry.root()

	if type(data) == "table" then
		self:_register_ref(data, self._reference_by_id)
	end

	local commit_data = self._id_by_reference[self._data] or self._data

	self._original_state_data = _create_commit_data(commit_data, self._reference_by_id)
end

DataHistory.from_json = function (json)
	local as_commit_data = cjson.decode(json)

	return DataHistory.from_commit_data(as_commit_data)
end

DataHistory.from_commit_data = function (commit_data)
	local data_history = DataHistory:new()
	local root = commit_data.reference_by_id[commit_data.data_id_or_val] or commit_data.data_id_or_val
	local reference_by_id = commit_data.reference_by_id

	for id, ref in pairs(reference_by_id) do
		data_history._reference_by_id[id] = ref
		data_history._id_by_reference[ref] = id
	end

	if type(root) == "table" then
		data_history._data = DataHistory._from_commit_data_recursive(data_history, root, commit_data.reference_by_id, {})
	else
		data_history._data = root
	end

	data_history._original_state_data = _create_commit_data(commit_data.data_id_or_val, commit_data.reference_by_id)

	return data_history
end

DataHistory.stringify = function (self)
	return cjson.encode(self._original_state_data)
end

DataHistory.record_changes = function (self)
	local original_state_data = self._original_state_data
	local current_state = self:_to_commit_data()
	local diffs = self:_gather_diffs(original_state_data, current_state)

	if table.is_empty(diffs) then
		return false
	end

	self:_prune_removed_references(original_state_data, current_state)

	local history_entry = HistoryEntry:new(diffs)

	self._history_entry:set_next(history_entry)

	self._history_entry = history_entry
	self._original_state_data = current_state

	return true
end

DataHistory.undo = function (self)
	if not self:can_undo() then
		return false
	end

	local history_entry = self._history_entry
	local previous = history_entry:previous()
	local diffs = history_entry:diffs()

	self:_apply_diffs(diffs, DIFF_APPLICATION_TYPES.revert)

	self._original_state_data = self:_to_commit_data()
	self._history_entry = previous

	return true
end

DataHistory.can_undo = function (self)
	local history_entry = self._history_entry
	local previous = history_entry:previous()

	if not previous or history_entry == previous then
		return false
	end

	return true
end

DataHistory.redo = function (self, optional_branch_index)
	if not self:can_redo(optional_branch_index) then
		return false
	end

	local history_entry = self._history_entry
	local next = history_entry:next(optional_branch_index or 1)
	local diffs = next:diffs()

	self:_apply_diffs(diffs, DIFF_APPLICATION_TYPES.apply)

	self._original_state_data = self:_to_commit_data()
	self._history_entry = next

	return true
end

DataHistory.can_redo = function (self, optional_branch_index)
	local history_entry = self._history_entry
	local next = history_entry:next(optional_branch_index or 1)

	if not next then
		return false
	end

	return true
end

DataHistory._from_commit_data_recursive = function (data_history, data, reference_by_id, built_lut)
	local already_built = built_lut[data]

	if already_built then
		return already_built
	end

	local out_data = {}
	local id = data_history._id_by_reference[data]

	data_history._id_by_reference[out_data] = id
	data_history._instance_by_id[id] = out_data
	built_lut[data] = out_data

	for k, v in pairs(data) do
		local ref = reference_by_id[v]

		if ref then
			out_data[k] = DataHistory._from_commit_data_recursive(data_history, ref, reference_by_id, built_lut)
		else
			out_data[k] = v
		end
	end

	return out_data
end

DataHistory._to_commit_data = function (self)
	local data_id = self._id_by_reference[self._data] or self._data
	local reference_by_id = {}

	if type(self._data) == "table" then
		self:_register_ref(self._data, reference_by_id)
	end

	return _create_commit_data(data_id, reference_by_id)
end

DataHistory._prune_removed_references = function (self, original_state, current_state)
	local current_reference_by_id = current_state.reference_by_id
	local original_reference_by_id = original_state.reference_by_id

	for ref_id in pairs(original_reference_by_id) do
		if current_reference_by_id[ref_id] == nil then
			self:_remove_reference(ref_id)
		end
	end
end

DataHistory._gather_diffs = function (self, original_state_data, current_state)
	local diffs = {}
	local original_references = original_state_data.reference_by_id
	local current_references = current_state.reference_by_id

	for id, current in pairs(current_references) do
		local original = original_references[id]

		if not original then
			diffs[#diffs + 1] = {
				type = EDIT_TYPES.add_reference,
				ref_id = id,
				val = _copy_value(current),
			}
		else
			local handled_keys = {}

			for k, v in pairs(current) do
				handled_keys[k] = true

				if v ~= original[k] then
					diffs[#diffs + 1] = {
						type = EDIT_TYPES.change_field,
						ref_id = id,
						key = k,
						before = _copy_value(original[k]),
						after = _copy_value(v),
					}
				end
			end

			for k, v in pairs(original) do
				if not handled_keys[k] then
					diffs[#diffs + 1] = {
						after = nil,
						type = EDIT_TYPES.change_field,
						ref_id = id,
						key = k,
						before = _copy_value(v),
					}
				end
			end
		end
	end

	for id, original in pairs(original_references) do
		if current_references[id] == nil then
			diffs[#diffs + 1] = {
				type = EDIT_TYPES.remove_reference,
				ref_id = id,
				val = _copy_value(original),
			}
		end
	end

	return diffs
end

DataHistory._register_ref = function (self, ref, out_reference_by_id, handled)
	handled = handled or {}

	local id_by_reference = self._id_by_reference
	local flat_copy = {}
	local ref_id = id_by_reference[ref]

	ref_id = ref_id or self:_generate_reference(ref, flat_copy)

	local previous_flat = self._reference_by_id[ref_id]

	if previous_flat ~= nil and previous_flat ~= flat_copy then
		id_by_reference[previous_flat] = nil
	end

	self._reference_by_id[ref_id] = flat_copy
	id_by_reference[flat_copy] = ref_id
	out_reference_by_id[ref_id] = flat_copy
	self._instance_by_id[ref_id] = ref
	handled[ref] = true

	local handled_keys = {}

	for i = 1, #ref do
		local val = ref[i]

		if type(val) == "table" then
			if not handled[val] then
				local id = self:_register_ref(val, out_reference_by_id, handled)

				flat_copy[i] = id
			else
				flat_copy[i] = id_by_reference[val]
			end
		else
			flat_copy[i] = val
		end

		handled_keys[i] = true
	end

	for k, v in pairs(ref) do
		if not handled_keys[k] then
			local val = ref[k]

			if type(val) == "table" then
				if not handled[val] then
					local id = self:_register_ref(val, out_reference_by_id, handled)

					flat_copy[k] = id
				else
					flat_copy[k] = id_by_reference[val]
				end
			else
				flat_copy[k] = val
			end
		end
	end

	return ref_id
end

DataHistory._generate_reference = function (self, val, flat_copy)
	local id = math.uuid()

	while self._reference_by_id[id] or self._instance_by_id[id] do
		id = math.uuid()
	end

	self._id_by_reference[val] = id
	self._id_by_reference[flat_copy] = id
	self._reference_by_id[id] = flat_copy

	return id
end

DataHistory._ensure_instance = function (self, ref_id)
	local instance = self._instance_by_id[ref_id]

	if not instance then
		instance = {}
		self._instance_by_id[ref_id] = instance
		self._id_by_reference[instance] = ref_id
	end

	return instance
end

DataHistory._resolve_ref_value = function (self, value)
	if value ~= nil and self._reference_by_id[value] ~= nil then
		return self:_ensure_instance(value)
	end

	return value
end

DataHistory._add_reference = function (self, ref_id, flat)
	self._reference_by_id[ref_id] = flat
	self._id_by_reference[flat] = ref_id
end

DataHistory._remove_reference = function (self, ref_id)
	local flat = self._reference_by_id[ref_id]

	self._reference_by_id[ref_id] = nil

	if flat ~= nil then
		self._id_by_reference[flat] = nil
	end

	local instance = self._instance_by_id[ref_id]

	self._instance_by_id[ref_id] = nil

	if instance ~= nil then
		self._id_by_reference[instance] = nil
	end
end

DataHistory._populate_instance = function (self, ref_id, flat)
	local instance = self:_ensure_instance(ref_id)

	for k in pairs(instance) do
		instance[k] = nil
	end

	for k, v in pairs(flat) do
		instance[k] = self:_resolve_ref_value(v)
	end
end

DataHistory._apply_change_field = function (self, diff, is_apply)
	local field_value

	if is_apply then
		field_value = diff.after
	else
		field_value = diff.before
	end

	local field_name = diff.key
	local ref = self._reference_by_id[diff.ref_id]
	local instance = self._instance_by_id[diff.ref_id]

	ref[field_name] = field_value

	if instance then
		instance[field_name] = self:_resolve_ref_value(field_value)
	end
end

DataHistory._apply_diffs = function (self, diffs, diff_application_type)
	local is_apply = diff_application_type == DIFF_APPLICATION_TYPES.apply
	local num_diffs = #diffs

	for i = 1, num_diffs do
		local diff = diffs[i]

		if diff.type == EDIT_TYPES.add_reference then
			if is_apply then
				self:_add_reference(diff.ref_id, diff.val)
			else
				self:_remove_reference(diff.ref_id)
			end
		elseif diff.type == EDIT_TYPES.remove_reference then
			if is_apply then
				self:_remove_reference(diff.ref_id)
			else
				self:_add_reference(diff.ref_id, diff.val)
			end
		end
	end

	for i = 1, num_diffs do
		local diff = diffs[i]

		if diff.type == EDIT_TYPES.add_reference and is_apply or diff.type == EDIT_TYPES.remove_reference and not is_apply then
			self:_populate_instance(diff.ref_id, diff.val)
		end
	end

	local from, to, step

	if is_apply then
		from, to, step = 1, num_diffs, 1
	else
		from, to, step = num_diffs, 1, -1
	end

	for i = from, to, step do
		local diff = diffs[i]

		if diff.type == EDIT_TYPES.change_field then
			self:_apply_change_field(diff, is_apply)
		end
	end
end

return DataHistory
