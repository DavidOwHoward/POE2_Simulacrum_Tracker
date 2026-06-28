# POE2 Simulacrum Tracker

A lightweight **AutoHotkey v2** utility for tracking **Path of Exile 2 Simulacrum encounter results**.

The tracker is designed to make it quick to record:

* Currency drops
* Liquid Emotion drops
* Unique item drops

Results are saved to a daily log file and can optionally be posted to a Discord channel using a webhook.

---

## Features

* Compact AutoHotkey GUI
* Opens with `Ctrl + Space` while Path of Exile is active
* Optional `F10` test hotkey for opening the GUI outside of Path of Exile
* Track currency drops with quantities
* Track Liquid Emotion drops with quantities
* Track unique drops as individual entries
* Automatically total currency by type
* Automatically total Liquid Emotions by type
* Double-click summary entries to remove mistakes
* Clear the current encounter without closing the tracker
* Hide the tracker without losing current encounter data
* Submit encounters to a daily log file
* Optional Discord webhook posting

---

## Requirements

* Windows
* [AutoHotkey v2](https://www.autohotkey.com/)
* Path of Exile 2

> This script is written for **AutoHotkey v2**.
> It will not run correctly with AutoHotkey v1.

---

## Basic Usage

1. Run the `.ahk` script.
2. Open Path of Exile 2.
3. Press `Ctrl + Space` to open the tracker.
4. Select a currency, Liquid Emotion, or unique item.
5. Enter a quantity where applicable.
6. Click the appropriate Add button.
7. Review the current encounter summary.
8. Double-click any summary item to remove it if needed.
9. Click `Submit Encounter` to save the encounter.

---

## Hotkeys

| Hotkey         | Description                                                                            |
| -------------- | -------------------------------------------------------------------------------------- |
| `Ctrl + Space` | Opens or hides the tracker while Path of Exile is active                               |
| `F10`          | Opens or hides the tracker for testing outside Path of Exile, if enabled in the script |

---

## Log Files

Encounter logs are written to the `logs` folder.

The log file name uses the current date:

```text
logs/Simulacrum_Log_YYYY-MM-DD.txt
```

Example:

```text
logs/Simulacrum_Log_2026-06-27.txt
```

Any encounter submitted after midnight is automatically written to a new log file for the new date.

The `logs` folder is intended for local generated output and should not be committed to the repository.

---

## Discord Webhook Setup

Discord posting is optional.

The project includes an example config file:

```text
config.example.ini
```

To enable Discord posting:

1. Rename `config.example.ini` to `config.ini`, or remove `example` from the file name.
2. Get a Discord webhook:

   * Right-click the Discord channel where you want to post your results.
   * Click `Edit Channel`.
   * Click `Integrations`.
   * Click `Webhooks`.
   * Click `Add` or `New Webhook`.
   * Name the webhook.
   * Copy the webhook URL.
3. Add the webhook URL to `config.ini`.
4. Surround the webhook URL with quotes.
5. Change `Enabled=false` to `Enabled=true`.
6. Save the file.
7. Restart the script.

Example:

```ini
[Discord]
Enabled=true
WebhookUrl="https://discord.com/api/webhooks/your_webhook_here"
```

If Discord is disabled or the webhook URL is blank, the tracker still saves encounters locally.

---

## Example Output

```text
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
```

---

## Current Scope

This tracker is focused on Simulacrum encounter result tracking.

### Currently Tracked

* Currency
* Liquid Emotions
* Unique drops

### Not Currently Tracked

* Character or build details
* Map or area metadata
* Screenshots
* OCR
* Long-term statistics dashboard

---

## Planned Improvements

Possible future improvements:

* Better searchable selectors
* Session summaries
* Total currency and emotion aggregation across a session
* Discord summary formatting improvements
* Export to CSV or JSON
* Migration to a full desktop application outside of AutoHotkey

---

## Development Notes

The tracker follows a simple structure:

* Data model
* GUI
* Event handlers
* Formatter
* Log persistence
* Optional Discord posting

The current encounter is stored in memory while the GUI is open.

Clicking `Hide` does **not** clear the current encounter.

Clicking `Clear` resets the current encounter.
