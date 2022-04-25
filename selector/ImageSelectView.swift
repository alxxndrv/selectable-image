//
//  ImageSelectView.swift
//  selector
//
//  Created by Georgy Alexandrov on 25.04.2022.
//

import SwiftUI

struct ImageSelectView: View {
    var image: Image
    var id: Int
    @State var rect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    @Binding var rootRects: [(Int, CGRect)]
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: 1280, height: 720, alignment: .center)
            .clipShape(Rectangle())
            .gesture(DragGesture()
                        .onChanged({ value in
                rect.origin = value.startLocation
                rect.size = value.translation
                print(rect)
            })
                    .onEnded({_ in
                rootRects.append((id, rect))
            }))
            .overlay(Path(rect).stroke(Color.red, lineWidth: 5))
    }
}

struct ImageSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectView(image: Image("b"), id: 0, rootRects: .constant([]))
    }
}
