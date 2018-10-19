# Discovery Fab Button
A swift fab button with a circle reveal animation

![alt text](https://raw.githubusercontent.com/kuamanet/Discovery-Fab-Button/master/previews/simple.gif)

![alt text](https://raw.githubusercontent.com/kuamanet/Discovery-Fab-Button/master/previews/tableview.gif)

![alt text](https://raw.githubusercontent.com/kuamanet/Discovery-Fab-Button/master/previews/customizations.gif)

![alt text](https://raw.githubusercontent.com/kuamanet/Discovery-Fab-Button/master/previews/delegates.gif)

## Installation
### CocoaPods
DiscoveryFabButtonView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DiscoveryFabButton', '~> 0.1.1'
```

## Basic Usage

If you dig with the default colors of DiscoveryFabButton, just instantiate it, give it some menu items and add it to your view
```swift

// maybe in a controller
override func viewDidLoad() {
    super.viewDidLoad()
    let v = DiscoveryFabButtonView()
    var menuItems = [MenuItem]()
    menuItems.append(MenuItem(label: "Filter this 🙆‍♂️"))
    menuItems.append(MenuItem(label: "Don't click here 🙅‍♂️"))
    menuItems.append(MenuItem(label: "Whatever.. 🤷‍♂️"))
    v.menuItems = menuItems
        
    self.view.addSubview(v!)
}
```

If you are inside a UITableViewController, just adding DiscoveryFabButton won't work. What you can do is 

```swift

// maybe in a controller
override func viewDidLoad() {
    super.viewDidLoad()
    let v = DiscoveryFabButtonView()
    var menuItems = [MenuItem]()
    menuItems.append(MenuItem(label: "Filter this 🙆‍♂️"))
    menuItems.append(MenuItem(label: "Don't click here 🙅‍♂️"))
    menuItems.append(MenuItem(label: "Whatever.. 🤷‍♂️"))
    v.menuItems = menuItems
        
    v.inTableView() // <-- instead of self.view.addSubview(v!)
}
```

## Constructors
Some constructors are available to customize colors, or provide the menu items

```swift

init(buttonColor:UIColor)
init(buttonColor:UIColor, buttonIcon:UIImage)
init(discoveryColor:UIColor)
init(buttonColor:UIColor, buttonIcon:UIImage, discoveryColor:UIColor)
init(buttonColor:UIColor, buttonIcon:UIImage, menu:[MenuItem])
init(buttonColor:UIColor, buttonIcon:UIImage, discoveryColor:UIColor, menu:[MenuItem])

```

## Changing props

```swift
let v = DiscoveryFabButtonView()

v.buttonIcon = UIImage(named: "search")

v.buttonColor = #colorLiteral(red: 0.937254902, green: 0.462745098, blue: 0.4784313725, alpha: 1)

v.discoveryColor = #colorLiteral(red: 0.3921568627, green: 0.3411764706, blue: 0.6509803922, alpha: 1)

v.menuItemsColor = #colorLiteral(red: 0.4901960784, green: 0.4784313725, blue: 0.737254902, alpha: 1)

```

## MenuItem
A menu item have a `label` and an `id`, both `String`. The `id` label is not required, but can be provided.

```swift
let menuItem = MenuItem(label: "Awesome label")
let menuItem = MenuItem(id: "somethingUnique", label: "Awesome label")
```

## Public Methods

### `inTableView`
Will append the button directly to the window. It's up to you the removal, meaning that if you call `inTableView` inside a controller and then allow the user to navigate to another controller, the button will still be visible if you don't `remove` it inside the controller's `viewWillDisappear`.
```swift
override func viewDidLoad() {
    ...
    let v = DiscoveryFabButtonView()
    v.inTableView()
    ....
}

override func viewWillDisappear(_ animated: Bool) {
    v.remove()
}
```

### `remove`
Will remove the view from it's superview

```swift
let v = DiscoveryFabButtonView()
v.remove()
```

### `toggle`, `show`, `dismiss`

Allow to open / close the menu from your code
```swift
let v = DiscoveryFabButtonView()
v.show()
v.dismiss()
v.toggle()
```

## Delegate

### 1. Conform your view controller to the DiscoveryFabButtonViewDelegate protocol:

`class ViewController: UIViewController, DiscoveryFabButtonViewDelegate`

### 2. Assign the delegate to your AwesomeSpotlightView view instance:

```swift
let v = DiscoveryFabButtonView()
v.delegate = self

```

### 3. Implement the delegate protocol methods:

- `func onOpen()` [optional]
- `func onClose()` [optional]
- `func onMenuItemSelected(menuItem: MenuItem, index: Int)` [required]
- `func onMenuItemUnselected(menuItem: MenuItem, index: Int)` [optional]


## Special thanks
To [Roberto Gadotti](http://www.robertogadotti.it/), that came up with the graphic and interaction idea
