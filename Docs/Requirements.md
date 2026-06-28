Must Haves:
The application will have a list of currency(the list is provided below) which the user can choose to add to the list for a given simulacrum
	A quantity box should be added so the user can enter a quantity for the currency
		Nice to Have: a +- button to increment quantity
		
The application will have a list(list provide below) of uniques dropped by the simulacrum which the user can choose to add to the a list for a given simulacrum

The application will have a list of delirium emotions(list provided below) that the user can choose to add to the list for a giveun simulacrum
	A quantity box should be added so the user can enter a quantity for the delirium emotions
		Nice to Have: a +- button to increment the quantity
		
Double clicking submitted items from the above will remove it from the list

The application will have a "Submit Encounter" button which will have two functions:
	1) write the results to a log file
		a. the log file will be hosted in the directory the script is run from in a folder named "logs"
		b. the log will be named using the following format: "Simulacrum - {Current Date}
			i.The data written to the log file will be formatted as follows
				Encounter #
				-------------
				Currency
				-------------
					(list of currency and their totals)				
				Delirium Emotions
				-------------
					(list of delirium emotions and their totals
				Uniques
				-------------
					(list of each unique entered)
			ii.all run counters will reset at the end of the day, 11:59pm
				a.Assuming a run starts at 11:55pm pm on 7/1/2026 and ends at 12:01am on 7/2/2026, a new log will be created for that day
	2) a discord webhook will be added to report the results to a specific discord channel, based on the provided webhook
		Nice to Have: a way to store the webhook outside the script so that when committing to source control, the webhook is not exposed

To open the script(after it has been started), the user will press ctrl+space(^Space)

The application will have a "Hide" button that hides the GUI, but does not remove the data