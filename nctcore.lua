local ct,a,t=CopyTable,...
t.d,t.c,t.l={Pet={},Player={}},{},{}
t.f=CreateFrame('frame',a)
t.pe=CreateFrame('frame',a..'Pet')
t.pl=CreateFrame('frame',a..'Player')
t.pa=CreateFrame('frame',a..'Panel')
t.f:RegisterEvent('LOADING_SCREEN_DISABLED')
function t.event(p,u,...)
	if u~=_G[p..'Frame'].unit then return else local e,f,n=...
	if e~='WOUND' then f=e elseif n==0 then e='MISS' end
	if t.v[p][f] or t.v[p][e] then CombatFeedback_OnCombatEvent(_G[p..'Frame'],...) end end
end
function t.create(o,x,y,m)
	t.o=t.o and t.o+1 or 1
	local n=a..'Object'..format('%02i',t.o)
	if o=='b' then
		o=CreateFrame('CheckButton',n,t.pa,'InterfaceOptionsCheckButtonTemplate')
		o:SetHitRectInsets(-1,-128,-1,-1)
		o:SetPoint('TOPLEFT',x,y)
		_G[n..'Text']:SetText(m)
	elseif o=='l' then
		o=t.pa:CreateTexture(n)
		o:SetColorTexture(m,m,m)
		o:SetPoint('LEFT',t.pa,'TOPLEFT',x,y)
		o:SetSize(600,1)
	elseif o=='t' then
		o=t.pa:CreateFontString(n,'ARTWORK','GameFontNormalLarge')
		o:SetPoint('TOPLEFT',x,y)
		o:SetText(m)
	end
	return o
end
function t.options(a)
	if a=='c' then t.v=ct(t.tmp) elseif a=='d' then t.v=ct(t.d) end
	if a=='r' then for k1,v in next,t.d do for k2 in next,v do t[k1..k2]:SetChecked(t.v[k1][k2]) end end
	if not t.tmp then t.tmp=ct(t.v) end elseif a~='d' then NoCombatText_SV=ct(t.v) t.tmp=nil end
end
t.f:SetScript('OnEvent',function()
	t.f:UnregisterEvent('LOADING_SCREEN_DISABLED')
	t.c=ct(CombatFeedbackText)
	t.c.WOUND=DAMAGE
	t.c.HEAL=VOICEMACRO_LABEL_HEALME1
	t.c.ENERGIZE=COMBAT_TEXT_SHOW_ENERGIZE_TEXT
	for k,v in next,t.c do
		t.d.Pet[k]=false
		t.d.Player[k]=false
		tinsert(t.l,strlower(v)..':'..k)
	end
	sort(t.l)
	if NoCombatText_SV then t.v=ct(NoCombatText_SV)
		for k1,v1 in next,t.d do for k2,v2 in next,v1 do if t.v[k1]==nil then t.v[k1]=t.d[k1]
		elseif type(t.v[k1][k2])~=type(v2) then t.v[k1][k2]=t.d[k1][k2] end end end
		for k1,v in next,t.v do if t.d[k1]==nil then t.v[k1]=nil elseif type(v)=='table' then
		for k2 in next,v do if t.d[k1][k2]==nil then t.v[k1][k2]=nil end end end end
	else t.v=ct(t.d) end
	t.options()
	t.pa.name=a
	InterfaceOptions_AddCategory(t.pa,a)
	t.t1=t.create('t',16,-16,a)
	t.l1=t.create('l',10,-40,.25)
	t.t2=t.create('t',64,-64,PLAYER.." "..ENABLE)
	t.t3=t.create('t',256,-64,PET.." "..ENABLE)
	for _,v in ipairs(t.l) do
		local l,e=strsplit(':',v) t.po=t.po and t.po-28 or -96
		l=e=='ENERGIZE'and"|cff69ccf0"..l.."|r" or e=='HEAL'and"|cff00ff00"..l.."|r" or e=='WOUND'and"|cffffff00"..l.."|r" or l
		t['Pet'..e]=t.create('b',256,t.po,l)
		t['Pet'..e]:SetScript('PostClick',function(s)t.v.Pet[e]=s:GetChecked()end)
		t['Player'..e]=t.create('b',64,t.po,l)
		t['Player'..e]:SetScript('PostClick',function(s)t.v.Player[e]=s:GetChecked()end)
	end
	t.pa.okay=function()t.options()end
	t.pa.cancel=function()t.options('c')end
	t.pa.default=function()t.options('d')end
	t.pa.refresh=function()t.options('r')end
	SLASH_NOCOMBATTEXT1='/nocombattext'
	SLASH_NOCOMBATTEXT2='/nct'
	SlashCmdList.NOCOMBATTEXT=function()InterfaceOptionsFrame_OpenToCategory(a)end
	PetFrame:UnregisterEvent('UNIT_COMBAT')
	PlayerFrame:UnregisterEvent('UNIT_COMBAT')
	t.pe:RegisterUnitEvent('UNIT_COMBAT','pet','player')
	t.pl:RegisterUnitEvent('UNIT_COMBAT','player','vehicle')
	t.pe:SetScript('OnEvent',function(_,_,...)t.event('Pet',...)end)
	t.pl:SetScript('OnEvent',function(_,_,...)t.event('Player',...)end)
end)
