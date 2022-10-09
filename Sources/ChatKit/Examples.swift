//
//  Examples.swift
//  
//
//  Created by Zachary Shakked on 10/7/22.
//

import Foundation

public enum Examples {
    
    public static func pmfSurvey(appName: String) -> ChatSequence {
        let chats: [Chat] = [
            ChatMessage("Hey! Just wanted to ask you a few quick questions about \(appName)"),
            ChatMessageConditional(message: "Is that ok?", options: [
                ChatOption("Sure", chats: [
                    ChatMessageConditional(message: "How would you feel if you could no longer use \(appName)?", options: [
                        ChatOption("Very Disappointed", chats: []),
                        ChatOption("Somewhat Disappointed", chats: []),
                        ChatOption("Not Disappointed", chats: []),
                    ]),
                    ChatTextInput(message: "What is the main benefit you receive from using \(appName)?", placeholder: "...", validator: .length(atLeast: 1, maximum: 200), keyboardType: .`default`, returnKey: .`next`, contentType: nil),
                    ChatTextInput(message: "How did you discover \(appName)?", placeholder: "...", validator: .length(atLeast: 1, maximum: 200), keyboardType: .`default`, returnKey: .`next`, contentType: nil),
                    ChatTextInput(message: "What would you use as an alternative to \(appName) if it no longer existed?", placeholder: "...", validator: .length(atLeast: 1, maximum: 200), keyboardType: .`default`, returnKey: .`next`, contentType: nil),
                    ChatTextInput(message: "How can we improve \(appName) to better meet your needs?", placeholder: "...", validator: .length(atLeast: 1, maximum: 200), keyboardType: .`default`, returnKey: .`next`, contentType: nil),
                    ChatTextInput(message: "What type of person do you think would benefit most from \(appName)?", placeholder: "...", validator: .length(atLeast: 1, maximum: 200), keyboardType: .`default`, returnKey: .`next`, contentType: nil),
                    ChatMessage("Thank you so much for taking the time to answer!"),
                    ChatInstruction(.dismiss),
                ]),
                ChatOption("Not Right Now", chats: [
                    ChatMessage("No problem. Have a good day."),
                    ChatInstruction(.dismiss),
                ])
            ])
        ]
        
        let sequence = ChatSequence(id: "examples-pmf-survey", chats: chats)
        sequence.readingSpeed = 1.8
        return sequence
    }
    
    public static func subscriptionCancellation() -> ChatSequence {
        let chats: [Chat] = [
            ChatMessage("Hey, I understand you're thinking of cancelling your subscription"),
            ChatMessageConditional(message: "If you don't mind me asking, how come?", options: [
                ChatOption("Too Expensive", chats: [
                    ChatMessage("Ah, I totally get that. Well..."),
                    ChatMessageConditional(message: "I actually can offer you a special discount if you'd be interested. How's 40% off?", options: [
                        ChatOption("Sounds Great!", chats: [
                            ChatMessage("Awesome"),
                            ChatMessage("Let me get that started for you..."),
                            ChatInstruction(.purchaseProduct("product_discount"))
                        ]),
                        ChatOption("No, Thanks", chats: [
                            ChatMessage("Ah, sorry."),
                            ChatTextInput(message: "Can you at least tell me what price would be fair?",
                                          placeholder: "i.e. $30/year",
                                          validator: nil,
                                          keyboardType: .default,
                                          returnKey: .next,
                                          contentType: nil),
                            ChatMessage("Thank you, I'll let you go."),
                            ChatInstruction(.openURL(URL(string: "https://support.apple.com/en-us/HT202039")!, true))
                        ])
                    ])
                ]),
                ChatOption("Not Useful", chats: [
                    ChatMessageConditional(message: "Are you sure? We have a ton of really great support articles I'd love to show you that will help you find value in the app.", options: [
                        ChatOption("Sounds Good", chats: [
                            ChatMessage("Here you go!"),
                            ChatInstruction(.openURL(URL(string: "https://www.hashtag.expert/tutorials")!, true))
                        ]),
                        ChatOption("No, Thanks", chats: [
                            ChatTextInput(message: "Can you at least tell us what would make the app more useful?",
                                          placeholder: "i.e. add more features",
                                          validator: .length(atLeast: 1, maximum: 300),
                                          keyboardType: .default,
                                          returnKey: .next,
                                          contentType: nil),
                            ChatMessage("Thanks for taking the time to do that. I'll let you go."),
                            ChatInstruction(.openURL(URL(string: "https://support.apple.com/en-us/HT202039")!, true))
                        ])
                    ]),
                    
                ]),
                ChatOption("Other", chats: [
                    ChatMessageConditional(message: "I actually can offer you a special discount if you'd be interested. How's 40% off?", options: [
                        ChatOption("Sounds Great!", chats: [
                            ChatMessage("Awesome"),
                            ChatMessage("Let me get that started for you..."),
                            ChatInstruction(.purchaseProduct("product_discount"))
                        ]),
                        ChatOption("No, Thanks", chats: [
                            ChatMessage("Ah, sorry."),
                            ChatTextInput(message: "Can you at least tell us what would make the app more useful?",
                                          placeholder: "i.e. add more features",
                                          validator: .length(atLeast: 1, maximum: 300),
                                          keyboardType: .default,
                                          returnKey: .next,
                                          contentType: nil),
                            ChatMessage("Thank you, I'll let you go."),
                            ChatInstruction(.openURL(URL(string: "https://support.apple.com/en-us/HT202039")!, true))
                        ])
                    ])
                ]),
            ]),
            ChatInstruction(.showCancelButton),
        ]
        let sequence = ChatSequence(id: "examples-subscription-cancellation", chats: chats)
        sequence.readingSpeed = 1.8
        return sequence
    }
    
    public static func netPromoterScore() -> ChatSequence {
        let chats: [Chat] = [
            ChatMessage("Hey, just a quick question from our team."),
            ChatMessageConditional(message: "How likely would you be to recommend Hashtag Expert to a friend (10 means very likely and 1 means not likely at all)?", options: [
                ChatOption("10", chats: []),
                ChatOption("9", chats: []),
                ChatOption("8", chats: []),
                ChatOption("7", chats: []),
                ChatOption("6", chats: []),
                ChatOption("5", chats: []),
                ChatOption("4", chats: []),
                ChatOption("3", chats: []),
                ChatOption("2", chats: []),
                ChatOption("1", chats: []),
            ]),
            ChatTextInput(message: "Oh interesting. Can I ask why you chose %@?", placeholder: "It's a great app, but...", validator: .length(atLeast: 1, maximum: 300), keyboardType: .default, returnKey: .default, contentType: nil),
            ChatInstruction(.showCancelButton),
        ]
        let sequence = ChatSequence(id: "examples-nps-survey", chats: chats)
        sequence.readingSpeed = 1.8
        return sequence
    }
    
    public static func howdYouHearAboutUs() -> ChatSequence {
        let chats: [Chat] = [
            ChatMessage("Hey, welcome to the app! So happy to have you."),
            ChatMessage("Super quick question, then I promise I'll let you get back to the app."),
            ChatMessageConditional(message: "How'd you hear about us? It would help us so much if you could tell us :)", options: [
                ChatOption("Facebook", chats: [
                    ChatMessage("Ah no way!"),
                    ChatMessageConditional(message: "Was it from an ad or a post from an influencer?", options: [
                        ChatOption("Ad", chats: [
                            ChatTextInput(message: "What did the ad look like?", placeholder: "a funny meme...", validator: ChatTextValidator.length(atLeast: 1, maximum: 120), keyboardType: .default, returnKey: .default, contentType: nil),
                        ]),
                        ChatOption("Influencer", chats: [
                            ChatTextInput(message: "Which influencer was it?", placeholder: "@kyliejenner", validator: ChatTextValidator.length(atLeast: 1, maximum: 120), keyboardType: .default, returnKey: .default, contentType: nil),
                        ]),
                        ChatOption("Other", chats: [
                            ChatTextInput(message: "Anyway you could describe to me? It would help so much...", placeholder: "...", validator: ChatTextValidator.length(atLeast: 1, maximum: 120), keyboardType: .default, returnKey: .default, contentType: nil),
                        ])
                    ])
                ]),
                ChatOption("Instagram", chats: [
                    ChatMessage("Ah no way!"),
                    ChatMessageConditional(message: "Was it from an ad or a post from an influencer?", options: [
                        ChatOption("Ad", chats: [
                            ChatTextInput(message: "What did the ad look like?", placeholder: "a funny meme...", validator: ChatTextValidator.length(atLeast: 1, maximum: 120), keyboardType: .default, returnKey: .default, contentType: nil),
                        ]),
                        ChatOption("Influencer", chats: [
                            ChatTextInput(message: "Which influencer was it?", placeholder: "@kyliejenner", validator: ChatTextValidator.length(atLeast: 1, maximum: 120), keyboardType: .default, returnKey: .default, contentType: nil),
                        ]),
                        ChatOption("Other", chats: [
                            ChatTextInput(message: "Anyway you could describe to me? It would help so much...", placeholder: "...", validator: ChatTextValidator.length(atLeast: 1, maximum: 120), keyboardType: .default, returnKey: .default, contentType: nil),
                        ])
                    ])
                ]),
                ChatOption("TikTok", chats: [
                    ChatMessage("Ooo I love TikTok!"),
                    ChatMessageConditional(message: "Was it from an ad or a for you page post?", options: [
                        ChatOption("Ad", chats: [
                            ChatTextInput(message: "What did the ad look like?", placeholder: "a funny meme...", validator: ChatTextValidator.length(atLeast: 1, maximum: 120), keyboardType: .default, returnKey: .default, contentType: nil),
                        ]),
                        ChatOption("Video", chats: [
                            ChatTextInput(message: "It'd make my day if you could share the TikTok video link with me :)", placeholder: "...", validator: nil, keyboardType: .default, returnKey: .default, contentType: nil),
                        ])
                    ])
                ]),
                ChatOption("Twitter", chats: [
                    ChatMessage("Twitter! I love Twitter."),
                    ChatMessageConditional(message: "Was it from a twitter thread or was someone talking about the app?", options: [
                        ChatOption("Thread", chats: [
                            ChatTextInput(message: "Any chance you could link me the thread?", placeholder: "...", validator: ChatTextValidator.length(atLeast: 0, maximum: 120), keyboardType: .default, returnKey: .default, contentType: nil),
                        ]),
                        ChatOption("Other", chats: [
                            ChatTextInput(message: "Anything else you could tell me about it?", placeholder: "...", validator: ChatTextValidator.length(atLeast: 1, maximum: 120), keyboardType: .default, returnKey: .default, contentType: nil),
                        ]),
                    ])
                ]),
                ChatOption("Other", chats: [
                    ChatTextInput(message: "Anything else you could tell me about how you heard about us? (It helps us so much, seriously!)", placeholder: "...", validator: ChatTextValidator.length(atLeast: 1, maximum: 120), keyboardType: .default, returnKey: .default, contentType: nil),
                ]),
            ]),
            ChatMessage("Thank you so much for taking the time!"),
            ChatMessage("I'll let you get back to the app now. You're a lifesaver!"),
            ChatInstruction(.rainingEmojis("🥳")),
            ChatInstruction(.showCancelButton),
        ]
        let sequence = ChatSequence(id: "examples-attribution-survey", chats: chats)
        sequence.readingSpeed = 1.8
        return sequence
    }
    
    public static func scheduled() -> ChatSequence {
        let chats: [Chat] = [
            ChatMessage("You should be seeing this 30 seconds after you pressed the button. If you closed the app, you should've received a notification (unless you denied the notification)."),
            ChatMessage("If you opened the app, but not from the notification, it should still pop up.")
        ]
        let sequence = ChatSequence(id: "scheduled", chats: chats)
        sequence.readingSpeed = 1.8
        return sequence
    }
    
    public static func chatWithFounder() -> ChatSequence {
        let chats: [Chat] = [
            ChatMessage("Hey! This is Zach, the founder of Hashtag Expert!"),
            ChatMessage("Ok, so recently I've been trying to understand how people have been using Hashtag Expert"),
            ChatMessage("Your time is valuable, so I'll be brief."),
            ChatMessage("I'd love to chat with you for about 15 minutes about your experience with the app."),
            ChatMessage("I'm also happy to compensate you for your time with a $25 Amazon gift card."),
            ChatMessageConditional(message: "Will you chat?", options: [
                ChatOption("Sure", chats: [
                    ChatMessage("You are the best!"),
                    ChatMessageConditional(message: "What's the easiest for you?", options: [
                        ChatOption("Phone Call", chats: [
                            ChatMessage("Great."),
                            ChatTextInput(message: "What's your phone number?", placeholder: "+1732-555-6358", validator: .length(atLeast: 1, maximum: 15), keyboardType: .phonePad, returnKey: .done, contentType: .telephoneNumber),
                            ChatMessage("Thank you! I'll give you a call or text at %@ in the next few days. Talk soon!")
                        ]),
                        ChatOption("Zoom Call", chats: [
                            ChatMessage("Sure, I'll open up my Calendly link for you - feel free to pick a time that works for you."),
                            ChatInstruction(.openURL(URL(string: "https://calendly.com/zach-shakked/30-minute-demo")!, false))
                        ]),
                        ChatOption("Email", chats: [
                            ChatMessage("Sure, happy to coordinate over email."),
                            ChatTextInput(message: "What's your email?", placeholder: "i.e. john@apple.com", validator: .email(), keyboardType: .emailAddress, returnKey: .done, contentType: .emailAddress),
                            ChatMessage("Great, I'll shoot you an email at %@ to coordinate. Talk soon!"),
                        ])
                    ])
                ]),
                ChatOption("No, Sorry", chats: [
                    ChatMessage("No problem at all. Enjoy using the app. I'll let you get back to it!")
                ])
            ]),
            ChatInstruction(.showCancelButton),
        ]
        let sequence = ChatSequence(id: "chatWithFounder", chats: chats)
        sequence.readingSpeed = 1.8
        return sequence
    }
    
    public static func supportBot() -> ChatSequence {
        let anythingElse: ChatMessageConditional = ChatMessageConditional(message: "Is there anything else I can help you with?", options: [
            ChatOption("Yes", chats: [
                ChatInstruction(.loopEnd("support"))
            ]),
            ChatOption("Nope :)", chats: [
                ChatInstruction(.rainingEmojis("😄")),
                ChatMessage("Ok great! Glad I was able to help you."),
                ChatMessage("If there's anything else, you can always come right back here."),
                ChatMessage("Have a great day!"),
                ChatInstruction(.delay(3.0)),
                ChatInstruction(.dismiss),
            ])
        ])
        
        let contactSupport: [Chat] = [
            ChatMessage("Sorry I wasn't able to directly answer your question."),
            ChatMessage("Let me put you in touch with support directly so you can ask them."),
            ChatInstruction(.openURL(URL(string: "https://command-services.typeform.com/c/RJxRZ4e6")!, true))
        ]
        
        let chats: [Chat] = [
            ChatMessage("Hey, welcome to support."),
            ChatInstruction(.loopStart("support")),
            ChatRandomMessage(["What can I help you with today?", "Which of these can I help you with?", "Here are a few topics:", "Here are some things I can help you with:"]),
            ChatMessageConditional(message: "", options: [
                ChatOption("Billing & Subscriptions", chats: [
                    ChatMessage("Sure! No problem."),
                    ChatMessageConditional(message: "Which of these applies?", options: [
                        ChatOption("Manage Subscription", chats: [
                            ChatMessage("Sure, let me open that up for you."),
                            ChatInstruction(.openURL(URL(string: "https://apps.apple.com/account/subscriptions")!, false))
                        ]),
                        ChatOption("Subscription Status", chats: [
                            ChatMessage("Sure, let me check on that for you..."),
                            ChatInstruction(.delay(3.0)),
                            ChatMessage("Aha, you have a Pro subscription that expires in 29 days. You don't have auto-renew turned on.")
                        ]),
                        ChatOption("Restore Purchases", chats: [
                            ChatMessage("One moment..."),
                            ChatInstruction(.delay(3.0)),
                            ChatInstruction(.restorePurchases),
                            ChatMessage("Your purchases have been restored!"),
                            ChatInstruction(.rainingEmojis("💸"))
                        ]),
                        ChatOption("Cancel Subscription", chats: subscriptionCancellation().chats),
                        ChatOption("Refunds", chats: [
                            ChatMessage("Oh no, I'm so sorry you got charged. We're going to help you get your money back ASAP."),
                            ChatMessage("I'm going to open up the refund request form for you now..."),
                            ChatMessage("Simply mark the transaction from Hashtag Expert you'd like to get refunded and it should be back in a few days."),
                            ChatMessage("If not, come back here and we'll help you out."),
                            ChatInstruction(.openURL(URL(string: "https://reportaproblem.apple.com")!, false))
                        ]),
                    ]),
                    anythingElse
                ]),
                ChatOption("Hashtags & Tutorials", chats: [
                    ChatMessageConditional(message: "Sure, here are a couple topics I can help you with:", options: [
                        ChatOption("Generating Hashtags", chats: [
                            ChatMessage("Here's a super helpful article on %@."),
                            ChatInstruction(.openURL(URL(string: "https://www.hashtag.expert/tutorials/how-to-generate-a-group-of-hashtags")!, true))
                        ]),
                        ChatOption("How to Pick Hashtags", chats: [
                            ChatMessage("Ah, I wrote this really helpful article about that. Check it out."),
                            ChatInstruction(.openURL(URL(string: "https://www.hashtag.expert/tutorials/the-four-rules-of-hashtags")!, true))
                        ]),
                        ChatOption("Trending Tab", chats: [
                            ChatMessage("No prob! Here's how to use the trending tab."),
                            ChatInstruction(.openURL(URL(string: "https://www.hashtag.expert/tutorials/trending-hashtags")!, true))
                        ]),
                        ChatOption("Collections", chats: [
                            ChatMessage("Collections are super cool. Let me show you how to use them."),
                            ChatInstruction(.openURL(URL(string: "https://www.hashtag.expert/tutorials/collections-app-feature-hashtag-expert")!, true))
                        ]),
                        ChatOption("All Articles", chats: [
                            ChatMessage("We have a bunch of great resources!"),
                            ChatInstruction(.openURL(URL(string: "https://www.hashtag.expert/tutorials")!, true))
                        ]),
                        ChatOption("Other", chats: contactSupport),
                    ]),
                    anythingElse
                ]),
                ChatOption("Instagram", chats: [
                    ChatMessage("We have a lot of super helpful resources on how to use Instagram effectively."),
                    ChatMessageConditional(message: "Want me to show you them?", options: [
                        ChatOption("Yes", chats: [
                            ChatMessage("Ah, I wrote this really helpful article about that. Check it out."),
                            ChatInstruction(.openURL(URL(string: "https://www.hashtag.expert/tutorials/the-four-rules-of-hashtags")!, true))
                        ]),
                        ChatOption("Nope", chats: [
                            anythingElse
                        ]),
                        ChatOption("Other", chats: contactSupport),
                    ]),
                ]),
                ChatOption("Connect Facebook Account", chats: [
                    ChatMessage("Connecting your Facebook account to Hashtag Expert is a great way to get advanced analytics."),
                    ChatMessage("We admit, they don't make it easy and it can be a bit confusing."),
                    ChatMessage("Let me help you out a bit"),
                    ChatMessage("So basically, you need to make sure that your Instagram account is a business or creator account. Then, it must be connected to a corresponding Facebook page."),
                    ChatMessage("Then, in Hashtag Expert, you log in using THAT Facebook account."),
                    ChatMessage("This will allow us to show you more personalized hashtags, your best time to post, and other analytics in the app."),
                    ChatMessageConditional(message: "Did that answer your question or are you still having issues?", options: [
                        ChatOption("Yes", chats: [
                            ChatMessage("Fantastic!"),
                        ]),
                        ChatOption("No", chats: [
                            ChatMessage("Dang. Sorry about that. Here's a link to our FAQs which has more helpful info."),
                            ChatInstruction(.openURL(URL(string: "https://www.hashtag.expert/faq")!, true))
                        ]),
                        ChatOption("Contact Support", chats: contactSupport),
                    ]),
                    anythingElse
                ]),
                ChatOption("FAQs", chats: [
                    ChatMessage("We have a great FAQ."),
                    ChatMessage("Let me take you there"),
                    ChatInstruction(.openURL(URL(string: "https://www.hashtag.expert/faq")!, true)),
                    anythingElse
                ]),
                ChatOption("Other", chats: [
                    ChatMessage("Let me put you in touch with a support agent."),
                    ChatMessage("One moment..."),
                    ChatInstruction(.openURL(URL(string: "https://command-services.typeform.com/c/RJxRZ4e6")!, true)),
                    anythingElse
                ]),
            ]),
        ]
        
        
        let sequence = ChatSequence(id: "supportbot", chats: chats)
        sequence.readingSpeed = 1.8
        return sequence
    }
}
