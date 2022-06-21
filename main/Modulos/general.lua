require("main.Modulos.serialize")

play = function (url, foo)
  local t = ser.load("config")
  sound.play(url, {speed = t.velocidade, gain = t.volume}, foo)
end


play_correct = function (foo)
  local t = ser.load("config")
  sound.play('/UI#correto', {speed = t.velocidade, gain = t.volume * 4}, foo)
end

play_wrong = function (foo)
  local t = ser.load("config")
  sound.play('/UI#errado', {speed = t.velocidade, gain = t.volume * 3}, foo)
end

play_vamos = function (foo)
  local t = ser.load("config")
  sound.play('/UI#vamos la', {speed = t.velocidade, gain = t.volume}, foo)
end

play_coisas = function (foo)
  local t = ser.load("config")
  sound.play('/UI#coisas dificeis', {speed = t.velocidade, gain = t.volume}, foo)
end

play_e = function (foo)
  local t = ser.load("config")
  sound.play('/UI#e', {speed = t.velocidade, gain = t.volume}, foo)
end

play_pressione = function (foo)
  local t = ser.load("config")
  sound.play('/UI#pressione', {speed = t.velocidade, gain = t.volume}, foo)
end



keys = {
  CLIQUE = hash("clique"),
  CIMA = hash("cima"),
  BAIXO = hash("baixo"),
  ESQUERDA = hash("esquerda"),
  DIREITA = hash("direita"),
  PRESS = hash("press"),
  ESC = hash("esc"),
  TYPE = hash("type")
}

urls = {
  MENU_INICIAL = msg.url("menu_inicial:/Menu#MenuInicial"),
  FASE = msg.url("fase:/level"),
  MANAGER = msg.url("manager:/manager")
}

msgs = {
  START = hash("start"),
  LOAD_FASE = hash("load_fase"),
  LOAD_MENU_INICIAL = hash("menu_inicial"),
  ENSINO_DADO = hash("ensino_dado")
}

pressiona = function(node)
  gui.play_flipbook(node, "botao pressionado")
end

solta = function(node)
  gui.play_flipbook(node, "botao solto")
end


toca_som = function(audio)
  play(audio)
end

seleciona = function(node)
  gui.play_flipbook(node, "botao selecionado")
end

menu = {
  first_time_menu = function (node)
    seleciona(node)
  end,

  key_move = function(selecao, pressionado, id, action, foos, nodes, audios)
    assert(type(foos) == "table", "foos tem q ser tabela")
    assert(type(nodes) == "table", "foos tem q ser tabela")

    local max
    local troca_menu
    for i = 1, #nodes do max = i end
    
    if action.pressed then
      if id == keys.CIMA then
        if selecao == 1 then
          selecao = max
        else
          selecao = selecao - 1
        end
      
      elseif id == keys.BAIXO then
        if selecao == max then
          selecao = 1
        else
          selecao = selecao + 1
        end

      elseif id == keys.PRESS then
        pressiona(nodes[selecao])
        troca_menu = foos[selecao]()

        if troca_menu then
          selecao = 1
          pressionado = false
          return selecao, pressionado
        end

        pressionado = true
      
    -- toda a função de voltar deve ser a última da tabela
      elseif id == keys.ESC then
        foos[#foos]()
        
        selecao = 1
        pressionado = false
        return selecao, pressionado
      end

    elseif action.released then
      if id == keys.PRESS then
        pressionado = false
      end
    end
    
    if not pressionado then 
      seleciona(nodes[selecao])
      
      if not action.released then
        if selecao == max then
          sound.stop(audios[selecao - 1])
          sound.stop(audios[1])

        elseif selecao == 1 then
          sound.stop(audios[max])
          sound.stop(audios[selecao + 1])

        else
          sound.stop(audios[selecao - 1])
          sound.stop(audios[selecao + 1])
        end

        toca_som(audios[selecao])
    end
    end

    for i in ipairs(nodes) do
      if nodes[i] ~= nodes[selecao] then solta(nodes[i]) end
    end

    return selecao, pressionado
  end
}