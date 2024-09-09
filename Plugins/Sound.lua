
assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsSound")
--~~ local dewdrop = DewdropLib:GetInstance("1.0")

local sounds = {
	Long = "Interface\\AddOns\\BigWigs_NG\\Sounds\\Long.mp3",
	Info = "Interface\\AddOns\\BigWigs_NG\\Sounds\\Info.ogg",
	Alert = "Interface\\AddOns\\BigWigs_NG\\Sounds\\Alert.ogg",
	Alarm = "Interface\\AddOns\\BigWigs_NG\\Sounds\\Alarm.mp3",
	Victory = "Interface\\AddOns\\BigWigs_NG\\Sounds\\Victory.mp3",

	Beware = "Interface\\AddOns\\BigWigs_NG\\Sounds\\Beware.wav",
	RunAway = "Interface\\AddOns\\BigWigs_NG\\Sounds\\RunAway.wav",

	One = "Interface\\AddOns\\BigWigs_NG\\Sounds\\1.ogg",
	Two = "Interface\\AddOns\\BigWigs_NG\\Sounds\\2.ogg",
	Three = "Interface\\AddOns\\BigWigs_NG\\Sounds\\3.ogg",
	Four = "Interface\\AddOns\\BigWigs_NG\\Sounds\\4.ogg",
	Five = "Interface\\AddOns\\BigWigs_NG\\Sounds\\5.ogg",
	Six = "Interface\\AddOns\\BigWigs_NG\\Sounds\\6.ogg",
	Seven = "Interface\\AddOns\\BigWigs_NG\\Sounds\\7.ogg",
	Eight = "Interface\\AddOns\\BigWigs_NG\\Sounds\\8.ogg",
	Nine = "Interface\\AddOns\\BigWigs_NG\\Sounds\\9.ogg",
	Ten = "Interface\\AddOns\\BigWigs_NG\\Sounds\\10.ogg",

	Murloc = "Sound\\Creature\\Murloc\\mMurlocAggroOld.wav",
	Pain = "Sound\\Creature\\Thaddius\\THAD_NAXX_ELECT.wav",
	Shakira = "Interface\\AddOns\\BigWigs_NG\\Sounds\\Shakira.mp3",
	Mario = "Interface\\AddOns\\BigWigs_NG\\Sounds\\mario.ogg",
}


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Sounds"] = true,
	["sounds"] = true,
	["Options for sounds."] = true,

	["toggle"] = true,
	["Use sounds"] = true,
	["Toggle sounds on or off."] = true,
	["default"] = true,
	["Default only"] = true,
	["Use only the default sound."] = true,
} end)

L:RegisterTranslations("esES", function() return {
	["Sounds"] = "Sonidos",
	--["sounds"] = true,
	["Options for sounds."] = "Opciones para sonidos",

	--["toggle"] = "Alternar",
	["Use sounds"] = "Usar sonidos",
	["Toggle sounds on or off."] = "Alterna los sonidos activos o desactivos",
	--["default"] = "defecto",
	["Default only"] = "Solamente defecto",
	["Use only the default sound."] = "Solamente usa el sonido por defecto",
} end)

L:RegisterTranslations("frFR", function() return {
	["Sounds"] = "Sons",
	--["sounds"] = true,
	["Options for sounds."] = "Options des sons",

	--["toggle"] = "Alternar",
	["Use sounds"] = "Activé les sons",
	["Toggle sounds on or off."] = "Active/Désactive les sons",
	--["default"] = "defecto",
	["Default only"] = "Sons par défaut seulement",
	["Use only the default sound."] = "Utilise seulement les sons par défaut",
} end)

L:RegisterTranslations("koKR", function() return {
	["Sounds"] = "효과음",
	["Options for sounds."] = "효과음 옵션.",

	["Use sounds"] = "효과음 사용",
	["Toggle sounds on or off."] = "효과음을 켜거나 끔.",
	["Default only"] = "기본음",
	["Use only the default sound."] = "기본음만 사용.",
} end)

L:RegisterTranslations("deDE", function() return {
	["Sounds"] = "Sound",
	["Options for sounds."] = "Optionen f\195\188r Sound.",
	["Use sounds"] = "Sound nutzen",
	["Toggle sounds on or off."] = "Sound aktivieren/deaktivieren.",
	["Default only"] = "Nur Standard",
	["Use only the default sound."] = "Nur Standard Sound.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSound = BigWigs:NewModule(L["Sounds"])
BigWigsSound.defaults = {
	defaultonly = false,
	sound = true,
}
BigWigsSound.consoleCmd = L["sounds"]
BigWigsSound.consoleOptions = {
	type = "group",
	name = L["Sounds"],
	desc = L["Options for sounds."],
	args = {
		[L["toggle"]] = {
			type = "toggle",
			name = L["Sounds"],
			desc = L["Toggle sounds on or off."],
			get = function() return BigWigsSound.db.profile.sound end,
			set = function(v)
				BigWigsSound.db.profile.sound = v
				BigWigs:ToggleModuleActive(L["Sounds"], v)
			end,
		},
		[L["default"]] = {
			type = "toggle",
			name = L["Default only"],
			desc = L["Use only the default sound."],
			get = function() return BigWigsSound.db.profile.defaultonly end,
			set = function(v) BigWigsSound.db.profile.defaultonly = v end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsSound:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_Sound")
end
function BigWigsSound:OnDisable()
	BigWigs:DebugMessage("OnDisable")
end

function BigWigsSound:BigWigs_Message(text, color, noraidsay, sound, broadcastonly)
	if self.db.profile.sound then
		if not text or sound == false or broadcastonly then return end

		if sounds[sound] and not self.db.profile.defaultonly then PlaySoundFile(sounds[sound])
		else PlaySound("RaidWarning") end
	end
end

function BigWigsSound:BigWigs_Sound( sound )
	if self.db.profile.sound then
		if sounds[sound] and not self.db.profile.defaultonly then
			PlaySoundFile(sounds[sound])
		else
			PlaySound("RaidWarning")
		end
	end
end
