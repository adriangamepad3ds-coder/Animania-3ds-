
local tiempoTranscurrido = 0
local cancionIniciada = false
local cambioAltEjecutado = false
local animacionDisparada = false
local animacionTerminada = false

function onCreate()
    makeAnimatedLuaSprite('bfcondon_layer', 'characters/extraAnims/bfcondon', 1335, 585)
    addAnimationByPrefix('bfcondon_layer', 'dance', 'bopeebo animation', 24, false)
    scaleObject('bfcondon_layer', 3.50, 3.50)
    setProperty('bfcondon_layer.visible', false)
    addLuaSprite('bfcondon_layer', true)
end

function onSongStart()
    cancionIniciada = true
end

function onUpdate(elapsed)
    if not cancionIniciada then
        return
    end

    tiempoTranscurrido = tiempoTranscurrido + elapsed

    if not cambioAltEjecutado and tiempoTranscurrido >= 52 then
        cambioAltEjecutado = true
        triggerEvent('Change Character', 'bf', 'bf-alt')
    end

    if not animacionDisparada and tiempoTranscurrido >= 72 then
        animacionDisparada = true

        setProperty('boyfriend.visible', false)
        setProperty('bfcondon_layer.visible', true)
        objectPlayAnimation('bfcondon_layer', 'dance', true)
    end

    if animacionDisparada and not animacionTerminada and tiempoTranscurrido >= 75 then
        animacionTerminada = true

        removeLuaSprite('bfcondon_layer', true)
        triggerEvent('Change Character', 'bf', 'bf_animania')
        setProperty('boyfriend.visible', true)
    end
end
