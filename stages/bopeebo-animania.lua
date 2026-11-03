local COORDENADAS_STAGE = {
    bf  = {x = 1335,  y = 585,   scale = 5.70},
    dad = {x = 340,   y = 350,   scale = 4.00},
    gf  = {x = 400,   y = 300,   scale = 4.00}
}

function onCreate()
    makeLuaSprite('Stagea', 'stages/mainStageAmTake/Stagea', -900, -350)
    scaleObject('Stagea', 3.501953, 3.501953)
    setScrollFactor('Stagea', 0.975, 0.975)
    addLuaSprite('Stagea', false)

    makeAnimatedLuaSprite('boombox', 'stages/mainStageAmTake/boombox_stage', -80, 570)
    addAnimationByPrefix('boombox', 'bop', 'boombox stage', 24, false)
    scaleObject('boombox', 1.15, 1.15)
    setScrollFactor('boombox', 0.95, 0.95)
    addLuaSprite('boombox', false)

    makeAnimatedLuaSprite('rightBoombox', 'stages/mainStageAmTake/right_boombox_stage', 1500, 570)
    addAnimationByPrefix('rightBoombox', 'bop', 'right boomboxes', 24, false)
    scaleObject('rightBoombox', 1.15, 1.15)
    setScrollFactor('rightBoombox', 0.95, 0.95)
    addLuaSprite('rightBoombox', false)

    makeAnimatedLuaSprite('baseSpeakers', 'stages/mainStageAmTake/base_speakers', 600, 600)
    addAnimationByPrefix('baseSpeakers', 'bop', 'stage speakers', 24, false)
    scaleObject('baseSpeakers', 1.00, 1.00)
    setScrollFactor('baseSpeakers', 0.95, 0.95)
    addLuaSprite('baseSpeakers', false)

    setProperty('boyfriend.x', COORDENADAS_STAGE.bf.x)
    setProperty('boyfriend.y', COORDENADAS_STAGE.bf.y)
    setProperty('dad.x', COORDENADAS_STAGE.dad.x)
    setProperty('dad.y', COORDENADAS_STAGE.dad.y)
    setProperty('gf.x', COORDENADAS_STAGE.gf.x)
    setProperty('gf.y', COORDENADAS_STAGE.gf.y)

    scaleObject('boyfriend', COORDENADAS_STAGE.bf.scale, COORDENADAS_STAGE.bf.scale)
    scaleObject('dad', COORDENADAS_STAGE.dad.scale, COORDENADAS_STAGE.dad.scale)
    scaleObject('gf', COORDENADAS_STAGE.gf.scale, COORDENADAS_STAGE.gf.scale)
end

function onCreatePost()
    makeAnimatedLuaSprite('croudBase', 'stages/mainStageAmTake/crowd/croud1', 356, 1055)
    addAnimationByPrefix('croudBase', 'bop', 'croud10000', 24, false)
    scaleObject('croudBase', 3.50, 3.50)
    setScrollFactor('croudBase', 0.95, 0.95)
    addLuaSprite('croudBase', true)

    makeAnimatedLuaSprite('croudAnim', 'stages/mainStageAmTake/crowd/croud2', 686, 1075)
    addAnimationByPrefix('croudAnim', 'bop', 'croud2 bop', 24, false)
    scaleObject('croudAnim', 5.40, 5.40)
    setScrollFactor('croudAnim', 0.95, 0.95)
    addLuaSprite('croudAnim', true)

    makeAnimatedLuaSprite('croudExtra', 'stages/mainStageAmTake/crowd/croud3', 341, 800)
    addAnimationByPrefix('croudExtra', 'bop', 'croud3', 24, false)
    scaleObject('croudExtra', 3.45, 3.45)
    setScrollFactor('croudExtra', 0.95, 0.95)
    addLuaSprite('croudExtra', true)
end

function onBeatHit()
    if luaSpriteExists('croudBase') then playAnim('croudBase', 'bop', true) end
    if luaSpriteExists('croudAnim') then playAnim('croudAnim', 'bop', true) end
    if luaSpriteExists('croudExtra') then playAnim('croudExtra', 'bop', true) end
    if luaSpriteExists('boombox') then playAnim('boombox', 'bop', true) end
    if luaSpriteExists('rightBoombox') then playAnim('rightBoombox', 'bop', true) end
    if luaSpriteExists('baseSpeakers') then playAnim('baseSpeakers', 'bop', true) end
end

