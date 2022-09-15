
# ChatKit

ChatKit is an iOS library designed to help you build iMessage-esque chat flows with your users seamlessly. ChatKit is ideal for asking your users to write reviews, fill out surveys, or take any other action in your app that requires some handholding.

With ChatKit, you have the abitity to create personalized, conditional chat bot flows with your users. 

## Installation
Currently, ChatKit is only offered through Swift Package Manager. It can be installed like so:

### Swift Package Manager
The preferred installation method is with [Swift Package Manager](https://swift.org/package-manager/). This is a tool for automating the distribution of Swift code and is integrated into the swift compiler. In Xcode, do the following:

- Select **File ▸ Add Packages...**
- Search for `https://github.com/shakked/ChatKit` in the search bar.
- Set the **Dependency Rule** to **Up to Next Major Version** with the lower bound set to **1.0.0**.
- Make sure your project name is selected in **Add to Project**.
- Then, **Add Package**.

### GitMart
ChatKit is a library offered for sale on GitMart. GitMart is a marketplace for premium software modules. You can sign up and purchase a license for GitMart [here](https://app.gitmart.co/library/63236af27c2d722951b52995). 

To make sure ChatKit works for you, ensure you add your GitMart API Key to your Info.plist as described in their [developer docs](https://www.notion.so/GitMart-Documentation-dca2340af04f4346996194e26322d3a3).

## How it Works
To use ChatKit, simply build a `ChatSequence` object and provide it to the `ChatViewController`. Present that view controller, and `ChatKit` will handle the rest.

A `ChatSequence` object stores the flow of messages, options, conditionals, and chats that a user will be put through. For example, here is a simple `ChatSequence` that shows the user a few messages.

    let chats: [Chat] = [
      ChatMessage(message: "Hey there! Welcome to ChatKit"),
      ChatMessage(message: "I'm so happy to have you here.")
    ]
    
    let chatSequence = ChatSequence(chats: chats)
    let chatViewController = ChatViewController(chatSequence: chatSequence, theme: .lightMode)

// Video demonstrating it

It's that simple. ChatKit will estimate reading times for various messages and send them at a natural cadence. 

## Chat Elements

All of the following elements can be used in your `ChatSequence`.

* `ChatMessage` - a standard message that comes from the app to the user (appears as if you were receiving a message from a friend)
* `ChatUserMessage` - a message that comes from the user to the app, as if you are sending a message to someone else
* `ChatMessageConditional` - a message that gives the user a few different options (which will appear as buttons), where you also provide alternative "child" `Chat` arrays that will be executed depending on which button the user pressed
* `ChatButton` - a message that gives the users buttons to press, where each button triggers a custom block that you can provide to do things like opening a URL, showing a review prompt, or showing a form

### Chat Instructions
In addition to Chats that send messages to the user, there are a few different chat instructions that instruct `ChatKit` to take certain actions or provide convenient functionality.

* `ChatContinueButton` - shows a button with a custom message, designed to be used after the user takes an action - does _not_ send a message in the UI as well, it just shows a button
* `ChatShowCancelButton` - shows a cancel button for the view controller, where it was previously hidden - (ideal if you only want to let the user exit the flow after answering some questions)
* `ChatFallingEmojis` - a special message that overlays falling emojis onto the UI for congradulatory or other creative messages


## Chat Themes
ChatKit provides a handful of themes for the chat UI including:
* `ChatTheme.lightMode` - mirrors iOS light-mode iMessage UI
* `ChatTheme.darkMode` - mirrors iOS dark-mode iMessage UI
* `ChatTheme.twitter` - mirrors Twitter DMs look
* `ChatTheme.bigText` - iOS light-mode theme but with larger text

If you don't want to use a standard theme, you can customize all of the following fields in your `ChatTheme`:


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

Feel free to experiment and create your own themes to match the UI of your app.

## Using ChatMessageConditional
`ChatMessageConditional ` structs are some of the most versatile in `ChatKit` because it allows you build an interactive flow with the user. You can take their answers into account and guide them accordingly, seamlessly.

The most confusing part about `ChatMessageConditional` is probably how they are initialized.
The initializer looks like this:

    public init(message: String, options: [(String, [Chat])])

What's confusing is the `options` piece as it is an `array` of `tuples`. Here's an example of how that would be filled in.

    let chats: [Chat] = [
      ChatMessageConditional(message: "How's are you today?", options: [
        // Amazing
        ("Good", [
            ChatMessage(message: "I'm glad to hear you are good!"),
        ]),
        // Bad
        ("Bad", [
            ChatMessage(message: "Oh no. I'm sorry to hear you are feeling bad")
        ])
      ])
    ]

This `ChatMessageConditional` provides two options that will appear as buttons in the UI: "Good" and "Bad". Each of those options then has 1 `child` `Chat`, that prepares a response to what the user said. Now, those responses could actually be multiple parts, and you could continue and entire sequence from there.

For example, let's expand the above example a bit:

    let chats: [Chat] = [ChatMessageConditional(message: "How's are you today?", 
      options: [
        // Amazing
        ("Good", [
          ChatMessage(message: "I'm glad to hear you are good!"),
          ChatMessage(message: "Feeling good is always great!"),
          ChatMessage(message: "We always want to hear you're feeling good")
        ]),
        ("Bad", [
          ChatMessage(message: "Oh no. I'm sorry to hear you are feeling bad"),
          ChatMessage(message: "It's tough to have a bad day."),
          ChatMessage(message: "My favorite thing to do is to have ice cream."),
        ])
      ])
    ]

Notice how you can keep going! What makes `ChatKit` so powerful though, is that you can continue branching the messages, as the array of message you can provide, can be _any_ kind of chat. For example, you could ask a follow up question:

    let chats: [Chat] = [
      ChatMessageConditional(message: "How's are you today?", options: [
        ("Good", [
          ChatMessage(message: "I'm glad to hear you are good!"),
        ]),
        ("Bad", [
          ChatMessage(message: "I'm sorry to hear that."),
          ChatMessageConditional(message: "Can I offer you some ice cream to make you feel better?", options: [
            ("Sure!", [
              ChatMessage(message: "Great, here you go 🍦"),
              ChatMessage(message: "I hope that helps."),
            ]),
            ("I'm okay.", [
              ChatMessage(message: "If there's anything I can do to help, just let me know!"),
            ])
          ])
        ])
      ]),
      ChatMessage(message: "Well, it's been nice talking. I hope you feel better!"),
      ChatFallingEmojis(emoji: "😀"),
    ]

Here, when the user indicates that they are feeling bad, we send a follow up question toask them if we can offer them ice cream to make them feel better. This allows you to build some really complex flows. 

You might be wondering, what happens after we get to the end of the second `ChatMessageConditional` - well, at that point, `ChatKit` will work back up the chain and go to the `Well, it's been nice talking. I hope you feel better!` message and then send some falling emojis. This allows you to ask follow up questions, but rejoin the prior sequence once you get to the end of the questions. 

Phew. It's a lot, I know, and the syntax is a bit tricky, but I'm working to make it better! Within Xcode, it's really not that bad. 




