local zoomTween=nil

local function easeValue(t,e)
if e=='classicLerp' or e=='linear' then
return t
elseif e=='quadIn' then
return t*t
elseif e=='quadOut' then
return 1-(1-t)^2
elseif e=='quadInOut' then
return t < .5 and 2*t*t or 1-(-2*t+2)^2/2
elseif e=='cubeIn' then
return t^3
elseif e=='cubeOut' then
return 1-(1-t)^3
elseif e=='cubeInOut' then
return t < .5 and 4*t^3 or 1-(-2*t+2)^3/2
elseif e=='expoOut' then
return t==1 and 1 or 1-2^(-10*t)
elseif e=='expoIn' then
return t==0 and 0 or 2^(10*(t-1))
elseif e=='smoothStep' then
return t*t*(3-2*t)
end
return t
end
function smoothCamZoom(target,duration,ease)
zoomTween={start=getProperty('camGame.zoom'),target=target,time=0,duration=math.max(duration,0.001),ease=ease or 'linear'}
end
function onUpdatePost(e)
if zoomTween then
zoomTween.time=zoomTween.time+e
local t=math.min(zoomTween.time/zoomTween.duration,1)
local v=easeValue(t,zoomTween.ease)
setProperty('camGame.zoom',zoomTween.start+(zoomTween.target-zoomTween.start)*v)
if t>=1 then
setProperty('camGame.zoom',zoomTween.target)
setProperty('defaultCamZoom',zoomTween.target)
zoomTween=nil
end
end
end

function onEvent(n,v1,v2)
if n=='ZoomCamera' then
local duration=tonumber(v1) or 1
local zoom=1
local mode='direct'
local ease='linear'
for value in (v2 .. ','):gmatch('(.-),') do
if tonumber(value) then
zoom=tonumber(value)
elseif value=='stage' or value=='direct' then
mode=value
elseif value ~= '' then
ease=value
end
end

if mode=='stage' then
local stageData=callMethodFromClass('backend.StageData','getStageFile',{curStage})
if stageData and stageData.defaultZoom then
zoom=zoom * stageData.defaultZoom
end
end
if ease:upper()=='INSTANT' or duration<=0 then
zoomTween=nil
setProperty('camGame.zoom',zoom)
setProperty('defaultCamZoom',zoom)
return
end
smoothCamZoom(zoom,(stepCrochet / 1000) * duration,ease)
end
end