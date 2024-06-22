import SwiftUI

struct ContentView: View {
    @State private var deserts: [Desert] = []
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search desserts")
                    .padding(.horizontal)
                
                List(filteredDeserts, id: \.idMeal) { desert in
                    NavigationLink(destination: DesertDetailView(desert: desert)) {
                        HStack {
                            AsyncImage(url: URL(string: desert.strMealThumb)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } placeholder: {
                                ProgressView()
                            }
                            Spacer()
                                .frame(width: 20)
                            Text(desert.strMeal)
                                .font(.headline)
                            Spacer()
                        }
                    }
                }
                .onAppear {
                    fetchDeserts()
                }
                .navigationTitle("Desserts")
            }
        }
    }

    private var filteredDeserts: [Desert] {
        if searchText.isEmpty {
            return deserts
        } else {
            return deserts.filter { $0.strMeal.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func fetchDeserts() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(MealResponse.self, from: data)
                DispatchQueue.main.async {
                    self.deserts = response.meals
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal, 10)
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                        .padding(8)
                }
            }
        }
    }
}

struct Desert: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String

    var id: String { idMeal }
}

struct MealResponse: Codable {
    let meals: [Desert]
}

#Preview {
    ContentView()
}

