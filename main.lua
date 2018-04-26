local population = {}
local args = {}
local data_module_prefix = "پودمان:جمعیت/آزمایشی/داده/"
local converter = require("Module:Numeral converter")

local function ifexist(page)
    if not page then return false end
    if mw.title.new(page).exists then return true end
    return false
end

local function isempty(s)
  return s == nil or s == ''
end

local function loadpopulationdb(frame, s, p, year)
	local facodestr = converter.convert("fa", s)
	year = converter.convert("en", year)
	pfa = converter.convert("fa", p)
	local function setarg(k, v)
		if(v and v ~= '') then args[k] = v end
	end
	if( codestr ~= '' ) then
		local dbpage = data_module_prefix..pfa
		if (ifexist(dbpage)) then
			local data = mw.loadData(dbpage)
			local dargs = data[facodestr]
			if isempty(dargs) then
				setarg('pop', 'خطا:کد یافت نشد')
			else
				if (year == '85') then
					setarg('pop', dargs['p85'])
					setarg('year', '85')
				elseif (year =='95') then
					setarg('pop', dargs['p95'])
					setarg('year', '95')
				end
			end
		else 
			setarg('pop', 'خطا:استان یافت نشد')	
		end
	end
end

local function printpop(frame)
	return (args['pop'])	
end

function population.main(frame)
	local args = require('Module:Arguments').getArgs(frame)--, {
		--	wrappers = 'Template:Iran population'
	--	})
	return population._main(args)
end

function population._main(args)

	if(args['کد'] and args['کد'] ~= '' and args['استان'] and args['استان'] ~= '') then
		if( args['سال'] and args['سال'] ~= '') then
			loadpopulationdb(frame,args['کد'], args['استان'], args['سال'])
		else
			loadpopulationdb(frame,args['کد'], args['استان'], '95')
		end
	end
	
	return printpop(frame)
end

return population