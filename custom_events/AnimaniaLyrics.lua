local dev=false

function onCreatePost()
makeLuaText('subText2','',0,0,0)
setTextAlignment('subText2','center')
setTextSize('subText2',26)
setTextFont('subText2',songName=='phone-call' and 'comicz.ttf' or 'RuthlessSketch-Regular.ttf')
setTextBorder('subText2',0,'0x')
camSubtitles('subText2')
screenCenter('subText2','x')
setProperty('subText2.alpha',0.8)
setProperty('subText2.y',downscroll and getProperty('scoreTxt.y')+35 or getProperty('healthBar.y')-110)

makeLuaSprite('subText2Border',nil,0,0)
makeGraphic('subText2Border',1,1,'000000')
camSubtitles('subText2Border')
setProperty('subText2Border.alpha',0.5)

addLuaSprite('subText2Border',true)
addLuaText('subText2',true)
end

function onEvent(n,v1,v2)
if n=='AnimaniaLyrics'then
local text=v1 or''
local clean=text
local formats={}
local id=0

clean=clean:gsub('<font([^>]*)>(.-)</font>',function(attrs,word)
local color=attrs:match('color%s*=%s*"([^"]+)"')or''
if color~=''then
color=color:gsub('#','')
id=id+1
local mark='§'..id..'§'
table.insert(formats,{mark,color,word})
return mark..word..mark
end
return word
end)
clean=clean:gsub('<font[^>]*>',''):gsub('</font>','')
setTextString('subText2',clean)
screenCenter('subText2','x')

if #formats>0 then
local pairs=''
for _,f in ipairs(formats)do
pairs=pairs..'new flixel.text.FlxTextFormatMarkerPair(new flixel.text.FlxTextFormat(0xFF'..f[2]..'),"'..f[1]..'"),'
end

runHaxeCode([[
game.getLuaObject("subText2").text="]]..clean:gsub('"','\\"')..[[";
game.getLuaObject("subText2").applyMarkup("]]..clean:gsub('"','\\"')..[[",[ ]]..pairs..[[ ]);
]])
end

screenCenter('subText2','x')
makeGraphic('subText2Border',getProperty('subText2.width')+10,getProperty('subText2.height')+10,'000000')
setProperty('subText2Border.x',getProperty('subText2.x')-5)
setProperty('subText2Border.y',getProperty('subText2.y')-5)
setProperty('subText2Border.visible',v1~='')

if dev then
debugPrint('Texto: '..clean)
debugPrint('Cor: '..(text:match('color%s*=%s*"([^"]+)"')or''))
end
end
end