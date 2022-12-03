-- Change SECOND_PART to "true" to show the solution for 2nd Part
SECOND_PART = true

-- Change DEBUG to "true" for verbose output
DEBUG=false

-- Put your Input between [[ and ]]
INPUT = [[
A Y
B X
C Z
]]

function InputToArray()
	local ret = {}
	local t  -- tmp-table
	local i = 1
	local l_input = INPUT
	-- Ersetze alle Carriage Returns durch "x":
	l_input = string.gsub(l_input, "\r\n", "x")
	l_input = string.gsub(l_input, "\r", "x")
	l_input = string.gsub(l_input, "\n", "x")
	
	-- Ich cheate eiskalt, und gebe XYZ die Werte ABC
	l_input = string.gsub(l_input, "X", "A")
	l_input = string.gsub(l_input, "Y", "B")
	l_input = string.gsub(l_input, "Z", "C")
	
	-- Letztes Zeichen ignorieren
	l_input = string.sub(l_input, 1, #l_input-1)
	
	while #l_input>0 do
		t = {}
		t["left"] = string.sub(l_input, 1, 1)
		t["right"] = string.sub(l_input, 3, 3)
		table.insert(ret, t)
		l_input = string.sub(l_input, 5, #l_input)
	end
	return ret
end

function main()
	local POINT_FOR_WIN = {A="C", B="A", C="B" }
	local POINT_FOR_USING = {A=1, B=2, C=3 }
	local POINT_FOR_LOSE = {C="A", A="B", B="C" }
	
	local array = InputToArray()
	
	if SECOND_PART then
		for k,v in pairs(array) do
			-- Ich soll verlieren?
			if v.right == "A" then
				array[k]["right"] = POINT_FOR_WIN[v.left]
			-- Ich soll Gleichstand erreichen?
			elseif v.right == "B" then
				array[k]["right"] = v.left
			-- Ich soll gewinnen?
			else
				array[k]["right"] = POINT_FOR_LOSE[v.left]
			end
		end
	end

	
	all_score = 0
	score = 0
	for k,v in pairs(array) do
		score = score + POINT_FOR_USING[v.right]
		if DEBUG then print("SCORE FUER NUTZUNG VON "..v.right..": "..score) end
		if POINT_FOR_WIN[v.right] == v.left then
			score = score + 6
			if DEBUG then print("GEWONNEN BEI "..v.right.." GEGEN "..v.left..": 6") end
		elseif v.right == v.left then
			score = score + 3
			if DEBUG then print("GLEICHSTAND BEI "..v.right.." GEGEN "..v.left..": 3") end
		else
			if DEBUG then print("VERLOREN BEI "..v.right.." GEGEN "..v.left..": 0") end
		end
		if DEBUG then
			print("-- RUNDE VORBEI --")
			print("-- SCORE: "..score)
		end
		all_score = all_score + score
		score = 0
		if DEBUG then
			print("-- INSGE: "..all_score)
			print("---")
		end
	end
	
	-- Lösung:
	print(all_score)
end

main()
