//
//  ContentView.swift
//  selector
//
//  Created by Georgy Alexandrov on 25.04.2022.
//

import SwiftUI

struct ContentView: View {
    @State var rects = [(Int, CGRect)]()
    @State var images = [Image]()
    @State private var dragOver = false
    @State var index: Int = 0
    var body: some View {
        VStack {
        if images.isEmpty {
            VStack {
                Text("Перетащите изображения сюда")
                    .fixedSize()
                    .padding()
            }.frame(width: 300, height: 300, alignment: .center)
                .contentShape(Rectangle())
        } else {
            ImageSelectView(image: images[index], id: index, rootRects: $rects)
                .id(index)
                .onChange(of: rects.count, perform: { _ in
                    if images.count - 1 == index {
                        images = []
                        index = 0
                    } else {
                        index += 1
                    }
                })
        }
    }
        .onDrop(of: ["public.file-url"], isTargeted: $dragOver) { providers -> Bool in
            for provider in providers {
                provider.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { (data, error) in
                    if let data = data, let path = NSString(data: data, encoding: 4), let url = URL(string: path as String) {
                        let image = NSImage(contentsOf: url)
                        DispatchQueue.main.async {
                            images.append(Image(nsImage: image!))
                        }
                    }
                })
            }
            return true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MyDropDelegate: DropDelegate {
        @Binding var imageUrls: [Int: URL]
        @Binding var active: Int
        
        func validateDrop(info: DropInfo) -> Bool {
            return info.hasItemsConforming(to: [.image])
        }
        
        func dropEntered(info: DropInfo) {
            print("test")
            NSSound(named: "Morse")?.play()
        }
        
        func performDrop(info: DropInfo) -> Bool {
            NSSound(named: "Submarine")?.play()
            
            let gridPosition = getGridPosition(location: info.location)
            self.active = gridPosition
            
            if let item = info.itemProviders(for: ["public.file-url"]).first {
                item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                    DispatchQueue.main.async {
                        if let urlData = urlData as? Data {
                            self.imageUrls[gridPosition] = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                        }
                    }
                }
                
                return true
                
            } else {
                return false
            }

        }
        
        func dropUpdated(info: DropInfo) -> DropProposal? {
            self.active = getGridPosition(location: info.location)
                        
            return nil
        }
        
        func dropExited(info: DropInfo) {
            self.active = 0
        }
        
        func getGridPosition(location: CGPoint) -> Int {
            if location.x > 150 && location.y > 150 {
                return 4
            } else if location.x > 150 && location.y < 150 {
                return 3
            } else if location.x < 150 && location.y > 150 {
                return 2
            } else if location.x < 150 && location.y < 150 {
                return 1
            } else {
                return 0
            }
        }
    }
