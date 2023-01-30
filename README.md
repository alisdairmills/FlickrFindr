#  Flickr Findr

**************
PLEASE READ:
In the FlickrFindrApp there's a property to set at the top for the Flickr API key. I've set this to blank for the push to github - please replace with the key supplied in the PDF or the app will trigger a fatalError on launch.
**************

Some notes (no need to read):

- I ended up using The Composable Architecture / SwiftUI. I mentioned in my last interview I think this is not the way to go for a production app but allowed me to get a lot done in a short time for the assignment.
- I decided to stick with vanilla SwiftUI styling
- The app consists of 3 reducers - ImageSearch (handling typing / cancel from the search bar), ImageGrid (loading and displaying results from a search string, showing loading state, showing error message, passing photo item selection actions), and Detail (loading a higher res version of the image and showing the title)
- I went for paging of 24 rather than 25 - only because I decided on a 3 column grid so it fitted better.
- Titles are only shown on the detail screen (mainly as the titles from the API tend to be quite a mess).
- Selecting a photo presents the detail screen as a sheet - avoids handling any view routing in SwiftUI - so yes - I took the easy option :)
- Of the extra mile items I managed to get paging in (although if fails it doesn't retry) and assumes there is a next page rather than take the value from the API result (every search I did seemed to have 1000's of pages)
- Errors are handled of a failed call but basically just change the search prompt text string to ask the user to try another search.
- Some quick network code for the Flickr API using await async.
- Unit tests were added for every action handled by Reducers - the tests use the Composable Architecture syntax.
- For code styling I used SwiftLint.
