import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .autocapitalization(.none)
    }
}

// Extension to make the style easier to use
extension TextFieldStyle where Self == CustomTextFieldStyle {
    static var custom: CustomTextFieldStyle {
        CustomTextFieldStyle()
    }
} 