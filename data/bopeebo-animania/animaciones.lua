local condonX = 1457
local condonY = 560
local condonScale = 3.29
local tiempoTranscurrido = 0
local cancionIniciada = false
local cambioAltEjecutado = false
local animacionDisparada = false
local animacionTerminada = false

function onCreate()
    makeAnimatedLuaSprite('bfcondon_layer', 'characters/extraAnims/bfcondon', condonX, condonY)
    addAnimationByPrefix('bfcondon_layer', 'dance', 'bopeebo animation', 24, false)
    scaleObject('bfcondon_layer', condonScale, condonScale)
    setObjectCamera('bfcondon_layer', 'camGame')
    setProperty('bfcondon_layer.visible', false)
    addLuaSprite('bfcondon_layer', true)
end

function onSongStart()
    cancionIniciada = true
end

function onUpdate(elapsed)
    if not cancionIniciada then return end
    tiempoTranscurrido = tiempoTranscurrido + elapsed

    if not cambioAltEjecutado and tiempoTranscurrido >= 52 and tiempoTranscurrido < 72 then
        cambioAltEjecutado = true
    end

    if not animacionDisparada and tiempoTranscurrido >= 72 then
        animacionDisparada = true
        cambioAltEjecutado = false 
        setProperty('boyfriend.visible', false)
        setProperty('boyfriend.stunned', true) 
        setObjectOrder('bfcondon_layer', getObjectOrder('boyfriend') + 1)
        setProperty('bfcondon_layer.visible', true)
        objectPlayAnimation('bfcondon_layer', 'dance', true)
        runTimer('terminarCondonTimer', 5.0)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'terminarCondonTimer' then
        animacionTerminada = true
        removeLuaSprite('bfcondon_layer', true)
        setProperty('boyfriend.visible', true)
        setProperty('boyfriend.stunned', false) 
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if animacionDisparada and not animacionTerminada then return end
    if cambioAltEjecutado and playByboyfriend then ejecutarAnimacionAlt(noteData, false) end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if animacionDisparada and not animacionTerminada then return end
    if cambioAltEjecutado then ejecutarAnimacionAlt(noteData, false) end
end

function noteMiss(id, noteData, noteType, isSustainNote)
    if animacionDisparada and not animacionTerminada then return end
    if cambioAltEjecutado then ejecutarAnimacionAlt(noteData, true) end
end

function ejecutarAnimacionAlt(direccion, esFallo)
    local anims = {'LEFT', 'DOWN', 'UP', 'RIGHT'}
    local nombreAnim = 'sing' .. anims[direccion + 1] .. '-alt'
    if esFallo then nombreAnim = 'sing' .. anims[direccion + 1] .. 'miss-alt' end
    playAnim('boyfriend', nombreAnim, true)
    setProperty('boyfriend.specialAnim', true)
end

