//
//  ResultsView.swift
//  selector
//
//  Created by Georgy Alexandrov on 25.04.2022.
//

import SwiftUI

struct ResultsView: View {
    var text: String
    init(rects: [(Int, CGRect)]) {
        self.text = rects.map({ (id, rect) in
            return "image\(id),\(Int(rect.minX.rounded())),\(Int(rect.minY.rounded())),\(Int(rect.maxX.rounded())),\(Int(rect.maxY.rounded()))" }).joined(separator: "\n")
    }
    var body: some View {
        VStack {
            TextEditor(text: .constant(text))
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(rects: [])
    }
}
