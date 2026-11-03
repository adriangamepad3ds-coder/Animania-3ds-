local videoPlayed = false
local canSkip = false

function onStartCountdown()
    if not videoPlayed then
        videoPlayed = true
        startVideo('animania')
        return Function_Stop
    end

    return Function_Continue
end

function onUpdate(elapsed)
    if canSkip and keyboardJustPressed('a') then
        endVideo()
    end
end

function onBeatHit()
    -- 6 segundos equivalen a 3 beats si el BPM es 120.
    if curBeat >= 3 then
        canSkip = true
    end
end