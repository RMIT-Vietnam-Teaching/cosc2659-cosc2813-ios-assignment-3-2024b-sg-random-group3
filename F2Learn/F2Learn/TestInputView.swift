import SwiftUI

struct TestInputView: View {
    @State private var testInput = ""
    
    var body: some View {
        VStack {
            TextField("Test Input", text: $testInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("You typed: \(testInput)")
                .padding()
        }
    }
}

struct TestInputView_Previews: PreviewProvider {
    static var previews: some View {
        TestInputView()
    }
}
