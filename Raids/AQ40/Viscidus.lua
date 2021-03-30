
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Viscidus", "Ahn'Qiraj")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Viscidus",
	volley_cmd = "volley",
	volley_name = "Poison Volley Alert",
	volley_desc = "Warn for Poison Volley",

	toxinyou_cmd = "toxinyou",
	toxinyou_name = "Toxin Cloud on You Alert",
	toxinyou_desc = "Warn if you are standing in a toxin cloud",

	toxinother_cmd = "toxinother",
	toxinother_name = "Toxin Cloud on Others Alert",
	toxinother_desc = "Warn if others are standing in a toxin cloud",

	freeze_cmd = "freeze",
	freeze_name = "Freezing States Alert",
	freeze_desc = "Warn for the different frozen states",

	slow_trigger 	= "begins to slow",
	freeze_trigger 	= "is freezing up",
	frozen_trigger 	= "is frozen solid",
	crack_trigger 	= "begins to crack",
	shatter_trigger 	= "looks ready to shatter",
	volley_trigger	= "afflicted by Poison Bolt Volley",
	toxin_trigger 	= "^([^%s]+) ([^%s]+) afflicted by Toxin%.$",

	you 		= "You",
	are 		= "are",

	freeze1_warn 		= "First freeze phase!",
	freeze2_warn 		= "Second freeze phase!",
	frozen_warn 		= "Viscidus is frozen!",
	crack1_warn 		= "Cracking up - little more now!",
	crack2_warn 		= "Cracking up - almost there!",
	volley_warn		= "Poison Bolt Volley!",
	volley_soon_warn		= "Poison Bolt Volley in ~3 sec!",
	toxin_warn		= " is in a toxin cloud!",
	toxin_self_warn		= "You are in the toxin cloud!",

	volley_bar	= "Poison Bolt Volley",
} end )

L:RegisterTranslations("frFR", function() return {
	--cmd = "Viscidus",
	--volley_cmd = "volley",
	volley_name = "Alerte de Salve d'éclairs de poison",
	volley_desc = "Previen de la Salve d'éclairs de poison",

	--toxinyou_cmd = "toxinyou",
	toxinyou_name = "Alerte de nuage de poison sur vous",
	toxinyou_desc = "Préviens si vous ête dans un nuage de poison",

	--toxinother_cmd = "toxinother",
	toxinother_name = "Alerte de nuage de poison sur les autres",
	toxinother_desc = "Previens si quelqu'un est dans un nuage de poison",

	--freeze_cmd = "freeze",
	freeze_name = "Alerte de l'état de congèlation",
	freeze_desc = "Prévien des diffèrent état de congèlation",

	slow_trigger 	= "commence à ralentir.",
	freeze_trigger 	= "commence à geler.",
	frozen_trigger 	= "est un bloc congelé.",
	crack_trigger 	= "commence à se fissurer.",
	shatter_trigger 	= "semble prêt à s'effondrer.",
	volley_trigger	= "les effets de Salve d'éclairs de poison",
	toxin_trigger 	= "^([^%s]+) ([^%s]+) les effets de Toxine%.$",

	you 		= "Vous",
	are 		= "subissez",

	freeze1_warn 		= "Première phase de Gel!",
	freeze2_warn 		= "Deuxième phase de gel!",
	frozen_warn 		= "Viscidus est gelé!",
	crack1_warn 		= "Début de phase fissure!",
	crack2_warn 		= "Viscidus va exploser!",
	volley_warn		= "Salve d'éclairs de poison!",
	volley_soon_warn	= "Salve d'éclairs de poison dans ~3 secondes!",
	toxin_warn		= "  est dans un nuage de Toxines!",
	toxin_self_warn		= "Vous êtes dans un nuage de Toxines!",

	volley_bar	= "Salve d'éclairs de poison",
} end )

L:RegisterTranslations("deDE", function() return {
	volley_name = "Giftblitzsalve Alarm", -- ?
	volley_desc = "Warnt vor Giftblitzsalve", -- ?

	toxinyou_name = "Toxin Wolke",
	toxinyou_desc = "Warnung, wenn Du in einer Toxin Wolke stehst.",

	toxinother_name = "Toxin Wolke auf Anderen",
	toxinother_desc = "Warnung, wenn andere Spieler in einer Toxin Wolke stehen.",

	freeze_name = "Freeze Phasen",
	freeze_desc = "Zeigt die verschiedenen Freeze Phasen an.",

	slow_trigger 	= "wird langsamer!",
	freeze_trigger 	= "friert ein!",
	frozen_trigger 	= "ist tiefgefroren!",
	crack_trigger 	= "geht die Puste aus!", --CHECK
	shatter_trigger 	= "ist kurz davor, zu zerspringen!",
	volley_trigger	= "ist von Giftblitzsalve betroffen.",
	toxin_trigger 	= "^([^%s]+) ([^%s]+) von Toxin betroffen.$",

	you 		= "Ihr",
	are 		= "seid",

	freeze1_warn 		= "Erste Freeze Phase!",
	freeze2_warn 		= "Zweite Freeze Phase!",
	frozen_warn 		= "Dritte Freeze Phase!",
	crack1_warn 		= "Zerspringen - etwas noch!",
	crack2_warn 		= "Zerspringen - fast da!",
	volley_warn		= "Giftblitzsalve!", -- ?
	volley_soon_warn		= "Giftblitzsalve in ~3 Sekunden!", -- ?
	toxin_warn		= " ist in einer Toxin Wolke!",
	toxin_self_warn		= "Du bist in einer Toxin Wolke!",

	volley_bar        = "Giftblitzsalve",
} end )

---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20007 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"freeze", "volley", "toxinyou", "toxinother", "bosskill"}


-- locals
local timer = {
	earliestVolley = 10,
	latestVolley = 15,
}
local icon = {
	volley = "Spell_Nature_CorrosiveBreath",
	toxin = "Spell_Nature_AbolishMagic",
}
local syncName = {}

local prior

------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Emote")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "Emote")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckVis")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckVis")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckVis")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
	prior = nil
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.volley then
		self:IntervalBar(L["volley_bar"], timer.earliestVolley, timer.latestVolley, icon.volley)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CheckVis(arg1)
	if not prior and self.db.profile.volley and string.find(arg1, L["volley_trigger"]) then
		self:Message(L["volley_warn"], "Urgent")
		self:DelayedMessage(timer.earliestVolley - 3, L["volley_soon_warn"], "Urgent", nil, nil, true)
		self:IntervalBar(L["volley_bar"], timer.earliestVolley, timer.latestVolley, icon.volley)
		prior = true
	elseif string.find(arg1, L["toxin_trigger"]) then
		local _,_, pl, ty = string.find(arg1, L["toxin_trigger"])
		if (pl and ty) then
			if self.db.profile.toxinyou and pl == L["you"] and ty == L["are"] then
				self:Message(L["toxin_self_warn"], "Personal", true, "RunAway")
				self:Message(UnitName("player") .. L["toxin_warn"], "Important", nil, nil, true)
				self:WarningSign("Spell_Nature_AbolishMagic", 5)
			elseif self.db.profile.toxinother then
				self:Message(pl .. L["toxin_warn"], "Important")
				--self:TriggerEvent("BigWigs_SendTell", pl, L["toxin_self_warn"]) -- can cause whisper bug on nefarian
			end
		end
	end
end

function module:Emote(arg1)
	BigWigs:Debug("Emote: "..arg1)
	if not self.db.profile.freeze then return end
	if string.find(arg1, L["slow_trigger"]) then
		self:Message(L["freeze1_warn"], "Atention")
	elseif string.find(arg1, L["freeze_trigger"]) then
		self:Message(L["freeze2_warn"], "Urgent")
	elseif string.find(arg1, L["frozen_trigger"]) then
		self:Message(L["frozen_warn"], "Important")
	elseif string.find(arg1, L["crack_trigger"]) then
		self:Message(L["crack1_warn"], "Urgent")
	elseif string.find(arg1, L["shatter_trigger"]) then
		self:Message(L["crack2_warn"], "Important")
	end
end

function module:BigWigs_Message(text)
	if text == L["volley_soon_warn"] then prior = nil end
end
