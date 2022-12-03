-- Put your input between [[ and ]]
local INPUT = [[
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
]]

local FLR = math.floor
local C_LOWERCASE = "abcdefghijklmnopqrstuvwxyz"
local C_UPPERCASE = string.upper(C_LOWERCASE)

function InputToArray()
	local ret1 = {}
	local ret2 = {}
	local l_input = INPUT
	local t  -- tmp-table
	local c  -- tmp-char
	local s1  -- tmp-str1
	local s2  -- tmp-str2
	
	-- Ersetze alle Carriage Returns mit "-"
	l_input = string.gsub(l_input, "\r\n", "-")
	l_input = string.gsub(l_input, "\n\r", "-")
	l_input = string.gsub(l_input, "\r", "-")
	l_input = string.gsub(l_input, "\n", "-")
	-- Lösche erstes & letztes "-", falls dort etwas auftaucht.
	l_input = string.gsub(l_input, "^-*-", "")
	l_input = string.gsub(l_input, "-*-$", "")
	-- Füge schlussendlich ein "-" am Ende hinzu. +1 für Workarounds. Ja, es ist böse^^:
	l_input = l_input.."-"
	
	-- Bereite Array auf:
	while #l_input > 0 do
		for i = 1, #l_input do
			-- Suche Newline-Char:
			c = string.sub(l_input, i, i)
			-- Newline-Char gefunden? Dann in zwei Hälften teilen u. als Array "left" und
			-- "right" dem Rückgabewert hinzufügen bei ret1; ret2 einfach den kompletten String:
			if c == "-" then
				t = {}
				s1 = string.sub(l_input, 1, FLR(i/2))  -- Hälfte der Stringlänge in "left"
				s2 = string.sub(l_input, FLR((i/2)+1), i-1)  -- andere Hälfte der Stringlänge: -1, um das dahinter liegende "-" nicht mitzunehmen
				l_input = string.sub(l_input, i+1, #l_input)  -- Rest des Strings bis zu diesem Punkt kürzen
				-- Arrays aufbereiten:
				t["left"] = s1
				t["right"] = s2
				table.insert(ret1, t)
				table.insert(ret2, s1..s2)
				break
			end
		end
	end
	return ret1, ret2
end

function BuildScoreTable(array)
	local ret = {}
	for i = 1, #C_LOWERCASE do
		ret[string.sub(C_LOWERCASE, i, i)] = i
	end
	for i = 1, #C_UPPERCASE do
		ret[string.sub(C_UPPERCASE, i, i)] = i+26
	end
	return ret
end

function FindCharInTwoStrings(string_one, string_two)
	local c  -- tmp-char
	for i = 1, #string_one do
		c = string.sub(string_one, i, i)
		for j = 1, #string_two do
			if c == string.sub(string_two, j, j) then
				do return c end
			end
		end
	end
end

function FindJointChar(jointArray)
	return FindCharInTwoStrings(jointArray["left"], jointArray["right"])
end

-- Erweitert für Teil 2:
function FindCharInThreeStrings(string_one, string_two, string_three)
	local c  -- tmp-char
	for i = 1, #string_one do
		c = string.sub(string_one, i, i)
		for j = 1, #string_two do
			if c == string.sub(string_two, j, j) then
				for k = 1, #string_three do
					if c == string.sub(string_three, k, k) then
						do return c end
					end
				end
			end
		end
	end
end

function main()
	array1, array2 = InputToArray()
	tbl_score = BuildScoreTable()

	-- Lösung Part 1
	score = 0
	for k,v in pairs(array1) do
		score = score + tbl_score[FindJointChar(v)]
	end
	print(score)
		
	-- Lösung Part 2
	score = 0
	for i,v in ipairs(array2) do
		if (i%3 == 0) then
			score = score + tbl_score[FindCharInThreeStrings(array2[i-2], array2[i-1], array2[i])]
		end
	end
	print(score)
end

main()
