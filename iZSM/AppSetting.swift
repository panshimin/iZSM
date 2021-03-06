//
//  AppSetting.swift
//  ZSMTH
//
//  Created by Naitong Yu on 15/3/10.
//  Copyright (c) 2015 Naitong Yu. All rights reserved.
//

import Foundation
import DeviceKit
import KeychainSwift

class AppSetting {

    static let shared = AppSetting()
    
    let device = Device()
    
    enum DisplayMode: Int {
        case nForum = 0, www2, mobile
    }

    private struct Static {
        static let UsernameKey = "SmthAPI.username"
        static let PasswordKey = "SmthAPI.password"
        static let AccessTokenKey = "SmthAPI.accessToken"
        static let ExpireDateKey = "SmthAPI.expireDate"
        static let ClearUnreadModeKey = "SmthAPI.ClearUnreadMode"
        static let SortModeKey = "SmthAPI.SortMode"
        static let HideAlwaysOnTopThreadKey = "SmthAPI.hideAlwaysOnTopThread"
        static let ShowSignatureKey = "SmthAPI.showSignature"
        static let ArticleCountPerSectionKey = "SmthAPI.articleCountPerSection"
        static let ThreadCountPerSectionKey = "SmthAPI.threadCountPerSection"
        static let BackgroundTaskEnabledKey = "SmthAPI.backgroundTaskEnabled"
        static let EulaAgreedKey = "SmthAPI.eulaAgreed"
        static let MailCountKey = "SmthAPI.mailCountKey"
        static let ReplyCountKey = "SmthAPI.replyCountKey"
        static let ReferCountKey = "SmthAPI.referCountKey"
        static let RememberLastKey = "SmthAPI.rememberLastKey"
        static let DisplayModeKey = "SmthAPI.displayModeKey"
        static let PortraitLockKey = "SmthAPI.portraitLockKey"
        static let NightModeKey = "SmthAPI.nightModeKey"
        static let ShakeToSwitchKey = "SmthAPI.shakeToSwitch"
        static let ShowAvatarKey = "SmthAPI.showAvatarKey"
        static let NoPicModeKey = "SmthAPI.noPicModeKey"
        static let AddDeviceSignatureKey = "SmthAPI.deviceSignatureKey"
    }

    private let defaults = UserDefaults.standard
    private let keychain = KeychainSwift()
    
    private init () {
        // if some essential settings not set, then set them as default value
        let initialSettings: [String : Any] = [
            Static.ClearUnreadModeKey : Int(SmthAPI.ClearUnreadMode.NotClear.rawValue),
            Static.SortModeKey : Int(SmthAPI.SortMode.Normal.rawValue),
            Static.HideAlwaysOnTopThreadKey : false,
            Static.ShowSignatureKey : false,
            Static.ArticleCountPerSectionKey : 20,
            Static.ThreadCountPerSectionKey : 20,
            Static.BackgroundTaskEnabledKey : true,
            Static.EulaAgreedKey : false,
            Static.MailCountKey : 0,
            Static.ReplyCountKey : 0,
            Static.ReferCountKey : 0,
            Static.RememberLastKey : true,
            Static.DisplayModeKey : DisplayMode.mobile.rawValue,
            Static.PortraitLockKey : true,
            Static.NightModeKey : false,
            Static.ShakeToSwitchKey : true,
            Static.ShowAvatarKey : true,
            Static.NoPicModeKey : false,
            Static.AddDeviceSignatureKey : true
        ]
        defaults.register(defaults: initialSettings)
    }
    
    var signature: String {
        return "- 来自「最水木 for \(device)」"
    }
    
    var signatureRegularExpression : NSRegularExpression {
        let regx = try! NSRegularExpression(pattern: "- 来自「最水木 for .*」")
        return regx
    }
    
    var addDeviceSignature: Bool {
        get { return defaults.bool(forKey: Static.AddDeviceSignatureKey) }
        set {
            defaults.set(newValue, forKey: Static.AddDeviceSignatureKey)
        }
    }

    var username: String? {
        get {
            if let user = keychain.get(Static.UsernameKey) {
                if !user.isEmpty {
                    return user
                }
            }
            return nil
        }
        set {
            keychain.set(newValue ?? "", forKey: Static.UsernameKey)
        }
    }

    var password: String? {
        get {
            if let pass = keychain.get(Static.PasswordKey) {
                if !pass.isEmpty {
                    return pass
                }
            }
            return nil
        }
        set {
            keychain.set(newValue ?? "", forKey: Static.PasswordKey)
        }
    }

    var accessToken: String? {
        get {
            if
                let accessToken = defaults.string(forKey: Static.AccessTokenKey),
                let expireDate = defaults.object(forKey: Static.ExpireDateKey) as? Date,
                expireDate > Date()  // access token is not expired
            {
                return accessToken
            }
            return nil
        }
        set {
            defaults.set(newValue, forKey: Static.AccessTokenKey)
            defaults.set(Date(timeIntervalSinceNow: 24 * 60 * 60), forKey: Static.ExpireDateKey)
        }
    }

    var backgroundTaskEnabled: Bool {
        get { return defaults.bool(forKey: Static.BackgroundTaskEnabledKey) }
        set {
            defaults.set(newValue, forKey: Static.BackgroundTaskEnabledKey)
        }
    }

    var hideAlwaysOnTopThread: Bool {
        get { return defaults.bool(forKey: Static.HideAlwaysOnTopThreadKey) }
        set {
            defaults.set(newValue, forKey: Static.HideAlwaysOnTopThreadKey)
        }
    }

    var showSignature: Bool {
        get { return defaults.bool(forKey: Static.ShowSignatureKey) }
        set {
            defaults.set(newValue, forKey: Static.ShowSignatureKey)
        }
    }

    var eulaAgreed: Bool {
        get { return defaults.bool(forKey: Static.EulaAgreedKey) }
        set {
            defaults.set(newValue, forKey: Static.EulaAgreedKey)
        }
    }

    var clearUnreadMode: SmthAPI.ClearUnreadMode {
        get { return SmthAPI.ClearUnreadMode(rawValue: Int32(defaults.integer(forKey: Static.ClearUnreadModeKey)))! }
        set {
            defaults.set(Int(newValue.rawValue), forKey: Static.ClearUnreadModeKey)
        }
    }

    var sortMode: SmthAPI.SortMode {
        get { return SmthAPI.SortMode(rawValue: Int32(defaults.integer(forKey: Static.SortModeKey)))! }
        set {
            defaults.set(Int(newValue.rawValue), forKey: Static.SortModeKey)
        }
    }

    var articleCountPerSection: Int {
        get { return defaults.integer(forKey: Static.ArticleCountPerSectionKey) }
        set {
            defaults.set(newValue, forKey: Static.ArticleCountPerSectionKey)
        }
    }

    var threadCountPerSection: Int {
        get { return defaults.integer(forKey: Static.ThreadCountPerSectionKey) }
        set {
            defaults.set(newValue, forKey: Static.ThreadCountPerSectionKey)
        }
    }
    
    var mailCount: Int {
        get { return defaults.integer(forKey: Static.MailCountKey) }
        set {
            defaults.set(newValue, forKey: Static.MailCountKey)
        }
    }
    
    var replyCount: Int {
        get { return defaults.integer(forKey: Static.ReplyCountKey) }
        set {
            defaults.set(newValue, forKey: Static.ReplyCountKey)
        }
    }
    
    var referCount: Int {
        get { return defaults.integer(forKey: Static.ReferCountKey) }
        set {
            defaults.set(newValue, forKey: Static.ReferCountKey)
        }
    }
    
    var rememberLast: Bool {
        get { return defaults.bool(forKey: Static.RememberLastKey) }
        set {
            defaults.set(newValue, forKey: Static.RememberLastKey)
        }
    }
    
    var displayMode:  DisplayMode {
        get { return DisplayMode(rawValue: defaults.integer(forKey: Static.DisplayModeKey))! }
        set {
            defaults.set(newValue.rawValue, forKey: Static.DisplayModeKey)
        }
    }
    
    var portraitLock: Bool {
        get { return defaults.bool(forKey: Static.PortraitLockKey) }
        set {
            defaults.set(newValue, forKey: Static.PortraitLockKey)
        }
    }
    
    var nightMode: Bool {
        get { return defaults.bool(forKey: Static.NightModeKey) }
        set {
            defaults.set(newValue, forKey: Static.NightModeKey)
        }
    }
    
    var shakeToSwitch: Bool {
        get { return defaults.bool(forKey: Static.ShakeToSwitchKey) }
        set {
            defaults.set(newValue, forKey: Static.ShakeToSwitchKey)
        }
    }
    
    var showAvatar: Bool {
        get { return defaults.bool(forKey: Static.ShowAvatarKey) }
        set {
            defaults.set(newValue, forKey: Static.ShowAvatarKey)
        }
    }
    
    var noPicMode: Bool {
        get { return defaults.bool(forKey: Static.NoPicModeKey) }
        set {
            defaults.set(newValue, forKey: Static.NoPicModeKey)
        }
    }
}
