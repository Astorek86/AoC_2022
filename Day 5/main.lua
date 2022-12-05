-- Place your Input here, between [[ and ]]
local AOC_INPUT = [[
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
]]


local write = io.write


-- Simple Funktion, um Tables innerhalb von Tables
-- zu kopieren (andernfalls gibts Querverweise)
function CopyTable(a)
	local ret = {}
	for i=1,#a do
		table.insert(ret, {})
		for j=1,#a[i] do
			table.insert(ret[i], a[i][j])
		end
	end
	return ret
end

-- Debugfunktion
function printstack(stack)
	for pos,_ in ipairs(stack) do
		print("POSITION: "..pos)
		for _,val in ipairs(stack[pos]) do
			print(val)
		end
	end
end

-- Drehe Inhalt des Arrays um:
function InverseArray(array)
	local ret = {}
	for i=#array,1,-1 do
		table.insert(ret, array[i])
	end
	return ret
end

-- Aufbereitung des command-Strings; extrahiere die ersten
-- drei Befehle vom Command. Schneide den Command-String an
-- der Stelle ab und gib ihn ebenfalls als Rückgabewert zurück:
function GetThreeValuesAndTruncatedArray(array)
	local ret = {}
	local x
	for i=1,3 do
		x = string.find(array, "x")
		table.insert(ret, tonumber(string.sub(array, 1, x-1)))
		array = string.sub(array, x+1, #array)
	end
	table.insert(ret, array)
	return table.unpack(ret)
end

-- Aufbereitung des Inputs in Array (genannt Stack) und eines Command-Strings:
function InputToStackAndCommand()
	local stack = {} -- Return-Value 1, Table
	local commands  -- Return-Value 2, String mit Commands
	
	local str_stack  -- String mit Stack
	
	local stackpos  -- tmp-int
	local c  -- tmp-str
	local x,i  -- tmp-int
	local myinput  -- tmp-input
	
	-- Ersetze alle Carriage Returns mit x:
	myinput = string.gsub(AOC_INPUT, "\r\n", "x")
	myinput = string.gsub(myinput, "\n\r", "x")
	myinput = string.gsub(myinput, "\r", "x")
	myinput = string.gsub(myinput, "\n", "x")
	-- Lösche "x" am Anfang:
	myinput = string.gsub(myinput, "^x*x", "")
	-- Haue am Ende ein(!) "x" rein, für Workaround.
	myinput = string.gsub(myinput, "x*x$", "x")
	
	-- Teile Input in zwei Variablen auf:
	commands = string.sub(myinput, string.find(myinput, "xx")+2, #myinput)
	str_stack = string.sub(myinput, 1, string.find(myinput, "xx"))
	
	-- Stack-Input weiter aufbereiten...
	str_stack = string.gsub(str_stack, "    ", ".")  -- Leere Stacks mit "." kennzeichnen
	str_stack = string.gsub(str_stack, "   x", "x")  -- Leere Stacks mit "." kennzeichnen
	str_stack = string.gsub(str_stack, " ", "")  -- Überflüssige Leerzeichen raus
	str_stack = string.gsub(str_stack, "%[", "")  -- Überflüssige, eckige Klammern raus
	str_stack = string.gsub(str_stack, "%]", "")  -- Überflüssige, eckige Klammern raus
	str_stack = string.gsub(str_stack, "x1.*x", "x")  -- Überflüssige Zahlenreihe raus.
	-- Beispielausgabe: .D.xNC.xZMPx
	
	-- Command-Input weiter aufbereiten...
	commands = string.gsub(commands, "move ", "")
	commands = string.gsub(commands, " from ", "x")
	commands = string.gsub(commands, " to ", "x")
	-- Beispielausgabe: 1x2x1x3x1x3x2x2x1x1x1x2x

	-- Stack in Array manifestieren; erstmal von oben nach unten da einfacher:
	stackpos = 0
	for i=1,#str_stack do
		stackpos = stackpos + 1		
		c = string.sub(str_stack, i, i)
		-- Neue Zeile? Dann logischerweise Stackpos zurücksetzen
		if c == "x" then
			stackpos = 0
		else
			if not stack[stackpos] then table.insert(stack, {}) end  -- TODO: Performance-Tweak
			if c ~= "." then
				table.insert(stack[stackpos], c)
			end
		end
	end


	-- Sortiere die Stacks andersherum:
	for i, stackpos in pairs(stack) do
		stack[i] = InverseArray(stackpos)
	end

	
	-- Jetzt sind die Commands dran:
	return stack, commands
end

function SortStack_CrateMover9000(stack, commands)
	local stack,item = CopyTable(stack)
	local move, from, to
	while #commands>0 do
		move, from, to, commands = GetThreeValuesAndTruncatedArray(commands)
		
		for i = 1,move do
			item = stack[from][#stack[from]]
			table.remove(stack[from], #stack[from])
			-- Stack existiert noch nicht? Dann anlegen:
			while not stack[to] do
				table.insert(stack, {})
			end
			table.insert(stack[to], item)
		end
	end
	return stack
end

function SortStack_CrateMover9001(stack, commands)
	local stack,t = CopyTable(stack)
	local move, from, to, item
	while #commands>0 do
		move, from, to, commands = GetThreeValuesAndTruncatedArray(commands)
		
		t = {}
		for i = 1,move do
			item = stack[from][#stack[from]]
			table.insert(t, stack[from][#stack[from]])
			table.remove(stack[from], #stack[from])
		end
		t = InverseArray(t)
		while not stack[to] do
			table.insert(stack, {})
		end
		for i=1,#t do
			table.insert(stack[to], t[i])
		end
	end
	return stack
end


function main()
	stack, commands = InputToStackAndCommand()
	
	stack1 = SortStack_CrateMover9000(stack, commands)
	stack2 = SortStack_CrateMover9001(stack, commands)

	-- Losung 1:
	for i=1,#stack1 do
		write(stack1[i][#stack1[i]])
	end
	print("")
	
	-- Losung 2:
	for i=1,#stack2 do
		write(stack2[i][#stack2[i]])
	end
	print("")
end


main()
