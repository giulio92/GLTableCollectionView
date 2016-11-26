# GLTableCollectionView

<p align="center">
    <img src="https://github.com/giulio92/GLTableCollectionView/blob/master/GitHub%20Page/Images/logo.png" width="800">
</p>

[![Travis](https://travis-ci.org/giulio92/GLTableCollectionView.svg?branch=master)](https://travis-ci.org/giulio92/GLTableCollectionView)
![Language](https://img.shields.io/badge/language-Swift%203.0-orange.svg)
![Supported platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![codebeat badge](https://codebeat.co/badges/5a29ccd4-fda0-45d1-ae57-e7158e01449a)](https://codebeat.co/projects/github-com-giulio92-gltablecollectionview)
[![GitHub license](https://img.shields.io/badge/license-AGPL-blue.svg)](https://raw.githubusercontent.com/giulio92/GLTableCollectionView/master/LICENSE.txt)

## What it is
GLTableCollectionView is a ready-to-use ```UITableViewController``` with a ```UICollectionView``` for each ```UITableViewCell```, something like Netflix, Airbnb or the Apple's App Store are doing in their iOS apps. GLTableCollectionView is completely customizable in both his UITableView and UICollectionView part since it has been made on the same Data Source and Delegate methods with no additions.

## How it works
<p align="center">
    <img src="https://github.com/giulio92/GLTableCollectionView/raw/master/GitHub%20Page/Images/diagram.png" width="675">
</p>

## Features
- [x] Uses the same ```UITableView``` reusable cells logic provided from Apple's implementation
- [x] ```UICollectionView``` cell recycle
- [x] Both ```UITableView``` & ```UICollectionView``` can have sections
- [x] Customization of ```UICollectionViewCell```s using the same ```UICollectionViewDelegate Flow Layout``` you already know

## Requirements
- Xcode 8.0+
- Swift 3.0+
- iOS 8.0+

## Note
GLTableCollectionView is written using Swift 3.0 so it would only support iOS 8.0+ due to Swift 3 language compatibility, if you use Swift 2.0 in your project or you need iOS 7.0+ compatibility GLTableCollectionView will work too, but you **must** convert ```UITableView``` and ```UICollectionView``` Data Source and Delegate methods signatures before building your code or Xcode won't compile.
