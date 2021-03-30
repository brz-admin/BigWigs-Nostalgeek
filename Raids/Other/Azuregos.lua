----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Azuregos", "Azshara")

module.revision = 20008 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"teleport", "shield", "bosskill"}

---------------------------------
--      Module specific Locals --
---------------------------------

local timer = {
	--firstTeleport = 20,
	teleport = 30,
	shield = 10,
}
local icon = {
	teleport = "Interface\\Icons\\Spell_Arcane_Blink",
	shield = "Interface\\Icons\\Spell_Frost_FrostShock",
}
local syncName = {
	}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Azuregos",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for teleport",

	shield_cmd = "shield",
	shield_name = "Shield Alert",
	shield_desc = "Warn for shield",

	teleport_trigger = "Come, little ones",
	shieldDown_trigger = "^Reflection fades from Azuregos",
	shieldUp_trigger = "^Azuregos gains Reflection",

	teleport_warn = "Teleport!",
	shieldDown_warn = "Magic Shield down!",
	shieldUp_warn = "Magic Shield UP!",
	teleport_bar = "Teleport",
	teleportSoon_warn = "Teleport soon",

	shield_bar = "Magic Shield",
} end )

L:RegisterTranslations("frFR", function() return {
	--cmd = "Azuregos",

	--teleport_cmd = "teleport",
	teleport_name = "Alerte T\195\169l\195\169portation",
	teleport_desc = "Pr\195\169viens quans Azuregos t\195\169l\195\169porte quelqu'un.",

	--shield_cmd = "shield",
	shield_name = "Alerte Bouclier",
	shield_desc = "Pr\195\169viens quand Azuregos est prot\195\169g\195\169 par un bouclier magique.",

	teleport_trigger = "mes petits",
	shieldDown_trigger = "^Renvoi sur Azuregos vient de se dissiper.",
	shieldUp_trigger = "^Azuregos gagne Renvoi.",

	teleport_warn = "T\195\169l\195\169portation !",
	shieldDown_warn = "Bouclier magique dissip\195\169 !",
	shieldUp_warn = "Bouclier magique en place !",
	teleport_bar = "Téléportation",
	teleportSoon_warn = "Téléportation bientôt",

	shield_bar = "Bouclier magique",
} end )

L:RegisterTranslations("esES", function() return {
	--cmd = "Azuregos",

	--teleport_cmd = "teleport",
	teleport_name = "Alerta de Portal",
	teleport_desc = "Avisa para portal",

	--shield_cmd = "shield",
	shield_name = "Alerta de Escudo",
	shield_desc = "Avisa para escudo",

	teleport_trigger = "Come, little ones",
	shieldDown_trigger = "^Reflección desaparece de Azuregos",
	shieldUp_trigger = "^Azuregos gana Reflección",

	teleport_warn = "¡Portal!",
	shieldDown_warn = "¡Escudo magia no está activo!",
	shieldUp_warn = "¡Escudo magia está activo!",
	teleport_bar = "Portal",
	teleportSoon_warn = "Portal pronto",

	shield_bar = "Escudo magia",
} end )
------------------------------
--      Initialization      --
------------------------------

function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end

------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.teleport and string.find(msg, L["teleport_trigger"]) then
		self:Message(L["teleport_warn"], "Important")
		self:Bar(L["teleport_bar"], timer.teleport, icon.teleport)
		self:DelayedMessage(timer.teleport-5, L["teleportSoon_warn"], "Important", true, "Alert")
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER( msg )
	if self.db.profile.shield and string.find(msg, L["shieldDown_trigger"]) then
		self:Message(L["shieldDown_warn"], "Attention")
		self:RemoveBar(L["shield_bar"])
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if self.db.profile.shield and string.find(msg, L["shieldUp_trigger"]) then
		self:Message(L["shieldUp_warn"], "Important", true, "Alert")
		self:Bar(L["shield_bar"], timer.shield, icon.shield)
	end
end
