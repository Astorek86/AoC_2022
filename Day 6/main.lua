-- Place your Input between [[ and ]]
local MYINPUT = [[
mjqjpqmgbljsphdztnvjfqwrcgsmlb
]]

function duplicate_chars_in_string(search_string)
	local _, count, i
	for i=1,#search_string do
		_, count = string.gsub(search_string, string.sub(search_string, i, i), "")
		if count > 1 then
			do return true end
		end
	end
	return false
end

function InputProcessor(length)
	local ret
	local length = length-1
	local _, chain  -- tmp-str
	local i  -- tmp-int
	
	local l_input = MYINPUT
	
	for i=1,#l_input-length do
		chain = string.sub(l_input, i, i + length)
		if not (duplicate_chars_in_string(chain)) then
			break
		end
	end
	_, ret = string.find(l_input, chain)
	return ret
end


function main()
	-- Losung 1
	solution = InputProcessor(4)
	print(solution)

	-- Losung 2
	solution = InputProcessor(14)
	print(solution)
end


main()
