local COORDENADAS_STAGE = {
    bf  = {x = 1335,  y = 585,   scale = 5.70},
    dad = {x = 340,   y = 350,   scale = 7.00},
    gf  = {x = 400,   y = 300,   scale = 4.00}
}

function onCreate()
    makeLuaSprite('Stagea', 'stages/mainstageamtake/Stagea', -900, -350)
    scaleObject('Stagea', 3.5020, 3.5020)
    setScrollFactor('Stagea', 0.975, 0.975)
    addLuaSprite('Stagea', false)

    setProperty('boyfriend.x', COORDENADAS_STAGE.bf.x)
    setProperty('boyfriend.y', COORDENADAS_STAGE.bf.y)
    setProperty('dad.x', COORDENADAS_STAGE.dad.x)
    setProperty('dad.y', COORDENADAS_STAGE.dad.y)
    setProperty('gf.x', COORDENADAS_STAGE.gf.x)
    setProperty('gf.y', COORDENADAS_STAGE.gf.y)
    
    scaleObject('gf', COORDENADAS_STAGE.gf.scale, COORDENADAS_STAGE.gf.scale)
end

