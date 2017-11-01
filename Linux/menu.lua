Gamestate = require "hump.gamestate"

local singlepong
local multipong
local menu = { }
local dificul = { }
local control = { }
local creditos = { }

function menu:init()
	singlepong = require "singlepong"
	multipong = require "multipong"

	titlefont = love.graphics.newFont("media/Square.ttf", 220)
	optfont = love.graphics.newFont("media/Square.ttf", 30)
	width, height = love.window.getMode()
end

function menu:enter()
	poscursor = height/2
	cursorPressed = { }
end

function menu:update(delta)
	if cursorPressed["w"] or cursorPressed["up"] then
		if poscursor < height/2 + 40 then
			poscursor = height/2 + 160
		else
			poscursor = poscursor - 40
		end
		cursorPressed["w"] = false
		cursorPressed["up"] = false
	elseif cursorPressed["s"] or cursorPressed["down"] then
		if poscursor > height/2 + 120 then
			poscursor = height/2
		else
			poscursor = poscursor + 40
		end
		cursorPressed["s"] = false
		cursorPressed["down"] = false
	end
end

function love.keyreleased(key)
	if key == "w" then
		cursorPressed["w"] = true
	elseif key == "s" then
		cursorPressed["s"] = true
	elseif key == "up" then
		cursorPressed["up"] = true
	elseif key == "down" then
		cursorPressed["down"] = true
	elseif key == "return" then
		if Gamestate.current() == menu then
			if poscursor == height/2 then
				Gamestate.switch(dificul)
			elseif poscursor == height/2 + 40 then
				Gamestate.switch(multipong)
			elseif poscursor == height/2 + 80 then
				Gamestate.switch(control)
			elseif poscursor == height/2 + 120 then
				Gamestate.switch(creditos)
			elseif poscursor == height/2 + 160 then
				love.event.quit()
			end
		elseif Gamestate.current() == dificul then
			if poscursor == height/2 then
				Gamestate.switch(singlepong, 1)
			elseif poscursor == height/2 + 40 then
				Gamestate.switch(singlepong, 2)
			elseif poscursor == height/2 + 80 then
				Gamestate.switch(singlepong, 3)
			elseif poscursor == height/2 + 160 then
				Gamestate.switch(menu)
			end
		elseif Gamestate.current() == control then
			Gamestate.switch(menu)
		elseif Gamestate.current() == creditos then
			Gamestate.switch(menu)
		end
	end
end

function menu:draw()
	love.graphics.setFont(titlefont)
	love.graphics.setColor(77, 77, 77)
	love.graphics.printf("PONG", 0, height/4 - 130, width, "center")

	love.graphics.setFont(optfont)
	love.graphics.printf(">", -130, poscursor, width, "center")
	love.graphics.printf("1 jogador", 0, height/2, width, "center")
	love.graphics.printf("2 jogadores", 0, height/2 + 40, width, "center")
	love.graphics.printf("Controles", 0, height/2 + 80, width, "center")
	love.graphics.printf("Créditos", 0, height/2 + 120, width, "center")
	love.graphics.printf("Sair", 0, height/2 + 160, width, "center")
end

function dificul:init()
	menu = require "menu"
	singlepong = require "singlepong"

	titlefont = love.graphics.newFont("media/Square.ttf", 220)
	optfont = love.graphics.newFont("media/Square.ttf", 30)
	width, height = love.window.getMode()
end

function dificul:enter()
	poscursor = height/2
	cursorPressed = { }
end

function dificul:update(delta)
	if cursorPressed["w"] or cursorPressed["up"] then
		if poscursor < height/2 + 40 then
			poscursor = height/2 + 160
		else
			poscursor = poscursor - 40
			if poscursor == height/2 + 120 then
				poscursor = poscursor - 40
			end
		end
		cursorPressed["w"] = false
		cursorPressed["up"] = false
	elseif cursorPressed["s"] or cursorPressed["down"] then
		if poscursor > height/2 + 120 then
			poscursor = height/2
		else
			poscursor = poscursor + 40
			if poscursor == height/2 + 120 then
				poscursor = poscursor + 40
			end
		end
		cursorPressed["s"] = false
		cursorPressed["down"] = false
	end
end

function dificul:draw()
	love.graphics.setFont(titlefont)
	love.graphics.setColor(77, 77, 77)
	love.graphics.printf("PONG", 0, height/4 - 130, width, "center")

	love.graphics.setFont(optfont)
	love.graphics.printf(">", -130, poscursor, width, "center")
	love.graphics.printf("Fácil", 0, height/2, width, "center")
	love.graphics.printf("Médio", 0, height/2 + 40, width, "center")
	love.graphics.printf("Difícil", 0, height/2 + 80, width, "center")
	love.graphics.printf("Voltar", 0, height/2 + 160, width, "center")
end

function control:init()
	menu = require "menu"

	textfont = love.graphics.newFont("media/Square.ttf", 30)
	width, height = love.window.getMode()
end

function control:draw()
        love.graphics.setFont(textfont)
        love.graphics.printf("1 jogador:\n\"w\" para mover a raquete para cima\n\"s\" para mover a raquete para baixo\n\n2 jogadores:\n(jogador 1)\n\"w\" para mover a raquete para cima\n\"s\" para mover a raquete para baixo\n\n(jogador 2)\nseta para cima para mover a raquete para cima\nseta para baixo para mover a raquete para baixo\n\n\"ESC\" para pausar", 0, 20, width, "center")

        love.graphics.printf("Aperte ENTER para ir ao menu principal", 0, height - 70, width, "center")
end

function creditos:init()
        menu = require "menu"

        textfont = love.graphics.newFont("media/Square.ttf", 30)
        width, height = love.window.getMode()
end

function creditos:draw()
        love.graphics.setFont(textfont)
        love.graphics.printf("desenvolvimento & arte\nGabriel Silveira Pupo\n\nFonte \"SquareFont\" criada por\nBou Fonts\n\nEste jogo utiliza o framework Löve2d\n(c) 2006-2016 LÖVE Development Team\n\nEste jogo utiliza a biblioteca HUMP\n(c) 2011-2015 Matthias Richter", 0, 40, width, "center")

        love.graphics.printf("Aperte ENTER para ir ao menu principal", 0, height - 70, width, "center")
end

return menu
