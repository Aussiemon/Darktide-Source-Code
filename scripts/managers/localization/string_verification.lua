local Promise = require("scripts/foundation/utilities/promise")
local forbidden_words = require("scripts/managers/localization/forbidden_words")
local Interface = {
	"verify"
}
local WORD_CHARACTERS = "[^ %p]+"
local StringVerification = class("StringVerification")

StringVerification.verify = function (text)
	local filtered_text = text:gsub(WORD_CHARACTERS, function (word)
		local lowercase_word = string.lower(word)
		local len = Utf8.string_length(lowercase_word)
		local forbidden_words_set = forbidden_words.words[len]

		if forbidden_words_set then
			for i = 1, #forbidden_words_set, 1 do
				if lowercase_word == forbidden_words_set[i] then
					return string.rep("*", len)
				end
			end
		end

		return false
	end)
	local lowercase_text = string.lower(filtered_text)
	local text_len = Utf8.string_length(lowercase_text)

	for len = 1, text_len, 1 do
		local phrases = forbidden_words.phrases[len]

		if phrases then
			for i = 1, #phrases, 1 do
				local phrase = phrases[i]
				local offset = 0

				while true do
					local index_from, index_to = Utf8.find(lowercase_text, phrase, offset + 1, true)

					if not index_from then
						break
					end

					local phrase_length = Utf8.string_length(phrase)
					filtered_text = Utf8.string_remove(filtered_text, index_from, phrase_length)
					filtered_text = Utf8.string_insert(filtered_text, index_from, string.rep("*", phrase_length))
					offset = index_to
				end
			end
		end
	end

	return Promise.resolved(filtered_text)
end

if rawget(_G, "implements") then
	implements(StringVerification, Interface)
end

return StringVerification
