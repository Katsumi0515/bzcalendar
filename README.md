# BzCalendar (reference only)

BzCalendar is an iPhone calendar app that I developed and released on the App Store in the past. The app is no longer on the App Store, so I published the source here for reference only. It is no longer maintained.

## Background
- Development started around 2011 (earliest source file headers). It was written in Objective-C before ARC (Automatic Reference Counting) existed, so memory had to be managed by hand with retain and release.
- On the iPhones of that time, drawing a month view was slow. To make month switching fast, the app caches the data of the previous and next months.
- Some screens were added later in Swift (from 2018).

## Tech
Objective-C, Swift, Core Data, EventKit, iCloud, Crashlytics (Fabric)

## Notes
- This repository is published for reference only. It is not intended to be built or run as is: third-party libraries (CocoaPods) are not included and the project targets an older Xcode and iOS.
- The Crashlytics API key and the Twitter consumer key in the project files have been replaced with placeholders (Fabric and Twitter Kit have been discontinued).
- The bug-report email address in the source has been replaced with `bugreport@example.com`.
