--PARA DEBUGGAR, USAR ISSO NA LINHA - BREAKPOINT
--require('mobdebug').start()


function love.load()

  musicIntro = love.audio.newSource("sngs/Carefree.mp3")
  musicGame = love.audio.newSource("sngs/Life_of_Riley.mp3")


  musicIntro:play()
  
  
  love.window.setTitle("Espresson Caffè v0.3.9")

  icon = love.image.newImageData("imgs/icon.png")
  love.window.setIcon(icon)

  dialogBox = love.graphics.newImage("imgs/dialog.png")

  --background Inicial
  bgMain = love.graphics.newImage("imgs/bgMain.png")
  bg1 = love.graphics.newImage("imgs/bgMain.png")
  bgFases = love.graphics.newImage("imgs/bgFases.png")
  glow = love.graphics.newImage("imgs/glowBlue.png")
  cozinha = love.graphics.newImage("imgs/cenariosophie.png")
  --sophie = love.graphics.newImage("imgs/sophie.png")
  maquina = love.graphics.newImage("imgs/maquina.png")
  xicara = love.graphics.newImage("imgs/xicara.png")
   
    
  desvanecer = 0 -- Fade da CS de abertura

  --Fontes
  fonteDialogo = love.graphics.newFont("fnts/clBold.ttf", 20 )
  fonteTitulo = love.graphics.newFont("fnts/clBold.ttf", 50 )
  --Fim

  fase = 0

  --Variavel de controle de posição da linha de dialogo
  posicaoFala = 0
  --fim

  tempoExtraindo = 0
  volumeXicara = 0

  pontuacaoConseguida = 0
  pontuacaoConseguidaMaxima = 0

  exibirPontuacao = false
  pararTempo = false
  voltaMenu = false

  --Imagem da pontuação
  nobean = love.graphics.newImage("imgs/no-bean.png")
  bean = love.graphics.newImage("imgs/bean.png")
end

function love.update(dt)

  if fase == 0 and love.mouse.isDown(1) then
    fase = 1
    love.graphics.setBackgroundColor(0,0,0)
    
    if not musicGame:isPlaying() then      
      musicIntro:stop()
      musicGame:play()
    end
    
  end
  
  if fase == 1 then
    CSintro(dt)
    
    if not musicGame:isPlaying() then      
      musicIntro:stop()
      musicGame:play()
    end
  end
  
  if fase == 2 then
    CSSelecaoFase(dt)
    
    if not musicGame:isPlaying() then      
      musicIntro:stop()
      musicGame:play()
    end
  end

  if fase == 3 then
    GameInteration(dt)
    
    if not musicGame:isPlaying() then      
      musicIntro:stop()
      musicGame:play()
    end
  end

end


function love.draw()   
  if fase == 0 then
    DesenhaTelaInicial()
  end
  if fase == 1 then
    DesenhaInicioTutorial()
  end
  if fase == 2 then
    DesenhaEscolhaFase()
  end
  if fase == 3 then
    tempo = 0
    DesenhaFase1()
  end
end

---Funcoes de Draw

-- Tela de abertura
function DesenhaTelaInicial()

  love.graphics.setBackgroundColor(255,255,255)

  --love.graphics.draw(bgMain,1,1)
  love.graphics.draw(bg1,1,1)

end

function DesenhaInicioTutorial()

  if(desvanecer > 255) then
    desvanecer = 255
  end

  love.graphics.setBackgroundColor(desvanecer,desvanecer,desvanecer)

  if(desvanecer >= 250) then
    love.graphics.setColor(255,255,255) 
    
    love.graphics.draw(cozinha,1,1)
    --love.graphics.draw(sophie,100,1)
    DesenhaDialogo(posicaoFala)

    if posicaoFala > 13 then
      fase = 2
      desvanecer = 0
    end
  end


end



function DesenhaEscolhaFase()

  if(desvanecer > 255) then
    desvanecer = 255
  end

  love.graphics.setBackgroundColor(desvanecer,desvanecer,desvanecer)

  if(desvanecer >= 250) then
    
    love.graphics.draw(bgFases,1,1)
    
    love.graphics.setColor(0,0,0) 
    love.graphics.setFont(fonteDialogo)
    love.graphics.print("Fase 1 - Expresso", 180, 150)    

    love.graphics.setColor(255,255,255) 

    local cafesConseguidos = pontuacaoConseguidaMaxima
    local desenhaConseguido = false

    for i = 0, 4, 1 do
      local xIncremental = 35 * i

      if(i < cafesConseguidos) then
        desenhaConseguido = true
      else
        desenhaConseguido = false
      end

      if(desenhaConseguido == true) then
        love.graphics.draw(bean,450 + xIncremental,145)  
      else 
        love.graphics.draw(nobean,450 + xIncremental,145)  
      end

    end

   love.graphics.setColor(50,50,50) 

    love.graphics.print("Fase 2 - Longo", 180, 220)
    love.graphics.print("Fase 3 - Ristretto", 180, 290)
    love.graphics.print("Fase 4 - Latte", 180, 360)
    love.graphics.print("Fase 5 - Cappuccino", 180, 430)
    love.graphics.setColor(255,255,255) 
    
    love.graphics.rectangle("line", 160, 140, 480, 40)
  end


end  


function DesenhaFase1()

  love.graphics.setBackgroundColor(255, 255, 255)

  love.graphics.draw(maquina,1,60)
  love.graphics.draw(xicara,380,350)

  if(pararTempo == false) then 
    tempo = love.timer.getTime() - inicioTemporizador
  end

  love.graphics.setColor(0,0,0)
  love.graphics.setFont(fonteDialogo)
  love.graphics.print("Fazendo Espresso", 350, 50)
  love.graphics.print(string.format("Tempo real: %d segundos",tempo), 530, 10)
  love.graphics.print(string.format("Tempo extraindo: %d segundos", tempoExtraindo*6), 30, 10)
  love.graphics.print(string.format("Xicara: %d ml", volumeXicara), 370, 320)
  love.graphics.setColor(255,255,255)

  love.graphics.setColor(0,0,255)
  love.graphics.rectangle("line", 320, 480, 200, 70)

  love.graphics.setColor(0,0,0)
  love.graphics.print("Pronto!", 375, 505)

  love.graphics.setColor(255,255,255)
  love.graphics.draw(glow,131,117)
  love.graphics.draw(glow,420,117)
  --(x >= 160 and x <= 710) and (y >= 140 and y <= 180)
  
  
  love.graphics.setColor(255,255,255)
  if(exibirPontuacao) then

    if(pontuacaoConseguida == 5) then
      DesenhaDialogo(-5)

    elseif (pontuacaoConseguida == 4) then
      DesenhaDialogo(-4)

    elseif (pontuacaoConseguida == 3) then
      DesenhaDialogo(-3)

    elseif (pontuacaoConseguida == 2) then
      DesenhaDialogo(-2)

    elseif (pontuacaoConseguida == 1) then
      DesenhaDialogo(-1)

    elseif (pontuacaoConseguida == 0) then
      DesenhaDialogo(-0)

    end 

    if(pontuacaoConseguida > pontuacaoConseguidaMaxima) then
      pontuacaoConseguidaMaxima = pontuacaoConseguida
    end

    voltaMenu = true

  end

  love.graphics.setColor(255,255,255)
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

--Cutscene inicial
function CSintro(dt)

  if(desvanecer <= 255) then --De escuro pra claro
    desvanecer = desvanecer + 100*dt
  end

end

function CSSelecaoFase(dt)

  if(desvanecer <= 255) then --De escuro pra claro
    desvanecer = desvanecer + 170*dt
  end

end

function GameInteration(dt)

--love.graphics.rectangle("fill", 600, 140, 30, 100)  

  if love.mouse.isDown(1) and (love.mouse.getX() >= 200 and love.mouse.getX() <= 630) 
  and (love.mouse.getY() >= 180 and love.mouse.getY() <= 250) then
    tempoExtraindo = (tempoExtraindo + dt)
  end

end


function love.mousepressed(x, y, button, istouch)
  if button == 1 and fase == 1 then 
    posicaoFala = posicaoFala + 1; 
  end

  --Inicia jogo
  if button == 1 and fase == 2 and (x >= 160 and x <= 710) and (y >= 140 and y <= 180) then 
    fase = 3; 
    inicioTemporizador = love.timer.getTime()    

    resetaVariaveis()
  end

 --love.graphics.draw(xicara,380,350)
 
  if button == 1 and fase == 3 and (love.mouse.getX() >= 380 and love.mouse.getX() <= 480) 
  and (love.mouse.getY() >= 350 and love.mouse.getY() <= 450) then  

    if volumeXicara < 40 then 
      volumeXicara = (volumeXicara + 15)
    else
      volumeXicara = 50
    end
  end

  --love.graphics.rectangle("line", 320, 480, 200, 70)

  if button == 1 and fase == 3 and (love.mouse.getX() >= 320 and love.mouse.getX() <= 520) 
  and (love.mouse.getY() >= 480 and love.mouse.getY() <= 550) then  

    calculaPontuacao()
    exibirPontuacao = true
    pararTempo = true

  end

  --Volta pro menu
  if button == 1 and fase == 3 and voltaMenu == true then  

    fase = 2

  end
end

function calculaPontuacao()

  if(fase == 3) then
    --require('mobdebug').start()
    --Ideais
    local extracaoMaxima = 31
    local extracaoMinima = 20      
    local xicaraIdeal = 50

    --Do jogador
    local minhaExtracao = tempoExtraindo * 6
    local minhaXicara = volumeXicara   

    local conseguiuExtracao = (minhaExtracao >= extracaoMinima and minhaExtracao <= extracaoMaxima ) and
    (minhaXicara == xicaraIdeal)

    if (minhaExtracao == 0 or minhaXicara == 0) then
      pontuacaoConseguida = 0

    elseif conseguiuExtracao and (minhaXicara == xicaraIdeal) and tempo < 30 then
      pontuacaoConseguida = 5

    elseif conseguiuExtracao and (minhaXicara < xicaraIdeal) and tempo < 40 then
      pontuacaoConseguida = 4   

    elseif (conseguiuExtracao or (minhaXicara == xicaraIdeal)) and tempo < 60 then
      pontuacaoConseguida = 3

    elseif (conseguiuExtracao == false and (minhaXicara < xicaraIdeal)) and tempo < 60 then
      pontuacaoConseguida = 2   

    elseif (conseguiuExtracao == false and (minhaXicara < xicaraIdeal)) and tempo < 70 then
      pontuacaoConseguida = 1     

    else 
      pontuacaoConseguida = 0  
    end 

  end
end

function resetaVariaveis()

  exibirPontuacao = false
  pararTempo = false
  voltaMenu = false
  tempoExtraindo = 0
  volumeXicara = 0

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