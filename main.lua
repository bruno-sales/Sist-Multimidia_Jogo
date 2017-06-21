--PARA DEBUGGAR, USAR ISSO NA LINHA - BREAKPOINT
--require('mobdebug').start()


function love.load()

  --musicFight = love.audio.newSource("Songs/Exhilarate.mp3")

  love.window.setTitle("Espresson Caffè v0.3.3")

  icon = love.image.newImageData("imgs/icon.png")
  love.window.setIcon(icon)

  dialogBox = love.graphics.newImage("imgs/dialog.png")

  --background Inicial
  bg1 = love.graphics.newImage("imgs/open.png")
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

  exibirPontuacao = false
  pararTempo = false
  
  --Imagem da pontuação
  nobean = love.graphics.newImage("imgs/no-bean.png")
end

function love.update(dt)

  if fase == 0 and love.mouse.isDown(1) then
    fase = 1
    love.graphics.setBackgroundColor(0,0,0)
  end
  if fase == 1 then
    CSintro(dt)
  end
  if fase == 2 then
    CSSelecaoFase(dt)
  end

  if fase == 3 then
    GameInteration(dt)
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

    if posicaoFala >= 13 then
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
    love.graphics.setColor(0,0,0) 
    love.graphics.setFont(fonteDialogo)
    love.graphics.print("Fase 1 - Expresso", 180, 150)    

    love.graphics.setColor(255,255,255) 
    love.graphics.draw(nobean,400,145)  
    love.graphics.draw(nobean,435,145)  
    love.graphics.draw(nobean,470,145)  
    love.graphics.draw(nobean,505,145)  
    love.graphics.draw(nobean,540,145)    
    love.graphics.setColor(0,0,0) 

    love.graphics.print("Fase 2 - Outro Café", 180, 220)
    love.graphics.print("Fase 3 - Outro Café", 180, 290)
    love.graphics.print("Fase 4 - Outro Café", 180, 360)
    love.graphics.print("Fase 5 - Outro Café", 180, 420)

    love.graphics.rectangle("line", 160, 140, 430, 40)
  end


end  


function DesenhaFase1()

  love.graphics.setBackgroundColor(255,255,255)

  --love.graphics.draw(bg1,80,30)

  if(pararTempo == false) then 
    tempo = love.timer.getTime() - inicioTemporizador
  end
  
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(fonteDialogo)
  love.graphics.print("Fazendo Espresso", 300, 200)
  love.graphics.print(string.format("Tempo real: %d segundos",tempo), 500, 20)
  love.graphics.print(string.format("Tempo extraindo: %d segundos", tempoExtraindo*6), 500, 60)
  love.graphics.print(string.format("Xicara: %d ml", volumeXicara), 20, 20)
  love.graphics.setColor(255,255,255)

  love.graphics.setColor(255,0,0)
  love.graphics.rectangle("fill", 600, 140, 30, 100)  

  love.graphics.setColor(0,255,0)
  love.graphics.rectangle("fill", 50, 140, 30, 80)  

  love.graphics.setColor(0,0,255)
  love.graphics.rectangle("fill", 350, 500, 200, 70)

  love.graphics.setColor(255,255,255)
  love.graphics.print("Pronto!", 400, 530)

  love.graphics.setColor(0,0,0)
  if(exibirPontuacao) then

    if(pontuacaoConseguida == 5) then
      love.graphics.print("Surpreendente! 5 pontos! Seu café está ótimo! Você parece ter o dom para a coisa!", 30, 400)

    elseif (pontuacaoConseguida == 4) then
      love.graphics.print("Hm! Pontuação 4. Quase lá. Tá faltando alguma coisa...", 30, 400)

    elseif (pontuacaoConseguida == 3) then
      love.graphics.print("Pontuação 3. Você errou em alguma coisinha. Alguns clientes podem reclamar", 30, 400)

    elseif (pontuacaoConseguida == 2) then
      love.graphics.print("Parece faltar algo. Pontuação 2. Tente novamente.", 30, 400)

    elseif (pontuacaoConseguida == 1) then
      love.graphics.print("Hmmm, pontuação 1. Não está em um nível aceitável, preste mais atenção e tente novamente", 30, 400)

    elseif (pontuacaoConseguida == 0) then
      love.graphics.print("Uh-oh, sua pontuação foi 0. Certeza que quer trabalhar aqui?", 30, 400)

    end 

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

  if love.mouse.isDown(1) and (love.mouse.getX() >= 600 and love.mouse.getX() <= 630) 
  and (love.mouse.getY() >= 140 and love.mouse.getY() <= 240) then
    tempoExtraindo = (tempoExtraindo + dt)
  end

end


function love.mousepressed(x, y, button, istouch)
  if button == 1 and fase == 1 then 
    posicaoFala = posicaoFala + 1; 
  end

  if button == 1 and fase == 2 and (x >= 160 and x <= 660) and (y >= 140 and y <= 180) then 
    fase = 3; 
    inicioTemporizador = love.timer.getTime()
  end

  if button == 1 and fase == 3 and (love.mouse.getX() >= 50 and love.mouse.getX() <= 80) 
  and (love.mouse.getY() >= 140 and love.mouse.getY() <= 240) then  

    if volumeXicara < 40 then 
      volumeXicara = (volumeXicara + 15)
    else
      volumeXicara = 50
    end
  end

  if button == 1 and fase == 3 and (love.mouse.getX() >= 350 and love.mouse.getX() <= 550) 
  and (love.mouse.getY() >= 500 and love.mouse.getY() <= 570) then  

    calculaPontuacao()
    exibirPontuacao = true
    pararTempo = true

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

    if (minhaExtracao == 0 or minhaExtracao == 0) then
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