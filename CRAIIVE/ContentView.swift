//
//  ContentView.swift
//  CRAIIVE
//
//  Created by Diego Aguirre on 7/6/25.
//

import SwiftUI

// Move AppSection enum to top-level
enum AppSection: String, Hashable, Codable, CaseIterable, Identifiable {
    case fridge, freezer, pantry
    var id: String { rawValue }
    static func from(rawValue: String) -> AppSection? {
        AppSection.allCases.first { $0.rawValue == rawValue }
    }
}

// Define SectionIngredient for navigation
struct SectionIngredient: Hashable, Codable, Identifiable {
    let section: AppSection
    let ingredient: String
    var id: String { section.rawValue + ":" + ingredient }
}

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var selectedMainIngredient: String? = nil
    @State private var showExplore = false
    @State private var showInfluencerExplore = false
    @State private var showUpload = false
    @State private var showSearch = false
    @State private var showLoading = false
    @State private var showRecipe = false
    @State private var showShopping = false
    @State private var lastSearch: String = ""
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                // Header: App Title
                Text("CRAIIVE")
                    .font(.system(size: 36, weight: .bold))
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                // Search Bar (placeholder)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    Text("Find an ingredient")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // Button Row
                HStack(spacing: 16) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "heart")
                            Text("Favorites")
                        }
                    }
                    .buttonStyle(.bordered)
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "list.bullet.rectangle")
                            Text("Inventory")
                        }
                    }
                    .buttonStyle(.bordered)
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "clock")
                            Text("History")
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 8)
                .padding(.bottom, 16)

                // Main ScrollView
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Fridge Section
                        SectionHeader(title: "What's In My Fridge?", onTap: {
                            path.append(AppSection.fridge)
                        })
                        HorizontalFoodList(items: [
                            ("Fruit", "photo"),
                            ("Wine", "photo"),
                            ("Milk", "photo"),
                            ("Eggs", "photo")
                        ], onItemTap: { selectedMainIngredient = $0 })

                        // Freezer Section
                        SectionHeader(title: "What's In My Freezer?", onTap: {
                            path.append(AppSection.freezer)
                        })
                        HorizontalFoodList(items: [
                            ("Ice Cream", "photo"),
                            ("Pizza", "photo"),
                            ("Fruit", "photo"),
                            ("Gelato", "photo")
                        ], onItemTap: { selectedMainIngredient = $0 })

                        // Pantry Section
                        SectionHeader(title: "What's In My Pantry?", onTap: {
                            path.append(AppSection.pantry)
                        })
                        HorizontalFoodList(items: [
                            ("Hot Sauce", "photo"),
                            ("Marinara", "photo"),
                            ("Chips", "photo"),
                            ("Soda", "photo")
                        ], onItemTap: { selectedMainIngredient = $0 })
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 80) // For bottom nav bar spacing
                }

                // Bottom Navigation Bar (placeholder icons)
                Divider()
                HStack {
                    Spacer()
                    Button(action: { path = NavigationPath() }) {
                        Image(systemName: "circle") // ai icon placeholder
                    }
                    Spacer()
                    Button(action: { showExplore = true }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.accentColor)
                    }
                    Spacer()
                    Button(action: { showUpload = true }) {
                        Image(systemName: "plus.circle")
                    }
                    Spacer()
                    Button(action: { showShopping = true }) {
                        Image(systemName: "cart")
                    }
                    Spacer()
                    Image(systemName: "person.crop.circle")
                    Spacer()
                }
                .frame(height: 64)
                .background(Color(.systemBackground))
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationDestination(for: AppSection.self) { section in
                switch section {
                case .fridge:
                    MyFridgePage(goToMain: { path = NavigationPath() }, onIngredientTap: { ingredient in path.append(SectionIngredient(section: section, ingredient: ingredient)) }, goToUpload: { showUpload = true }, goToExplore: { showExplore = true }, goToCart: { showShopping = true })
                case .freezer:
                    MyFreezerPage(goToMain: { path = NavigationPath() }, onIngredientTap: { ingredient in path.append(SectionIngredient(section: section, ingredient: ingredient)) }, goToUpload: { showUpload = true }, goToExplore: { showExplore = true }, goToCart: { showShopping = true })
                case .pantry:
                    MyPantryPage(goToMain: { path = NavigationPath() }, onIngredientTap: { ingredient in path.append(SectionIngredient(section: section, ingredient: ingredient)) }, goToUpload: { showUpload = true }, goToExplore: { showExplore = true }, goToCart: { showShopping = true })
                }
            }
            .navigationDestination(for: SectionIngredient.self) { pair in
                IngredientPage(ingredientName: pair.ingredient, goToMain: { path = NavigationPath() }, goToExplore: { showExplore = true }, goToUpload: { showUpload = true }, goToCart: { showShopping = true })
            }
            .navigationDestination(item: $selectedMainIngredient) { ingredient in
                IngredientPage(ingredientName: ingredient, goToMain: { selectedMainIngredient = nil }, goToExplore: { showExplore = true }, goToUpload: { showUpload = true }, goToCart: { showShopping = true })
            }
            .navigationDestination(isPresented: $showExplore) {
                ExplorePage(
                    goToMain: { showExplore = false; path = NavigationPath() },
                    goToExplore: { },
                    goToInfluencer: { showInfluencerExplore = true },
                    goToUpload: { showUpload = true },
                    goToSearch: { showSearch = true },
                    goToCart: { showShopping = true }
                )
            }
            .navigationDestination(isPresented: $showInfluencerExplore) {
                InfluencerExplorePage(goBack: { showInfluencerExplore = false }, goToUpload: { showUpload = true }, goToCart: { showShopping = true })
            }
            .navigationDestination(isPresented: $showUpload) {
                UploadPage(goToMain: { showUpload = false; path = NavigationPath() }, goToExplore: { showUpload = false; showExplore = true }, goToCart: { showShopping = true })
            }
            .navigationDestination(isPresented: $showSearch) {
                SearchPage(
                    goToMain: { showSearch = false; path = NavigationPath() },
                    goToExplore: { showSearch = false; showExplore = true },
                    goToUpload: { showUpload = true },
                    onSubmit: { query in
                        lastSearch = query
                        showSearch = false
                        showLoading = true
                    },
                    goBack: { showSearch = false; showExplore = true },
                    goToCart: { showShopping = true }
                )
            }
            .navigationDestination(isPresented: $showLoading) {
                LoadingPage(onComplete: {
                    showLoading = false
                    showRecipe = true
                }, goToMain: { showLoading = false; path = NavigationPath() }, goToExplore: { showLoading = false; showExplore = true }, goToUpload: { showLoading = false; showUpload = true }, goToCart: { showLoading = false; showShopping = true })
            }
            .navigationDestination(isPresented: $showRecipe) {
                RecipePage(
                    recipeTitle: lastSearch.isEmpty ? "Creamy Tomato Gnocchi" : lastSearch,
                    goToMain: { showRecipe = false; path = NavigationPath() },
                    goToExplore: { showRecipe = false; showExplore = true },
                    goToUpload: { showRecipe = false; showUpload = true },
                    goToCart: { showShopping = true },
                    goToProfile: {},
                    goBack: { showRecipe = false; showSearch = true }
                )
            }
            .navigationDestination(isPresented: $showShopping) {
                ShoppingPage(goToMain: { showShopping = false; path = NavigationPath() }, goToExplore: { showShopping = false; showExplore = true }, goToUpload: { showShopping = false; showUpload = true }, goToCart: { showShopping = true }, goToProfile: {})
            }
        }
    }
}

// MARK: - Section Header Component
struct SectionHeader: View {
    let title: String
    var onTap: (() -> Void)? = nil
    var body: some View {
        if let onTap = onTap {
            Button(action: onTap) {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .contentShape(Rectangle())
                .padding(.bottom, 4)
            }
            .buttonStyle(.plain)
        } else {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 4)
        }
    }
}

// MARK: - Horizontal Food List Component (Placeholder images)
struct HorizontalFoodList: View {
    let items: [(String, String)] // (label, imageName)
    var onItemTap: ((String) -> Void)? = nil
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(items, id: \.0) { item in
                    Button(action: { onItemTap?(item.0) }) {
                        VStack {
                            // Placeholder for food image
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 56, height: 56)
                                .background(Color(.systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(item.0)
                                .font(.caption)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Nutrition Page (Placeholder)
struct NutritionPage: View {
    var ingredientName: String = "Wine"
    var goToMain: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToUpload: () -> Void = {}
    var goToCart: () -> Void = {}
    var body: some View {
        VStack(spacing: 0) {
            // Header: App Title
            Text("CRAIIVE")
                .font(.system(size: 36, weight: .bold))
                .padding(.top, 8)
                .padding(.bottom, 8)

            // Nutrition Title
            Text("Nutrition")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 16)

            // Calories Circle
            ZStack {
                Circle()
                    .stroke(Color.black, lineWidth: 1)
                    .frame(width: 120, height: 120)
                VStack(spacing: 2) {
                    Text("152")
                        .font(.system(size: 32, weight: .bold))
                    Text("kcal")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 24)

            // Nutrition Facts
            VStack(alignment: .leading, spacing: 0) {
                Text("Amount per glass")
                    .font(.headline)
                    .padding(.bottom, 12)
                NutritionFactRow(label: "Total Fat", value: "0g", percent: "0%")
                NutritionFactRow(label: "Saturated Fat", value: "0g", percent: "0%")
                NutritionFactRow(label: "Sodium", value: "5mg", percent: "0%")
                NutritionFactRow(label: "Total Carbs", value: "4g", percent: "1%")
                NutritionFactRow(label: "Dietary Fiber", value: "0g", percent: "0%")
                NutritionFactRow(label: "Total Sugars", value: "1g", percent: "–", sublabel: "Includes 1.5g Added Sugars")
                NutritionFactRow(label: "Protein", value: "0g", percent: "0%")
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            Spacer()

            // Bottom Navigation Bar (reuse from main page)
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle") // ai icon placeholder
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - Nutrition Fact Row (Placeholder)
struct NutritionFactRow: View {
    var label: String
    var value: String
    var percent: String
    var sublabel: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(label)
                    .font(.body)
                Spacer()
                Text(value)
                    .font(.body)
                Text(percent)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            if let sub = sublabel {
                Text(sub)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }
        }
        .padding(.vertical, 6)
        Divider()
    }
}

// MARK: - Ingredient Page (Placeholder)
struct IngredientPage: View {
    var ingredientName: String = "Wine"
    var goToMain: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToUpload: () -> Void = {}
    var goToCart: () -> Void = {}
    @State private var showNutrition = false
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Main content
                VStack(spacing: 0) {
                    // Header: App Title
                    Text("CRAIIVE")
                        .font(.system(size: 36, weight: .bold))
                        .padding(.top, 8)
                        .padding(.bottom, 8)

                    Spacer()

                    // Ingredient Image (placeholder)
                    Button(action: { showNutrition = true }) {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 220)
                            .padding(.bottom, 8)
                    }
                    .buttonStyle(.plain)

                    // Ingredient Name
                    Text(ingredientName)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 24)

                    // Nutrition/Stock Row
                    HStack(spacing: 32) {
                        VStack {
                            Text("152")
                                .font(.system(size: 32, weight: .bold))
                            Text("Calories")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Divider().frame(height: 40)
                        VStack {
                            Text("1,2g")
                                .font(.system(size: 32, weight: .bold))
                            Text("In Stock")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)

                    // Store Cards (placeholder)
                    HStack(spacing: 16) {
                        IngredientStoreCard(store: "TRADER JOE'S", price: "$13.99", stock: "In Stock", distance: "0.5 mi")
                        IngredientStoreCard(store: "WHOLE FOODS", price: "$14.99", stock: "Low Stock", distance: "1,2 mi")
                        IngredientStoreCard(store: "Walmart", price: "$12.49", stock: "In Stock", distance: "1,5 mi")
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 24)

                    Spacer()
                }
                // Overlay to dismiss NutritionPage when sheet is open and user taps anywhere except nav bar
                if showNutrition {
                    Color.black.opacity(0.001) // invisible but catches taps
                        .ignoresSafeArea(edges: .all)
                        .onTapGesture {
                            showNutrition = false
                        }
                }
            }
            // Bottom Navigation Bar (reuse from main page)
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showNutrition) {
            NutritionPage(ingredientName: ingredientName, goToMain: goToMain, goToExplore: goToExplore, goToUpload: goToUpload, goToCart: goToCart)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled(false)
        }
    }
}

// MARK: - Ingredient Store Card (Placeholder)
struct IngredientStoreCard: View {
    var store: String
    var price: String
    var stock: String
    var distance: String
    var body: some View {
        VStack(spacing: 4) {
            Text(store)
                .font(.caption)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text(price)
                .font(.headline)
            Text(stock)
                .font(.caption2)
                .foregroundColor(.gray)
            Text(distance)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(width: 90, height: 90)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

// MARK: - My Fridge Page
struct MyFridgePage: View {
    let categories = ["Drinks", "Dairy", "Snacks", "Meat & Poultry"]
    @State private var selectedCategory = "Drinks"
    let drinks = [
        ("Red Wine", "photo"),
        ("Rosé", "photo"),
        ("White Wine", "photo"),
        ("Water Bottle", "photo"),
        ("Cold Brew", "photo"),
        ("Sparkling Water", "photo"),
        ("Lite Beer", "photo"),
        ("Margarita Mix", "photo"),
        ("Coke", "photo")
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var goToMain: () -> Void = {}
    var onIngredientTap: (String) -> Void = { _ in }
    var goToUpload: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToCart: () -> Void = {}
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: goToMain) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .padding(.leading, 8)
                Spacer()
            }
            .padding(.top, 0)
            // Header: App Title
            Text("CRAIIVE")
                .font(.system(size: 36, weight: .bold))
                .padding(.top, 8)
                .padding(.bottom, 8)
            // Search Bar (placeholder)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Search for something in your fridge")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            // Category Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            Text(category)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedCategory == category ? Color(.label) : Color(.systemBackground))
                                .foregroundColor(selectedCategory == category ? .white : .black)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(Color(.systemGray3), lineWidth: selectedCategory == category ? 0 : 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            // Drinks Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 32) {
                    ForEach(drinks, id: \.0) { drink in
                        Button(action: { onIngredientTap(drink.0) }) {
                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 80)
                                    .background(Color(.systemGray5))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Text(drink.0)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 80)
            }
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - My Freezer Page
struct MyFreezerPage: View {
    let categories = ["All", "Sweet", "Savory"]
    @State private var selectedCategory = "All"
    let freezerItems = [
        ("Pizza", "photo"),
        ("Sweet Peas", "photo"),
        ("Gelato Mint", "photo"),
        ("Gelato Berry", "photo"),
        ("Raspberries", "photo"),
        ("Smoothie Bowl", "photo")
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var goToMain: () -> Void = {}
    var onIngredientTap: (String) -> Void = { _ in }
    var goToUpload: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToCart: () -> Void = {}
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: goToMain) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .padding(.leading, 8)
                Spacer()
            }
            .padding(.top, 0)
            // Header: App Title
            Text("CRAIIVE")
                .font(.system(size: 36, weight: .bold))
                .padding(.top, 8)
                .padding(.bottom, 8)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Search for something in your freezer")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            Text(category)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedCategory == category ? Color(.label) : Color(.systemBackground))
                                .foregroundColor(selectedCategory == category ? .white : .black)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(Color(.systemGray3), lineWidth: selectedCategory == category ? 0 : 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            ScrollView {
                LazyVGrid(columns: columns, spacing: 32) {
                    ForEach(freezerItems, id: \.0) { item in
                        Button(action: { onIngredientTap(item.0) }) {
                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 120)
                                    .background(Color(.systemGray5))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Text(item.0)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 80)
            }
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - My Pantry Page
struct MyPantryPage: View {
    let categories = ["All", "Canned", "Snacks", "Sauces"]
    @State private var selectedCategory = "All"
    let pantryItems = [
        ("Truff Sauce", "photo"),
        ("Popcorners", "photo"),
        ("Flour", "photo"),
        ("Truff Hot Sauce", "photo"),
        ("Hearts Drink", "photo"),
        ("Red Lentil Penne", "photo")
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var goToMain: () -> Void = {}
    var onIngredientTap: (String) -> Void = { _ in }
    var goToUpload: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToCart: () -> Void = {}
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: goToMain) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .padding(.leading, 8)
                Spacer()
            }
            .padding(.top, 0)
            // Header: App Title
            Text("CRAIIVE")
                .font(.system(size: 36, weight: .bold))
                .padding(.top, 8)
                .padding(.bottom, 8)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Search for something in your pantry")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            Text(category)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedCategory == category ? Color(.label) : Color(.systemBackground))
                                .foregroundColor(selectedCategory == category ? .white : .black)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(Color(.systemGray3), lineWidth: selectedCategory == category ? 0 : 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            ScrollView {
                LazyVGrid(columns: columns, spacing: 32) {
                    ForEach(pantryItems, id: \.0) { item in
                        Button(action: { onIngredientTap(item.0) }) {
                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 120)
                                    .background(Color(.systemGray5))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Text(item.0)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 80)
            }
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Explore Page (Placeholder)
struct ExplorePage: View {
    let filters = ["New", "Trending", "Quick", "Cocktails", "Italian"]
    @State private var selectedFilter = "New"
    let recipes = [
        ("Recipe 1", "photo", "15 min"),
        ("Recipe 2", "photo", "25 min"),
        ("Recipe 3", "photo", "10 min"),
        ("Recipe 4", "photo", "35 min"),
        ("Recipe 5", "photo", "20 min"),
        ("Recipe 6", "photo", "15 min"),
        ("Recipe 7", "photo", "20 min"),
        ("Recipe 8", "photo", "25 min"),
        ("Recipe 9", "photo", "20 min"),
        ("Recipe 10", "photo", "25 min"),
        ("Recipe 11", "photo", "20 min"),
        ("Recipe 12", "photo", "15 min")
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var goToMain: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToInfluencer: () -> Void = {}
    var goToUpload: () -> Void = {}
    var goToSearch: () -> Void = {}
    var goToCart: () -> Void = {}
    var body: some View {
        VStack(spacing: 0) {
            // Header: App Title and Profile Icon
            ZStack {
                Text("CRAIIVE")
                    .font(.system(size: 36, weight: .bold))
                HStack {
                    Spacer()
                    Button(action: goToInfluencer) {
                        Image(systemName: "person.2")
                            .font(.title2)
                            .padding(.trailing, 16)
                    }
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 8)

            // Search Bar (tappable)
            Button(action: goToSearch) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    Text("Find the recipe you're craiiving")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }

            // Filter Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: { selectedFilter = filter }) {
                            Text(filter)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedFilter == filter ? Color(.label) : Color(.systemBackground))
                                .foregroundColor(selectedFilter == filter ? .white : .black)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(Color(.systemGray3), lineWidth: selectedFilter == filter ? 0 : 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }

            // Recipes Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(recipes, id: \.0) { recipe in
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: recipe.1)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 110, height: 110)
                                .background(Color(.systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(recipe.2)
                                .font(.caption)
                                .padding(6)
                                .background(Color.white.opacity(0.85))
                                .clipShape(Capsule())
                                .padding(6)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 80)
            }

            // Bottom Navigation Bar (reuse from main page)
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.accentColor)
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Influencer Explore Page
struct InfluencerExplorePage: View {
    var goBack: () -> Void = {}
    var goToUpload: () -> Void = {}
    var goToCart: () -> Void = {}
    var body: some View {
        VStack(spacing: 0) {
            // Header: Back Button and Title
            HStack {
                Button(action: goBack) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding(.leading, 8)
                }
                Spacer()
                Text("CRAIIVE")
                    .font(.system(size: 36, weight: .bold))
                Spacer()
                // Invisible icon for spacing
                Image(systemName: "chevron.left")
                    .opacity(0)
                    .padding(.trailing, 8)
            }
            .padding(.top, 8)
            .padding(.bottom, 8)

            // Search Bar (placeholder)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Find a recipe")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)

            // Famous Friends
            SectionHeader(title: "Famous Friends!", onTap: {})
                .padding(.top, 16)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { _ in
                        Image(systemName: "person.crop.square")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 110)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 8)

            // Chefs
            SectionHeader(title: "Chefs", onTap: {})
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<2) { _ in
                        Image(systemName: "person.crop.square")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 110)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 8)

            // Restaurants
            SectionHeader(title: "Restaurants", onTap: {})
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { _ in
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 110, height: 80)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 8)

            Spacer()

            // Bottom Navigation Bar (reuse from main page)
            Divider()
            HStack {
                Spacer()
                Button(action: goBack) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goBack) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.accentColor)
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Upload Page
struct UploadPage: View {
    var goToMain: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToCart: () -> Void = {}
    var body: some View {
        VStack(spacing: 0) {
            // Header: App Title
            Text("CRAIIVE")
                .font(.system(size: 36, weight: .bold))
                .padding(.top, 8)
                .padding(.bottom, 8)

            Spacer()

            // Upload Title
            Text("Upload a food item")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
            Text("Add photos of food, beverages, etc.")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom, 32)

            // Upload Box (placeholder)
            Button(action: {}) {
                VStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 40, weight: .bold))
                    Text("Add Image, Receipt, or Item")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                .frame(width: 200, height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                        .foregroundColor(.gray)
                )
            }
            .buttonStyle(.plain)
            .padding(.bottom, 40)

            // Save Button (disabled)
            Button(action: {}, label: {
                Text("Save")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.label))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            })
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
            .disabled(true)

            Spacer()

            // Bottom Navigation Bar (reuse from main page)
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.accentColor)
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Loading Page
struct LoadingPage: View {
    var onComplete: () -> Void = {}
    @State private var progress: CGFloat = 0.0
    @State private var isActive = true
    var goToMain: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToUpload: () -> Void = {}
    var goToCart: () -> Void = {}
    var body: some View {
        VStack(spacing: 0) {
            Text("CRAIIVE")
                .font(.system(size: 36, weight: .bold))
                .padding(.top, 8)
                .padding(.bottom, 8)
            Spacer()
            VStack(spacing: 32) {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(width: 320)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .padding(.bottom, 16)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sourcing your flavor fix...")
                        .font(.title3).fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("Just a sec!")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 32)
            }
            Spacer()
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            progress = 0.0
            withAnimation(Animation.linear(duration: 2.0)) {
                progress = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if isActive {
                    onComplete()
                }
            }
        }
        .onDisappear {
            isActive = false
        }
    }
}

// MARK: - Recipe Page (Sample)
struct RecipePage: View {
    var recipeTitle: String = "Creamy Tomato Gnocchi"
    var recipeImage: String = "photo" // Use system image as placeholder
    var goToMain: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToUpload: () -> Void = {}
    var goToCart: () -> Void = {}
    var goToProfile: () -> Void = {}
    var goBack: () -> Void = {}
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: goBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .padding(.leading, 8)
                Spacer()
            }
            .padding(.top, 8)
            ScrollView {
                VStack(spacing: 0) {
                    Text("CRAIIVE")
                        .font(.system(size: 36, weight: .bold))
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    Image(recipeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 8)
                        .padding(.bottom, 8)
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text("30 mins")
                                .font(.headline)
                        }
                        Spacer()
                        Text("Medium")
                            .font(.headline)
                        Image(systemName: "star.fill")
                            .foregroundColor(.black)
                        Image(systemName: "star.fill")
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 8)
                    Text(recipeTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                    Text("A rich, comforting one-pot dinner ready in under 30 minutes")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    HStack(spacing: 8) {
                        ForEach(["Quick", "Vegetarian", "One-Pot"], id: \.self) { tag in
                            Text(tag)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        }
                    }
                    .padding(.bottom, 8)
                    Divider().padding(.vertical, 8)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Ingredients")
                            .font(.title2).fontWeight(.bold)
                            .padding(.bottom, 2)
                        Text("Stocked")
                            .font(.headline)
                            .padding(.bottom, 2)
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach([
                                "1 lb fresh gnocchi",
                                "3 cloves garlic, minced",
                                "2 cups cherry tomatoes, halved",
                                "1/2 cup vegetable broth",
                                "4 oz lighter cream cheese",
                                "Oregano, Italian seasoning, thyme",
                                "Olive oil, salt, and pepper"
                            ], id: \.self) { item in
                                HStack {
                                    Image(systemName: "square")
                                    Text(item)
                                }
                            }
                        }
                        .padding(.bottom, 4)
                        Text("To buy")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach([
                                "1 red onion, diced",
                                "2 tbsp tomato paste",
                                "1/2 cup shredded mozzarella"
                            ], id: \.self) { item in
                                HStack {
                                    Image(systemName: "square")
                                        .foregroundColor(.red)
                                    Text(item).foregroundColor(.red)
                                }
                            }
                        }
                        Divider().padding(.vertical, 4)
                        HStack {
                            Spacer()
                            Text("Estimated: $9.75")
                                .font(.headline)
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    Divider().padding(.vertical, 8)
                    Text("STEPS")
                        .font(.title2).fontWeight(.bold)
                        .padding(.bottom, 2)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. Sauté the Aromatics")
                            .font(.headline)
                        Text("Cook onion in olive oil 5–6 min")
                            .font(.body)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 80)
            }
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Button(action: goToProfile) {
                    Image(systemName: "person.crop.circle")
                }
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Search Page (Figma-inspired)
struct SearchPage: View {
    var goToMain: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToUpload: () -> Void = {}
    var onSubmit: (String) -> Void = { _ in }
    var goBack: () -> Void = {}
    var goToCart: () -> Void = {}
    @State private var searchText: String = ""
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: goBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .padding(.leading, 8)
                Spacer()
            }
            .padding(.top, 8)
            Text("CRAIIVE")
                .font(.system(size: 36, weight: .bold))
                .padding(.top, 8)
                .padding(.bottom, 8)
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemGray6))
                    .frame(width: 300, height: 200)
                    .shadow(color: Color(.black).opacity(0.08), radius: 8, x: 0, y: 4)
                VStack(spacing: 0) {
                    Text("Curate.")
                        .font(.system(size: 24, weight: .semibold, design: .default))
                        .italic()
                    Text("Your.")
                        .font(.system(size: 24, weight: .semibold, design: .default))
                        .italic()
                    Text("Craving.")
                        .font(.system(size: 24, weight: .semibold, design: .default))
                        .italic()
                }
                .foregroundColor(.black)
            }
            .padding(.bottom, 32)
            // Editable Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("ex. minimalist breakfast, indulgent tr", text: $searchText, onCommit: {
                    if !searchText.isEmpty {
                        onSubmit(searchText)
                    }
                })
                .foregroundColor(.primary)
                .submitLabel(.search)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            Spacer()
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.accentColor)
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                }
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Shopping Page (Figma-inspired)
struct ShoppingPage: View {
    var goToMain: () -> Void = {}
    var goToExplore: () -> Void = {}
    var goToUpload: () -> Void = {}
    var goToCart: () -> Void = {}
    var goToProfile: () -> Void = {}
    @State private var selectedFilter: String = "All"
    let filters = ["All", "Produce", "Dairy", "Favorites", "Meat"]
    let sections: [(String, [(String, String, String, String)])] = [
        ("Most Purchased", [
            ("Broccoli", "$1.75/lb", "Walmart", "photo"),
            ("Eggs", "$4.12/dozen", "Whole Foods", "photo")
        ]),
        ("Almost Out", [
            ("Flour", "$3.49/5lb", "Target", "photo"),
            ("Raspberries", "$8.00/lb", "Whole Foods", "photo")
        ]),
        ("CRAIIVE Picks", [
            ("Bell Peppers", "$2.15/lb", "Stop & Shop", "photo"),
            ("Avocado", "$0.99", "Trader Joe's", "photo")
        ]),
        ("Top Savings", [
            ("Banza", "$4.99", "Whole Foods", "photo"),
            ("Bagels", "$3.00/per 6", "Stop & Shop", "photo")
        ]),
        ("Expiring Soon", [
            ("Milk", "$2.99/gal", "Stop & Shop", "photo"),
            ("Spinach", "$1.99/bag", "Trader Joe's", "photo")
        ])
    ]
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Text("CRAIIVE")
                    .font(.system(size: 36, weight: .bold))
                HStack {
                    Spacer()
                    Button(action: goToCart) {
                        Image(systemName: "cart")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(.trailing, 8)
                    }
                }
            }
            .padding(.top, 8)
            .padding(.horizontal)
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Search for ingredients")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            // Filter Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: { selectedFilter = filter }) {
                            Text(filter)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedFilter == filter ? Color(.label) : Color(.systemBackground))
                                .foregroundColor(selectedFilter == filter ? .white : .black)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(Color(.systemGray3), lineWidth: selectedFilter == filter ? 0 : 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            // Sections
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(sections, id: \.0) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(section.0)
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(section.1, id: \.0) { item in
                                        ShoppingCardView(name: item.0, price: item.1, store: item.2, imageName: item.3)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 80)
            }
            // Bottom Navigation Bar
            Divider()
            HStack {
                Spacer()
                Button(action: goToMain) {
                    Image(systemName: "circle")
                }
                Spacer()
                Button(action: goToExplore) {
                    Image(systemName: "magnifyingglass")
                }
                Spacer()
                Button(action: goToUpload) {
                    Image(systemName: "plus.circle")
                }
                Spacer()
                Button(action: goToCart) {
                    Image(systemName: "cart")
                        .foregroundColor(.accentColor)
                }
                Spacer()
                Button(action: goToProfile) {
                    Image(systemName: "person.crop.circle")
                }
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Shopping Card View
struct ShoppingCardView: View {
    var name: String
    var price: String
    var store: String
    var imageName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 60)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(name)
                .font(.headline)
            Text(price)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(store)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 140, height: 120)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.black).opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    // Preview MyFridgePage for development
    MyFridgePage(onIngredientTap: { _ in })
}

#Preview {
    // Preview MyFreezerPage for development
    MyFreezerPage(onIngredientTap: { _ in })
}

#Preview {
    // Preview MyPantryPage for development
    MyPantryPage(onIngredientTap: { _ in })
}
