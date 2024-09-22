/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Random Group 3/F2 Learn
  ID: Tran Ngoc Minh – s3911737
      Nguyen Duong Truong Thinh – s3914412
      Dang Minh Triet – s4022878
      Du Tuan Vu – s3924489
  Created  date:  26/08/2024
  Last modified:  23/09/2024
  Acknowledgement: RMIT Canvas( tutorials, modules)
*/
import SwiftUI

struct ExploreView: View {
    @ObservedObject var postViewModel: PostViewModel
    @State private var searchText = ""
    @State private var selectedCategory: SubjectCategory?
    @State private var sortOption: SortOption = .newest
    @State private var showFilters = false
    @State private var selectedPost: Post?
    @State private var showingPostDetail = false
    
    enum SortOption: String, CaseIterable {
        case newest = "Newest"
        case oldest = "Oldest"
        case mostLiked = "Most Liked"
        case mostCommented = "Most Commented"
    }
    
    var filteredPosts: [Post] {
        postViewModel.posts.filter { post in
            post.isApproved &&
            (searchText.isEmpty || post.title.lowercased().contains(searchText.lowercased()) || post.content.lowercased().contains(searchText.lowercased())) &&
            (selectedCategory == nil || post.subjectCategory == selectedCategory)
        }.sorted { post1, post2 in
            switch sortOption {
            case .newest:
                return post1.createdAt > post2.createdAt
            case .oldest:
                return post1.createdAt < post2.createdAt
            case .mostLiked:
                return post1.likes > post2.likes
            case .mostCommented:
                return post1.comments.count > post2.comments.count
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar
            filterAndSortBar
            
            if showFilters {
                FilterView(selectedCategory: $selectedCategory)
            }
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredPosts) { post in
                        VStack(spacing: 0) {
                            PostRow(post: post, postViewModel: postViewModel)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .onTapGesture {
                                    selectedPost = post
                                    showingPostDetail = true
                                }
                            
                            Divider()
                                .background(Color.customSecondary.opacity(0.5))
                        }
                    }
                }
            }
        }
        .background(Color.customBackground)
        .sheet(isPresented: $showingPostDetail) {
            if let post = selectedPost {
                PostDetailView(post: post, postViewModel: postViewModel)
            }
        }
        .onAppear {
            postViewModel.fetchPosts(isAdmin: false)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.customSecondary)
            TextField("Search posts", text: $searchText)
                .foregroundColor(.customTextPrimary)
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.customSecondary)
                }
            }
        }
        .padding()
        .background(Color.customBackground)
    }
    
    private var filterAndSortBar: some View {
        HStack {
            Button(action: { showFilters.toggle() }) {
                Label("Filters", systemImage: "line.horizontal.3.decrease.circle")
                    .foregroundColor(.customPrimary)
            }
            Spacer()
            Menu {
                Picker("Sort", selection: $sortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
                    .foregroundColor(.customPrimary)
            }
        }
        .padding()
        .background(Color.customBackground)
    }
}

struct FilterView: View {
    @Binding var selectedCategory: SubjectCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                FilterButton(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                
                ForEach(SubjectCategory.allCases, id: \.self) { category in
                    FilterButton(title: category.rawValue, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
        .background(Color.customBackground)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.customPrimary : Color.customSecondary.opacity(0.2))
                .foregroundColor(isSelected ? .white : .customTextPrimary)
                .cornerRadius(20)
        }
    }
}
