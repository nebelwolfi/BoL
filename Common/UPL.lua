--[[
	_    _       _  __ _          _   _____              _ _      _   _               _      _ _                          
 | |  | |     (_)/ _(_)        | | |  __ \            | (_)    | | (_)             | |    (_) |                         
 | |  | |_ __  _| |_ _  ___  __| | | |__) | __ ___  __| |_  ___| |_ _  ___  _ __   | |     _| |__  _ __ __ _ _ __ _   _ 
 | |  | | '_ \| |  _| |/ _ \/ _` | |  ___/ '__/ _ \/ _` | |/ __| __| |/ _ \| '_ \  | |    | | '_ \| '__/ _` | '__| | | |
 | |__| | | | | | | | |  __/ (_| | | |   | | |  __/ (_| | | (__| |_| | (_) | | | | | |____| | |_) | | | (_| | |  | |_| |
	\____/|_| |_|_|_| |_|\___|\__,_| |_|   |_|  \___|\__,_|_|\___|\__|_|\___/|_| |_| |______|_|_.__/|_|  \__,_|_|   \__, |
																																																									 __/ |
																																																									|___/ 
	By Nebelwolfi


	How To Use:

		require("UPL")
		UPL = UPL()

		UPL:AddToMenu(Menu)
		Will add prediction selector to the given scriptConfig

		UPL:AddSpell(_Q, { speed = 1800, delay = 0.25, range = 900, width = 70, collision = true, aoe = false, type = "linear" })
		Will add the spell to all predictions

		CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, Target)
		if HitChance >= X then
			CastSpell(_Q, CastPosition.x, CastPosition.y)
		end
	
	Supports and auto-detects: VPrediction, SPrediction, DPrediction, HPrediction, KPrediction, FHPrediction

]]--

class "UPL"

--Scriptstatus tracker (usercounter)
assert(load(Base64Decode("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"), nil, "bt", _ENV))()
TrackerLoad("dUSfSclJkhEOpI3n")
--Scriptstatus tracker (usercounter)

function UPL:__init()
	if not _G.UPLloaded then
		_G.UPLversion = 9
		_G.UPLautoupdate = true
		_G.UPLloaded = false
		self.ActiveP = 1
		self.LastRequest = 0
		self.Config = nil
		self.predTable = {}
		self.Spells  = {
			FH={},
			KP={},
			HP={},
			DP={},
			VP={},
			SP={}
		}
		local possiblePredictions = {
			{"FH", "FHPrediction", function() return FHPrediction ~= nil end, 1.1, 1, 2, 2},
			{"KP", "KPrediction", function() return FileExist(LIB_PATH .. "KPrediction.lua") end, 1.75, 0, 3, 2},
			{"HP", "HPrediction", function() return FileExist(LIB_PATH .. "HPrediction.lua") end, 1.05, 0, 3, 2},
			{"DP", "DivinePred", function() return FileExist(LIB_PATH .. "DivinePred.lua") and FileExist(LIB_PATH .. "DivinePred.luac") end, 50, 0, 100, 0},
			{"VP", "VPrediction", function() return FileExist(LIB_PATH .. "VPrediction.lua") end, 2, 1, 3, 0},
			{"SP", "SPrediction", function() return FileExist(LIB_PATH .. "SPrediction.lua") end, 1, 1, 3, 0}
		}
		for i=1, #possiblePredictions do
			local pPred = possiblePredictions[i]
			if pPred[3]() then
				table.insert(self.predTable, {pPred[1], pPred[2], pPred[4], pPred[5], pPred[6], pPred[7]})
			end
		end
		self.slotToString = {[-6] = "P", [-5] = "R2", [-4] = "E2", [-3] = "W2", [-2] = "Q3", [-1] = "Q2", [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R"}
		self:Update()
		DelayAction(function() self:Loaded() end, 3)
		return self
	end
end

function UPL:Update()
	local UPL_UPDATE_HOST = "raw.githubusercontent.com"
	local UPL_UPDATE_PATH = "/nebelwolfi/BoL/master/Common/UPL.lua"
	local UPL_UPDATE_FILE_PATH = LIB_PATH.."UPL.lua"
	local UPL_UPDATE_URL = "https://"..UPL_UPDATE_HOST..UPL_UPDATE_PATH
	if UPLautoupdate then
		local UPLServerData = GetWebResult(UPL_UPDATE_HOST, "/nebelwolfi/BoL/master/Common/UPL.version")
		if UPLServerData then
			UPLServerVersion = type(tonumber(UPLServerData)) == "number" and tonumber(UPLServerData) or nil
			if UPLServerVersion then
				if tonumber(UPLversion) < UPLServerVersion then
					self:Msg("New version available v"..UPLServerVersion)
					self:Msg("Updating, please don't press F9")
					DelayAction(function() DownloadFile(UPL_UPDATE_URL, UPL_UPDATE_FILE_PATH, function () self:Msg("Successfully updated. ("..UPLversion.." => "..UPLServerVersion.."), press F9 twice to load the updated version") end) end, 3)
					return true
				end
			end
		else
			self:Msg("Error downloading version info")
		end
	end
	return false
end

function UPL:Loaded()
	local preds = ""
	for k,v in pairs(self.predTable) do
		preds=preds.." "..v[2]
		if k ~= #self.predTable then preds=preds.."," end
	end
	self:Msg("Loaded the latest version (v"..UPLversion..")")
	self:Msg("Detected predictions: "..preds)
	UPLloaded = true
end

function UPL:Msg(msg)
	print("<font color=\"#ff0000\">[</font><font color=\"#ff2000\">U</font><font color=\"#ff4000\">n</font><font color=\"#ff5f00\">i</font><font color=\"#ff7f00\">f</font><font color=\"#ff9900\">i</font><font color=\"#ffb200\">e</font><font color=\"#ffcc00\">d</font><font color=\"#ffe500\">P</font><font color=\"#ffff00\">r</font><font color=\"#bfff00\">e</font><font color=\"#80ff00\">d</font><font color=\"#40ff00\">i</font><font color=\"#00ff00\">c</font><font color=\"#00ff40\">t</font><font color=\"#00ff80\">i</font><font color=\"#00ffbf\">o</font><font color=\"#00ffff\">n</font><font color=\"#00ccff\">L</font><font color=\"#0099ff\">i</font><font color=\"#0066ff\">b</font><font color=\"#0033ff\">r</font><font color=\"#0000ff\">a</font><font color=\"#2300ff\">r</font><font color=\"#4600ff\">y</font><font color=\"#6800ff\">]</font><font color=\"#8b00ff\">:</font> <font color=\"#FFFFFF\">"..msg.."</font>") 
end

function UPL:GetFHSpell(data)
	local spell = table.copy(data)
	spell.radius = spell.width * 0.5
	local fhType = 0
	if spell.type == "linear" then
		fhType = (not spell.speed or spell.speed == math.huge) and SkillShotType.SkillshotLine or SkillShotType.SkillshotMissileLine
	elseif spell.type == "circular" then
		fhType = SkillShotType.SkillshotCircle
	elseif spell.type == "cone" then
		fhType = SkillShotType.SkillshotCone
	else
		fhType = (not spell.speed or spell.speed == math.huge) and SkillShotType.SkillshotLine or SkillShotType.SkillshotMissileLine
	end
	return spell
end

function UPL:GetHPSpell(spell)
	require "HPrediction"
	if spell.type == "linear" then
		if spell.speed ~= math.huge then 
			if spell.collision then
				return HPSkillshot({type = "DelayLine", range = spell.range, speed = spell.speed, width = spell.width, delay = spell.delay, collisionM = spell.collision, collisionH = spell.collision})
			else
				return HPSkillshot({type = "DelayLine", range = spell.range, speed = spell.speed, width = spell.width, delay = spell.delay})
			end
		else
			return HPSkillshot({type = "PromptLine", range = spell.range, width = spell.width, delay = spell.delay})
		end
	elseif spell.type == "circular" then
		if spell.speed ~= math.huge then 
			return HPSkillshot({type = "DelayCircle", range = spell.range, speed = spell.speed, radius = .5*spell.width, delay = spell.delay})
		else
			return HPSkillshot({type = "PromptCircle", range = spell.range, radius = .5*spell.width, delay = spell.delay})
		end
	else
		return HPSkillshot({type = "DelayLine", range = spell.range, speed = spell.speed, width = spell.width, delay = spell.delay})
	end
end

function UPL:GetKPSpell(spell)
	require "KPrediction"
	if spell.type == "linear" then
		if spell.speed ~= math.huge then 
			return KPSkillshot({type = "DelayLine", range = spell.range, speed = spell.speed, width = spell.width, delay = spell.delay})
		else
			return KPSkillshot({type = "PromptLine", range = spell.range, width = spell.width, delay = spell.delay})
		end
	elseif spell.type == "circular" then
		if spell.speed ~= math.huge then 
			return KPSkillshot({type = "DelayCircle", range = spell.range, speed = spell.speed, radius = .5*spell.width, delay = spell.delay})
		else
			return KPSkillshot({type = "PromptCircle", range = spell.range, radius = .5*spell.width, delay = spell.delay})
		end
	else
		if spell.angle then
			if spell.speed ~= math.huge then
				return KPSkillshot({type = "DelayArc", range = spell.range, angle = spell.angle, speed = spell.speed, delay = spell.delay})
			else
				return KPSkillshot({type = "PromptArc", range = spell.range, angle = spell.angle, delay = spell.delay})
			end
		else
			return KPSkillshot({type = "DelayLine", range = spell.range, speed = spell.speed, width = spell.width, delay = spell.delay})
		end
	end
end

function UPL:GetDPSpell(spell)
	require "DivinePred"
	local col = spell.collision and ((myHero.charName=="Lux" or myHero.charName=="Veigar") and 1 or 0) or math.huge
	if spell.type == "circular" then
		return CircleSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
	elseif spell.type == "cone" then
		return ConeSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
	else
		return LineSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
	end
end

function UPL:GetVPSpell(data)
	require "VPrediction"
	return data
end

function UPL:GetSPSpell(data)
	require "SPrediction"
	return data
end

function UPL:AddToMenu(Config)
	self.Config = Config or scriptConfig("Prediction Handler (UPL)", "Prediction"..myHero.charName)
	if Config then self.Config:addSubMenu("Prediction Handler (UPL)", "Prediction"..myHero.charName) self.Config = self.Config["Prediction"..myHero.charName] end
end

function UPL:AddToMenu2(Config)
	self.Config = Config or scriptConfig("Prediction Handler (UPL)", "Prediction"..myHero.charName)
	if Config then self.Config:addSubMenu("Prediction Handler (UPL)", "Prediction"..myHero.charName) self.Config = self.Config["Prediction"..myHero.charName] end
	for i, v in pairs(self.Spells) do
		for k, e in pairs(v) do
			self:AddSpellToMenu(k)
		end
		break
	end
end

function UPL:AddSpell(slot, spellData)
	local toMenu = {}
	for i=1, #self.predTable do
		local cPred = self.predTable[i]
		self.Spells[cPred[1]][slot] = self["Get"..cPred[1].."Spell"](self, spellData)
		table.insert(toMenu, cPred[2])
	end
	self:AddSpellToMenu(slot)
end

function UPL:AddSpellToMenu(slot)
	local slotString = type(slot) == "string" and slot or type(slot) == "number" and self.slotToString[slot] or error("Please supply a valid slot.")
	if self.Config and not self.Config[slotString] then
		local toMenu = {}
		for i=1, #self.predTable do
			table.insert(toMenu, self.predTable[i][2])
		end
		local pAm = #self.Config._param
		if pAm > 0 then
			self.Config:addParam("spacer"..pAm, "", SCRIPT_PARAM_INFO, "")
		end
		self.Config:addParam(slotString, ">> Spell: "..slotString, SCRIPT_PARAM_INFO, "")
		self.Config:addParam(slotString.."Prediction", "Prediction: ", SCRIPT_PARAM_LIST, 1, toMenu)
		self.Config:addParam(slotString.."HitChance", "HitChance: ", SCRIPT_PARAM_SLICE, self.predTable[1][3], self.predTable[1][4], self.predTable[1][5], self.predTable[1][6])
		local function SetupMenu(i)
			self.Config:modifyParam(slotString.."HitChance", "min", self.predTable[i][4])
			self.Config:modifyParam(slotString.."HitChance", "max", self.predTable[i][5])
			self.Config:modifyParam(slotString.."HitChance", "idc", self.predTable[i][6])
			self.Config[slotString.."HitChance"] = self.predTable[i][3]
		end
		self.Config:setCallback(slotString.."Prediction", function(i)SetupMenu(i)end)SetupMenu(self.Config[slotString.."Prediction"])
	end
end

function UPL:ActivePred(spell)
	local slotString = type(slot) == "string" and slot or type(slot) == "number" and self.slotToString[slot] or error("Please supply a valid slot.")
	local int = self.Config[slotString.."Prediction"] or 1
	return tostring(self.predTable[int][2]), self.predTable[int]
end

function UPL:SetActive(pred)
	local slotString = type(slot) == "string" and slot or type(slot) == "number" and self.slotToString[slot] or error("Please supply a valid slot.")
	for i=1,#self.predTable do
		if self.predTable[i][2] == pred then
			self.Config[slotString.."Prediction"] = i
		end
	end
end

function UPL:ValidRequest(x)
	if GetInGameTimer() - self.LastRequest < self:TimeRequest(x) then
		return false
	else
		self.LastRequest = GetInGameTimer()
		return true
	end
end

function UPL:TimeRequest(spell)
	local aPred = self:ActivePred(spell)
	if aPred == "VPrediction" or aPred == "SPrediction" then
		return 0.001
	elseif aPred == "DivinePred" then
		return 0.1
	else
		return 0.01
	end
end

function UPL:FHPredict(spell, source, target)
	local spellString = self.slotToString[spell]
	local spell = self.Spells.FH[spell]
	local col = (self.FHPSpells[spell].collision and source.charName) and ((source.charName=="Lux" or source.charName=="Veigar") and 1 or 0) or math.huge
	local x, y, z = _G.FHPrediction.GetPrediction(FHPrediction.HasPreset(spellString) and spellString or spell, target, source)
	return x, (z and (not z.collision or z.collision.amount < col)) and y or 0, Vector(target)
end

function UPL:KPPredict(spell, source, target)
	if not KP then KP = KPrediction() end
	local spell = self.Spells.KP[spell]
	if spell.collision and (myHero.charName=="Lux" or myHero.charName=="Veigar") then
		spell.penetration = 1
	end
	local x, y, z1, z2 = KP:GetPrediction(spell, target, source, nil, spell.aoe)
	return x, y, Vector(target)
end

function UPL:HPPredict(spell, source, target)
	if not HP then HP = HPrediction() end
	local spell = self.Spells.HP[spell]
	local col = spell.collision and ((myHero.charName=="Lux" or myHero.charName=="Veigar") and 1 or 0) or math.huge
	return HP:GetPredict(spell, target, source, col)
end

function UPL:DPPredict(spell, source, target)
	if not DP then 
		DP = DivinePred()
		for i, v in pairs(self.Spells.DP) do
			local spellString = self.slotToString[i]
			DP:bindSS(spellString, self.Spells.DP[i], 1)
			self.Spells.DP[i] = spellString
		end
	end
	return DP:predict(self.Spells.DP[spell], target, Vector(source))
end

function UPL:VPPredict(spell, source, target)
	if not VP then VP = VPrediction() end
	local spell = self.Spells.VP[spell]
	if spell.type == "linear" then
		if spell.aoe then
			return VP:GetLineAOECastPosition(target, spell.delay, spell.width, spell.range, spell.speed, myHero)
		else
			return VP:GetLineCastPosition(target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
		end
	elseif spell.type == "circular" then
		if spell.aoe then
			return VP:GetCircularAOECastPosition(target, spell.delay, spell.width, spell.range, spell.speed, myHero)
		else
			return VP:GetCircularCastPosition(target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
		end
	elseif spell.type == "cone" then
		if spell.aoe then
			return VP:GetConeAOECastPosition(target, spell.delay, spell.width, spell.range, spell.speed, myHero)
		else
			return VP:GetLineCastPosition(target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
		end
	end
end

function UPL:SPPredict(spell, source, target)
	if not SP then SP = SPrediction() end
	local spell = self.Spells.SP[spell]
	return SP:Predict(target, spell.range, spell.speed, spell.delay, spell.width, (myHero.charName == "Lux" or myHero.charName == "Veigar") and 1 or spell.collision, source)
end

function UPL:Predict(slot, source, target)
	local slotString = type(slot) == "string" and slot or type(slot) == "number" and self.slotToString[slot] or error("Please supply a valid slot.")
	local aPred = self.predTable[self.Config[slotString.."Prediction"]][1]
	local a, b, c = self[aPred.."Predict"](self, slot, source, target)
	return a, b >= self.Config[slotString.."HitChance"] and b or 0, c
end
