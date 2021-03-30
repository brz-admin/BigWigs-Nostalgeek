assert( BigWigs, "BigWigs not found!")

--[[

created by Vnm-Kronos (https://github.com/Vnm-Kronos)
improved by Dorann (https://github.com/xorann)

Allows you to start a pull timer.

Usage:
/pull 				starts a 6s pull timer
/pull <duration>	starts a custom pull timer. "/pull 7" starts a 7s pull timer.

--]]


-----------------------------------------------------------------------
--      Are you local?
-----------------------------------------------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsPausetimer")

local timer = {
	pausetimer = 0,
}
local syncName = {
	pausetimer = "PausetimerSync",
	stoppausetimer = "PausetimerStopSync",
}
local icon = {
	pausetimer = "RACIAL_ORC_BERSERKERSTRENGTH",
}

-----------------------------------------------------------------------
--      Localization
-----------------------------------------------------------------------

L:RegisterTranslations("enUS", function() return {
	["Pause Timer"] = true,

	["pausetimer"] = true,
	["Options for Pause Timer"] = true,
	pausestart_message = "Pause %d min. (Sent by %s)",
	pausestop_message = "Pause aborted (Sent by %s)",
	pause1_message = "Pause off in 1",
	pause2_message = "Pause off  2",
	pause3_message = "Pause off  3",
	pause4_message = "Pause off  4",
	pause5_message = "Pause off  5",
	pause0_message = "Pause off !",

	["Pause"] = true,
	["pause"] = true,
	["You have to be the raid leader or an assistant"] = true,

	["Enable"] = true,
	["Enable pausetimer."] = true,
} end )

L:RegisterTranslations("frFR", function() return {
	["Pause Timer"] = "Timer de Pause",

	--["pulltimer"] = true,
	["Options for Pause Timer"] = "Options pour le timer de pause",
	pausestart_message = "Pause de %d minutes (Envoyé par %s)",
	pausestop_message = "Pause annulée (Envoyé par %s)",
	pause1_message = "Pause finie dans 1",
	pause2_message = "Pause finie 2",
	pause3_message = "Pause finie 3",
	pause4_message = "Pause finie 4",
	pause5_message = "Pause finie dans 5",
	pause0_message = "Pause terminée!",

	--["Pull"] = true,
	--["pull"] = true,
	["You have to be the raid leader or an assistant"] = "Vous devez être chef de raid ou avoir une promotion",

	["Enable"] = "Activé",
	["Enable pausetimer."] = "Active le timer de pause",
} end )

L:RegisterTranslations("esES", function() return {
	["Pause Timer"] = "Temporizador de Tirar",

	--["pulltimer"] = true,
	["Options for Pause Timer"] = "Opciones para Temporizador de Tirar",
	pausestart_message = "Pause %d min. (Sent by %s)",
	pausestop_message = "Pause aborted (Sent by %s)",
	pause1_message = "Pause off in 1",
	pause2_message = "Pause off  2",
	pause3_message = "Pause off  3",
	pause4_message = "Pause off  4",
	pause5_message = "Pause off  5",
	pause0_message = "Pause off !",

	--["Pull"] = true,
	--["pull"] = true,
	["You have to be the raid leader or an assistant"] = "Tienes que ser líder o asistente para hacerlo",

	["Enable"] = "Activar",
	["Enable pausetimer."] = "Activar Temporizador de Tirar",
} end )

-----------------------------------------------------------------------
--      Module Declaration
-----------------------------------------------------------------------

BigWigsPausetimer = BigWigs:NewModule(L["Pause Timer"], "AceConsole-2.0")
BigWigsPausetimer.revision = 20001
BigWigsPausetimer.defaultDB = {
	enable = true,
}
BigWigsPausetimer.consoleCmd = L["pausetimer"]
BigWigsPausetimer.consoleOptions = {
	type = "group",
	name = L["Pause Timer"],
	desc = L["Options for Pause Timer"],
	args = {
		enable = {
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable pausetimer."],
			order = 1,
			get = function() return BigWigsPausetimer.db.profile.enable end,
			set = function(v) BigWigsPausetimer.db.profile.enable = v end,
		},
	},
}

-----------------------------------------------------------------------
--      Initialization
-----------------------------------------------------------------------
-- For easy use in macros.
local function BWPAT(minutes)
	if tonumber(minutes) then
		minutes = tonumber(minutes)
	else
		minutes = 0
	end
	BigWigsPausetimer:BigWigs_PauseCommand(minutes)
end

function BigWigsPausetimer:OnRegister()
--[[self:RegisterChatCommand({ L["slashpull_cmd"] }, {
type = "group",
args = {
pull = {
type = "text", name = L["slashpull2_cmd"],
desc = L["slashpull2_desc"],
set = function(v) self:BigWigs_PullCommand(v) end,
get = false,
usage = L["<duration>"],
},
},
})]]

end

function BigWigsPausetimer:OnEnable()
	self:RegisterEvent("BigWigs_Pausetimer")
	self:RegisterEvent("BigWigs_PauseCommand")
	self:RegisterEvent("BigWigs_RecvSync")
	self:ThrottleSync(0.5, syncName.pausetimer)


	if SlashCmdList then
		SlashCmdList["BWPAT_SHORTHAND"] = BWPAT
		setglobal("SLASH_BWPAT_SHORTHAND1", "/"..L["pause"])
	end
end

function BigWigsPausetimer:OnSetup()
end

-----------------------------------------------------------------------
--      Event Handlers
-----------------------------------------------------------------------

-----------------------------------------------------------------------
--      Synchronization
-----------------------------------------------------------------------

function BigWigsPausetimer:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.pausetimer then
		self:BigWigs_Pausetimer(rest, nick)
	end
	if sync == syncName.stoppausetimer then
		self:BigWigs_StopPausetimer()

		self:Message(string.format(L["pausestop_message"], nick), "Attention", false)
		PlaySound("igQuestFailed")
	end
end

-----------------------------------------------------------------------
--      Utility
-----------------------------------------------------------------------

function BigWigsPausetimer:BigWigs_PauseCommand(msg)
	if (IsRaidLeader() or IsRaidOfficer()) then
		if tonumber(msg) then
			timer.pausetimer = tonumber(msg)
		else
			self:Sync(syncName.stoppausetimer)
			return
		end

		if  timer.pausetimer == 0 then
			-- stop pull timer if it is already running
			local registered, time, elapsed, running = self:BarStatus(L["Pause"])
			if running then
				self:Sync(syncName.stoppausetimer)
				return
				-- otherwise start a 1min pull timer
			else
				timer.pulltimer = 1
			end
		elseif ((timer.pulltimer > 63) or (timer.pulltimer < 1))  then
			return
		end

		self:Sync("BWCustomBar "..timer.pulltimer.." ".."bwPauseTimer")	--[[This triggers a pull timer for older versions of bigwigs.
		Modified CustomBar.lua RecvSync to ignore sync calls with "bwPullTimer" string in them.
		--]]
		self:Sync(syncName.pausetimer.." "..timer.pausetimer)
	else
		self:Print(L["You have to be the raid leader or an assistant"])
	end
end

function BigWigsPausetimer:BigWigs_StopPausetimer()
	self:TriggerEvent("BigWigs_StopBar", self, L["Pause"])
	self:CancelDelayedSound("One")
	self:CancelDelayedSound("Two")
	self:CancelDelayedSound("Three")
	self:CancelDelayedSound("Four")
	self:CancelDelayedSound("Five")
	self:CancelDelayedMessage(L["pause0_message"])
	self:CancelDelayedMessage(L["pause1_message"])
	self:CancelDelayedMessage(L["pause2_message"])
	self:CancelDelayedMessage(L["pause3_message"])
	self:CancelDelayedMessage(L["pause4_message"])
	self:CancelDelayedMessage(L["pause5_message"])
end

function BigWigsPausetimer:BigWigs_Pausetimer(duration, requester)
	--cancel events from an ongoing pull timer in case a new one is initiated
	self:BigWigs_StopPausetimer()

	if tonumber(duration) then
		timer.pausetimer = tonumber(duration)
	else
		return
	end

	self:Message(string.format(L["pausestart_message"], timer.pausetimer, requester), "Attention", false, "RaidAlert")
	self:Bar(L["Pause"], timer.pausetimer, icon.pausetimer)

	--self:DelayedSound(timer.pulltimer, "Warning")
	self:DelayedMessage(timer.pausetimer, L["pause0_message"], "Important", false, "Warning")
	self:DelayedSound(timer.pausetimer - 1, "One")
	self:DelayedMessage(timer.pausetimer - 1, L["pause1_message"], "Attention", false, false, true)
	if not (timer.pausetimer < 2.2) then
		self:DelayedSound(timer.pausetimer - 2, "Two")
		self:DelayedMessage(timer.pausetimer - 2, L["pause2_message"], "Attention", false, false, true)
	end
	if not (timer.pausetimer < 3.2) then
		self:DelayedSound(timer.pausetimer - 3, "Three")
		self:DelayedMessage(timer.pausetimer - 3, L["pause3_message"], "Attention", false, false, true)
	end
	if not (timer.pausetimer < 4.2) then
		self:DelayedSound(timer.pausetimer - 4, "Four")
		self:DelayedMessage(timer.pausetimer - 4, L["pause4_message"], "Attention", false, false, true)
	end
	if not (timer.pausetimer < 5.2) then
		self:DelayedSound(timer.pausetimer - 5, "Five")
		self:DelayedMessage(timer.pausetimer - 5, L["pause5_message"], "Attention", false, false, true)
	end
end
