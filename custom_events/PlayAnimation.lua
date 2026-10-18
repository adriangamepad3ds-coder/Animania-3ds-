function onEvent(n, v1,v2)
if n == 'PlayAnimation' then
if v2 == '0' then
triggerEvent('Play Animation',v1,'boyfriend')
setProperty('boyfriend.specialAnim',true)
elseif v2 == '1' then
triggerEvent('Play Animation',v1,'dad')
setProperty('dad.specialAnim',true)
elseif v2 == '2' then
triggerEvent('Play Animation',v1,'gf')
setProperty('gf.specialAnim',true)
end
end
end