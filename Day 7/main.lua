-- Change "false" to "true" if you wanna see verbose output:
local VERBOSE=false

-- Put your Input here, between [[ and ]]
local MYINPUT = [[
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
]]

local flr = math.floor

function SplitOnSpace(input)
	local i = string.find(input, " ")
	return string.sub(input, 1, i-1), string.sub(input, i+1, #input)
end

function GetRidOfSpecial(input)
	-- Ersetze Carriage Returns mit _
	local l_input = string.gsub(input, "\r\n", "_")
	l_input = string.gsub(l_input, "\n\r", "_")
	l_input = string.gsub(l_input, "\r", "_")
	l_input = string.gsub(l_input, "\n", "_")
	-- Entferne mehrere _ am Anfang u. Ende (aber eines bleibt)
	l_input = "_"..string.gsub(l_input, "^_*_", "^_")
	l_input = string.gsub(l_input, "_*_$", "_$")
	-- Ersetze "$" mit "-" (um Verwirrung des Lua-Interpreters mit "$" zu vermeiden:
	l_input = string.gsub(l_input, "%$", "-")
	
	return l_input
end

function GetFirstLineAndCrop(string_one)
	local e = string.find(string.sub(string_one, 2, #string_one), "_")
	return string.sub(string_one, 2, e), string.sub(string_one, e+1, #string_one)
end


function DEBUG_ShowDrive(drive)
	for k,v in pairs(drive) do
		if k ~= ".." then  -- Ignoriere "..", sonst wirds unendlich...
			if type(v) == "table" then
				print("Im Verzeichnis "..k)
				DEBUG_ShowDrive(v)
				print("Im Verzeichnis ..")
			else
				print("Datei "..k..", Groesse: "..v)
			end
		end
	end
end


function InputToArray()
	local drive = {} -- Rückgabewert 1
	local dirs = {} -- Rückgabewert 2
	local l_input  -- Zwischenspeichern des Input-Strings
	local current_pos  -- tmp-pointer
	local line,dir,name,size  -- tmp-str
	
	-- Directory entsprechend vorbereiten
	drive["/"] = {}
	drive["/"][".."] = drive["/"]  -- Normalerweise ist ".." = ein Verzeichnis drüber, aber nicht bei "/"
	current_pos = drive["/"]
	table.insert(dirs, current_pos)
	
	-- Input entsprechend vorbereiten
	l_input = GetRidOfSpecial(MYINPUT)
	
	-- Line für Line durchgehen:
	while #l_input>2 do
		line, l_input = GetFirstLineAndCrop(l_input)
		-- Wechsel des Verzeichnisses?
		if string.find(line, "- cd") then
			dir = string.sub(line, 6, #line)
			-- "/" ist ein Spezialcharakter u. muss gesondert betrachtet werden:
			if string.sub(dir, 1, 1) == "/" then
				dir = string.sub(dir, 2, #dir)
				current_pos = drive["/"]
			end
			-- Wechsle ins entsprechende Verzeichnis (Längenprüfung wg. "/" als einzigen Parameter abhaken!):
			if #dir>0 then
				-- Verzeichnis existiert noch nicht? Anlegen:
				if not (current_pos[dir]) then
					current_pos[dir] = {}
					current_pos[dir][".."] = current_pos
					table.insert(dirs, current_pos[dir])
				end
				current_pos = current_pos[dir]
			end
		-- Datei gefunden?
		elseif string.find(line, "[0-9]") then
			size, name = SplitOnSpace(line)
			current_pos[name] = flr(size)
		end
	end
	if VERBOSE then
		DEBUG_ShowDrive(drive)
	end
	return drive, dirs
end

function GetDirSize(dir)
	local ret = 0
	for k,v in pairs(dir) do
		-- Unbedingt ".." ignorieren, wenn wir keine endlose Rekursion wollen!
		if k ~= ".." then
			-- Ist Directory?
			if type(v) == "table" then
				ret = ret + GetDirSize(v)
			else
				ret = ret + v
			end
		end
	end
	return ret
end


function main()
	local val
	local drive, dirs = InputToArray()
	
	-- Losung 1:
	local score1 = 0
	for _,v in pairs(dirs) do
		val = GetDirSize(v)
		if val <= 100000 then
			score1 = score1 + val
		end
	end
	print(score1)
	
	-- Losung 2:
	-- Benoetigten u. Freien Speicherplatz berechnen:
	local TotalSpace = 70000000
	local UsedSpace = GetDirSize(drive["/"])
	local FreeSpace = TotalSpace - UsedSpace
	local NeededSpace = 30000000
	local FreeSpaceIfDirDeleted = {}
	for _,v in pairs(dirs) do
		val = GetDirSize(v)
		if FreeSpace + val >= NeededSpace then
			table.insert(FreeSpaceIfDirDeleted, val)
		end
	end
	table.sort(FreeSpaceIfDirDeleted)
	print(FreeSpaceIfDirDeleted[1])
end


main()
