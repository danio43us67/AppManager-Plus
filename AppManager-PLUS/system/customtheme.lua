--[[
    Modulo Administrador de temas 'livearea'.
]]

theme_mgr = {}

function theme_mgr.launch()
	local list = themes.list()
	if list and #list>0 then
		local i = #list
		while i > 0 do
			if list[i].id:sub(1,9) != "ux0:theme" then
				list[i].info = themes.info(list[i].id.."/".."theme.xml")
				if list[i].home then
					list[i].preview = image.load(list[i].id.."/"..list[i].home)
					if list[i].preview then
						list[i].preview:resize(252,151)
					end
				end
			else
				table.remove(list,i)
			end

			i -= 1
		end

		if #list<=0 then os.message(strings.notthemes) return end

		local sel = 1
		while true do

			buttons.read()

			if buttons.up then sel-= 1
			elseif buttons.down then sel+=1 end

			if sel < 1 then sel = 1
			elseif sel > #list then sel=#list end 

			if buttons.square then
				if os.message(strings.deltheme.."\n"..list[sel].info.title.." ?",1)==1 then
					themes.delete(list[sel].id)
					if os.message(strings.delfilestheme,1)==1 then
						files.delete(list[sel].id)
					end
					table.remove(list,sel)
				end
			end

			if theme.data["themesmanager"] then theme.data["themesmanager"]:blit(0,0) end

			screen.print(480,15,strings.customthemes,1,theme.style.TITLECOLOR,color.blue,__ACENTER)
			draw.rect(700-1,84-1,252+2,151+2,color.white)
			local y = 70
			for i=1,#list do
				if i==sel then
					if list[i].preview then list[i].preview:blit(700,84) end
					screen.print(700+126,240,list[i].info.title or "unk",0.9,theme.style.TITLECOLOR,theme.style.BKGCOLOR,__ACENTER)
					screen.print(700+126,260,list[i].info.author or "unk",0.9,theme.style.TITLECOLOR,theme.style.BKGCOLOR,__ACENTER)
					draw.fillrect(15,y-3,665,25,theme.style.SELCOLOR)
				end
				screen.print(20,y,list[i].id)
				y+=26
			end

			if theme.data["buttons1"] then
				theme.data["buttons1"]:blitsprite(10,518,2)
			end
			screen.print(35,520,strings.pressremove,1.0,color.white,color.blue,__ALEFT)
			screen.flip()

			if buttons.start then											--USB
				usbMassStorage()
			end

			if buttons[cancel] then break end
		end
	else os.message(strings.notthemes) end
end

