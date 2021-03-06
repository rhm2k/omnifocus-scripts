(*
	# DESCRIPTION #
	
	Creates a Completed task in a folder and project, with optional tag(s). 
	I keep a handful of these scripts that log to specific projects
		
	# LICENSE #

	Copyright � 2015-2020 Dan Byler (contact: dbyler@gmail.com)
	Licensed under MIT License (http://www.opensource.org/licenses/mit-license.php)
	(TL;DR: no warranty, do whatever you want with it.)

	# CHANGE HISTORY #

	2020-02-14
	-	Updated for OmniFocus 3; supports adding 0 or many tags

	2018-03-15
	-	Updated for compatibility with a breaking change in OmniFocus' AppleScript Dictionary

	2015-05-19
	-	Initial version

	# CONFIGURATION #

	1. set myFolderName to the name of the folder containing your the destination project
	2. set myProjectName to the name of the destination project
	3. set myContextName to the name of the destination context
	4. Save this script in a place that can be indexed by LaunchBar or Alfred

*)

property myFolderName : "Miscellaneous"
property myProjectName : "Ad Hoc"
property myTags : ["tag1", "tag2"] --set to empty list [] if you don't want to set tags


on log_item(myTaskName)
	tell application "OmniFocus"
		tell default document
			set myFolder to (get first folder whose name is myFolderName)
			repeat with thisProject in (flattened projects in myFolder)
				if name of thisProject is equal to myProjectName then
					set myProject to thisProject
					exit repeat
				end if
			end repeat
			
			tell myProject
				set myTask to make task with properties {name:myTaskName}
				mark complete myTask
				
				tell application "OmniFocus"
					tell default document
						repeat with myTagName in myTags
							set myTag to (first flattened tag whose name is myTagName)
							add myTag to (tags of item 1 of myTask)
						end repeat
					end tell
				end tell
			end tell
			
			display notification "\"" & myTaskName & "\"" & " logged to " & name of myProject
			
		end tell
	end tell
end log_item

on handle_string(mystring)
	my log_item(mystring)
end handle_string

on alfred_script(q)
	main(q)
end alfred_script

on run
	tell application "OmniFocus"
		activate
		set mystring to text returned of (display dialog "Log in" & myProjectName & ":" default answer "Completed task description")
		my log_item(mystring)
	end tell
end run