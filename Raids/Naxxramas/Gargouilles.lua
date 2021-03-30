------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Stoneskin Gargoyle"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gargouilles",

	acidbolt_cmd = "acidbolt",
	acidbolt_name = "Salve d'acide",
	acidbolt_desc = "Affiche le cooldown de la Salve d'acide",

	stoneskin_cmd = "stoneskin",
	stoneskin_name = "Alerte Peau de pierre",
	stoneskin_desc = "Affiche le temps avant la Peau de pierre",
	
	sound_cmd = "sound",
	sound_name = "Son", 
	sound_desc = "Jouer un son",
	
	acidbolt_trigger = "casts Acid Volley.",
	acidbolt_msg = "Acid Volley!",
	acidbolt_bar = "Next Acid Volley",
	
	stoneskin_trigger = "begins to perform Stone skin.", 
	stoneskin_msg = "Stone Skin! Finish Him!",
	stoneskin_bar = "Stone Skin",
} end )

L:RegisterTranslations("frFR", function() return {
	acidbolt_name = "Salve d'acide",
	acidbolt_desc = "Affiche le cooldown de la Salve d'acide",

	stoneskin_name = "Alerte Peau de pierre",
	stoneskin_desc = "Affiche le temps avant la Peau de pierre",

	sound_name = "Son", 
	sound_desc = "Jouer un son",
	
	acidbolt_trigger = "lance Salve d'acide.",
	acidbolt_msg = "Salve d'acide!",
	acidbolt_bar = "Prochaine Salve d'acide",
	
	stoneskin_trigger = "commence à exécuter Peau de pierre.",
	stoneskin_msg = "Peau de pierre! Finish Him!",
	stoneskin_bar = "Peau de pierre",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGargouille = BigWigs:NewModule(boss)
BigWigsGargouille.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsGargouille.enabletrigger = boss
BigWigsGargouille.toggleoptions = {"acidbolt", "stoneskin", "sound"}
BigWigsGargouille.revision = tonumber(string.sub("$Revision: 16639 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGargouille:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "StoneSkin", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "AcidBolt", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsGargouille:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsGargouille:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if string.find(msg, L["stoneskin_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "StoneSkin")
	end
end

function BigWigsGargouille:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["acidbolt_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "AcidBolt")
	end
end

function BigWigsGargouille:BigWigs_RecvSync(sync)
	if sync == "AcidBolt" and self.db.profile.acidbolt then
		self:TriggerEvent("BigWigs_Message", L["acidbolt_msg"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["acidbolt_bar"], 9, "Interface\\Icons\\Spell_Nature_Acid_01")
	elseif sync == "StoneSkin" and self.db.profile.stoneskin then
		self:TriggerEvent("BigWigs_Message", L["stoneskin_msg"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["stoneskin_bar"], 6, "Interface\\Icons\\Ability_GolemThunderclap")
		if self.db.profile.sound then
			PlaySoundFile("Interface\\AddOns\\BigWigs\\Sounds\\FinishHim.mp3")
		end
	end
end