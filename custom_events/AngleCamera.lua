function onEvent(n,v1,v2)
if n=='AngleCamera' then
local data=stringSplit(v2,',')
local ease=data[1] or 'linear'
local dur=data[2] or 1
local to=data[3] or 1
local out=data[4] or ''
if not lowQuality then
--setProperty('camGame.angle',v1)
--doTweenAngle('ca','camGame',0,0.5,ease)
end
end
end