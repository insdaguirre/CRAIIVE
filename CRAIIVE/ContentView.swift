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
                    Image(systemName: "plus.circle")
                    Spacer()
                    Image(systemName: "cart")
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
                    MyFridgePage(goToMain: { path = NavigationPath() }, onIngredientTap: { ingredient in path.append(SectionIngredient(section: section, ingredient: ingredient)) })
                case .freezer:
                    MyFreezerPage(goToMain: { path = NavigationPath() }, onIngredientTap: { ingredient in path.append(SectionIngredient(section: section, ingredient: ingredient)) })
                case .pantry:
                    MyPantryPage(goToMain: { path = NavigationPath() }, onIngredientTap: { ingredient in path.append(SectionIngredient(section: section, ingredient: ingredient)) })
                }
            }
            .navigationDestination(for: SectionIngredient.self) { pair in
                IngredientPage(ingredientName: pair.ingredient)
            }
            .navigationDestination(item: $selectedMainIngredient) { ingredient in
                IngredientPage(ingredientName: ingredient)
            }
            .navigationDestination(isPresented: $showExplore) { ExplorePage(goToMain: { showExplore = false; path = NavigationPath() }, goToExplore: { }) }
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
                Image(systemName: "circle") // ai icon placeholder
                Spacer()
                Image(systemName: "magnifyingglass")
                Spacer()
                Image(systemName: "plus.circle")
                Spacer()
                Image(systemName: "cart")
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
    @State private var showNutrition = false
    var body: some View {
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

            // Bottom Navigation Bar (reuse from main page)
            Divider()
            HStack {
                Spacer()
                Image(systemName: "circle") // ai icon placeholder
                Spacer()
                Image(systemName: "magnifyingglass")
                Spacer()
                Image(systemName: "plus.circle")
                Spacer()
                Image(systemName: "cart")
                Spacer()
                Image(systemName: "person.crop.circle")
                Spacer()
            }
            .frame(height: 64)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(
            NavigationLink(destination: NutritionPage(ingredientName: ingredientName), isActive: $showNutrition) { EmptyView() }
                .hidden()
        )
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
    var body: some View {
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
                Image(systemName: "magnifyingglass")
                Spacer()
                Image(systemName: "plus.circle")
                Spacer()
                Image(systemName: "cart")
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
    var body: some View {
        VStack(spacing: 0) {
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
                Image(systemName: "magnifyingglass")
                Spacer()
                Image(systemName: "plus.circle")
                Spacer()
                Image(systemName: "cart")
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
    var body: some View {
        VStack(spacing: 0) {
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
                Image(systemName: "magnifyingglass")
                Spacer()
                Image(systemName: "plus.circle")
                Spacer()
                Image(systemName: "cart")
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
    var body: some View {
        VStack(spacing: 0) {
            // Header: App Title and Profile Icon
            ZStack {
                Text("CRAIIVE")
                    .font(.system(size: 36, weight: .bold))
                HStack {
                    Spacer()
                    Image(systemName: "person.2")
                        .font(.title2)
                        .padding(.trailing, 16)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 8)

            // Search Bar (placeholder)
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
                Image(systemName: "plus.circle")
                Spacer()
                Image(systemName: "cart")
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

// MARK: - TODO: Replace all placeholder images and icons with real assets and shared components as per Figma when available.

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
