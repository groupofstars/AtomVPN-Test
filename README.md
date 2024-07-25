# ATOM VPN SDK demo for iOS Applications
This is a demo application for iOS Applications with basic usage of ATOM VPN SDK which will help the developers to create smooth applications over ATOM SDK quickly.

## SDK Features covered in this Demo
* Connection with Parameters    
* Connection with Pre-Shared Key (PSK)
* Connection with Dedicated IP
* Connection with Multiple Protocols (Auto-Retry Functionality)
* Connection with Real-time Optimized Servers (Countries based on latency from user in Real-time)
* Connection with Smart Dialing (Use getCountriesForSmartDialing() to get the Advanced VPN Dialing supported countries)
* Connection with Smart Connect (Tags based dialing)


## Compatibility
* Compatible with Xcode 15.3, iOS 12.0, macOS 10.13, tvOS 17.0 and later
* Compatible with ATOM SDK Version 5.0 and onwards


## Supported Protocols
* IPSec
* IKEv2
* TCP
* UDP
* Wireguard


## SDK Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate AtomSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'AtomSDKBySecure'
pod 'AtomSDKTunnel'
```

### Integrate AtomWireguardTunnel in iOS App for Wireguard Protocol
You can add AtomWireguardTunnel package via Swift Package Manager

1. Open your project in Xcode 15.3 or above
2. Go to File > Swift Packages > Add Package Dependency...
3. In the field Enter package repository URL, enter "https://github.com/AtomSDK/AtomWireguardTunnel"
4. Choose Dependency Rule "Branch", and add the branch name "main"

# Getting Started with the Code
To add the SDK in Xcode:

1.    Open your Xcode project.
2.    Add your developer account to Xcode from Preferences -> Account if you didn't add before.
3.    Select General tab from your app target and then set your developer account details.
4.    From your app target select Capabilities tab and select the switch right of the Personal VPN.   Then select the capabilties you are going to use.
5.    Drag and drop AtomSDK.framework into your project. (Skip if using Cocoapods)
6.    Go to your project -> General tab from your app target, add the framework using ‘+’ to the Embedded Binaries section. (Skip if using Cocoapods)
8.    After the setup is completed, you should be able to use all the classes from the SDK by including it with the #import <AtomSDK/AtomSDK.h> directive.
9.    ATOM SDK needs to be initialized with a “SecretKey” provided to you after you buy the subscription which is typically a hex-numeric literal.


It can be initialized using an instance of AtomConfiguration. It should have a vpnInterfaceName which will be used to create the Network Interface for VPN connection. 

```ruby
    AtomConfiguration *atomConfiguration= [[AtomConfiguration alloc] init];
    atomConfiguration.secretKey = @"SECRETKEY_GOES_HERE";
    atomConfiguration.vpnInterfaceName = @"Atom";
    atomConfiguration.tunnelProviderBundleIdentifier = “ENTER_YOUR_NETWORK_EXTENSION_BUNDLE_ID”;
    atomConfiguration.wireGuardTunnelProviderBundleIdentifier = “ENTER_YOUR_WIREGUARD_NETWORK_EXTENSION_BUNDLE_ID”;

    [AtomManager sharedInstanceWithAtomConfiguration:atomConfiguration];
```

PS: ATOM SDK is a singleton, and must be initialized before accessing its methods.

## Enable Local Inventory Support
ATOM SDK offers a feature to enable the local inventory support. This can help Application to fetch Countries and Protocols even when device network is not working.

* To enable it, Log In to the Atom Console
* Download the local data file in json format
* File name should be localdata.json. Please rename the file to localdata.json if you find any discrepancy in the file name.
* Paste the file in root of your application folder.

## Delegates to Register
ATOM SDK offers few delegates to register for the ease of the developer.
* atomManagerDidConnect:
* atomManagerDidDisconnect:
* atomManagerOnRedialing:
* atomManagerDialErrorReceived:
* atomManagerOnUnableToAccessInternet:
* atomManagerDidReceiveConnectedLocation:

## StateDidChangedHandler to monitor a VPN connection status
ATOM SDK offers stateDidChangedHandler for the ease of the developer.
```ruby
[AtomManager sharedInstance].stateDidChangedHandler = ^(AtomVPNState status) { };
```


## VPN Authentication
ATOM SDK provided two ways to authenticate your vpn user.
First one is to offer VPN Credentials directly to the SDK which you may create through the Admin Panel provided by ATOM.

```ruby
[AtomManager sharedInstance].atomCredential = [[AtomCredential alloc] initWithUsername:@"<username>" password:@"<password>"];
```
Alternatively, if you don’t want to take hassle of creating users yourself, leave it on us and we will do the rest for you!

```ruby
[AtomManager sharedInstance].UUID = @<"[[[UIDevice currentDevice] identifierForVendor] UUIDString]>";
```
You just need to provide a Unique User ID for your user e.g. any unique hash or even user’s email which you think remains consistent and unique for your user. ATOM SDK will generate VPN Account behind the scenes automatically and gets your user connected! Easy isn’t it?
# VPN Connection
You need to declare an object of “AtomProperties” Class to define your connection preferences. Details of all the available properties can be seen in the inline documentation of “AtomProperties” Class. For the least, you need to give Country and Protocol with which you want to connect.

```ruby
AtomProperties* properties = [[AtomProperties alloc] initWithCountry:@"<country>" protocol:@"<protocol>"];
```
## Fetch Countries
Countries can be obtained through ATOM SDK as well.
```ruby
[[AtomManager sharedInstance] getCountriesWithSuccess:^(NSArray<AtomCountry *> *success) {}
} errorBlock:^(NSError *error) {}];
```

## Fetch Recommended Country
You can get the Recommended Country for user's location through ATOM SDK.
```ruby
[[AtomManager sharedInstance] getRecommendedCountry:^(AtomCountry *country) {
} errorBlock:^(NSError *error) {
}];
```

## Fetch Countries For Smart Dialing
You can get the Countries those support Smart Dialing through ATOM SDK.
```ruby
[[AtomManager sharedInstance] getCountriesForSmartDialing:^(NSArray<AtomCountry *> *success) {}
} errorBlock:^(NSError *error) {}];
```

## Fetch Protocols
Protocols can be obtained through ATOM SDK as well.

```ruby
[[AtomManager sharedInstance] getProtocolsWithSuccess:^(NSArray<AtomProtocol *> *success) {}
errorBlock:^(NSError *error) {}];
```

## VPN Connection Speed
For VPN connection speed you need to registor onPacketsTransmitted handler from AtomManager class to get the VPN connection speed in bytes per second. This callback is recieve only in VPN connected state.
```ruby
AtomManager.sharedInstance.onPacketsTransmitted = ^(NSNumber *bytesReceived, NSNumber *bytesSent) {
    NSLog(@"bytesIN: %ld | bytesOUT: %ld ",(long)bytesReceived.integerValue,bytesSent.integerValue);
};
```

## Protocol switch
You can enable or disable protocol switch from VPNProperties class. By default its value is set to true.
```ruby
properties.enableProtocolSwitch = false;
```
or
```ruby
properties.enableProtocolSwitch = true;
```

## Recommanded protocol
If you didn't specify the protocol in case of Country, City and Channel dailing then Atom SDK dialed with recommanded protocol according to the specified country, city and channel. It did not work in PSK, Smart connect dialing and dedicated IP.

## Use Failover
Failover is a mechanism in which Atom dialed with nearest server if requested server is busy or not found for any reason. You can control this mechanism from VPNPorperties class. By default its value is set to true.
```ruby
properties.useFailover = false;
```
or
```ruby
properties.useFailover = true;
```

### How to Connect

As soon as you call Connect method, the events you were listening to will get the updates about the states being changed and VPNDialedError  (if any occurs) as well.


### Connection with Parameters
It is the simplest way of connection which is well explained in the steps above. You just need to provide the country and the protocol objects and call the Connect method.
```ruby
AtomProperties* properties = [[AtomProperties alloc] initWithCountry:@"<#country#>" protocol:@"<#protocol#>"];

[[AtomManager sharedInstance] connectWithProperties:properties completion:^(NSString *success) {}
errorBlock:^(NSError *error) {}];
```

### Include or Exclude Server with Nas Identifier
When connecting with parameters, a server can be included or excluded with its Nas Identifier
```ruby
AtomProperties* properties = [[AtomProperties alloc] initWithCountry:@"<#country#>" protocol:@"<#protocol#>"];
NSMutableArray<ServerFilter *> *serverFilters = [NSMutableArray new];
[serverFilters addObject:[[ServerFilter alloc] initWithNasIdentifier:@"nas-identifier-here"" andFilter:INCLUDE]];
[serverFilters addObject:[[ServerFilter alloc] initWithNasIdentifier:@"nas-identifier-here" andFilter:EXCLUDE]];
[properties setServerFilters:serverFilters];
[[AtomManager sharedInstance] connectWithProperties:properties completion:^(NSString *success) {}
errorBlock:^(NSError *error) {}];
``` 

### Connection with Pre-Shared Key (PSK)
In this way of connection, it is pre-assumed that you have your own backend server which communicates with ATOM Backend APIs directly and creates a Pre-Shared Key (usually called as PSK) which you can then provide to the SDK for dialing. While providing PSK, no VPN Property other than PSK is required to make the connection. ATOM SDK will handle the rest.
```ruby
AtomProperties *properties = [[AtomProperties alloc] initWithPreSharedKey:@"<#PSK#>"];

[[AtomManager sharedInstance] connectWithProperties:properties completion:^(NSString *success) {}
errorBlock:^(NSError *error) {}];
```
### Connection with Dedicated IP
You can also make your user comfortable with this type of connection by just providing them with a Dedicated IP/Host and they will always connect to a dedicated server! For this purpose, ATOM SDK provides you with the following constructor.
```ruby
AtomProperties *properties = [[AtomProperties alloc] initWithDedicatedHostName:@"<#DedicatedIP/Host#>" protocol:@"<#protocol#>"];

[[AtomManager sharedInstance] connectWithProperties:properties completion:^(NSString *success) {}
errorBlock:^(NSError *error) {}];
```

### Connection with Real-time Optimized Servers
This one is same as the first one i.e. “Connection with Parameters” with a slight addition of using Real-time optimized servers best from your user’s location. You just need to set this property to TRUE and rest will be handled by the ATOM SDK.
```ruby
AtomProperties* properties = [[AtomProperties alloc] initWithCountry:@"<#country#>" protocol:@"<#protocol#>"];
[properties setUseOptimization:YES];

[[AtomManager sharedInstance] connectWithPropertiesconnectWithProperties:properties completion:^(NSString *success) {}
errorBlock:^(NSError *error) {}];
```

If you want to show your user the best location for him on your GUI then ATOM SDK have it ready for you as well! ATOM SDK has a method exposed namely “getOptimizedCountries” which adds a property “RoundTripTime” in the country object which has the real-time latency of all countries from your user’s location (only if ping is enabled on your user’s system and ISP doesn’t blocks any of our datacenters). You can use this property to find the best speed countries from your user’s location.

### Connection with Smart Dialing
“Connection with Parameters” with a slight addition of using smart dialing to connect. You just need to call "withSmartDialing" and rest will handled by the ATOM SDK.
```ruby
AtomProperties* properties = [[AtomProperties alloc] initWithCountry:@"<#country#>" protocol:@"<#protocol#>"];
[properties setUseSmartDialing:YES];
[[AtomManager sharedInstance] connectWithProperties:properties completion:^(NSString *success) {}
errorBlock:^(NSError *error) {}];
```

For more information, please see the inline documentation of AtomProperties Class.

### Connection with Multiple Protocols (Auto-Retry Functionality)
You can provide three protocols at max so ATOM SDK can attempt automatically on your behalf to get your user connected with the Secondary or Tertiary protocol if your base Protocol fails to connect. 

```ruby
properties.secondaryProtocol = @"<protocol2>";
properties.tertiaryProtocol = @"<protocol3>";
```

### Connection with Smart Connect
If you want us to connect your user with what's best for him, you can now do it using *_SmartConnect_* feature. Atom has introduced an enum list of feature a.k.a *_Tags_* you want to apply over those smart connections which can be found under  *_Atom.Core.AtomSmartConnectTag_*. An example usage of SmartConnect is depicted below.
```ruby
NSArray *selectedAtomTags = [[NSArray alloc] initWithObjects: @(AtomSmartConnectTagFileSharing),@(AtomSmartConnectTagPaid), nil];
AtomProperties *properties = [[AtomProperties alloc] initWithProtocol:selectedProtocol andTags:selectedAtomTags];
[[AtomManager  sharedInstance] connectWithProperties:properties completion:^(NSString *success) {
} errorBlock:^(NSError *error) {
}];
```

Tags aren't mandatory and are nil parameter. You can only provide Protocol to connect and rest Atom will manage.

# Cancel VPN Connection
You can cancel connection between dialing process by calling the cancelVPN method.
```ruby
[[AtomManager sharedInstance] cancelVPN];
```
# Disconnect VPN Connection
To disconnect, simply call the disconnectVPN method of AtomManager.
```ruby
[[AtomManager sharedInstance] disconnectVPN];
```

# Remove VPN Profile
To remove VPN profile, simply call the removeVPNProfileWithCompletion method of AtomManager.
```ruby
[[AtomManager sharedInstance] removeVPNProfileWithCompletion:^(BOOL isSuccess) {
}];
```
# How to setup NetworkExtension for OpenVPN TCP, OpenVPN UDP & Wireguard

## Compatibility For OpenVPN TCP & OpenVPN UDP
* Compatible with Xcode 15.3, iOS 12.0, macOS 10.15, tvOS 17.0 and later

## Compatibility For Wireguard
* Compatible with Xcode 15.3, iOS 15.0, macOS 12.0, tvOS 17.0 and later

**Note: Please follow the following steps to create two NetworkExtensions, One for OpenVPN TCP & UDP and other one for Wireguard.**

1. Open your Xcode project.
2. Add your developer account to Xcode from Preferences -> Account if you didn't add before.
3. Select General tab from your app target and then set your developer account details.
4. Now add new target “Network extension” in your Xcode project.

![Network Extension](docs/1.png)


5. From your app target and Extension target select capabilities tab and enable both Personal VPN and the Network Extension. Then select the capabilities you are going to use. 

![Network Extension](docs/2.png)


6. Drag and drop AtomSDK.framework and AtomSDKTunnel.framework into your project. (Skip if using Cocoapods)
7. Select AtomSDKTunnel.framework for both App target and Extension target in Target Member ship section in right side of Xcode. (Skip if using Cocoapods)

8. Go to your project -> General tab from your app target, add both frameworks using ‘+’ to the Embedded Binaries section. (Skip if using Cocoapods)

![Network Extension](docs/3.png)




9. After the setup is completed, you should be able to use all the classes from the SDK by including it with the #import <AtomSDK/AtomSDK.h> and <AtomSDKTunnnel/AtomPacketTunnelProvider.h> directives in your App and extension target.


10. Now in extension target NEPacketTunnelProvider.h class, inherit class with AtomPacketTunnelProvider instead of NEPacketTunnelProvider.
 
![Network Extension](docs/4.1.png)

**with**

![Network Extension](docs/4.2.png)

 
11. Also in NEPacketTunnelProvider.m file, remove all methods.

![Network Extension](docs/5.png)

AtomSDK can be initialized using an instance of AtomConfiguration. It should have a vpnInterfaceName which will be used to create the Network Interface for VPN connection. Also, there is tunnelProviderBundleIndentifier in which you have to enter the bundle ID of Network Extension of your project.

```ruby
AtomConfiguration *atomConfiguration = [AtomConfiguration alloc]init];
atomConfiguration.secretKey = @” SECRETKEY_GOES_HERE”;
atomConfiguration.vpnInterfaceName = @”Atom”;
atomConfiguration.tunnelProviderBundleIdentifier = “ENTER_YOUR_OPENVPN_NETWORK_EXTENSION_BUNDLE_ID”;
atomConfiguration.wireGuardTunnelProviderBundleIdentifier = "ENTER_YOUR_WIREGUARD_NETWORK_EXTENSION_BUNDLE_ID"
[AtomManager sharedInstanceWithAtomConfiguration:atomConfiguration]
```


## Note:
The current version of the VPN Atom SDK uses the following library under the hood:

* NEVPNManager
* NEVPNTunnelProvider
