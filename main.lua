--PARA DEBUGGAR, USAR ISSO NA LINHA - BREAKPOINT
--require('mobdebug').start()


function love.load()

  --musicFight = love.audio.newSource("Songs/Exhilarate.mp3")

  love.window.setTitle("Espresson Caffè v0.2.3")

  icon = love.image.newImageData("imgs/icon.png")
  love.window.setIcon(icon)

  dialogBox = love.graphics.newImage("imgs/dialog.png")

  --background Inicial
  bg1 = love.graphics.newImage("imgs/open.png")
  desvanecer = 0 -- Fade da CS de abertura
  pyTexto = 600

  --Fontes
  fonteDialogo = love.graphics.newFont("fnts/clBold.ttf", 20 )
  fonteTitulo = love.graphics.newFont("fnts/clBold.ttf", 50 )
  --Fim
  
  fase = 0

  --Variavel de controle de posição da linha de dialogo
  posicaoFala = 0
  --fim

end

function love.update(dt)
  
  if fase == 0 and love.mouse.isDown(1) then
    fase = 1
    love.graphics.setBackgroundColor(0,0,0)
	end
  if fase == 1 then
    CSintro(dt)
   end
end


function love.draw()   
  if fase == 0 then
      DesenhaTelaInicial()
  end
  if fase == 1 then
      DesenhaInicioTutorial()
  end
end

---Funcoes de Draw

-- Tela de abertura
function DesenhaTelaInicial()

  love.graphics.setBackgroundColor(255,255,255)

  love.graphics.draw(bg1,80,30)
  
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(fonteTitulo)
  love.graphics.print("Clique para Iniciar", 230, 350)
  love.graphics.setColor(255,255,255)

end

function DesenhaInicioTutorial()
  
  if(desvanecer > 255) then
    desvanecer = 255
  end
    
  love.graphics.setBackgroundColor(desvanecer,desvanecer,desvanecer)
   
  if(desvanecer >= 250) then
    love.graphics.setColor(255,255,255) 
  
    DesenhaDialogo(posicaoFala)
  end


end

--Desenho da caixa de texto
function DesenhaDialogo(identificador)

  local autor,texto = LoadFalas(identificador)

  love.graphics.draw(dialogBox,10,450)
  love.graphics.setFont(fonteDialogo)
  love.graphics.print(autor,40,450)
  love.graphics.printf(texto,40,500,600,'left')    

end
---Fim

function love.mousepressed(x, y, button, istouch)
   if button == 1 and fase == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
      posicaoFala = posicaoFala + 1; 
   end
end

--Cutscene inicial
function CSintro(dt)

  if(desvanecer <= 255) then --De escuro pra claro
    desvanecer = desvanecer + 100*dt
  end

end

--Carrega fala de acordo com o identificador
function LoadFalas(numeroLinha)
  local file = io.open("txts/falas.txt")
  local autor = ""
  local texto = ""

  for line in file:lines() do
    local idLinha = "$#"..numeroLinha

    if(string.find(line, idLinha,1,true)) then

      local index = string.find(line, "&%",1,true) --Obtem a posicao do identificador de autor
      local Findex = string.find(line, idLinha,1,true) --Obtem a posicao do identificador de texto

      autor = line:sub(1,index-1) --O autor será do inicio até a posicação do identificador -1
      --O texto será do identificador do identificador de autor + 2 (Index guarda posicao do &, então, index+2, por ser "$%") até o identificador de texto -1   
      texto = line:sub(index+2,Findex-1) 
      break

    end
  end

  file:close()
  return autor,texto
end