-- Put your Input here, between [[ and ]]:
local MYINPUT = [[
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
]]


-- Erzeugt aus zwei Werten eine Table mit allen
-- Werten zwischen den beiden Werten, beide
-- Werte miteingeschlossen.
function BuildFromTo(from, to)
	local ret = {}
	for i=from,to do
		table.insert(ret, math.floor(i))
	end
	return ret
end

-- Bereite Input entsprechend auf, um im Programm-
-- code leichter damit umgehen zu können
function InputToArray()
	local ret = {}
	local c,l,r  -- tmp-str
	local next_comma  -- tmp-int
	
	-- Ersetze alle Carriage Returns mit ","
	local l_input = string.gsub(MYINPUT, "\r\n", ",")
	l_input = string.gsub(l_input, "\n\r", ",")
	l_input = string.gsub(l_input, "\r", ",")
	l_input = string.gsub(l_input, "\n", ",")
	-- Entferne am Anfang u. Ende ",":
	l_input = string.gsub(l_input, "^,*,", "")
	l_input = string.gsub(l_input, ",*,$", "")
	-- Setze am Ende ein "," für Workaround ;P
	l_input = l_input..","
	
	i = 0
	while #l_input>0 do
		i = i + 1
		c = string.sub(l_input, i, i)
		
		-- Minus an aktueller Position gefunden?
		if c=="-" then
			-- Finde nächstes Komma (um die Zahlen dazwischen aufzugreifen)
			next_comma = string.find(l_input, ",")
			-- Alles vor dem Minus = Zahl 1
			l = string.sub(l_input, 1, i-1)
			-- Alles nach dem Minus, aber vor dem Komma = Zahl 2
			r = string.sub(l_input, i+1, next_comma-1)
			-- Array entsprechend füllen
			table.insert(ret, BuildFromTo(l,r))
			-- String bis zur "Nachkommastelle" löschen u. Suchposition zurücksetzen:
			l_input = string.sub(l_input, next_comma+1, #l_input)
			i = 0
		end
	end
	return ret
end


-- Sucht Variable im Array. Falls gefunden, gib "true" zurück, sonst "false".
-- (Warum eigentlich muss man so eine Basic-Funktion in Lua selberschreiben?)
function ValInArray(searchvar, array_one)
	for i=1,#array_one do
		if searchvar == array_one[i] then
			do return true end
		end
	end
	return false
end

-- Prüft, wie oft im größeren Array alle Werte des kleineren Arrays
-- auftauchen.
-- Parameter: Zwei Arrays (Reihenfolge egal).
-- Gibt zwei Bool-Werte zurück:
-- >> Wenn ALLE Werte des kleineren Arrays im größeren Array gefunden
--    werden, ist der erste Rückgabewert "true", sonst "false".
-- >> Wenn (wenigstens) EINES der Werte des kleineren Arrays im
--    größeren Array gefunden werden, ist der zweite Rückgabewert
--    "true", ansonsten "false" (= kein einziger Wert des kleineren
--    Arrays wurde im größeren Array gefunden).
function CheckOverlap(array_one, array_two)
	local a1 = array_one
	local a2 = array_two
	if #a1>#a2 then a1,a2 = a2,a1 end
	local counter = #a1
	for _,val in pairs(a1) do
		if ValInArray(val, a2) then
			counter = counter - 1
		end
	end
	return counter == 0, counter ~= #a1
end


function main()
	array = InputToArray()
	-- array beinhaltet in Tables abwechselnd alle Zahlen von Links nach Rechts.
	-- Beispiel: Input ist "2-4,6-8\n2-3,4-5", ergibt das:
	-- array[1] = {2,3,4}, array[2] = {6,7,8}, array[3] = {2,3}, array[4] = {4,5}

	local counter_one, counter_two = 0,0
	for i,_ in ipairs(array) do
		if (i%2==0) then
			c1, c2 = CheckOverlap(array[i-1], array[i])
			if (c1) then counter_one = counter_one + 1 end
			if (c2) then counter_two = counter_two + 1 end
		end
	end
	-- Losung Part 1:
	print(counter_one)
	-- Losung Part 2:
	print(counter_two)
end


main()
