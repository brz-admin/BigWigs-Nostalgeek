﻿--[[
--
-- Big Wigs Strategy Module for Instructor Razuvious in Naxxramas.
--
-- Adds timer bars and warning messages for the Understudies
-- Mind Exhaustion debuff, so priests know exactly when they are ready.
--
-- Also adds a timer bar for Taunt.
--
--]]

----------------------------------
--      Module Declaration      --
----------------------------------

local myname = "Razuvious Assistant"
local bossName = "Instructor Razuvious"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..myname)
local module = BigWigs:NewModule(myname)
local boss = AceLibrary("Babble-Boss-2.2")[bossName]
local understudy = AceLibrary("Babble-Boss-2.2")["Deathknight Understudy"]
module.bossSync = myname
module.synctoken = myname
module.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
module.translatedName = boss
module.external = true
module.trashMod = true

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "RazAssist",

	debuff_cmd = "debuff",
	debuff_name = "Mind Exhaustion Timer",
	debuff_desc = "Show timer bar for the Mind Exhaustion debuff",

	taunt_cmd = "taunt",
	taunt_name = "Taunt",
	taunt_desc = "Show timer bar for Taunt",

	broadcast_cmd = "broadcast",
	broadcast_name = "Broadcast debuff states",
	broadcast_desc = "Broadcasts the debuff gone in 5 seconds messages to raid warning",

	taunt_bar = "Taunt",
	taunt_trigger = "Razuvious is afflicted by Taunt%.",

	mindexhaustion_bar = "%s - Exhaustion",
	mindexhaustion = "Mind Exhaustion",
	mindexhaustion_5sec = "%s is ready in 5sec!",

	["rtPath1"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Star",
	["rtPath2"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Circle",
	["rtPath3"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Diamond",
	["rtPath4"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Triangle",
	["rtPath5"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Moon",
	["rtPath6"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Square",
	["rtPath7"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Cross",
	["rtPath8"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Skull",

	["raidIcon0"] = "Unknown",
	["raidIcon1"] = "Star",
	["raidIcon2"] = "Circle",
	["raidIcon3"] = "Diamond",
	["raidIcon4"] = "Triangle",
	["raidIcon5"] = "Moon",
	["raidIcon6"] = "Square",
	["raidIcon7"] = "Cross",
	["raidIcon8"] = "Skull",

	["raidColor0"] = "Red",
	["raidColor1"] = "Yellow",
	["raidColor2"] = "Orange",
	["raidColor3"] = "Purple",
	["raidColor4"] = "Green",
	["raidColor5"] = "White",
	["raidColor6"] = "Blue",
	["raidColor7"] = "Red",
	["raidColor8"] = "White",

} end )

L:RegisterTranslations("zhTW", function() return {
--Bell@尖石 繁體化
	cmd = "講師助手",

	debuff_cmd = "debuff",
	debuff_name = "心靈疲憊計時條",
	debuff_desc = "顯示心靈疲憊DEBUFF計時條",

	taunt_cmd = "嘲諷",
	taunt_name = "嘲諷",
	taunt_desc = "顯示嘲諷計時條",

	broadcast_cmd = "廣播",
	broadcast_name = "廣播debuff狀態",
	broadcast_desc = "向團隊警告頻道警告DEBUFF將在五秒後消失",

	taunt_bar = "嘲諷",
	taunt_trigger = "死亡騎士實席者受到嘲諷的傷害。",

	mindexhaustion_bar = "%s - 心靈疲憊",
	mindexhaustion = "心靈疲憊",
	mindexhaustion_5sec = "%s 五秒後準備！",

	["rtPath1"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Star",
	["rtPath2"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Circle",
	["rtPath3"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Diamond",
	["rtPath4"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Triangle",
	["rtPath5"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Moon",
	["rtPath6"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Square",
	["rtPath7"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Cross",
	["rtPath8"] = "Interface\\AddOns\\BigWigs_NG\\Icons\\Skull",

	["raidIcon0"] = "未知",
	["raidIcon1"] = "Star",
	["raidIcon2"] = "Circle",
	["raidIcon3"] = "Diamond",
	["raidIcon4"] = "Triangle",
	["raidIcon5"] = "Moon",
	["raidIcon6"] = "Square",
	["raidIcon7"] = "Cross",
	["raidIcon8"] = "Skull",

	["raidColor0"] = "Red",
	["raidColor1"] = "Yellow",
	["raidColor2"] = "Orange",
	["raidColor3"] = "Purple",
	["raidColor4"] = "Green",
	["raidColor5"] = "White",
	["raidColor6"] = "Blue",
	["raidColor7"] = "Red",
	["raidColor8"] = "White",

} end )

L:RegisterTranslations("koKR", function() return {
	debuff_name = "피로한 정신 타이머",
	debuff_desc = "피로한 정신 디버프에 대한 타이머바 표시",

	taunt_name = "도발",
	taunt_desc = "도발에 대한 타이머바 표시",

	broadcast_name = "디버프 상태 알림",
	broadcast_desc = "디버프 사라짐 5초전 메세지를 공격대 경보로 알립니다.",

	taunt_bar = "도발",
	taunt_trigger = "죽음의 기사 수습생|1이;가; 도발에 걸렸습니다%.", -- CHECK

	mindexhaustion_bar = "%s - 피로",
	mindexhaustion = "피로한 정신",
	mindexhaustion_5sec = "%s|1은;는; 5초전 준비!",

	["raidIcon0"] = "없음",
	["raidIcon1"] = "별",
	["raidIcon2"] = "원",
	["raidIcon3"] = "마름모",
	["raidIcon4"] = "세모",
	["raidIcon5"] = "달",
	["raidIcon6"] = "네모",
	["raidIcon7"] = "가위표",
	["raidIcon8"] = "해골",

} end )

L:RegisterTranslations("frFR", function() return {
	debuff_name = "Chrono Contr\195\180le mental",
	debuff_desc = "Montre une barre de timer pour le contrôle mental",

	taunt_name = "Provocation",
	taunt_desc = "Montre la barre chrono pour Provocation",

	taunt_bar = "Provocation",
	taunt_trigger = "Doublure de chevalier de la mort subit les effets de Provocation%.",

	broadcast_name = "Diffuse le status du Débuff",
	broadcast_desc = "Diffuse en avertissement raid quand il reste 5 sec sur le debuff du cm",
	
	mindexhaustion_bar = "%s - Mal\195\169diction de fatigue",
	mindexhaustion = "Mal\195\169diction de fatigue",
	mindexhaustion_5sec = "%s est pret dans 5 sec!",

	["raidIcon0"] = "Inconnu",
	["raidIcon1"] = "Etoile",
	["raidIcon2"] = "Cercle",
	["raidIcon3"] = "Diamant",
	["raidIcon4"] = "Triangle",
	["raidIcon5"] = "Lune",
	["raidIcon6"] = "Carre",
	["raidIcon7"] = "Croix",
	["raidIcon8"] = "Crane",

	["raidColor0"] = "Rouge",
	["raidColor1"] = "Jaune",
	["raidColor2"] = "Orange",
	["raidColor3"] = "Violet",
	["raidColor4"] = "Vert",
	["raidColor5"] = "Blanc",
	["raidColor6"] = "Bleu",
	["raidColor7"] = "Rouge",
	["raidColor8"] = "Blanc",
} end)

L:RegisterTranslations("deDE", function() return {
	mindexhaustion = "Gedankenersch\195\182pfung",
	taunt_trigger = "Reservist der Todesritter ist von Spott betroffen%.",
} end)


---------------------------------
--      	Variables 		   --
---------------------------------

module.enabletrigger = { boss }
module.toggleoptions = { "broadcast", "debuff", "taunt" }
module.revision = 20001

--locals
local times = nil

------------------------------
--      Initialization      --
------------------------------

function module:OnEnable()
	self:RegisterEvent("SpecialEvents_UnitDebuffGained")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
end

function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	times = {}
end

function module:OnEngage()
end

function module:OnDisengage()
end

------------------------------
--      Utility             --
------------------------------

function module:GetRaidIconName(unitid)
	local iconIndex = GetRaidTargetIndex(unitid)
	if not iconIndex or not UnitExists(unitid) then return L["raidIcon0"], 0 end
	return L["raidIcon"..iconIndex], iconIndex
end

function module:GetRaidIconColor(raidIconIndex)
	if L:HasTranslation("raidColor"..raidIconIndex) then
		return L["raidColor"..raidIconIndex]
	end
	return "Red"
end

function module:GetRaidIconPath(raidIconIndex)
	if L:HasTranslation("rtPath"..raidIconIndex) then
		return L["rtPath"..raidIconIndex]
	end
	return "Interface\\Icons\\Spell_Shadow_Teleport"
end

------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self:SendBossDeathSync()
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if not self.db.profile.taunt then return end
	if string.find(msg, L["taunt_trigger"]) then
		self:TriggerEvent("BigWigs_StartBar", self, L["taunt_bar"], 20, "Interface\\Icons\\Spell_Nature_Reincarnation", "Green", "Yellow", "Orange")
	end
end

function module:SpecialEvents_UnitDebuffGained(unitid, debuffName, applications, debuffType, texture)
	if self.db.profile.debuff and debuffName == L["mindexhaustion"] and UnitName(unitid) == understudy then
		local iconName, iconIndex = self:GetRaidIconName(unitid)

		-- Throttle by iconIndex. We will get many UnitDebuffGained events.
		if not times[iconIndex] or (times[iconIndex] + 5) <= GetTime() then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mindexhaustion_bar"], iconName), 60, self:GetRaidIconPath(iconIndex), self:GetRaidIconColor(iconIndex))
			self:ScheduleEvent("bwrazassmcreadysoon"..iconIndex, "BigWigs_Message", 55, string.format(L["mindexhaustion_5sec"], iconName), "Green", not self.db.profile.broadcast)
			times[iconIndex] = GetTime()
		end
	end
end

