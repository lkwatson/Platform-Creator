--Platform creator 
--Created by Lucas Watson
--Copyright 2015
--GNU Affero General Public License v3.0

--Created for the LHS Techincal Theater Class

myPacker = require'packer' --Add the packer.lua file

curEntry = '' 
keyInput = ''

prompting = 0
prompt = ''

mode = 'draw' 		--others are draw and type
snap = true 		--Should we have boxes that are drawn snap or not?

sortMode = 'width' 	--This defines how boxes are sorted before running process()
					--Values can be: area, height, width. TODO: Move to param of process()

processing = false

lastKey = ''

function love.load() 
	lines = { } 		--initialize the tables we need
	squares = { }

	platforms = { }
	placements = { }

	drag = false 		--is the mouse currently in drag mode?
	scale = 20 			--how many pixel equals one foot
	shape = 'sq' 		--ln, sq, tri

	--static sample data entered for platforms 
	--they have nil values for x and y pos, as they haven't been placed yet
	--their width and heigh is what's important
	--TODO: Modify how this data is stored, allow it to be written to
	platforms[1] = {x = nil, y = nil, w=8, h=4}
	platforms[2] = {x = nil, y = nil, w=8, h=4}
	platforms[3] = {x = nil, y = nil, w=5, h=3}
	platforms[4] = {x = nil, y = nil, w=4.5, h=4.3}
	platforms[5] = {x = nil, y = nil, w=4.25, h=4}
	platforms[6] = {x = nil, y = nil, w=8, h=4}
	platforms[7] = {x = nil, y = nil, w=8, h=4}
	platforms[8] = {x = nil, y = nil, w=8, h=4}
	platforms[9] = {x = nil, y = nil, w=8, h=4}
	platforms[10] = {x = nil, y = nil, w=8, h=4}
	platforms[11] = {x = nil, y = nil, w=8, h=4}
	platforms[12] = {x = nil, y = nil, w=8, h=4}
	platforms[13] = {x = nil, y = nil, w=8, h=4}
	platforms[14] = {x = nil, y = nil, w=8, h=4}
	platforms[15] = {x = nil, y = nil, w=8, h=4}
	platforms[16] = {x = nil, y = nil, w=4, h=3}
	platforms[17] = {x = nil, y = nil, w=4, h=3}
	platforms[18] = {x = nil, y = nil, w=4, h=3}
	platforms[19] = {x = nil, y = nil, w=3, h=3}
	platforms[20] = {x = nil, y = nil, w=3, h=3}
	platforms[21] = {x = nil, y = nil, w=3, h=3}
	platforms[22] = {x = nil, y = nil, w=5.75, h=2}
	platforms[23] = {x = nil, y = nil, w=5.75, h=2}
	platforms[24] = {x = nil, y = nil, w=5.75, h=2}
	platforms[25] = {x = nil, y = nil, w=5, h=2}
	platforms[26] = {x = nil, y = nil, w=4, h=2}
	platforms[27] = {x = nil, y = nil, w=3, h=2}
	platforms[28] = {x = nil, y = nil, w=3, h=2}
	platforms[29] = {x = nil, y = nil, w=2, h=2}
	platforms[30] = {x = nil, y = nil, w=2, h=2}
	platforms[31] = {x = nil, y = nil, w=1.5, h=1.5}
	platforms[32] = {x = nil, y = nil, w=1.5, h=1.5}

	for i,platform in ipairs(platforms) do 	--This converts all the data given into scaled height
		platform.w = platform.w*scale 		--and width values, will let us use it more easily.
		platform.h = platform.h*scale 		--This currently prevents scale from being changed after love.load runs
	end

	love.graphics.setBackgroundColor(225,225,225) --Lets make things pretty

	fontLarge = love.graphics.newFont("OpenSans-Regular.ttf", 30) --Define some fonts
	fontMed = love.graphics.newFont("OpenSans-Regular.ttf", 18)
	fontSmall = love.graphics.newFont("OpenSans-Regular.ttf", 12)
	love.graphics.setFont(fontLarge)

	setPrompt('Welcome') 
end

function love.update(dt)
	--nothing needs to be done live (yet)
end

function setPrompt(string)
	prompting = 225
	prompt = string
end

function love.draw()
	love.graphics.setFont(fontLarge)

	--Draw the grid
	local height = love.graphics.getHeight()
	local width = love.graphics.getWidth()
	for i=0,math.floor(height/scale) do 			
		love.graphics.line(0,i*scale,width,i*scale)
		love.graphics.setColor(200, 200, 200)
	end
	for i=0,math.floor(width/scale) do
		love.graphics.line(i*scale,0,i*scale,height)
		love.graphics.setColor(200, 200, 200)
	end

	--Is there an active prompt? If so, display and fade it.
	if prompting > 0 then
		love.graphics.setColor(0,0,0,prompting)
		love.graphics.print(prompt, (love.graphics.getWidth()/2)-100, love.graphics.getHeight()/2)
		prompting = prompting - 2.5
		if prompting == 1 then
			prompt = ''
		end
	end

	--Display a graphic representing the active tool
	love.graphics.setColor(32, 180, 32)
	if shape == 'ln' then love.graphics.rectangle('fill',10,10,5,50) end
  	if shape == 'sq' then love.graphics.rectangle('line',10,10,50,50) end
  	if shape == 'tri' then love.graphics.rectangle('line',110,60,50,10) end

  	--Tell us the canvas size!
  	love.graphics.setColor(0,0,0)
  	love.graphics.setFont(fontMed)
  	love.graphics.print('Canvas size (W x H): '..(math.floor(width/scale))..' x '..(math.floor(height/scale)),70,10)

  	--Here's the section that draws boxes and lines. 
  	love.graphics.setFont(fontSmall)
  	love.graphics.setColor(0, 0, 0)
	local dragX, dragY = love.mouse.getPosition()
	for i,line in ipairs(lines) do
		if line.x2 == nil then 						--If an element has "nil" for its second coords, we must be dragging
			lineD(line.x1, line.y1, dragX, dragY)	--Therefore, draw the element with the coords equal to our drag values
		else
			lineD(line.x1, line.y1, line.x2, line.y2)
		end
	end
	for i,sq in ipairs(squares) do 
		if sq.x2 == nil then
			squareD(sq.x1, sq.y1, dragX, dragY)
		else
			squareD(sq.x1, sq.y1, sq.x2, sq.y2)
		end
	end
	love.graphics.setColor(0, 0, 0)

	--Key input section, not currently used.
	if keyInput == '' then
		love.graphics.print(curEntry, 5, 5, 0, 1.3)
		love.graphics.setColor(225, 225, 225)
	else
		love.graphics.print(keyInput, 5, 5, 0, 1.3)
		love.graphics.setColor(100, 225, 225)
	end

	--If we've decided to process platforms into the boxes
	--Draw all platforms that are fitting into boxes.
	if processing == true then 
		for i,platform in ipairs(platforms) do
			if platform.fit then
				love.graphics.setColor(100, 100, 100, 70)
				love.graphics.rectangle('fill',platform.fit.x+2,platform.fit.y+2,(platform.w)-4,(platform.h)-4)
				love.graphics.setColor(0, 0, 0)
				love.graphics.print((platform.w/scale)..'x'..(platform.h/scale), 
					(platform.fit.x) + (platform.w/2) - 14, 
					(platform.fit.y) + (platform.h/2) - 12)
			end
		end
	end
end

function lineD(x1,y1,x2,y2)  --function for drawing lines
	love.graphics.line(x1,y1,x2,y2)
	local pX, pY, r, dist = measPosDist(x1,y1,x2,y2)
	love.graphics.print(dist/scale, pX, pY, r)
end

function squareD(x1,y1,x2,y2) --function for drawing sqaures
	love.graphics.rectangle('line', x1, y1, (x2-x1), (y2-y1))

	local s1X, s1Y, s1r, s1dist = measPosDist(x1,y1,x1,y2)
	love.graphics.print(math.floor((s1dist/scale)+.5), s1X, s1Y, s1r)

	local s2X, s2Y, s2r, s2dist = measPosDist(x1,y1,x2,y1)
	love.graphics.print(math.floor((s2dist/scale)+.5), s2X, s2Y, s2r)
end

function love.mousepressed( x, y, btn ) --This handles all mouseclicks
	if snap == true then 				--if we're snapping (which is most of the time), then we snap the x and y values to the nearest box
		x = (math.floor((x/scale) + .5))*scale 
		y = (math.floor((y/scale) + .5))*scale
	end

												--For drawing, we first check if we're starting or completing an object 
	if drag == false then 						--starting an object, for either line or square, add a new table value
		if shape == 'ln' then
			lines[#lines+1] = {x1=x, y1=y, x2 = nil, y2 = nil}
		elseif shape == 'sq' then
			squares[#squares+1] = {x1=x, y1=y, x2 = nil, y2 = nil, f=false}
		end
		drag = true 
	elseif drag == true then 					--if we're finishing an object
		if shape == 'ln' then 					--get the object type
			for i, line in ipairs(lines) do 	--and fill the most recent table value with 
				if line.x2 == nil then
					line.x2, line.y2 = x, y
				end
			end
		elseif shape == 'sq' then
			for i, sq in ipairs(squares) do
				if sq.x2 == nil then
					sq.x2, sq.y2 = x, y
				end
			end
		end
		drag = false
	end
end

function measPosDist(x1,y1,x2,y2) 	--For a given line with (x1,y1) and (x2,y2)
	local midX = (x1+x2)/2			--returns midpoint with angle of line (rads), and length of line
	local midY = (y1+y2)/2

	local slope = (y2-y1)/(x2-x1)

	local angle = math.atan(slope)

	local rX = midX
	local rY = midY

	local distance = math.floor(math.sqrt((x2-x1)^2+(y2-y1)^2))

	return rX, rY, angle, distance
end

function process(box,platforms)
	table.sort(platforms, 
		function(a,b) 
			local areaA = a.h*a.w
			local areaB = b.h*b.w

			if sortMode == 'area' then
				return areaA > areaB
			elseif sortMode == 'height' then
				return a.h > b.h
			elseif sortMode == 'width' then
				return a.w > b.w
			else
				setPrompt('Error: sortMode not set')
				return areaA > areaB --default to area sort
			end
		end
		)
	for i,box in ipairs(box) do 					--for every square do
		if box.f == false then 						--if the box already has a given platform, don't do shit
			
			boxX = math.abs(box.x1-box.x2)/scale
			boxY = math.abs(box.y1-box.y2)/scale

			myPacker:init(box.x1, box.y1, boxX*scale, boxY*scale)
			myPacker:fit(platforms)

		end
	end
end

keys = {
    escape = love.event.quit,
}
function love.keypressed( key )
	if mode == 'draw' then
		if key == 's' then
			shape = 'sq'
			setPrompt('Square Tool')
		end
		if key == 'l' then
			shape = 'ln'
			setPrompt('Line Tool')
		end
		if key == 'p' then 					--Ensure they want to process
			if lastKey ~= 'p' then
				setPrompt('Press "P" again to confirm')
			else
				setPrompt('Processing')
				process(squares,platforms)
				processing = true
			end
		end
	end

	lastKey = key

    local action = keys[key]
    if action then  return action( key )  end
end
