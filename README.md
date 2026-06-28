POE2 Simulacrum Tracker

A lightweight AutoHotkey v2 utility for tracking Path of Exile 2 Simulacrum encounter results.

The tracker is designed to make it quick to record currency, liquid emotions, and unique drops during or after a Simulacrum run. Results are saved to a daily log file and can optionally be posted to a Discord channel using a webhook.

Features
Compact AutoHotkey GUI
Opens with Ctrl + Space while Path of Exile is active
Optional F10 test hotkey for opening the GUI outside of Path of Exile
Track currency drops with quantities
Track Liquid Emotion drops with quantities
Track unique drops as individual entries
Currency and Liquid Emotion quantities are automatically totaled by type
Double-click summary entries to remove mistakes
Clear current encounter without closing the tracker
Hide the tracker without losing current encounter data
Submit encounters to a daily log file
Optional Discord webhook posting
Requirements
Windows
AutoHotkey v2
Path of Exile 2

This script is written for AutoHotkey v2. It will not run correctly with AutoHotkey v1.

Basic Usage
Run the .ahk script.
Open Path of Exile 2.
Press Ctrl + Space to open the tracker.
Select a currency, Liquid Emotion, or unique item.
Enter a quantity where applicable.
Click the appropriate Add button.
Review the current encounter summary.
Double-click any summary item to remove it if needed.
Click Submit Encounter to save the encounter.
Hotkeys
Hotkey	Description
Ctrl + Space	Opens/hides the tracker while Path of Exile is active
F10	Opens/hides the tracker for testing outside Path of Exile, if enabled in the script
Log Files

Encounter logs are written to the logs folder.

The log file name uses the current date:

logs/Simulacrum_Log_YYYY-MM-DD.txt

Example:

logs/Simulacrum_Log_2026-06-27.txt

Any encounter submitted after midnight will automatically be written to a new log file for the new date.

The logs folder is intended for local generated output and should not be committed to the repository.

Discord Webhook Setup

Discord posting is optional.

The project includes an example config file:

config.example.ini

To enable Discord posting:

Rename config.example.ini to config.ini, or remove example from the file name.
To get a Discord webhook:
Right-click the Discord channel where you want to post your results.
Click Edit Channel.
Click Integrations.
Click Webhooks.
Click Add or New Webhook.
Name the webhook.
Copy the webhook URL.
Add the webhook URL to config.ini.
Surround the webhook URL with quotes if your config format expects quotes.
Change Enabled=false to Enabled=true.
Save the file.
Restart the script.

Example:

[Discord]
Enabled=true
WebhookUrl="https://discord.com/api/webhooks/your_webhook_here"

If Discord is disabled or the webhook URL is blank, the tracker will still save encounters locally.


Example Output
Encounter 1
-------------

Currency
-------------
3 Divine
2 Perfect Chaos

Delirium Emotions
-------------
4 Liquid Envy
1 Concentrated Liquid Fear

Uniques
-------------
1. Example Unique
2. Another Unique

Current Scope

This tracker is focused on Simulacrum encounter result tracking.

Currently tracked:

Currency
Liquid Emotions
Unique drops

Not currently tracked:

Character/build details
Map/area metadata
Screenshots
OCR
Long-term statistics dashboard
Planned Improvements

Possible future improvements:

Better searchable selectors
Session summaries
Total currency and emotion aggregation across a session
Discord summary formatting improvements
Export to CSV or JSON
Migration to a full desktop application outside of AutoHotkey
Development Notes

The tracker follows the same general structure as the POE2 Expedition Tracker prototype:

Data model
GUI
Event handlers
Formatter
Log persistence
Optional Discord posting

The current encounter is stored in memory while the GUI is open. Clicking Hide does not clear the current encounter. Clicking Clear resets the current encounter.