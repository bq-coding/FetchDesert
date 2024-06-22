import SwiftUI
import SafariServices

struct DesertDetailView: View {
    let desert: Desert
    @State private var desertDetails: DesertDetails?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let desertDetails = desertDetails {
                    AsyncImage(url: URL(string: desertDetails.strMealThumb)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                    } placeholder: {
                        ProgressView()
                    }
                    Text(desertDetails.strMeal)
                        .font(.largeTitle)
                        .padding(.top)
                        .padding(.bottom, 8)
                    
                    if let origin = desertDetails.strArea {
                        Text("Origin: " + origin)
                            .padding(.bottom, 4)
                    }
                    if let youtubeURL = desertDetails.strYoutube, !youtubeURL.isEmpty {
                        Button(action: {
                            openLink(url: youtubeURL)
                        }) {
                            Text("Watch on Youtube")
                        }
                        .padding(.bottom, 4)
                    }
                    if let sourceURL = desertDetails.strSource, !sourceURL.isEmpty {
                        Button(action: {
                            openLink(url: sourceURL)
                        }) {
                            Text("Click for more info")
                        }
                        .padding(.bottom, 8)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients:")
                            .font(.headline)
                        
                        ForEach(1...20, id: \.self) { index in
                            let ingredient = desertDetails.getValue(forKey: "strIngredient\(index)") ?? ""
                            let measure = desertDetails.getValue(forKey: "strMeasure\(index)") ?? ""
                            if !ingredient.isEmpty && !measure.isEmpty {
                                Text("\(index). \(measure) \(ingredient)")
                                    .padding(.bottom, 4)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if let instructions = desertDetails.strInstructions {
                        Text("Instructions:")
                            .font(.headline)
                            .padding(.top)
                        Text(instructions)
                            .padding(.bottom)
                    }

                    Spacer()
                } else {
                    ProgressView()
                        .onAppear {
                            fetchDetailedDesert()
                        }
                }
            }
            .padding()
        }
        .navigationTitle(desert.strMeal)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func openLink(url: String) {
        if let link = URL(string: url) {
            UIApplication.shared.open(link)
        }
    }
    
    func fetchDetailedDesert() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(desert.idMeal)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(DetailedMealResponse.self, from: data)
                DispatchQueue.main.async {
                    self.desertDetails = response.meals.first
                }
            } catch {
                print("Error fetching detailed desert: \(error.localizedDescription)")
            }
        }.resume()
    }
}

// there has to be a way to combine all those ingrediaents and measures into a single array of tuples...
struct DesertDetails: Codable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String?
    let strArea: String?
    let strTags: String?
    let strYoutube: String?
    let strSource: String?
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
    
    func getValue(forKey key: String) -> String? {
        return Mirror(reflecting: self).children.first { $0.label == key }?.value as? String
    }
}

struct DetailedMealResponse: Codable {
    let meals: [DesertDetails]
}

#Preview {
    DesertDetailView(desert: Desert(idMeal: "52893", strMeal: "Test Meal", strMealThumb: ""))
}
