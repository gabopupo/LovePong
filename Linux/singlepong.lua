Gamestate = require("hump.gamestate")

local singlepong = { }
local menu

function singlepong:init()
	menu = require "menu"
end

function singlepong:keypressed(key)                            
	if key == "escape" then   
                paused = not paused                               
        end                                            
end

function singlepong:keyreleased(key)                                      
        if (end_game or paused) and key == "return" then
                Gamestate.switch(menu)                 
        end
end

function singlepong:focus(f)
	if not f then
		paused = true
	else
		paused = false
	end
end

function singlepong:enter(state, dificul)
	width, height = love.window.getMode() -- dimensões da janela

	raq1 = love.graphics.newImage("media/paddle.jpg")
	raq2 = love.graphics.newImage("media/paddle.jpg")
	bola = love.graphics.newImage("media/ball.jpg")
	rede = love.graphics.newImage("media/net.png")
	pause = love.graphics.newImage("media/pause.png")

	gamefont = love.graphics.newFont("media/Square.ttf", 150)
	normalfont = love.graphics.newFont("media/Square.ttf", 30)

	pos1x = 8
	pos1y = height/2
	size1 = 0.3

	pos2x = width-8
	pos2y = pos1y
	size2 = size1

	posbolx = width/2 - 9.35
	posboly = height/2

	velbolx = 390
	velboly = 200

	posredx = width/2 - rede:getWidth() + 9.35
	posredy = -25
	
	service = 1
	ponto1 = 0
	ponto2 = 0
	
	waiting = true
	wtimer = 3

	paused = false
	end_game = false

	GO_UP = false
	GO_DOWN = false
	IA_dif = dificul
	change = false
end

function newRound()
	pos1y = height/2
	pos2y = pos1y

	posbolx = width/2 - 9.35
	posboly = height/2

	velbolx = 390
	velboly = 200

	waiting = true
	wtimer = 3

	GO_UP = false
	GO_DOWN = false
	change = false
end

function IA_mov(mov, err)
	if posbolx >= mov then
		if posboly-err < pos2y then
			GO_UP = true
			GO_DOWN = false
		elseif posboly-err > pos2y then
			GO_UP = false
			GO_DOWN = true
		end
	else
		if not change then
			GO_UP = true
			GO_DOWN = false
			if pos2y <= height/7 then change = true end
		else
			GO_UP = false
			GO_DOWN = true
			if pos2y >= 6*height/7 then change = false end
		end
	end
end

function singlepong:update(delta)
	if not paused and not end_game then
		wtimer = wtimer - delta
		if wtimer <= 0 then
			waiting = false
		end

		if not waiting then
			-- controle das raquetes
			if love.keyboard.isDown("w") and pos1y > (raq1:getWidth()/2) * size1 then
				pos1y = pos1y - 360*delta
			elseif love.keyboard.isDown("s") and pos1y < height - (raq1:getWidth()/2) * size1 then
				pos1y = pos1y + 360*delta
			end

			if GO_UP and pos2y > (raq2:getWidth()/2) * size2 then
				pos2y = pos2y - 360*delta
			elseif GO_DOWN and pos2y < height - (raq2:getWidth()/2) * size2 then
				pos2y = pos2y + 360*delta
			end
			
			-- física da bola
			if service == 1 then posbolx = posbolx - velbolx*delta
			elseif service == -1 then posbolx = posbolx + velbolx*delta end

			posboly = posboly - velboly*delta
			
			-- colisão com a parede de cima
			if posboly < 0 then
				velboly = -velboly
				posboly = 0
			end

			-- colisão com a parede de baixo
			if posboly > height - 20 then
				velboly = -velboly
				posboly = height - 20
			end

			-- colisão com a raquete da esquerda
			if posbolx > 0 and posbolx < 10 and math.abs(pos1y - posboly) < 41 then
				velbolx = -velbolx
				velboly = 390
				if love.keyboard.isDown("w") then
					if velboly < 0 then velboly = -velboly end
				elseif love.keyboard.isDown("s") then
					if velboly > 0 then velboly = -velboly end
				else
					velboly = 0
				end
				posrebat = posboly
				posbolx = 10				
			end

			-- entrou no gol da esquerda
			if posbolx < -10 then 
				ponto2 = ponto2 + 1 
				service = -1
				newRound() -- nova rodada
			end

			-- colisão com a raquete da direita
			if posbolx < width - 20 and posbolx > width - 30 and math.abs(pos2y - posboly) < 41 then
				velbolx = -velbolx
				velboly = 390
				if GO_UP then
					if velboly < 0 then velboly = -velboly end
				elseif GO_DOWN then
					if velboly > 0 then velboly = -velboly end
				else
					velboly = 0
				end
				posbolx = width - 30
			end
			
			-- entrou no gol da direita
			if posbolx > width + 10 then
				ponto1 = ponto1 + 1
				service = 1
				newRound() -- nova rodada
			end

			-- IA
			
			-- fácil
			if IA_dif == 1 then
				IA_mov(width/2 + 192, 22)
			end

			-- médio
			if IA_dif == 2 then
				IA_mov(width/2 - 40, 19)
			end

			-- difícil
			if IA_dif == 3 then
				IA_mov(0, 0)
			end

			-- fim de jogo
			if ponto1 == 10 or ponto2 == 10 then
				end_game = true
			end
		end
	end
end

function singlepong:draw()
	if not end_game then
		if not paused then love.graphics.setColor(255, 255, 255)
		else love.graphics.setColor(255, 255, 255, 40) end

		love.graphics.draw(raq1, pos1x, pos1y, math.pi/2, size1, 1, raq1:getWidth()/2, raq1:getHeight()/2)
		love.graphics.draw(raq2, pos2x, pos2y, math.pi/2, size2, 1, raq2:getWidth()/2, raq2:getHeight()/2)
		love.graphics.draw(bola, posbolx, posboly)
		love.graphics.draw(rede, posredx, posredy, 0, 1, 2, 0, 0)

		love.graphics.setFont(gamefont)
		if not paused then love.graphics.setColor(255, 255, 255, 100)
		else love.graphics.setColor(255, 255, 255, 40) end

		love.graphics.print(ponto1, width/4 + 3, height/4 + 73)
		love.graphics.print(ponto2, 3*width/4 - 88, height/4 + 73)

		if waiting then
			love.graphics.setFont(normalfont)
			if service == 1 then
				love.graphics.printf("<", width/2 - 40, height/3, width, "left")
			elseif service == -1 then
				love.graphics.printf(">", width/2 + 30, height/3, width, "left")
			end
			if not paused then
				love.graphics.setFont(gamefont)
				love.graphics.setColor(77, 77, 77)
				love.graphics.rectangle("fill", width/4 + 144, height/4 + 97, (pause:getWidth()/2) + 20, (pause:getHeight()/2) + 20)
				love.graphics.setColor(255, 255, 255)
				love.graphics.printf(math.ceil(wtimer), 0, height/4 + 73, width, "center")
			end
		end

		if paused then
			love.graphics.setColor(77, 77, 77)
			love.graphics.rectangle("fill", width/4 + 144, height/4 + 97, (pause:getWidth()/2) + 20, (pause:getHeight()/2) + 20)
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(pause, width/4 + 154, height/4 + 107, 0, 0.5, 0.5, 0, 0)
		end	
	else
		love.graphics.setFont(normalfont)

		love.graphics.printf("GAME OVER!", 0, height/4, width, "center")
		love.graphics.printf(ponto1 .. " v " .. ponto2, 0, height/4 + 28, width, "center")
		if (ponto1 == 10) then
			love.graphics.printf("O jogador 1 é o vencedor!", 0, height/2, width, "center")
		else
			love.graphics.printf("O jogador 2 é o vencedor!", 0, height/2, width, "center")	
		end
		love.graphics.printf("Aperte ENTER para ir ao menu principal", 0, 3*height/4, width, "center")
	end
end

return singlepong 
