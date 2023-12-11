    //
//  ProfileView.swift
//  SwfitUIFirebaseBootcamp
//
//  Created by Shubham Deshmukh on 26/05/23.
//

import SwiftUI
import PhotosUI


struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedItem: PhotosPickerItem? = nil
//    @State private var image: UIImage? = nil
    @State private var url: URL? = nil
    
    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]
    
    private func preferenceIsSelected(text: String) -> Bool {
        return viewModel.user?.preferences?.contains(text) == true
    }
    
    var body: some View {
        List{
            if let user = viewModel.user {
                
                Text("UserId: \(user.userId)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("is Anonymous: \(isAnonymous.description.capitalized)")
                }
                
                Button {
                    viewModel.togglePremiumStatus()
                } label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                }
                
                VStack{
                    HStack{
                        ForEach(preferenceOptions, id:\.self) { string in
                            Button(string) {
                                if preferenceIsSelected(text: string){
                                    viewModel.removeUserPrefrence(text: string)
                                }else{
                                    viewModel.addUserPrefrence(text: string)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .font(.headline)
                            .tint(preferenceIsSelected(text: string) ? .green : .red)
                        }
                    }
 
                    Text("User Preferences : \((user.preferences ?? []).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                
                Button {
                    if user.favoriteMovie == nil {
                        viewModel.addFavoriteMovie()
                    }else{
                        viewModel.removeFavoriteMovie()
                    }
                } label: {
                    Text("Favorite Movie: \((user.favoriteMovie?.title ?? "").description.capitalized)")
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                
//                if let image {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 200, height: 200)
//                        .cornerRadius(10)
//                }
                
                if let urlString = viewModel.user?.profileImagePathUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                }
                
                if viewModel.user?.profileImagePath != nil {
                    Button("Delete Image") {
                        viewModel.deleteProfileImage()
                    }
                }
            }
        }
        
        .task {
            try? await viewModel.loadCurrentUser()
            
//            if let user = viewModel.user, let path = user.profileImagePath {
//                let uiImage = try? await StorageManager.shared.getImage(userId: user.userId, path: path)
//                print("downloaded image path \(path)")
//                self.image = uiImage
//            }
//
//            if let user = viewModel.user, let path = user.profileImagePath {
//                let url = try? await StorageManager.shared.getUrlForImage(path: path)
//                print("downloaded image path \(path)")
//                self.url = url
//            }
            
        }
        .onChange(of: selectedItem, perform: { newValue in
            if let newValue {
                viewModel.saveProfileImage(item: newValue)
            }
        })
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
//        ProfileView(showSignInView: .constant(false))
        RootView()
    }
}
