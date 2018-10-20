-- Res, Classic WoW Resistance Addon
-- by thekk
-- 20.09.2018

------------------------ Variablen --------------------------
local parent

debuffs = {
	"Interface\\Icons\\Ability_Warrior_Sunder",
	"Interface\\Icons\\INV_Axe_12",
	"Interface\\Icons\\Spell_Nature_FaerieFire",
	"Interface\\Icons\\INV_Misc_Gem_Amethyst_01",
	"Interface\\Icons\\Spell_Holy_Dizzy",
	"Interface\\Icons\\Spell_Holy_ElunesGrace",
	"Interface\\Icons\\Spell_Fire_SoulBurn",
	"Interface\\Icons\\Spell_Fire_Incinerate",
	"Interface\\Icons\\Spell_Shadow_UnholyStrength",
	"Interface\\Icons\\Spell_Shadow_ChillTouch",
	"Interface\\Icons\\Spell_Shadow_CurseOfAchimonde",
	"Interface\\Icons\\Spell_Shadow_ShadowBolt",
	"Interface\\Icons\\Spell_Shadow_BlackPlague",
	"Interface\\Icons\\Spell_Shadow_UnsummonBuilding",
}
------------------------ Variablen --------------------------

-------------------- help functions -----------------------
local function print(msg)
  DEFAULT_CHAT_FRAME:AddMessage("|cffcccc33INFO: |cffffff55" .. ( msg or "nil" ))
end

local function CheckDebuffs(unit)
	local id = 1;
	while (UnitDebuff(unit, id)) do
		local debuffTexture = UnitDebuff(unit, id);
		local i, v = next(debuffs, nil)  -- i is an index of t, v = t[i]
		while i do
			--new_t[i] = v
			if (string.find(debuffTexture, v)) then
				
			end
			i, v = next(debuffs, i)        -- get next index
		end
		id = id + 1;
	end
end

local function Update()
	if pfUI.uf.target then parent = pfUI.uf.target
	elseif XPerl_Target then parent = XPerl_Target
	else parent = TargetFrame end
	
	local width = parent:GetWidth()
	local _print = ""
	
	if UnitExists("target") then
		local _,totalArmor = UnitResistance("target",0)
		local calcArmor = tonumber(string.format("%.2f",(totalArmor/(totalArmor+400+85*UnitLevel("player")))*100))
		local _,totalFr = UnitResistance("target",2)
		local _,totalNr = UnitResistance("target",3)
		local _,totalFrR = UnitResistance("target",4)
		local _,totalSr = UnitResistance("target",5)
		
		_print = ("|cffBDB76B"..totalArmor.."\n|cffBDB76B"..calcArmor.."\n|cffFF0000"..totalFr.." |cff00FF00"..totalNr.."\n|cff4AE8F5"..totalFrR.." |cff800080"..totalSr)
	end
	ResFrame_Text:SetText(_print)

	local frameWidth = ResFrame_Text:GetWidth()
	ResFrame:SetPoint("CENTER", parent:GetName(), -(frameWidth/2)-(width/2), 0)
	ResFrame:SetWidth(frameWidth+4)
	ResFrame:SetHeight(ResFrame_Text:GetHeight()+6)
	
	CheckDebuffs("target")
end

-------------------- Register game event handlers ---------------------------
function Res_OnLoad()
	ResFrame:RegisterEvent("ADDON_LOADED")
	ResFrame:RegisterEvent("UNIT_AURA")
	ResFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
end

-------------------- Event Handler ----------------------
function Res_OnEvent(event)
	if (event == "ADDON_LOADED") then
		ResFrame:SetWidth(0)
		ResFrame:SetHeight(0)
		ResFrame:Hide()
		ResDebuffFrame:SetWidth(0)
		ResDebuffFrame:SetHeight(0)
		ResDebuffFrame:Hide()
		ResFrame:UnregisterEvent("ADDON_LOADED")
		print("Res loaded")
	end
	
	if UnitExists("target") then
		Update()
		ResFrame:Show()
	else
		ResFrame:Hide()
	end
end