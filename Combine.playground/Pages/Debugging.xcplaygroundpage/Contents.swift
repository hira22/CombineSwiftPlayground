//: [Previous](@previous)

import Foundation
import UIKit
import Combine
/*:
## Debugging
Operators which help debug Combine publishers
Combineパブリッシャーのデバッグに役立つオペレーター

More info: [https://www.avanderlee.com/debugging/combine-swift/‎](https://www.avanderlee.com/debugging/combine-swift/‎)
*/

enum ExampleError: Swift.Error {
	case somethingWentWrong
}

/*:
### Handling events
Can be used combined with breakpoints for further insights.
- exposes all the possible events happening inside a publisher / subscription couple
- very useful when developing your own publishers

ブレイクポイントと組み合わせて使用することで、より詳細な情報を得ることができます。
- パブリッシャーとサブスクリプションのカップルの中で発生する可能性のあるすべてのイベントを公開します。
- 独自のパブリッシャーを開発する際に非常に便利
*/
let subject = PassthroughSubject<String, ExampleError>()
let subscription = subject
	.handleEvents(receiveSubscription: { (subscription) in
		print("Receive subscription")
	}, receiveOutput: { output in
		print("Received output: \(output)")
	}, receiveCompletion: { _ in
		print("Receive completion")
	}, receiveCancel: {
		print("Receive cancel")
	}, receiveRequest: { demand in
		print("Receive request: \(demand)")
	}).replaceError(with: "Error occurred").sink { _ in }

subject.send("Hello!")
subscription.cancel()

// Prints out:
// Receive request: unlimited
// Receive subscription
// Received output: Hello!
// Receive cancel

//subject.send(completion: .finished)

/*:
### `print(_:)`
Prints log messages for every event

イベントごとにログメッセージを表示
*/

let printSubscription = subject
	.print("Print example")
	.replaceError(with: "Error occurred")
	.sink { _ in }

subject.send("Hello!")
printSubscription.cancel()

// Prints out:
// Print example: receive subscription: (PassthroughSubject)
// Print example: request unlimited
// Print example: receive value: (Hello!)
// Print example: receive cancel

/*:
### `breakpoint(_:)`
Conditionally break in the debugger when specific values pass through

特定の値を通過するとデバッガが条件付きでブレークする
*/
let breakSubscription = subject
	.breakpoint(receiveOutput: { value in
	  value == "Hello!"
	})
