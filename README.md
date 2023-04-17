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

## SmartVerticalGrid

A couple of years ago I needed to add a variable number of views on a vertical grid, but fitting as many views in each row as possible. At that time the way to do it was very ugly and buggy, but having in mind that SwiftUI 4 brought a new Layout protocol, I re-did the code and this is the result. Very happy with it.


 *Disclaimer:* This has not being thoroughly tested. You might need to add this into a scroll view for better results.

By default the rows are horizontally aligned to the leading side and each view is centered in their rows.

You can choose between leading, center and trailing horizontal alignment and between top, center and bottom vertical alignment, plus the space between views (horizontal) and between rows (vertical).
 

````
 let names = ["James", "Robert", "John", "Michael", "David", "William", "Richard", "Mary", "Patricia", "Jennifer", "Linda", "Elizabeth", "Thomas", "Charles", "Christopher", "Mark", "Margaret", "Joan"]
 
 var body: some View {
     VStack(alignment: .leading) {
         SmartVerticalGrid(horizontalAlignment: .leading, verticalAlignment: .center, horizontalSpacing: 4, verticalSpacing: 4) {
                ForEach(names, id: \.self) { name in
                    HStack {
                        Text(name)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 6)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.secondary))
                }
            }
     }
 }
 ````
 
 
