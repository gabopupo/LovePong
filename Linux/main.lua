Gamestate = require "hump.gamestate"

local menu, multipong

function love.load()
	menu = require "menu"
	multipong = require "multipong"
	Gamestate.registerEvents()
	Gamestate.switch(menu)
end
