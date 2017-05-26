# GLTableCollectionView

<p align="center">
    <img src="https://github.com/giulio92/GLTableCollectionView/blob/master/GitHub%20Page/Images/logo.png" width="675">
</p>

|**Branch**|**Status**|
|:--------:|:--------:|
|master|[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=592889ed482e8d00016f99eb&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/592889ed482e8d00016f99eb/build/latest?branch=master)|
|develop|[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=592889ed482e8d00016f99eb&branch=develop&build=latest)](https://dashboard.buddybuild.com/apps/592889ed482e8d00016f99eb/build/latest?branch=develop)|

![Language](https://img.shields.io/badge/language-Swift%203.x-orange.svg)
![Supported platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![codebeat badge](https://codebeat.co/badges/5a29ccd4-fda0-45d1-ae57-e7158e01449a)](https://codebeat.co/projects/github-com-giulio92-gltablecollectionview)
[![license](https://img.shields.io/github/license/giulio92/GLTableCollectionView.svg)](https://github.com/giulio92/GLTableCollectionView/blob/master/LICENSE.txt)

## What it is
GLTableCollectionView is a ready to use `UITableViewController` with a `UICollectionView` for each `UITableViewCell`, something like Netflix, Airbnb or the Apple's App Store are doing in their iOS apps. GLTableCollectionView is completely customizable in both his UITableView and UICollectionView parts since it has been made on the same Data Source and Delegate methods with no complicated additions.

|          |  GLTableCollectionView  |
|----------|-------------------------------|
🔄|The **same** `UITableView` reusable cells logic provided from Apple's implementation
♻️|`UICollectionView` cell recycle
🆒|Both `UITableView` & `UICollectionView` can have their own sections and/or headers
🎨|Customization of `UICollectionViewCell`s using the same `UICollectionViewDelegate Flow Layout` you already know
✨|Previous `UICollectionView` **.contentOffset** value restoration after scroll
↔️|`UICollectionView` cell-size-based scroll pagination, see below for instructions
📐|Storyboard and Auto Layout compatibility
💎|Clean architecture
🔧|Unit Tests

## Enable/disable scroll pagination
Set `paginationEnabled` variable `true` in GLTableCollectionViewController class, `false` to disable. Default value is `true`.
```
/// Set true to enable UICollectionViews scroll pagination
var paginationEnabled: Bool = true
```

## Demo
<p align="center">
    <img src="https://github.com/giulio92/GLTableCollectionView/raw/master/GitHub%20Page/Images/demonstration.gif" width="220">
</p>

## How it works
<p align="center">
    <img src="https://github.com/giulio92/GLTableCollectionView/raw/master/GitHub%20Page/Images/diagram.png" width="625">
</p>

## Requirements
- Xcode 8.0+
- Swift 3.0+
- iOS 8.0+
- [SwiftLint](https://github.com/realm/SwiftLint) (Optional, but _highly_ suggested)

## Note
GLTableCollectionView is written using Swift 3.0 so it would only support iOS 8.0+ due to Swift 3 language compatibility, if you use Swift 2.0 in your project or you need iOS 7.0+ compatibility GLTableCollectionView will work too, but you **must** convert `UITableView` and `UICollectionView` Data Source and Delegate methods signatures before building your code or Xcode won't compile.
