local contadorFuckUp = 0

local eventosDad = {
    {0.000, "singLEFT-beatbox"}, 
    {0.250, "singLEFT-beatbox"}, 
    {0.500, "singDOWN-beatbox"},
    {0.875, "singDOWN-beatbox"}, 
    {1.125, "singUP-beatbox"}, 
    {1.250, "singDOWN-beatbox"},
    {1.500, "singRIGHT-beatbox"}, 
    {4.000, "singLEFT-beatbox"}, 
    {4.250, "singLEFT-beatbox"},
    {4.500, "singDOWN-beatbox"}, 
    {4.875, "singDOWN-beatbox"}, 
    {5.125, "singUP-beatbox"},
    {5.250, "singRIGHT-beatbox"},
    {54.000, "lights off"},
    {56.000, "fresh huh"},
    {59.000, "shock"},
    {71.375, "activar-angry"}
}

local tiempoTranscurrido = 0
local cancionIniciada = false
local eventoActual = 1
local modoAngryActivo = false
local modoShockActivo = false
local modoAltActivo = false

local TIEMPO_BAILE_ORIGINAL = 25.000
local TIEMPO_CIERRE_GF      = 53.000

function onCreatePost()
    tiempoTranscurrido = 0
    eventoActual = 1
    cancionIniciada = false
    modoAngryActivo = false
    modoShockActivo = false
    modoAltActivo = false
    contadorFuckUp = 0
end

function onSongStart()
    tiempoTranscurrido = 0
    eventoActual = 1
    cancionIniciada = true
    contadorFuckUp = 0
end

function onUpdate(elapsed)
    if not cancionIniciada then return end

    tiempoTranscurrido = getSongPosition() / 1000

    while eventoActual <= #eventosDad and tiempoTranscurrido >= eventosDad[eventoActual] do
        local nombreAnimacion = eventosDad[eventoActual]
        
        if nombreAnimacion == "shock" then
            modoShockActivo = true
            playAnim('dad', 'shock', true)
            setProperty('dad.specialAnim', true)
        elseif nombreAnimacion == "activar-angry" then
            modoShockActivo = false 
            modoAngryActivo = true
            setProperty('dad.idleSuffix', '-angry')
            
            for i = 0, getProperty('unspawnNotes.length') - 1 do
                if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                    setPropertyFromGroup('unspawnNotes', i, 'animSuffix', '-angry')
                end
            end
            
            playAnim('dad', 'idle-angry', true)
            setProperty('dad.specialAnim', false)
        else
            playAnim('dad', nombreAnimacion, true)
            setProperty('dad.specialAnim', true)
        end
        
        eventoActual = eventoActual + 1
    end

    if tiempoTranscurrido >= TIEMPO_BAILE_ORIGINAL and tiempoTranscurrido < TIEMPO_CIERRE_GF then
        if not modoAltActivo then
            modoAltActivo = true
        end
    elseif tiempoTranscurrido >= TIEMPO_CIERRE_GF then
        if modoAltActivo then
            modoAltActivo = false
        end
    end

    if modoShockActivo then
        setProperty('dad.specialAnim', true) 
        if getProperty('dad.animation.curAnim.name') == 'shock' and getProperty('dad.animation.curAnim.finished') then
            local totalFrames = getProperty('dad.animation.curAnim.numFrames')
            setProperty('dad.animation.curAnim.curFrame', totalFrames - 1)
        end
    end

    if modoAngryActivo and not modoShockActivo then
        local animActual = getProperty('dad.animation.curAnim.name')
        if animActual == 'idle-angry' and getProperty('dad.animation.curAnim.finished') then
            playAnim('dad', 'idle-angry', true)
            setProperty('dad.specialAnim', false)
        end
    end
end

function onBeatHit()
    if modoAngryActivo and not modoShockActivo then
        local animActual = getProperty('dad.animation.curAnim.name')
        if animActual == 'idle-angry' or getProperty('dad.animation.curAnim.finished') then
            playAnim('dad', 'idle-angry', true)
            setProperty('dad.specialAnim', false)
        end
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if noteType == 'Fuck Up' then
        contadorFuckUp = contadorFuckUp + 1
        local animFuck = 'fresh fuck'
        if contadorFuckUp % 2 == 0 then animFuck = 'fresh fuck2' end
        
        playAnim('dad', animFuck, true)
        setProperty('dad.specialAnim', true)
        return
    end

    if modoShockActivo then
        modoShockActivo = false
    end

    if modoAngryActivo then
        ejecutarAnimacionAngry(noteData, isSustainNote)
    elseif modoAltActivo then
        ejecutarAnimacionAlt(noteData, isSustainNote)
    end
end

function ejecutarAnimacionAngry(direccion, esSostenida)
    local anims = {'LEFT', 'DOWN', 'UP', 'RIGHT'}
    local nombreAnim = 'sing' .. anims[direccion + 1] .. '-angry'
    
    if esSostenida then 
        nombreAnim = nombreAnim .. '-hold' 
    end
    
    playAnim('dad', nombreAnim, true)
    setProperty('dad.specialAnim', true)
    setProperty('dad.holdTimer', 0)
end

function ejecutarAnimacionAlt(direccion, esSostenida)
    local anims = {'LEFT', 'DOWN', 'UP', 'RIGHT'}
    local nombreAnim = 'sing' .. anims[direccion + 1] .. '-alt'
    
    if esSostenida then 
        nombreAnim = nombreAnim .. '-hold' 
    end
    
    playAnim('dad', nombreAnim, true)
    setProperty('dad.specialAnim', true)
    setProperty('dad.holdTimer', 0)
end

