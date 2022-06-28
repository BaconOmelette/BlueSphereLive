client.SetGameExtraPadding(0, 16, 256, 16) --Expand window to make room for layout images

Grid = {} -- Initialize Grid Array, keep in mind that LUA arrays start at 1 where as the game's array for blue spheres starts at 0
for Col=1,32 do
	Grid[Col] = {}
	for Row=1,32 do	
		Grid[Col][Row] = {}
	end
end

ReDraw = false --set ReDraw to false

while true do
    GameMode = memory.readbyte(0xFFF600) --Game Mode Flag
    if GameMode == 52 then --Check for Special Stage Game Mode Flag
	
		--Drawing the display
		if ReDraw == true then --Lets draw ourselves a grid!
			Col = 0 --Set sights on first position
			while Col <32 do --Stop after out of range
				Row = 0 --Set sights on first position
				while Row < 32 do --Stop after out of range
					DrawSlot = memory.readbyte(((0xFFF4E0-(Col*32))+Row)) --Memory address for currently targetted position
					if DrawSlot < 11 then --Safeguard to not draw images that don't exist
						gui.drawImage(DrawSlot .. ".png", (320+(Col*8)),(Row*8)) --Grab the image, place it in the proper position in the display
						Grid[(Col+1)][(Row+1)] = DrawSlot --Write the the Grid Array to compare with later
					end
					Row = Row + 1 --Set sights on the next position
				end
				Col = Col + 1 --Set sights on the next position
			end
			ReDraw = false --set ReDraw to false, its finished and we can go back to comparing
		end
		
		--Comparing game memory addresses with the Grid array in LUA
        Col = 0 --Set sights on first position
        while Col <32 do --Stop after out of range
            Row = 0 --Set sights on first position
            while Row < 32 do --Stop after out of range
				DrawSlot = memory.readbyte(((0xFFF4E0-(Col*32))+Row)) --Memory address for currently targetted position
                if DrawSlot < 11 then --Safeguard to not draw images that don't exist
					if Grid[(Col+1)][(Row+1)] ~= DrawSlot then --If the game has something different than what we have in the Grid array, lets get to work!
						ReDraw = true --set ReDraw to true
						break --we no longer need to check the rest of the data because a change is detected
					end
                end
				Row = Row + 1 --Set sights on the next position
            end
            if ReDraw == true then --again, bail out of our loop because we detected a change
                break
            end
			Col = Col + 1 --Set sights on the next position
        end	
    end
	emu.frameadvance()
end

