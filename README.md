Decode a string encoded in Base64 into an https link and launch it in Google Chrome!

Yes, many websites and a two-or-three-liner in pyton/terminal can do the same job. 

But a MacOS app can detect your paste board content and generate a neat web link / chrome launcher! 

I actually learned a lot in this dumb little project (coming from 100% iOS development previously):

- Interprocess communication between NSPasteBoard and sandboxed app 

- NSNotificationCenter pattern to detect pasteboard changes
	- in MacOS, we can't set an observer on NSPasteBoard (which is a functionality in iOS), so our choices are to poll (ask the pasteboard for the most current value every couple of seconds) or to ask at a specific time. 
	- In this case, why not ask when we get the notification that the app is about to return to foreground status? i.e NSApplication.willBecomeActiveNotification. The user will need to switch to another app to copy the value anyway. 


- The tiny-yet-annoying-as-hell differences between developing an macOS vs iOS app. The macOS view's main window doesn't seem to play nicely with auto-layout in the same manner as in iOS. I still need to understand how to configure the stackview to generate a dynamic NSTextField based on a given text length. 


- Basic UI iteration: minimize visual elements and buttons/choices for the user. We don't have the luxury of writing an owner's manual so we gotta make the UI intuitive to use from first glance. Such a simple desire to convert base64 into a URL can actually lead to quite a bit of clutter: 
	- do we display the full value in the paste board? Make it scrollable? 
	- what about a button to refresh the paste board if our notification doesn't trigger for some reason?
	- what about another button to decode manually?
	- etc.

- decoding a string via String(data:encoding): 
	- we can decode our input string into a Data object with base64-encodeding
	- and then pass this data object into the above initializer. Voila! 

- last but not least, executing a bash command via the Process class:
	- we just need to specify the location of bash: /user/bin/your command
	- and of course, your command's arguments 
	- Process.run() even comes with a handy termination handler (completionHandler in iOS)

My god, it's been a while since I made a silly app for fun and negative profit. I need to do this more often.




