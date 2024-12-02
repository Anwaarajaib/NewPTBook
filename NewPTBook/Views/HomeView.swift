import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var clientViewModel: ClientViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Welcome Section
                if let user = authViewModel.currentUser {
                    Text("Welcome, \(user.name)!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                }
                
                // Stats Section
                VStack(spacing: 15) {
                    StatsCard(
                        title: "Total Clients",
                        value: "\(clientViewModel.clients.count)",
                        icon: "person.2.fill"
                    )
                    
                    StatsCard(
                        title: "Active Programs",
                        value: "Coming Soon",
                        icon: "figure.run"
                    )
                }
                .padding(.horizontal)
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            QuickActionButton(
                                title: "Add Client",
                                icon: "person.badge.plus",
                                action: { /* Add navigation to add client */ }
                            )
                            
                            QuickActionButton(
                                title: "Create Workout",
                                icon: "plus.circle",
                                action: { /* Add navigation to create workout */ }
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Dashboard")
        }
    }
}

// Helper Views
struct StatsCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(.white)
            .frame(width: 100, height: 80)
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(ClientViewModel())
}