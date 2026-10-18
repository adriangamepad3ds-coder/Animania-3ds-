function onEvent(n,v1,v2)
if n=='BooperSpeed' then
triggerEvent('Set GF Speed',v1=='girlfriend' and 'gf' or v1=='bf' and 'bf' or 'bf',v2)
end
end