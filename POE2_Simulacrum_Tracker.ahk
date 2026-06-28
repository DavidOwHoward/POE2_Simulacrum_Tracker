#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; POE2 Simulacrum Tracker
; Phase 1 + Phase 2
; Data Model + Compact GUI
; ============================================================

AppName := "POE2 Simulacrum Tracker"
AppVersion := "0.2.0"

; =============================================================
; Configuration
; =============================================================

ConfigPath := A_ScriptDir "\config.ini"
DiscordEnabled := false
DiscordWebhookUrl := ""

LoadConfig()

; ============================================================
; PROVIDED LISTS
; Replace CurrencyOptions and UniqueOptions with your final lists.
; ============================================================

CurrencyOptions := [
    "Mirror of Kalandra",
    "Hinekora Lock",
    "Divine",
    "Perfect Chaos",
    "Greater Chaos",
    "Chaos",
    "Orb of Annulment",
    "Perfect Exalted",
    "Greater Exalted",
    "Perfect Regal",
    "Greater Regal",
    "Perfect Jeweller",
    "Orb of Chance",
    "Perfect Augmentation",
    "Perfect Transmutation"
]

LiquidEmotionOptions := [
    "Diluted Liquid Ire",
    "Diluted Liquid Guilt",
    "Diluted Liquid Greed",
    "Liquid Paranoia",
    "Liquid Envy",
    "Liquid Disgust",
    "Liquid Despair",
    "Concentrated Liquid Fear",
    "Concentrated Liquid Suffering",
    "Concentrated Liquid Isolation",
    "Ancient Diluted Liquid Ire",
    "Ancient Diluted Liquid Guilt",
    "Ancient Diluted Liquid Greed",
    "Ancient Liquid Paranoia",
    "Ancient Liquid Envy",
    "Ancient Liquid Disgust",
    "Ancient Liquid Despair",
    "Ancient Concentrated Liquid Fear",
    "Ancient Concentrated Liquid Suffering",
    "Ancient Concentrated Liquid Isolation",
    "Potent Liquid Melancholy",
    "Potent Liquid Ferocity",
    "Potent Liquid Contempt",
    "Ancient Potent Liquid Melancholy",
    "Ancient Potent Liquid Ferocity",
    "Ancient Potent Liquid Contempt"
]

UniqueOptions := [
    "Megalomaniac", "Assailum", "Voices", "Perfidy", "Collapsing Horizon", "Strugglescream", "Melting Maelstrom"
]

; ============================================================
; DATA MODEL
; ============================================================

CreateSimulacrum() {
    return Map(
        "CurrencyTotals", Map(),
        "EmotionTotals", Map(),
        "Uniques", []
    )
}

CurrentSimulacrum := CreateSimulacrum()

; ============================================================
; GUI STATE
; ============================================================

TrackerGui := ""
GuiVisible := false

CurrencyList := ""
CurrencyQtyEdit := ""

EmotionList := ""
EmotionQtyEdit := ""

UniqueList := ""

SummaryCurrency := ""
SummaryEmotions := ""
SummaryUniques := ""

StatusText := ""

BuildGui()

#HotIf WinActive("ahk_exe PathOfExileSteam.exe") || WinActive("ahk_class POEWindowClass")
^Space::{
    KeyWait "Space"
    KeyWait "Ctrl"
    ToggleGui()
}
#HotIf

; Temporary testing hotkey outside POE.
F10::ToggleGui()

; ============================================================
; GUI
; ============================================================

BuildGui() {
    global TrackerGui
    global CurrencyList, CurrencyQtyEdit, EmotionList, EmotionQtyEdit, UniqueList
    global SummaryCurrency, SummaryEmotions, SummaryUniques, StatusText
    global AppName, AppVersion, CurrencyOptions, LiquidEmotionOptions, UniqueOptions

    TrackerGui := Gui("+ToolWindow", AppName " v" AppVersion)
    TrackerGui.SetFont("s9", "Segoe UI")

    ; LEFT SIDE - INPUTS

    TrackerGui.Add("Text", "xm ym", "Currency")
    CurrencyList := TrackerGui.Add("ListBox", "xm w220 h110", CurrencyOptions)

    TrackerGui.Add("Text", "x+10 yp", "Qty")
    CurrencyQtyEdit := TrackerGui.Add("Edit", "w50 Number", "1")

    addCurrencyBtn := TrackerGui.Add("Button", "xp y+8 w120", "Add Currency")
    addCurrencyBtn.OnEvent("Click", OnAddCurrency)

    TrackerGui.Add("Text", "xm y+12", "Delirium Emotion")
    EmotionList := TrackerGui.Add("ListBox", "xm w220 h130", LiquidEmotionOptions)

    TrackerGui.Add("Text", "x+10 yp", "Qty")
    EmotionQtyEdit := TrackerGui.Add("Edit", "w50 Number", "1")

    addEmotionBtn := TrackerGui.Add("Button", "xp y+8 w120", "Add Emotion")
    addEmotionBtn.OnEvent("Click", OnAddEmotion)

    TrackerGui.Add("Text", "xm y+12", "Unique")
    UniqueList := TrackerGui.Add("ListBox", "xm w220 h110", UniqueOptions)

    addUniqueBtn := TrackerGui.Add("Button", "xm y+5 w120", "Add Unique")
    addUniqueBtn.OnEvent("Click", OnAddUnique)

    ; RIGHT SIDE - CURRENT SIMULACRUM SUMMARY

    TrackerGui.Add("Text", "x380 ym", "Current Simulacrum")

    TrackerGui.Add("Text", "x380 y+8", "Currency")
    SummaryCurrency := TrackerGui.Add("ListBox", "x380 y+2 w300 h110")
    SummaryCurrency.OnEvent("DoubleClick", OnRemoveCurrency)

    TrackerGui.Add("Text", "x380 y+8", "Delirium Emotions")
    SummaryEmotions := TrackerGui.Add("ListBox", "x380 y+2 w300 h110")
    SummaryEmotions.OnEvent("DoubleClick", OnRemoveEmotion)

    TrackerGui.Add("Text", "x380 y+8", "Uniques")
    SummaryUniques := TrackerGui.Add("ListBox", "x380 y+2 w300 h110")
    SummaryUniques.OnEvent("DoubleClick", OnRemoveUnique)

    clearBtn := TrackerGui.Add("Button", "x380 y+12 w100", "Clear")
    clearBtn.OnEvent("Click", OnClear)

    submitBtn := TrackerGui.Add("Button", "x380 y+12 w120", "Submit Encounter")
    submitBtn.OnEvent("Click", OnSubmitEncounter)

    clearBtn := TrackerGui.Add("Button", "x+10 w80", "Clear")
    clearBtn.OnEvent("Click", OnClear)

    hideBtn := TrackerGui.Add("Button", "x+10 w80", "Hide")
    hideBtn.OnEvent("Click", (*) => HideGui())

StatusText := TrackerGui.Add("Text", "x380 y+10 w300", "Ready")

    hideBtn := TrackerGui.Add("Button", "x+10 w100", "Hide")
    hideBtn.OnEvent("Click", (*) => HideGui())

    StatusText := TrackerGui.Add("Text", "x380 y+10 w300", "Ready")

    TrackerGui.OnEvent("Close", (*) => HideGui())

    RefreshUI()
}

ToggleGui() {
    global GuiVisible
    GuiVisible ? HideGui() : ShowGui()
}

ShowGui() {
    global TrackerGui, GuiVisible

    if GuiVisible
        return

    TrackerGui.Show("x950 y120")
    GuiVisible := true
}

HideGui() {
    global TrackerGui, GuiVisible

    TrackerGui.Hide()
    GuiVisible := false
}

; ============================================================
; EVENT HANDLERS
; ============================================================

OnAddCurrency(*) {
    global CurrentSimulacrum, CurrencyList, CurrencyQtyEdit

    try {
        AddCurrency(CurrentSimulacrum, CurrencyList.Text, CurrencyQtyEdit.Value)
        CurrencyList.Choose(0)
        CurrencyQtyEdit.Value := "1"
        SetStatus("Currency added.")
        RefreshUI()
    } catch as err {
        SetStatus(err.Message)
        MsgBox err.Message
    }
}

OnAddEmotion(*) {
    global CurrentSimulacrum, EmotionList, EmotionQtyEdit

    try {
        AddEmotion(CurrentSimulacrum, EmotionList.Text, EmotionQtyEdit.Value)
        EmotionList.Choose(0)
        EmotionQtyEdit.Value := "1"
        SetStatus("Emotion added.")
        RefreshUI()
    } catch as err {
        SetStatus(err.Message)
        MsgBox err.Message
    }
}

OnAddUnique(*) {
    global CurrentSimulacrum, UniqueList

    try {
        AddUnique(CurrentSimulacrum, UniqueList.Text)
        UniqueList.Choose(0)
        SetStatus("Unique added.")
        RefreshUI()
    } catch as err {
        SetStatus(err.Message)
        MsgBox err.Message
    }
}

OnRemoveCurrency(*) {
    global CurrentSimulacrum, SummaryCurrency

    selected := SummaryCurrency.Text

    if selected = "" || selected = "None"
        return

    for currency, quantity in CurrentSimulacrum["CurrencyTotals"] {
        if selected = quantity " " currency {
            CurrentSimulacrum["CurrencyTotals"].Delete(currency)
            SetStatus("Currency removed.")
            RefreshUI()
            return
        }
    }
}

OnRemoveEmotion(*) {
    global CurrentSimulacrum, SummaryEmotions

    selected := SummaryEmotions.Text

    if selected = "" || selected = "None"
        return

    for emotion, quantity in CurrentSimulacrum["EmotionTotals"] {
        if selected = quantity " " emotion {
            CurrentSimulacrum["EmotionTotals"].Delete(emotion)
            SetStatus("Emotion removed.")
            RefreshUI()
            return
        }
    }
}

OnRemoveUnique(*) {
    global CurrentSimulacrum, SummaryUniques

    index := SummaryUniques.Value

    if index <= 0 || CurrentSimulacrum["Uniques"].Length = 0
        return

    CurrentSimulacrum["Uniques"].RemoveAt(index)
    SetStatus("Unique removed.")
    RefreshUI()
}

OnClear(*) {
    result := MsgBox("Clear the current simulacrum?", "Confirm Clear", "YesNo Icon?")
    if result != "Yes"
        return

    ClearSimulacrum()
    ClearInputs()
    SetStatus("Current simulacrum cleared.")
    RefreshUI()
}

ClearInputs() {
    global CurrencyList, CurrencyQtyEdit, EmotionList, EmotionQtyEdit, UniqueList

    CurrencyList.Choose(0)
    CurrencyQtyEdit.Value := "1"

    EmotionList.Choose(0)
    EmotionQtyEdit.Value := "1"

    UniqueList.Choose(0)
}

OnSubmitEncounter(*) {
    global CurrentSimulacrum

    try {
        ValidateSimulacrumForSubmit(CurrentSimulacrum)

        logPath := GetSimulacrumLogPath()
        encounterNumber := GetNextEncounterNumber(logPath)
        output := FormatSimulacrum(CurrentSimulacrum, encounterNumber)

        FileAppend output "`n", logPath, "UTF-8"

        ClearSimulacrum()
        ClearInputs()
        RefreshUI()

        SetStatus("Encounter " encounterNumber " saved.")
        MsgBox "Encounter " encounterNumber " saved.`n`n" logPath
    } catch as err {
        SetStatus(err.Message)
        MsgBox err.Message
    }
}

ValidateSimulacrumForSubmit(simulacrum) {
    if simulacrum["CurrencyTotals"].Count = 0
        && simulacrum["EmotionTotals"].Count = 0
        && simulacrum["Uniques"].Length = 0 {
        throw Error("Nothing to submit.")
    }
}

GetSimulacrumLogPath() {
    logDir := A_ScriptDir "\logs"

    if !DirExist(logDir)
        DirCreate(logDir)

    return logDir "\Simulacrum_Log_" FormatTime(, "yyyy-MM-dd") ".txt"
}

GetNextEncounterNumber(filePath) {
    if !FileExist(filePath)
        return 1

    content := FileRead(filePath)
    count := 0
    pos := 1

    while pos := RegExMatch(content, "Encounter\s+\d+", &match, pos) {
        count++
        pos += StrLen(match[0])
    }

    return count + 1
}

; ============================================================
; CONFIG FUNCTIONS
; ============================================================

LoadConfig() {
    global ConfigPath, DiscordEnabled, DiscordWebhookUrl

    if !FileExist(ConfigPath) {
        CreateDefaultConfig(ConfigPath)
        DiscordEnabled := false
        DiscordWebhookUrl := ""
        return
    }

    enabledValue := IniRead(ConfigPath, "Discord", "Enabled", "false")
    webhookValue := IniRead(ConfigPath, "Discord", "WebhookUrl", "")

    DiscordEnabled := StrLower(Trim(enabledValue)) = "true"
    DiscordWebhookUrl := Trim(webhookValue)
}

CreateDefaultConfig(configPath) {
    defaultConfig := ""
    defaultConfig .= "[Discord]`n"
    defaultConfig .= "Enabled=false`n"
    defaultConfig .= "WebhookUrl=`n"

    FileAppend defaultConfig, configPath, "UTF-8"
}


; ============================================================
; UI REFRESH
; ============================================================

RefreshUI() {
    global CurrentSimulacrum
    global SummaryCurrency, SummaryEmotions, SummaryUniques

    RefreshTotalsListBox(SummaryCurrency, CurrentSimulacrum["CurrencyTotals"])
    RefreshTotalsListBox(SummaryEmotions, CurrentSimulacrum["EmotionTotals"])
    RefreshArrayListBox(SummaryUniques, CurrentSimulacrum["Uniques"])
}

RefreshTotalsListBox(listBox, totals) {
    listBox.Delete()

    if totals.Count = 0 {
        listBox.Add(["None"])
        return
    }

    for name, quantity in totals {
        listBox.Add([quantity " " name])
    }
}

RefreshArrayListBox(listBox, items) {
    listBox.Delete()

    if items.Length = 0 {
        listBox.Add(["None"])
        return
    }

    index := 1
    for item in items {
        listBox.Add([index ". " item])
        index++
    }
}

SetStatus(message) {
    global StatusText
    StatusText.Text := message
}

; ============================================================
; SIMULACRUM FUNCTIONS
; ============================================================

AddCurrency(simulacrum, currency, quantity) {
    AddQuantityTotal(simulacrum["CurrencyTotals"], currency, quantity, "Currency")
}

AddEmotion(simulacrum, emotion, quantity) {
    AddQuantityTotal(simulacrum["EmotionTotals"], emotion, quantity, "Emotion")
}

AddQuantityTotal(totals, name, quantity, label) {
    name := Trim(name)
    quantity := Integer(quantity)

    if name = ""
        throw Error(label " is required.")

    if quantity <= 0
        throw Error("Quantity must be greater than 0.")

    if totals.Has(name)
        totals[name] += quantity
    else
        totals[name] := quantity
}

AddUnique(simulacrum, uniqueName) {
    uniqueName := Trim(uniqueName)

    if uniqueName = ""
        throw Error("Unique is required.")

    simulacrum["Uniques"].Push(uniqueName)
}

ClearSimulacrum() {
    global CurrentSimulacrum
    CurrentSimulacrum := CreateSimulacrum()
}

; ============================================================
; FORMATTER
; Used later by Phase 3 persistence and Phase 4 Discord.
; ============================================================

FormatSimulacrum(simulacrum, encounterNumber := 1) {
    text := ""

    text .= "Encounter " encounterNumber "`n"
    text .= "-------------`n`n"

    text .= "Currency`n"
    text .= "-------------`n"
    text .= FormatTotals(simulacrum["CurrencyTotals"])

    text .= "`nDelirium Emotions`n"
    text .= "-------------`n"
    text .= FormatTotals(simulacrum["EmotionTotals"])

    text .= "`nUniques`n"
    text .= "-------------`n"
    text .= FormatArray(simulacrum["Uniques"])

    text .= "`n"

    return text
}

FormatTotals(totals) {
    if totals.Count = 0
        return "None`n"

    text := ""

    for name, quantity in totals {
        text .= quantity " " name "`n"
    }

    return text
}

FormatArray(items) {
    if items.Length = 0
        return "None`n"

    text := ""
    index := 1

    for item in items {
        text .= index ". " item "`n"
        index++
    }

    return text
}