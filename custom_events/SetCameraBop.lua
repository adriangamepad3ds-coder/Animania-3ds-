local camInt=1
local z=false

function onCreatePost()
setOnScripts('SetCameraBop',true)
end

function onEvent(n, v1,v2)
if n=='SetCameraBop' and SetCameraBop then
setProperty('camZooming',true)
setProperty('camZoomingMult',0)
local newIntensity=tonumber(v1)
z=true
camInt=newIntensity
end
end

function onBeatHit()
if z and SetCameraBop then
if camInt>0 then
setProperty('camHUD.zoom',getProperty('camHUD.zoom')+(0.03 *camInt))
end
end
end