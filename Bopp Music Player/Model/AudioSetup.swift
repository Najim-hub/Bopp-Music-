//
//  AudioSetup.swift
//  Bopp Music Player
//
//  Created by Najim Mohammed on 2021-06-07.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer


class AudioSetup: ObservableObject {
    
    //public var ifPlaying : Bool = false
    
    //public var audioPlayer: AVAudioPlayer? = nil
    
    var playValue: TimeInterval = 0.0
    
    public var playerDuration: TimeInterval = 0
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    public var position : Int = 0
    
    @Published public var songs = [Landmark]()
    
    public var isPlaying : Bool = false
    
    var player = MusicPlayerViewModel()
    
    func playSound(SongPosition:Int) -> Int{
        
        //set up player
        //let song = songs[landmarks[SongPosition].id - 1]
        
        print(SongPosition, "From Play Sound Inside Audio Class")
        
     
        let urlString = Bundle.main.path(forResource: landmarks[SongPosition].trackName, ofType: "mp3")
        
        position = SongPosition
        
        let fileUrl = NSURL(fileURLWithPath: urlString!)
        
        do {
         

           // player.audioPlayer?.stop()
            
           // try player.audioPlayer = AVAudioPlayer(contentsOf:fileUrl as URL)
            
            print("Testing Url", urlString ,":::::::::OUTPUT")
            
            //playerDuration = player.audioPlayer?.duration ?? 0
            
            if player.isPlaying == false {
        
                play()
                
                print(player.isPlaying, " Player Now Playing")
                
                player.isPlaying = true
            }
            
            else {
        
                play()
              // stop()
                           
                print("Music stopped because another instance playing")
                
            }
        
    
        }
        catch {
            print("error occurred")
        
        }
       
    
        
        return SongPosition
         
     
    }
    
    func playSoundInMiniView(){
        
        let urlString = Bundle.main.path(forResource: landmarks[position + 1].trackName, ofType: "mp3")
        
        let fileUrl = NSURL(fileURLWithPath: urlString!)
        
        print(position + 1)
        
        do {
            
            player.isPlaying = false
         
            //player.audioPlayer?.stop()
            
           // try audioPlayer = AVAudioPlayer(contentsOf:fileUrl as URL)
            
            print("Testing Url", urlString ,":::::::::OUTPUT")
            
            //playerDuration = player.audioPlayer?.duration ?? 0
            
            if player.isPlaying == false {
        
            //    audioPlayer?.play()
                
                print(player.isPlaying, " Player Now Playing")
                
                player.isPlaying = true
            }
            
            else {
        
             //   audioPlayer?.play()
              // stop()
                           
                print("Music stopped because another instance playing")
                
            }
        
    
        }
        catch {
            print("error occurred")
        
        }
       
    
        
        
    }
    
    func play(){
        
    //   if player.audioPlayer?.isPlaying == false{
        
     //   player.audioPlayer?.prepareToPlay()
     ///
      //  player.audioPlayer?.play()
        //   }
    }
    
    func stop(){
        
      //  if player.audioPlayer?.isPlaying == true{
             
      //      player.audioPlayer?.stop()
      //   }
    }
    
    
    func didTapNextButton(){
        
       // var Position  = Position
        var Position = (position - 1) + 1
        
        print(Position, "in Next Button")
        
        print(landmarks.count, "Land Mark size")
        
       // player.audioPlayer?.stop()
         
         if Position < landmarks.count {
             
            
            Position = Position + 1
             
            print(Position, "Adding one to Position")
           
         
            //audioPlayer?.stop()
            
            //playSound(SongPosition: Position)
            
            //audioPlayer?.play()
                
             print(Position,"Next Song")
            
             
         }
         
  
         
         
     }
    
    
}

class AudioPlayer {
    
    var player: AVAudioPlayer? = AVAudioPlayer()
    
    var MPlayer = MusicPlayerViewModel()
    
    //var players = MusicPlayerViewModel()
   static let sharedInstance = AudioPlayer()
    
    class func destroy() {
        sharedInstance.player = nil
      }
    
    
    func playSong(){
        
        if Position.sharedInstance.position < landmarks.count - 1 && Position.sharedInstance.position > -1{
            
            print(Position.sharedInstance.position)
    
    let urlString = Bundle.main.path(forResource: landmarks[Position.sharedInstance.position].trackName, ofType: "mp3")
    
    print(Position.sharedInstance.position, "Within position")
        
        //Position.sharedInstance.position = Position.sharedInstance.position
    
    let fileUrl = NSURL(fileURLWithPath: urlString!)
    
        //player.audioPlayer?.stop()
    
    do {
        
    try player = AVAudioPlayer(contentsOf:fileUrl as URL)
        
        player?.play()
        
        MPlayer.isPlaying = true
      
    
    }
    
    catch {
        print("error occurred")
    
    }
        }
   }
    
    private init() {
        
        print("init singletion")
    }
    
    
    
    deinit {
           print("deinit singleton")
       }
}
