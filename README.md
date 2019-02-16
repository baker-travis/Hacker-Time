# Hacker Time

## About
This is an iOS client for the popular Hacker News at https://news.ycombinator.com/

This is only meant to show the individual stories/jobs and not the comments.

The first screen will list the titles of all of the stories/jobs, while selecting one will take you to the story/job detail. The detail page may contain only a single link that the user can tap on to bring up a web view, or it may contain the text of the story/job.

## Running the app
1. Ensure you have cocoapods installed. https://guides.cocoapods.org/using/getting-started.html
2. Run `pod install`
3. Open the `Hacker Time.xcworkspace` file
4. Run the app through Xcode by pushing the play button

## Expectations
- The app will persist fetched data. That means once it has retrieved a set of stories from the network once, that the app can function without a network connection on subsequent runs.
- Network activity will be shown by a spinner