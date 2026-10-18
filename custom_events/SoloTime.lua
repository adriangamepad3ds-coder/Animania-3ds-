local MULTI_SHIT = 0.35
local OFFSET = 0.25
function onCreatePost()
if difficultyName == 'Easy' or difficultyName == 'Normal' or difficultyName == 'Hard' then
precacheImage('ui/times/solo_time')
precacheImage('ui/times/solo_time-xmas')
end
end

function onEvent(n,v1,v2)
if n== 'SoloTime' then
local suffix = v1 or ''
playSound('gameplay/solo_time/solotime'..suffix)
local texturePath = 'ui/times/solo_time'..suffix
local splash = 'soloTimeTxtSplash'
makeAnimatedLuaSprite(splash,texturePath,0,0)
addAnimationByPrefix(splash,'anim','solo_time',24,false)
playAnim(splash,'anim',true)
scaleObject(splash,0.75,0.75)
setObjectCamera(splash,'hud')
setObjectOrder(splash,20)
screenCenter(splash,'xy')
setProperty(splash..'.x',-120)
setProperty(splash..'.angle',getRandomFloat(-2,2))
setProperty(splash..'.animation.curAnim.frameRate',24/MULTI_SHIT)
doTweenAlpha('soloTimeFade',splash,0,0.5,'linear')
doTweenX('soloTimeMove',splash,20,1*MULTI_SHIT,'cubeOut')
doTweenAngle('soloTimeAngle',splash,0,1*MULTI_SHIT,'cubeOut')
addLuaSprite(splash,true)
createCoolBackLine(100,1,140,-180,300)
createCoolBackLine(350,1,60,-180,650)
createCoolBackLine(560,1,15,-180,950)
createBlackLine(-(screenHeight/4),-(screenHeight/6),1)
createBlackLine(screenHeight,screenHeight - (screenHeight/8),2)
end
end

function createBlackLine(yPos,targetY,id)
local tag = 'soloBlackLine'..id
makeLuaSprite(tag,nil,0,yPos)
makeGraphic(tag,screenWidth,math.floor(screenHeight/4),'000000')
setObjectCamera(tag,'hud')
setObjectOrder(tag,5)
addLuaSprite(tag,true)
doTweenY(tag..'In',tag,targetY,(10/24)*MULTI_SHIT,'quadOut')
runTimer(tag..'Wait',(4/24)*MULTI_SHIT)
_G[tag..'_y'] = yPos
end

function createCoolBackLine(xPos,zIndex,scaleX,moveAmount,moveEnd)
local id = 'soloCoolLine'..tostring(getRandomInt(10000,99999))
makeLuaSprite(id,nil,xPos,-100)
makeGraphic(id,1,math.floor(screenHeight*1.75),'000000')
setObjectCamera(id,'hud')
setObjectOrder(id,zIndex)
scaleObject(id,0.001,1)
setProperty(id..'.angle',-20)
addLuaSprite(id,true)
doTweenX(id..'ScaleIn',id..'.scale',scaleX,(9/24)*MULTI_SHIT,'quadOut')
doTweenX(id..'MoveIn',id,xPos - moveAmount,(10/24)*MULTI_SHIT,'quadOut')
runTimer(id..'DelayOut',(38/24)*MULTI_SHIT+OFFSET)
_G[id..'_startX'] = xPos
_G[id..'_moveEnd'] = moveEnd
end

function onTimerCompleted(tag)
if string.find(tag,'soloBlackLine') and string.find(tag,'Wait') then
local id = string.gsub(tag,'Wait','')
local yPos = _G[id..'_y']
doTweenY(id..'Out',id,yPos,(10/24)*MULTI_SHIT,'quadOut')
runTimer(id..'Remove',(30/24)*MULTI_SHIT)
end
if string.find(tag,'soloCoolLine') and string.find(tag,'DelayOut') then
local id = string.gsub(tag,'DelayOut','')
local startX = _G[id..'_startX']
local moveEnd = _G[id..'_moveEnd']
doTweenX(id..'ScaleOut',id..'.scale',0,(9/24)*MULTI_SHIT,'quadOut')
doTweenX(id..'MoveOut',id,startX - moveAmount + moveEnd,(10/24)*MULTI_SHIT,'quadOut')
runTimer(id..'Remove',(10/24)*MULTI_SHIT)
end
if string.find(tag,'Remove') then
local id = string.gsub(tag,'Remove','')
if luaSpriteExists(id) then
removeLuaSprite(id,true)
end
_G[id..'_y'] = nil
_G[id..'_startX'] = nil
_G[id..'_moveEnd'] = nil
end
end