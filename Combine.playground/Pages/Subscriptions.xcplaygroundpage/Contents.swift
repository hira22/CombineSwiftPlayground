//: [Previous](@previous)

import Combine
import UIKit

/*:
 ## Subscription details
 - A subscriber will receive a _single_ subscription
 - _Zero_ or _more_ values can be published
 - At most _one_ {completion, error} will be called
 - After completion, nothing more is received

  - サブスクライバーは、_シングル_のサブスクリプションを受け取る
 - _ゼロまたはそれ以上の値_ を公開できる
 - 最大で _一度_ {completion, error} が呼び出されます。
 - 完了後、それ以上は何も受信しません
 */

enum ExampleError: Swift.Error {
    case somethingWentWrong
}

let subject = PassthroughSubject<String, ExampleError>()

// The handleEvents operator lets you intercept
// All stages of a subscription lifecycle
// handleEvents オペレーターにより、以下をインターセプトすることができます。
// サブスクリプションのライフサイクルのすべてのステージ
subject.handleEvents(receiveSubscription: { (subscription) in
        print("New subscription!")
    }, receiveOutput: { _ in
        print("Received new value!")
    }, receiveCompletion: { _ in
        print("A subscription completed")
    }, receiveCancel: {
        print("A subscription cancelled")
    })
    .replaceError(with: "Failure")
    .sink { (value) in
        print("Subscriber received value: \(value)")
    }

subject.send("Hello!")
subject.send("Hello again!")
subject.send("Hello for the last time!")
subject.send(completion: .failure(.somethingWentWrong))
subject.send("Hello?? :(")

//: [Next](@next)
