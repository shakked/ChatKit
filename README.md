
<p align="center">
  <br />
  <img src=https://github.com/shakked/ChatKit/blob/main/ChatKit@3x.png?raw=true alt="logo" height="100px" />
  <h3 style="font-size:26" align="center">Simple chatbots & chat flows for iOS</h3>
  <br />
</p>

<p align="center">
  <a href="https://www.notion.so/gitmart/Using-a-GitMart-Library-1e43cbfa8d6f4aeb88da603dd2b776b9#4522280846b149ad9d057fb18fd09273">
    <img src="https://img.shields.io/badge/SwiftPM-Compatible-brightgreen" alt="SwiftPM Compatible">
  </a>
  <a href="#">
    <img src="https://img.shields.io/badge/Pod-Incompatible-red" alt="Cocoapods Incompatible">
  </a>
  <a href="https://gitmart.co/">
    <img src="https://img.shields.io/badge/iOS%20Version-%3E%3D%2015.0-blueviolet">
  </a>
  <a href="https://github.com/shakked/ChatKit/blob/main/LICENSE.md">
    <img src="https://img.shields.io/badge/License-GPLv3-blue" alt="GPLv3 License">
  </a>
  <a href="https://www.notion.so/gitmart/License-860ab94179ce4e4785621aa33c600de8">
    <img src="https://img.shields.io/badge/GitMart-fixed cost-green" alt="Community Active">
  </a>
  <a href="#">
    <img src="https://img.shields.io/github/v/tag/shakked/chatkit" alt="Version Number">
  </a>
</p>

ChatKit is an iOS library designed to help you build iMessage-esque chat flows with your users in minutes. ChatKit is ideal for asking your users to write reviews, fill out surveys, or take any other action in your app that requires some handholding. With ChatKit, you have the abitity to create personalized, conditional chat bot flows with your users. 

![final_6324d2741cff8a0068bdb59c_812868 (1)](https://user-images.githubusercontent.com/5383089/190785321-e0af5d4a-1501-432b-9f0e-451eefbfd338.gif)

# Table of Contents
- [Table of Contents](#table-of-contents)
- [GitMart](#gitmart)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
- [How it Works](#how-it-works)
- [Chat Elements](#chat-elements)
- [Chat Theme](#chat-theme)
- [ChatMessageConditional](#chatmessageconditional)
- [ChatButtons](#chatbuttons)
- [Loops](#loops)
- [Examples](#examples)
  - [Customer Support Flow](#customer-support-flow)
  - [App Reviews](#app-reviews)
  - [Surveys](#surveys)
- [Conclusion](#conclusion)

# GitMart
ChatKit requires a GitMart license to use it. GitMart is a marketplace for premium software modules and ChatKit is a library offered for sale on GitMart. You can sign up and purchase a license for GitMart [here](https://app.gitmart.co/library/63236af27c2d722951b52995). By purchasing through GitMart, you can enjoy a bunch of benefits including:
* Integration support - I will help you integrate ChatKit into your app
* Access to a Discord community of other developers using ChatKit
* Free updates of future versions of ChatKit
* 15+ templates of chat flows for support, onboarding, surveys, app reviews
* Direct access to the developer for support and feature requests

To make sure ChatKit works for you, ensure you add your GitMart API Key to your Info.plist as described in their [developer docs](https://www.notion.so/GitMart-Documentation-dca2340af04f4346996194e26322d3a3).


# Installation
Currently, ChatKit is only offered through Swift Package Manager. It can be installed like so:

## Swift Package Manager
The only current installation method is with [Swift Package Manager](https://swift.org/package-manager/). This is a tool for automating the distribution of Swift code and is integrated into the swift compiler. In Xcode, do the following:

- Select **File ▸ Add Packages...**
- Search for `https://github.com/shakked/ChatKit` in the search bar.
- Leave **Dependency Rule** as is.
- Make sure your project name is selected in **Add to Project**.
- Then, **Add Package**.

# How it Works
To use ChatKit, simply build a `ChatSequence` object and provide it to the `ChatViewController`. Present that view controller, and `ChatKit` will handle the rest.

A `ChatSequence` object stores the flow of messages, options, conditionals, and chats that a user will be put through. For example, here is a simple `ChatSequence` that shows the user a few messages.

```swift
import ChatKit

// Somewhere in your app where you can present a view controller

let chats: [Chat] = [
  ChatMessage("Hey there! Welcome to ChatKit"),
  ChatMessage("I'm so happy to have you here.")
]

let chatSequence = ChatSequence(chats: chats)
let chatViewController = ChatViewController(chatSequence: chatSequence, theme: .lightMode)
// present the chatViewController
```

<img src="https://gitmart.nyc3.cdn.digitaloceanspaces.com/ezgif-1-1ca23ab804.gif" alt="drawing" width="60%"/>

It's that simple. ChatKit will estimate reading times for various messages and send them at a natural cadence. 

Here, you can show some banter that the user of your app would be able to witness.

```swift
// inside a view controller
let chats: [Chat] = [
   ChatMessage("Hey there! Welcome to ChatKit"), // a message that we sent to the user
   ChatUserMessage("Thanks for having me!"),     // a message that looks like the user sent it
   ChatMessage("Of course!"),                    // a message that we sent to the user
   ChatUserMessage("This is pretty cool!"),      // a message that looks like the user sent it
   ChatMessage("I know! Watch this..."),         // ... 
   ChatFallingEmojis(emoji: "🥳"),               // shows falling emojis over the chat
   ChatShowCancelButton(),                       // displays the hidden cancel button so the user can dismiss
]
var theme = ChatTheme.darkMode                   // we chose a preset theme in chatKit
theme.hidesCancelButtonOnStart = true            // customize the theme to hide the cancel button on open
let chatSequence = ChatSequence(chats: chats)    // initialize our chat sequence with our chats
chatSequence.readingSpeed = 1.5                  // we set the reading speed to 1.0 (defaults to 1.0)
let chatViewController = ChatViewController(chatSequence: chatSequence, theme: theme) 
chatViewController.modalPresentationStyle = .fullScreen
present(chatViewController, animated: true)
```

<img src="https://gitmart.nyc3.cdn.digitaloceanspaces.com/ezgif-1-742d3ff52c.gif" alt="example" width="60%">

Now, you should have a basic understanding of how to build chat sequences/flows. Below you'll find all of the Chat elements that can be used inside a chat sequence (an array of `[Chat]` structs).


# Chat Elements
All of the following elements can be used in your `ChatSequence`. Below, there are two types of `Chat` structs:
* UI-Related - display something in the UI including messages or buttons
* Instructions - instructions that are executed when the `ChatSequence` gets to them, like showing a cancel button, dismissing the chat screen, etc.

| Element  | Screenshot | Explanation  |
| -------- |-------------|-----|
| `ChatMessage` | ![](https://i.imgur.com/GFA4Tea.png) | a standard message that comes from the app to the user (appears as if you were receiving a message from a friend) |
| `ChatUserMessage` | ![](https://i.imgur.com/bN5szdb.png)  | a message that appears to come from the user in response to the app |
| `ChatRandomMessage` | N/A | a standard message, but you can provide different options and one will randomly be chosen every time its run |
| `ChatMessageConditional` | ![](https://i.imgur.com/FTSr145.png) | a message that gives the user a few different options (which will appear as buttons), where you also provide alternative "child" `Chat` arrays that will be executed depending on which button the user presses |
| `ChatButton` | ![](https://i.imgur.com/D8XkJwn.png) | a message that gives the users buttons to press, where the button triggers a custom block that you can provide to do things like opening a URL, showing a review prompt, or showing a form |
| `ChatButtons` | ![](https://i.imgur.com/I8HCbWN.png) | presents multiple `ChatButton` structs to give the user multiple choices |
| `ChatRunLogic` | N/A | instruction that lets you run an arbitrary piece of logic / code in the middle of a chat sequence |
| `ChatShowCancelButton` | N/A | instruction that will display a presumably hidden cancel button |
| `ChatFallingEmojis` | ![](https://i.imgur.com/7fh1VZA.gif) | displays falling emojis |
| `ChatLoopStart` and `ChatLoopEnd` | ![](https://gitmart.nyc3.cdn.digitaloceanspaces.com/ezgif-1-00ef171469.gif) | instruction that lets you create loops, for example in a customer support flow, after the user reaches the end of a query, go back to the top and ask them if they have any other questions|
| `ChatDelay` | N/A | instruction that delays the chat sequence for a provided amount of seconds, useful |
| `ChatOpenURL` | N/A | instruction that opens a url in either a SafariViewController or in Safari |

# Chat Theme 
The `ChatTheme` struct is what tells `ChatKit` how to display your chat interface. This struct is passed into the `ChatViewController` and can be heavily customized. 

ChatKit provides a handful of themes for the chat UI including:
* `ChatTheme.lightMode` - mirrors iOS light-mode iMessage UI
* `ChatTheme.darkMode` - mirrors iOS dark-mode iMessage UI
* `ChatTheme.twitter` - mirrors Twitter DMs look
* `ChatTheme.bigText` - iOS light-mode theme but with larger text

If you don't want to use a standard theme, you can customize all of the following fields in your `ChatTheme`:

```swift
public struct ChatTheme {
  public var hidesCancelButtonOnStart: Bool = true

  // Avatars
  public var profilePicture: UIImage
  public var meTextColor: UIColor 
  public var meBackgroundColor: UIColor

  // Chat Bubbles
  public var meBubbleColor: UIColor
  public var meBubbleTextColor: UIColor
  public var appBubbleColor: UIColor
  public var appBubbleTextColor: UIColor
  public var bubbleFont: UIFont
  public var bubbleCornerRadius: CGFloat

  public var backgroundColor: UIColor
  public var chatViewCornerRadius: CGFloat
  public var chatViewBackgroundColor: UIColor

  // Button colors
  public var buttonBackgroundColor: UIColor
  public var buttonTextColor: UIColor
  public var buttonFont: UIFont
  public var buttonCornerRadius: CGFloat

  // X Button color
  public var xButtonTintColor: UIColor
}
```

To customize a theme, do the following:
```swift
var chatTheme: ChatTheme = ChatTheme() // defaults to .lightMode
chatTheme.meTextColor = UIColor.purple
chatTheme.buttonCornerRadius = 12.0
// ...

// You can also customize one of our themes
var darkMode: ChatTheme = ChatTheme.darkMode
darkMode.meTextColor = UIColor.orange
// and so on...

```
Feel free to experiment and create your own themes to match the UI of your app. These are pretty intutive, so I won't go into too much detail. 


# ChatMessageConditional
`ChatMessageConditional ` structs are some of the most versatile in `ChatKit` because they allow you build interactive flows with the user. You can take their answers into account and guide them accordingly.

`ChatMessageConditional` chats take an array of `ChatOption` structs, where each `ChatOption` indicates a path the user can select. Each `ChatOption` also has a series of chats that will be executed if the user chooses that option.

The initializer for `ChatMessageConditional` looks like this:

    public init(_ message: String, options: [ChatOption])

Here's an example that shows a conditional with two `ChatOptions` where each `ChatOption` has a response after the user selects their choice.

```swift
let chats: [Chat] = [
  ChatMessageConditional("How are you today?", options: [
    // Good
    ChatOption("Good", chats: [
        // If the user taps "Good", we'll respond with the below two chats
        ChatMessage("I'm glad to hear you are good!"),
        ChatMessage("Feeling good is always good."),
    ]),
    // Bad
    ChatOption("Bad", chats: [
        // If the user taps 'Bad', we'll respond with the following chat
        ChatMessage("Oh no. I'm sorry to hear you are feeling bad")
    ])
  ])
]
```

This `ChatMessageConditional` provides two options that will appear as buttons in the UI: "Good" and "Bad". Each of those options then has `child` `Chat`'s, that prepare a response to what the user said. Now, those responses could actually be multiple parts, and you could continue an entire sequence from there.

What makes `ChatKit` so powerful though, is that you can continue branching the messages, as the array of messages you can provide can be _any_ kind of chat. For example, you could ask a follow up question:

```swift
let chats: [Chat] = [
  ChatMessageConditional(message: "How's are you today?", options: [
    // Amazing
    ChatOption("Good", chats: [
        // If the user taps "Good", we'll response with the below two chats
        ChatMessage("I'm glad to hear you are good!"),
        ChatMessage("Feeling good is always good."),
        ChatMessageConditional("What is making you feel good?", options: [
          ChatOption("Great Weather", chats: [
            ChatMessage("The weather truly is great.")
          ]),
          ChatOption("I Slept Well", chats: [
            ChatMessage("Sleeping well is so important.")
          ]),
        ])
    ]),
    // Bad
    ChatOption("Bad", chats: [
        ChatMessage("Oh no. I'm sorry to hear you are feeling bad")
    ])
  ]),
  ChatMessage("Thanks for chatting!"),
  ChatFallingEmojis(emoji: "😀")
]
```
Here, when the user indicates that they are feeling good, we send a follow up question to ask them why they are feeling good. This allows you to build some really complex flows. 

You might be wondering, what happens after we get to the end of the second `ChatMessageConditional` - well, at that point, `ChatKit` will work back up the chain and go to the `Thanks for chatting!` message and then send some falling emojis. This allows you to ask follow up questions, but rejoin the prior sequence once you get to the end of the questions. 

# ChatButtons

`ChatButton` is another very useful type of `Chat` struct. It allows you to present the user with buttons that run a block of code when the button is tapped. 

```swift
let chats: [Chat] = [
  ChatMessage("Please write us an app review."),
  ChatButton(title: "Write Review", image: UIImage(named: "Checkmark Icon")!, tapped: { [unowned self] viewController in
    UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/hashtag-expert/id1256222789")!)
  }),
]
```

You can also present an array of buttons using `ChatButtons`. `ChatButtons` also optionally takes a message parameter. Note, if you want to add additional logic when the user tap's `No Thanks`, it is recommended to use a `ChatMessageConditional`. This is the key difference between `ChatButtons` and `ChatMessageConditional`. Theoretically, you can accomplish almost the same things with both. For example, the below logic will run a block of code after either `ChatOption` is picked using the `ChatRunLogic`. 

`ChatButtons` are ideal for when you know there isn't subsequent logic that you want to run. (Though I acknowledge there probably isn't a use for both in this SDK, who knows, maybe I'll simplify in the future!).

```swift
    let chats: [Chat] = [
      ChatMessageConditional("How are you today?", options: [
        // Good
        ChatOption("Good", chats: [
            ChatRunLogic({ controller in
              // open a view controller or do something
            })
        ]),
        // Bad
        ChatOption("Bad", chats: [
            ChatRunLogic({ controller in
              // open a view controller or do something
            })
        ])
      ])
    ]
  
```

These two examples 👆👇 do basically the same thing, but the above one lets you continue to add additional functionality. Up to you to choose which.

```swift
    let chats: [Chat] = [
      ChatButtons("How are you today?", options: [
        // Good
        ChatButton(title: "Good", image: nil, tapped: { controller in
          // open a view controller or do something
        }),
        // Bad
        ChatButton(title: "Bad", image: nil, tapped: { controller in
          // open a view controller or do something
        }),
      ])
    ]
```

# Loops
Loops are a fantastic tool for building customer support bots. A loop lets you repeat a series of chats, while still allowing the user to exit if they wish. For example, here's how you could use loops to build a repeating chat:

```swift
  let chats: [Chat] = [
    ChatLoopStart(id: "loop"),
    ChatMessageConditional("What do you want to make it rain?", options: [
        ChatOption("Dogs", chats: [
            ChatFallingEmojis(emoji: "🐶")
        ]),
        ChatOption("Cats", chats: [
            ChatFallingEmojis(emoji: "🐱")
        ])
    ]),
    ChatLoopEnd(id: "loop")
  ]
```
After the user chooses whether to make it rain cats or dogs, the chat will go back to the original question. This is very powerful as you can use it to let users continue to navigate different flows and options in your sequence. (You can see some examples below to see the true power of loops).

# Examples

## Customer Support Flow
ChatKit is an excellent way to save your company some customer support hours. Often times, 90% of support tickets fall into the same few buckets. With a flow like the one below, you can let the user answer their own questions easily, without involving your ticket system and customer support person. And best of all, it's native. With a ChatBot built using Intercom or some other service, you can't trigger native iOS functions when the user responses to certain queries. Whereas below, you can literally show them the refund dialogue or restore their purchases, instead of giving them instructions on how to do it.
```swift
  let chats: [Chat] = [
    ChatMessage("Hey, I'm Zach, a customer support agent."),
    ChatMessage("I'm going to do my best to help you"),
    ChatLoopStart(id: "loop"),
    ChatMessageConditional("Which of these applies?", options: [
        ChatOption("Refunds", chats: [
            ChatRunLogic(block: { _ in
                UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/hashtag-expert/id1256222789")!)
            }),
            ChatFallingEmojis(emoji: "💸")
        ]),
        ChatOption("Tech Support", chats: [
            ChatMessageConditional("Where are you have technical problems?", options: [
                ChatOption("App", chats: [
                    ChatMessage("Aha. Here's a support article"),
                    ChatButton(title: "Open Article", image: nil, tapped: { _ in
                        // open article
                    })
                ]),
                ChatOption("Website", chats: [
                    ChatMessage("Let me direct you to our FAQs.."),
                    ChatButton(title: "Open FAQs", image: nil, tapped: { _ in
                        // open FAQs
                    })
                ]),
                ChatOption("Watch App", chats: [
                    ChatMessage("We actually don't have a Watch app yet, interested in the beta?"),
                    ChatMessageConditional("", options: [
                        ChatOption("Yes", chats: [
                            ChatRunLogic(block: { _ in
                                // open up typeform to put name on list
                            })
                        ]),
                        ChatOption("Nope!", chats: [
                            ChatMessage("Aha, I totally get that")
                        ])
                    ])
                ]),
            ]),
        ]),
        ChatOption("Get in Touch", chats: [
            ChatMessageConditional("How do you want to contact us?", options: [
                ChatOption("Email", chats: [
                    ChatMessage("Sure, I'll open up that UI for you."),
                    ChatRunLogic(block: { _ in
                        // open email UI
                    })
                ]),
                ChatOption("Call", chats: [
                    ChatMessage("Great. Our number is 1800-555-5555."),
                    ChatMessage("I'll start the call for you."),
                    ChatRunLogic(block: { _ in
                        // start the call
                    })
                ])
            ])
        ])
    ]),
    ChatMessageConditional("Is there anything else I can help you with?", options: [
        ChatOption("Yes", chats: [
            ChatLoopEnd(id: "loop") // LOOP
        ]),
        ChatOption("No", chats: [
            ChatMessage("Okay, have a great day!"),
        ])
    ]),
    ChatFallingEmojis(emoji: "🔥"),
    ChatDismiss(after: 10.0),
  ]
```

## App Reviews
This is perhaps the best use of ChatKit. Getting written reviews is one of the most challenging things to do as an app developer. Written reviews help you get more downloads as they convince prospecting users why they should download your app. This flow below takes the user through a short journey, and adds additional context and color as to why them writing a review would be so helpful. Also, it links to the App Store listing rather than just showing the `requestReview()` prompt. This makes it more likely the user will write a review and not just rate the app.
```swift
let reviews: [Chat] = [
  ChatMessage("Hey John, how are ya!"),
  ChatMessage("This is Zach, the founder of ChatKit."),
  ChatMessageConditional("I have a quick question for you, do you have a minute?", options: [
      ChatOption("Sure", chats: [
          ChatMessage("Okay, so recently, we've been getting some 1 star reviews on the app."),
          ChatMessage("It really stinks, I try so hard to get good ratings, but it just doesn't work!"),
          ChatMessageConditional("You ever try really hard and still not get something?", options: [
              ChatOption("Yes, I understand", chats: [
                  ChatMessage("Exactly!")
              ]),
              ChatOption("No, you are crazy.", chats: [
                  ChatMessage("Lol. Maybe a little")
              ])
          ]),
          ChatMessage("So here's my question..."),
          ChatMessageConditional("Can you take 2 minutes out of your day to write us a review?", options: [
              ChatOption("Sure", chats: [
                  ChatMessage("Omg. You are a lifesaver!"),
                  ChatMessage("Here's the link, thank you so much!"),
                  ChatButton(title: "Write Review", image: UIImage(systemName: "square.and.pencil")!, tapped: { _ in
                      if let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1256222789&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software") {
                          if UIApplication.shared.canOpenURL(url) {
                              UIApplication.shared.open(url, options: [:], completionHandler: nil)
                          }
                      }
                  })
              ]),
              ChatOption("No, I'm busy", chats: [
                  ChatMessage("Aha, I totally get that. Let me let you out of here so you can get back to your life."),
                  ChatMessage("... where is that darn button"),
                  ChatMessage("There it is!"),
                  ChatShowCancelButton()
              ])
          ])
      ]),
      ChatOption("Nope", chats: [
          ChatMessage("Ah okay, no problem. I'll let you get back to it."),
          ChatMessage("Let me toggle that darn dismiss button for you..."),
          ChatShowCancelButton(),
          ChatMessage("There it is. Half a great day!"),
          ChatFallingEmojis(emoji: "😄")
      ])
  ])
]
```

## Surveys
ChatKit is a great tool for getting people to answer surveys. Right now, it's not completely optimizmed for actually giving surveys itself, but you can easily link to a Typeform or Google Form. In testing, opt-in rates for surveys will be much higher when you take the user through a personalized journey below versus just emailing someone a "we want your opinion" survey.
```swift
let survey: [Chat] = [
  ChatMessage("Hey Paul, this is Zach, the founder of ChatKit."),
  ChatUserMessage("Hey Zach, this is Paul... a user of ChatKit"),
  ChatMessage("Ah, hello there good friend!"),
  ChatMessage("Now, you're probably wondering why I brought you here."),
  ChatUserMessage("I could not be less curious about why you brought me here."),
  ChatMessage("Yes yes, with patience, you shall learn."),
  ChatMessage("Well, it's simple. I'm trying to figure out ..."),
  ChatMessage("I'm embarrassed to say it."),
  ChatMessageConditional(options: [
      ChatOption("Spit it out", chats: [
          ChatMessage("Ah! Fine.")
      ]),
      ChatOption("Don't be embarrassed", chats: [
          ChatMessage("Oh shucks, I will. You're a good person.")
      ]),
  ]),
  ChatMessage("Well, I'm trying to figure out how much to charge for my app."),
  ChatMessage("Accordingy to my *fancy* data, you are a paying user."),
  ChatMessageConditional("Are you?", options: [
      ChatOption("Yes, I pay", chats: [
         ChatMessage("Wow, thank you for your support!"),
         ChatMessage("Okay, can I borrow two mintues of your time?"),
         ChatMessageConditional(options: [
          ChatOption("Lol. No.", chats: [
              ChatMessage("Fine. No need to be sassy. Feel free to leave!"),
              ChatShowCancelButton()
          ]),
          ChatOption("Sure!", chats: [
              ChatMessage("Ah, thank you so much, you are a lifesaver!"),
              ChatMessage("So here's a quick survey, it only has 3 questions."),
              ChatMessage("It would help me so much if you filled this out."),
              ChatButton(title: "Open Survey", image: UIImage(systemName: "checkmark.circle.fill")!, tapped: { controller in
                  if let url = URL(string: "https://www.typeform.com/") {
                      if UIApplication.shared.canOpenURL(url) {
                          UIApplication.shared.open(url, options: [:], completionHandler: nil)
                      }
                  }
              }),
              ChatMessage("Thank you so much!"),
              ChatShowCancelButton(),
          ])
         ])
      ]),
      ChatOption("No, I do not pay", chats: [
          ChatMessage("Ah, it appears there has been a mistake."),
          ChatMessage("You are free to go!"),
          ChatShowCancelButton(),
      ]),
  ])
]
```

# Conclusion
ChatKit is designed to make your life easier. If you have any feature ideas, feel free to open an issue or get in touch with me directly on GitMart.