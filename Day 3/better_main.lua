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


-- Bereitet Input für Arrays auf, für leichteren Zugriff im Programmcode
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


--[[
 Baue Score-Table zusammen, like:
 tbl_score["a"] = 1
 tbl_score["b"] = 2
 ...
 tbl_score["Z"] = 52
 -- Gibt Table dann zurück.
--]]
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


-- Prüft, ob ein String einen Char enthält;
-- search_char = char, der in Variable string_one auftauchen muss.
-- Wenn search_char im String gefunden wurde, gib "true" zurück, andernfalls "false".
function _HasJointChar(search_char, string_one)
	for j = 1, #string_one do
		if search_char == string.sub(string_one, j, j) then
			do return true end
		end
	end
	return false
end


--[[
 Querverweis: _HasJointChar
 Argument = Table von Strings.
 Gibt den Char zurück, wenn bei allen Strings im Table dasselbe Char gefunden wurde (egal auf welcher Position),
 oder "false", wenn kein Char bei allen(!) Strings im Table gefunden wurde.
--]]
function FindSameChar(lst_strings)
	-- Minimum 2 Einträge in Table nötig
	if (#lst_strings < 2) then do return false end end
	local counter
	
	-- Sortiere Table, damit der mit der niedrigsten Länge durchgegangen wird (Performance-Tweak)
	table.sort(lst_strings, function(a,b) return #a<#b end)
	
	for i=1, #lst_strings[1] do
		counter = 1
		c = string.sub(lst_strings[1], i, i)  -- Extrahiere Char
		for j = 2, #lst_strings do  -- Gehe alle anderen Tables durch...
			-- ... ob die dasselbe Char haben.
			if _HasJointChar(c, lst_strings[j]) then
				counter = counter + 1  -- erhöhe Counter.
			else
				break
			end
		end
		-- Counter hat denselben Wert wie die Anzahl der Tables? Dann muss der gesuchte
		-- Char bei allen Tables aufgetaucht sein u. kann zurückgegeben werden:
		if counter == #lst_strings then
			do return c end
		end
	end
	print("EMOTIONAL DAMAGE!")
	return false
end


function main()
	array1, array2 = InputToArray()
	tbl_score = BuildScoreTable()

	-- Lösung Part 1
	score = 0
	for k,v in pairs(array1) do
		score = score + tbl_score[FindSameChar({v["left"], v["right"]})]
	end
	print(score)
	
	-- Lösung Part 2
	score = 0
	for i,v in ipairs(array2) do
		if (i%3 == 0) then
			score = score + tbl_score[FindSameChar({array2[i-2], array2[i-1], array2[i]})]
		end
	end
	print(score)
end


main()
