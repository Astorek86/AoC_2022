
function SortByElf(compList)
	local ret = {}
	local counter = 0 -- tmp-counter
	local c  -- tmp-char
	local t  -- tmp-table

	-- Alle Newlines mit einem anderen Zeichen ersetzen; erleichtert die Zuordnungen:
	compList = string.gsub(compList, "\r\n", "x")
	compList = string.gsub(compList, "\r", "x")
	compList = string.gsub(compList, "\n", "x")
	-- Anfang und Ende mit "x" löschen, falls sich dort welche befinden...
	compList = string.gsub(compList, "x*x$", "")
	compList = string.gsub(compList, "^x*x", "")
	-- Mehr als eine oder mehrere Newlines ebenfalls umschreiben. Es leben Regular Expressions^^:
	compList = string.gsub(compList, "xx*x", "n")
	-- Schlussendlich am Ende noch ein "x". Workaround, zum Glück sieht das niemand^^.
	compList = compList.."n"

	-- String Zeichen für Zeichen durchgehen
	i = 1
	is_running = true
	while is_running do
		if i > #compList then
			is_running = false
		else
			-- Char extrahieren
			c = string.sub(compList, i, i)
			-- Char for Sonderzeichen?
			if c == "x" or c=="n" then
				-- String vor dem Sonderzeichen extrahieren:
				n = string.sub(compList, 1, i-1)
				-- Original-String von links kürzen - einschließlich Sonderzeichen - und Index zurücksetzen:
				compList = string.sub(compList, i+1, #compList)
				i = 1
				-- Counter erhöhen:
				counter = counter + n
				-- War eine Newline? Dann ists ab sofort ein neuer Elf^^:
				if c=="n" then
					table.insert(ret, counter)
					counter = 0
				end
			end
		end
		i = i + 1
	end
	return ret
end
--]]

function main()
	calList = [[
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
]]
	value = SortByElf(calList)
	table.sort(value)
	print(value[#value])
end


main()
