//
//  Home.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-06.
//

import SwiftUI
import AVFoundation
import MediaPlayer
import SystemConfiguration


struct Home: View {
    
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com")
    
    @State private var showAlert = false
    
    @StateObject var player = MusicPlayerViewModel()
  
    @GestureState var gestureOffset: CGFloat = 0
    
    @ObservedObject var playController = playControl.sharedInstance
    
    @ObservedObject var songList = loadInfo.sharedInstance
    
    @ObservedObject var audio = AudioSetup()
    
    @State var states : Bool = false
    
    @ObservedObject var Avplayer = AudioPlayer.sharedInstance
    
    @ObservedObject var val = playVal.sharedInstance
    
    @ObservedObject var searchBar: SearchBar = SearchBar()
    
    @ObservedObject var gen = GenWallet.sharedInstance
    
    var texting = searching.sharedInstance
   

    @State var searchText: String = ""
    
    
   @State private var keyboardHeight: CGFloat = 0

   
     
    @State var value: Float = 0
    
    @AppStorage("Name") var Name = ""
    
    //@State private var searchText : String = ""

    
    var body: some View {
        
        NavigationView {
                
                  List(
                    songList.songs.filter {
                                 
                    texting.text.isEmpty
                      
                            ||
                            
                     $0.trackName.localizedStandardContains(texting.text)
                      
                          ||
                      
                      $0.trackName.localizedStandardContains(val.searchText)
                      
                      ||
                      
                      $0.artistName.localizedStandardContains(texting.text)
                      
                      ||
                      
                      
                      $0.artistName.localizedStandardContains(val.searchText)
                            
                            }){
                          landmark in
                
                HStack(spacing: 15){
                    
                    LandmarkRow(landmark: landmark)
                    //.padding(.horizontal)
                    .onTapGesture {
                        withAnimation{
                            
                            var flags = SCNetworkReachabilityFlags()
                            SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                            
                            if self.isNetworkReachable(with: flags){
                                
                            gen.balance()
                                
                            playController.showPlayer = true
                            
                            
                            playController.isPlaying = true
                            
                                playController.isMini = true
                           
                            
                            playController.position = landmark.id - 1
                            
                            if Avplayer.player!.rate > 0 {
                                
                                val.playValue = 0
                            
                                Avplayer.player?.rate = 0
                                
                                
                                
                                Avplayer.playSong()
                            
                            }
                            
                            else{
                                val.playValue = 0
                                Avplayer.playSong()
                            }
                            HapticFeedBack.shared.hit(0.3)
                        
                            }
                            
                            else{
                                self.showAlert = true
                            }

                            
                        }
                        
                    }
                    
                    Button(action: {
                        
                        var flags = SCNetworkReachabilityFlags()
                        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                        
                        val.playValue = 0
                        
                        if self.isNetworkReachable(with: flags){
                            
                            
                        playController.showPlayer = true
                        
                        playController.isMini = true
                       
                        playController.isPlaying = true
                            
                       
                        
                        playController.position = landmark.id - 1
                        
                        if Avplayer.player!.rate > 0 {
                        
                            Avplayer.player?.rate = 0
                            
                            Avplayer.playSong()
                        
                        }
                        
                        else{
                            Avplayer.playSong()
                        }
                        HapticFeedBack.shared.hit(0.3)
                            
                        }
                        
                        else{
                            self.showAlert = true
                        }
                        
                 
                            
                    }, label: {
                        
                            Image(systemName: "")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                    }
                    )
                    
                    
                    
                
                }.onAppear(perform: {
                     var flags = SCNetworkReachabilityFlags()
                    SCNetworkReachabilityGetFlags(self.reachability!, &flags)
                    
                    if self.isNetworkReachable(with: flags){
                        
                        
                    }
                    
                    else{
                        self.showAlert = true
                    }
                    
                    
                })
                    //.padding(.bottom, playController.isMini ? 90 : 0)
                .listStyle(PlainListStyle())
                .alert(isPresented: self.$showAlert){
                    Alert(title: Text("No Internet Connection"), message: Text("Please enable WiFi or Cellular Data"), dismissButton: .default(Text("Ok")))
                }
                                
                                
                    
                }
            
            
              
               // .frame(width:  UIScreen.main.bounds.width, height: .infinity, alignment: .center)
               // .offset(y: playController.isMini ? -100 : 0)
                .navigationBarTitle(Text("Songs"), displayMode: .automatic)
            
                .add(self.searchBar)
            
                .ignoresSafeArea(.keyboard)
                }
        
        
        
            .navigationViewStyle(StackNavigationViewStyle())
                
            
            .onChange(of: gestureOffset, perform: { value in
            onChanged()
                
        })
        
      
        
       
}
    
    private func isNetworkReachable(with flags : SCNetworkReachabilityFlags) -> Bool{
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
        
      
    }
    
    func onChanged(){
        
        if gestureOffset > 0 && !playController.isMini && playController.offset + 180 <= playController.height{
        
            playController.offset = gestureOffset
        }
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(.default){

            if !playController.isMini{
                
                playController.offset = 0
                
                // Closing View...
          if value.translation.height > UIScreen.main.bounds.height / 3
                {
                    
            playController.isMini = true
                    
                    
                }
                else{
                    playController.isMini = false
                    
                 
            }
        }
    }
    }

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
           // .padding(.all)
    }
}
}
class SearchBar: NSObject, ObservableObject {
    
    @Published var text: String = ""
    
  var val = playVal.sharedInstance
    
    
   var playController = playControl.sharedInstance
    
    
    var texting = searching.sharedInstance
   
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override init() {
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
       
    }
}

extension SearchBar: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print("updating")
        // Publish search bar text changes.
         if let searchBarText = searchController.searchBar.text {
                
                self.text = searchBarText
                
                val.searchText = searchBarText
                
                searching.sharedInstance.text = searchBarText
                
                print("Not Mini: ", self.text)
                
                print("Val: ",  val.searchText)
            
        }
    }
}

struct SearchBarModifier: ViewModifier {
    
    let searchBar: SearchBar
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }
                    .frame(width: 0, height: 0)
            )
    }
}


class searching: ObservableObject{
    
    @Published var text = ""
    
    static let sharedInstance = searching()
    
    init(){
        
    }
    
}

extension View {
    
    func add(_ searchBar: SearchBar) -> some View {
        return self.modifier(SearchBarModifier(searchBar: searchBar))
    }
}
