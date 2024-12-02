import SwiftUI

struct AddClientView: View {
    @EnvironmentObject var clientViewModel: ClientViewModel
    @State private var clientName: String = ""
    @State private var clientEmail: String = ""

    var body: some View {
        VStack {
            TextField("Client Name", text: $clientName)
                .textFieldStyle(CustomTextFieldStyle())
                .padding()

            TextField("Client Email", text: $clientEmail)
                .textFieldStyle(CustomTextFieldStyle())
                .padding()

            Button("Add Client") {
                let newClient = Client(id: UUID().uuidString, name: clientName, email: clientEmail)
                Task {
                    await clientViewModel.addClient(client: newClient)
                }
            }
            .padding()
        }
        .navigationTitle("Add Client")
    }
}

#Preview {
    AddClientView()
        .environmentObject(ClientViewModel())
} 
