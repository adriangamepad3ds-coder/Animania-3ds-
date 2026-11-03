local colores = {
    {255, 0, 0}, {0, 255, 0}, {0, 0, 255}, {255, 255, 0}, {255, 0, 255},
    {0, 255, 255}, {255, 128, 0}, {128, 0, 255}, {0, 255, 128}, {255, 0, 128}
}

local colorIndices = {}
local indiceActual = 1
local activarColores = false
local hacerBucleGF_Original = false
local hacerBucleGF_Drop     = false
local alternarBailar        = true 
local tiempoTranscurrido = 0
local cancionIniciada = false
local eventoActualLuces = 1
local modoLightsOffActivo = false 

local eventosLuces = {
    {24.000, "pre-dance-gf"},
    {54.000, "lights off"}
}

local TIEMPO_BAILE_ORIGINAL = 25.000
local TIEMPO_CIERRE_GF      = 53.000
local TIEMPO_SHOCK_DAD      = 56.000  
local TIEMPO_INICIO_LUCES   = 72.000  
local TIEMPO_FIN_LUCES      = 88.000  

local baileOriginalDisparado = false
local cierreGFDisparado      = false
local shockDisparado         = false
local lucesDisparadas        = false
local finLucesDisparado = false
local ultimoBeatProcesado = -1
local ordenOriginalDad = 0

function barajarColores()
    colorIndices = {}
    for i = 1, #colores do table.insert(colorIndices, i) end
    for i = #colorIndices, 2, -1 do
        local j = getRandomInt(1, i)
        colorIndices[i], colorIndices[j] = colorIndices[j], colorIndices[i]
    end
    indiceActual = 1
end

function onCreatePost()
    barajarColores()
    tiempoTranscurrido = 0
    cancionIniciada = false
    eventoActualLuces = 1
    baileOriginalDisparado = false
    cierreGFDisparado      = false
    shockDisparado         = false
    lucesDisparadas        = false
    finLucesDisparado      = false
    hacerBucleGF_Original = false
    hacerBucleGF_Drop     = false
    modoLightsOffActivo = false
    
    ordenOriginalDad = getObjectOrder('dadGroup')
    
    makeLuaSprite('pantallaNegra', '', 0, 0)
    makeGraphic('pantallaNegra', screenWidth, screenHeight, '000000')
    setObjectCamera('pantallaNegra', 'other') 
    setProperty('pantallaNegra.alpha', 0.0)
    addLuaSprite('pantallaNegra', true)
end

function onSongStart()
    tiempoTranscurrido = 0
    eventoActualLuces = 1
    cancionIniciada = true
end

function onUpdate(elapsed)
    if not cancionIniciada then return end

    tiempoTranscurrido = getSongPosition() / 1000

    while eventoActualLuces <= #eventosLuces and tiempoTranscurrido >= eventosLuces[eventoActualLuces][1] do
        local nombreAnimacion = eventosLuces[eventoActualLuces][2]
        
        if nombreAnimacion == "pre-dance-gf" then
            triggerEvent('Play Animation', 'pre-dance', 'gf')
            setProperty('gf.specialAnim', true)
        elseif nombreAnimacion == "lights off" then
            modoLightsOffActivo = true
            setProperty('pantallaNegra.alpha', 1.0)
            setObjectCamera('dad', 'other')
            
            local negroOrder = getObjectOrder('pantallaNegra')
            setObjectOrder('dadGroup', negroOrder + 1)
            
            setProperty('dad.specialAnim', true)
            playAnim('dad', 'lights off', true)
        end
        eventoActualLuces = eventoActualLuces + 1
    end

    if modoLightsOffActivo then
        setProperty('dad.specialAnim', true)
        if getProperty('dad.animation.curAnim.name') == 'lights off' and getProperty('dad.animation.curAnim.finished') then
            local totalFrames = getProperty('dad.animation.curAnim.numFrames')
            setProperty('dad.animation.curAnim.curFrame', totalFrames - 1)
        end
    end

    if tiempoTranscurrido >= TIEMPO_BAILE_ORIGINAL and tiempoTranscurrido < TIEMPO_CIERRE_GF then
        if not baileOriginalDisparado then
            baileOriginalDisparado = true
            hacerBucleGF_Original = true
        end
    end

    if tiempoTranscurrido >= TIEMPO_CIERRE_GF and tiempoTranscurrido < 54.000 then
        if not cierreGFDisparado then
            cierreGFDisparado = true
            hacerBucleGF_Original = false
            triggerEvent('Play Animation', 'end-dance', 'gf')
            setProperty('gf.specialAnim', true)
        end
    end

    if tiempoTranscurrido >= TIEMPO_SHOCK_DAD and tiempoTranscurrido < TIEMPO_INICIO_LUCES then
        if not shockDisparado then
            shockDisparado = true
            modoLightsOffActivo = false 
            setObjectCamera('dad', 'camGame')
            setObjectOrder('dadGroup', ordenOriginalDad)
            
            cancelTween('quitarNegroLuces')
            doTweenAlpha('quitarNegroLuces', 'pantallaNegra', 0.0, 16.0, 'linear')
            triggerEvent('Play Animation', 'fresh solo', 'gf')
            setProperty('gf.specialAnim', true)
        end
    end

    if tiempoTranscurrido >= TIEMPO_INICIO_LUCES and tiempoTranscurrido < TIEMPO_FIN_LUCES then
        if not lucesDisparadas then
            lucesDisparadas = true
            cancelTween('quitarNegroLuces')
            setProperty('pantallaNegra.alpha', 0.0)
            activarColores = true
            hacerBucleGF_Drop = true
            setCameraShader("camGame", "tint")
            setCameraShader("camHUD", "tint")
        end
    end

    if tiempoTranscurrido >= TIEMPO_FIN_LUCES then
        if not finLucesDisparado then
            finLucesDisparado = true
            activarColores = false
            hacerBucleGF_Drop = false
            removeCameraShader("camGame", "tint")
            removeCameraShader("camHUD", "tint")
            setProperty('gf.specialAnim', false) 
        end
    end
end

function onBeatHit()
    if not cancionIniciada then return end

    if modoLightsOffActivo then
        return
    end

    if hacerBucleGF_Original then
        if alternarBailar then
            triggerEvent('Play Animation', 'danceLeft-dance', 'gf')
        else
            triggerEvent('Play Animation', 'danceRight-dance', 'gf')
        end
        setProperty('gf.specialAnim', true)
        alternarBailar = not alternarBailar
    end

    if hacerBucleGF_Drop then
        if alternarBailar then
            triggerEvent('Play Animation', 'danceLeft-drop', 'gf')
        else
            triggerEvent('Play Animation', 'danceRight-drop', 'gf')
        end
        setProperty('gf.specialAnim', true)
        alternarBailar = not alternarBailar
    end

    if activarColores and curBeat ~= ultimoBeatProcesado then
        ultimoBeatProcesado = curBeat
        cambiarColorPantalla()
    end
end

function cambiarColorPantalla()
    local idx = colorIndices[indiceActual]
    local r = colores[idx][1]
    local g = colores[idx][2]
    local b = colores[idx][3]
    
    setShaderParam("camGame", "tint", 1, r)
    setShaderParam("camGame", "tint", 2, g)
    setShaderParam("camGame", "tint", 3, b)
    setShaderParam("camHUD", "tint", 1, r)
    setShaderParam("camHUD", "tint", 2, g)
    setShaderParam("camHUD", "tint", 3, b)
    
    indiceActual = 1 + (indiceActual % #colorIndices)
end

