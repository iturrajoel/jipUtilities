# jipUtilities

I've been using SwiftUI since the second beta and with time, I have created many views that got obselete with new SwiftUI versions, but I'll try to add some new views that are useful to me and might be useful for someone else.

Please, let me know if you found any bug or if you have any suggestion.



## WeekDateSelector

For those that need a way to select an entire week, this view uses the SwiftUI MultiDateSelector to select and deselect one week at a time, returning the dates in a Set of DateComponents.

*Disclaimer:* This has not being tested in other Locales and Timezones beside America/New_York. 

You use this view by including this packages and a code similar to this example:

````
 @State private var selection = Set<DateComponents>()
 
 var body: some View {
     VStack {
         WeekDateSelector(selection: $selection)
             .fixedSize(horizontal: true, vertical: true)
     }
 }
 ````


