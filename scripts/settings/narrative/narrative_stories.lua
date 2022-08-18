local narrative_stories = {
	main_story = {}
}

for _, chapters in pairs(narrative_stories) do
	for i = 1, #chapters, 1 do
		chapters[i].index = i
	end
end

return settings("NarrativeStories", narrative_stories)
