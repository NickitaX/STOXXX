
<p align="center">
<img src="https://raw.githubusercontent.com/gautier-gdx/Hexacon/assets/hexacon-logo.png" />
</p>

<p align="center">
<a href="https://travis-ci.org/gautier-gdx/Hexacon.svg"><img alt="Travis Status" src="https://travis-ci.org/gautier-gdx/Hexacon.svg"/></a>
<a href="https://img.shields.io/cocoapods/v/Hexacon.svg"><img alt="CocoaPods compatible" src="https://img.shields.io/cocoapods/v/Hexacon.svg"/></a>
<a href="https://github.com/Carthage/Carthage"><img alt="Carthage compatible" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
</p>

**Hexacon** is a new way to display content in your app like the Apple Watch SpringBoard

Highly inspired by the work of [`lmmenge`](https://github.com/lmmenge/WatchSpringboard-Prototype).
Special thanks to [`zenly`](https://github.com/znly) for giving me the opportunity to do this

<p align="center">
<a href="#demo">Demo</a> • <a href="#installation">Installation</a> • <a href="#properties">Properties</a> • <a href="#methods">Methods</a> • <a href="#protocols">Protocols</a> • <a href="#license">License</a>
</p>


## Demo
<p align="center">
<img src="https://raw.githubusercontent.com/gautier-gdx/Hexacon/assets/HexaconDemo3.gif" />
</p>

You can also use the example provided in the repository or use `pod try Hexacon`

### How to use

Like a UITableView!

add it as a subview
```swift
override func viewDidLoad() {
    super.viewDidLoad()

    let hexagonalView = HexagonalView(frame: self.view.bounds)
    hexagonalView.hexagonalDataSource = self

    view.addSubview(hexagonalView)
}
``` 
Then use the dataSource protocol
```swift
extension ViewController: HexagonalViewDataSource {

    func numberOfItemInHexagonalView(hexagonalView: HexagonalView) -> Int {
        return data.count - 1
    }

    func hexagonalView(hexagonalView: HexagonalView, imageForIndex index: Int) -> UIImage? {
        return data[index]
    }
}
``` 

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Hexacon into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "gautier-gdx/Hexacon"
```

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Hexacon into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

pod 'Hexacon'
```
## Properties

The HexagonalView has the following properties:
```swift
weak var hexagonalDataSource: HexagonalViewDataSource?
```
An object that supports the HexagonalViewDataSource protocol and can provide views or images to configures the HexagonalView.
```swift
 weak var hexagonalDelegate: HexagonalViewDelegate?
```
An object that supports the HexagonalViewDelegate protocol and can respond to HexagonalView events.
```swift
public var lastFocusedViewIndex: Int 
```
The index of the view where the HexagonalView is or was centered on.

```swift
public var itemAppearance: HexagonalItemViewAppearance
```    
the appearance is used to configure the global apperance of the layout and the HexagonalItemView

#### Appearance

```swift
public struct HexagonalItemViewAppearance {

    public var needToConfigureItem: Bool // used to circle image and add border, default is false
    public var itemSize: CGFloat
    public var itemSpacing: CGFloat
    public var itemBorderWidth: CGFloat
    public var itemBorderColor: UIColor

    //animation
    public var animationType: HexagonalAnimationType
    public var animationDuration: NSTimeInterval
}
``` 
The default appearance is:
```swift
 itemAppearance = HexagonalItemViewAppearance(
    
    needToConfigureItem: false,
    itemSize: 50,
    itemSpacing: 10,
    itemBorderWidth: 5,
    itemBorderColor: UIColor.grayColor(),

    animationType: .Circle,
    animationDuration: 0.2)
``` 

#### Animation

There is three types of animation available (more to come)
```swift
public enum HexagonalAnimationType { case Spiral, Circle, None }
``` 

## Methods

``` swift
func reloadData() 
```
This function load or reload all the view from the dataSource and refreshes the display
``` swift
func viewForIndex(index: Int) -> HexagonalItemView?
```
Return a view at given index if it exists

## Protocols

There is Two protocols in hexacon, HexagonalViewDataSource and  HexagonalViewDelegate

#### dataSource

``` swift
func numberOfItemInHexagonalView(hexagonalView: HexagonalView) -> Int
```
Return the number of items the view will contain
``` swift
func hexagonalView(hexagonalView: HexagonalView,imageForIndex index: Int) -> UIImage?
```
Return a image to be displayed at index
``` swift
func hexagonalView(hexagonalView: HexagonalView,viewForIndex index: Int) -> UIView?
```
Return a view to be displayed at index, the view will be transformed in an image before being displayed

`NB: all of this methods are optional and you will have to choose whether you want to display a view or an image otherwise the image will be chosen in priority`

#### delegate

``` swift
func hexagonalView(hexagonalView: HexagonalView, didSelectItemAtIndex index: Int)
```
This method is called when the user has selected a view
``` swift
func hexagonalView(hexagonalView: HexagonalView, willCenterOnIndex index: Int)
```
This method is called when the HexagonalView will center on an item, it gives you the new value of lastFocusedViewIndex

## License

Copyright (c) 2015 Gautier Gédoux

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
