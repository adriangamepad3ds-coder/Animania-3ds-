local modoDebugActivo = false
local zoomGlobalCamara = 0.53
local editandoZoomActivo = false

local objetos = {
    {nombre='Stagea',        tipo='sprite', x=-900,  y=-350,  scale=3.5020},
    {nombre='croudBase',      tipo='sprite', x=356,   y=1055,  scale=3.50},  
    {nombre='croudAnim',      tipo='sprite', x=686,   y=1075,  scale=5.40},  
    {nombre='croudExtra',     tipo='sprite', x=341,   y=800,   scale=3.45},  
    {nombre='boombox',        tipo='sprite', x=-80,   y=570,   scale=1.15},  
    {nombre='rightBoombox',   tipo='sprite', x=1795,  y=515,   scale=2.05},  
    {nombre='baseSpeakers',   tipo='sprite', x=785,   y=620,   scale=3.10},  
    {nombre='boyfriend',     tipo='char',   x=1985,  y=980,   scale=0.45},
    {nombre='dad',           tipo='char',   x=1390,   y=720,   scale=5.45},
    {nombre='gf',            tipo='char',   x=1330,   y=570,   scale=4.00},
    {nombre='camara',        tipo='camara', x=890,   y=340,   scale=1.00}   
}

local debugMode = false
local exportMode = false
local scrollLine = 1
local seleccion = 1
local pos = {}
local ultimaSeccion = false

local function leerDatos()
    for i, o in ipairs(objetos) do
        pos[i] = {x = o.x, y = o.y, scale = o.scale}
    end
end

local function ordenarCapas()
    if luaSpriteExists('Stagea')       then setObjectOrder('Stagea', 0) end
    if luaSpriteExists('croudBase')    then setObjectOrder('croudBase', 1) end
    if luaSpriteExists('croudAnim')    then setObjectOrder('croudAnim', 2) end
    if luaSpriteExists('croudExtra')   then setObjectOrder('croudExtra', 3) end
    if luaSpriteExists('boombox')      then setObjectOrder('boombox', 4) end
    if luaSpriteExists('rightBoombox') then setObjectOrder('rightBoombox', 5) end
    if luaSpriteExists('baseSpeakers') then setObjectOrder('baseSpeakers', 6) end
end

local function aplicar()
    for i, o in ipairs(objetos) do
        if o.tipo == 'char' then
            setProperty(o.nombre .. '.x', pos[i].x)
            setProperty(o.nombre .. '.y', pos[i].y)
            setProperty(o.nombre .. '.scale.x', pos[i].scale)
            setProperty(o.nombre .. '.scale.y', pos[i].scale)
            setProperty(o.nombre .. '.updateHitbox', true)
        elseif o.tipo == 'sprite' and luaSpriteExists(o.nombre) then
            setProperty(o.nombre .. '.x', pos[i].x)
            setProperty(o.nombre .. '.y', pos[i].y)
            scaleObject(o.nombre, pos[i].scale, pos[i].scale)
        elseif o.tipo == 'camara' then
            if debugMode then
                setProperty('camFollow.x', pos[i].x)
                setProperty('camFollow.y', pos[i].y)
            end
        end
    end

    ordenarCapas()
end

function onCreatePost()
    leerDatos()
    aplicar() 
    setProperty('defaultCamZoom', zoomGlobalCamara)
    
    setProperty('isCameraOnForcedPos', true)
    setProperty('cameraSpeed', 1000)
    setProperty('camFollow.x', 890)  
    setProperty('camFollow.y', 340)  
    ultimaSeccion = mustHitSections
    
    runTimer('liberarCamaraInicio', 0.01)
end

function onUpdate(elapsed)
    if not debugMode then
        if mustHitSections ~= ultimaSeccion then
            ultimaSeccion = mustHitSections
            setProperty('cameraSpeed', 50)
            runTimer('restaurarVelocidadCamara', 0.05)
        end
    end

    if not modoDebugActivo then return end

    if not luaTextExists('debugText') then
        makeLuaText('debugText', '', 1200, 10, 10)
        setTextSize('debugText', 16)
        setObjectCamera('debugText', 'other')
        addLuaText('debugText')
        setProperty('debugText.visible', false)
    end

    if keyJustPressed('r') then
        debugMode = not debugMode
        exportMode = false
        editandoZoomActivo = false
        if debugMode then
            setProperty('debugText.visible', true)
            setProperty('camHUD.visible', false)
            setProperty('isCameraOnForcedPos', true)
        else
            setProperty('debugText.visible', false)
            setProperty('camHUD.visible', true)
            setProperty('isCameraOnForcedPos', false)
        end
    end

    if not debugMode then return end

    if keyJustPressed('select') then
        editandoZoomActivo = not editandoZoomActivo
    end

    if editandoZoomActivo then
        if keyPressed('a') then
            zoomGlobalCamara = math.max(0.1, zoomGlobalCamara - 0.01)
            setProperty('defaultCamZoom', zoomGlobalCamara)
        elseif keyPressed('x') then
            zoomGlobalCamara = math.min(3.0, zoomGlobalCamara + 0.01)
            setProperty('defaultCamZoom', zoomGlobalCamara)
        end
        setTextString('debugText', '=== MODO ZOOM CAMARA ===\nSELECT: volver al editor\nA: alejar (-)  |  X: acercar (+)\n---------------------------------\nZoom: ' .. string.format('%.2f', zoomGlobalCamara))
        return
    end

    if keyJustPressed('y') then
        exportMode = not exportMode
        scrollLine = 1
    end

    if exportMode then
        if keyJustPressed('up') then scrollLine = math.max(1, scrollLine - 1) end
        if keyJustPressed('down') then scrollLine = scrollLine + 1 end
        local lineas = {'=== COORDENADAS (Y: volver) ===', ''}
        for i, o in ipairs(objetos) do
            if o.tipo == 'camara' then
                table.insert(lineas, o.nombre .. ' = {x = ' .. string.format('%.0f', pos[i].x) .. ', y = ' .. string.format('%.0f', pos[i].y) .. '},')
            else
                table.insert(lineas, o.nombre .. ' = {x = ' .. string.format('%.0f', pos[i].x) .. ', y = ' .. string.format('%.0f', pos[i].y) .. ', scale = ' .. string.format('%.2f', pos[i].scale) .. '},')
            end
        end
        table.insert(lineas, '')
        table.insert(lineas, 'Zoom general: ' .. string.format('%.2f', zoomGlobalCamara))
        local maxVis = 11
        if scrollLine > math.max(1, #lineas - maxVis + 1) then scrollLine = math.max(1, #lineas - maxVis + 1) end
        local texto = ''
        for i = scrollLine, math.min(scrollLine + maxVis - 1, #lineas) do texto = texto .. lineas[i] .. '\n' end
        setTextString('debugText', texto)
        return
    end

    if keyJustPressed('l') then
        seleccion = seleccion - 1
        if seleccion < 1 then seleccion = #objetos end
    elseif keyJustPressed('start') then
        seleccion = seleccion + 1
        if seleccion > #objetos then seleccion = 1 end
    end

    if objetos[seleccion].tipo ~= 'camara' then
        if keyJustPressed('x') then
            pos[seleccion].scale = pos[seleccion].scale + 0.05
        elseif keyJustPressed('a') then
            pos[seleccion].scale = math.max(0.05, pos[seleccion].scale - 0.05)
        end
    end

    if keyPressed('left')  then pos[seleccion].x = pos[seleccion].x - 5 end
    if keyPressed('right') then pos[seleccion].x = pos[seleccion].x + 5 end
    if keyPressed('up')    then pos[seleccion].y = pos[seleccion].y - 5 end
    if keyPressed('down')  then pos[seleccion].y = pos[seleccion].y + 5 end

    aplicar()

    local o = objetos[seleccion]
    local p = pos[seleccion]
    local lineaCoordenadas = 'X: ' .. string.format('%.0f', p.x) .. ' | Y: ' .. string.format('%.0f', p.y)
    if o.tipo ~= 'camara' then
        lineaCoordenadas = lineaCoordenadas .. ' | Escala: ' .. string.format('%.2f', p.scale)
    end

    setTextString('debugText',
        '=== EDITOR STAGEA ===\n' ..
        'R: salir | L/START: object | CRUCETA: mover\n' ..
        'X/A: escala | SELECT: zoom | Y: reporte\n' ..
        '---------------------------------\n' ..
        'Objeto: ' .. string.upper(o.nombre) .. '\n' ..
        lineaCoordenadas .. '\n' ..
        'Zoom general: ' .. string.format('%.2f', zoomGlobalCamara))
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'liberarCamaraInicio' then
        setProperty('isCameraOnForcedPos', false)
        setProperty('cameraSpeed', 1)
    elseif tag == 'restaurarVelocidadCamara' then
        setProperty('cameraSpeed', 1)
    end
end

