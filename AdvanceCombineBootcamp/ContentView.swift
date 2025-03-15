//
//  ContentView.swift
//  AdvanceCombineBootcamp
//
//  Created by Weerawut Chaiyasomboon on 14/03/2568.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = AdvanceCombineViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                VStack {
                    ForEach(vm.data, id: \.self) {
                        Text($0)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                    
                    if !vm.errorMessage.isEmpty {
                        Text(vm.errorMessage)
                    }
                }
                
                VStack {
                    ForEach(vm.dataBool, id: \.self) {
                        Text($0.description)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
