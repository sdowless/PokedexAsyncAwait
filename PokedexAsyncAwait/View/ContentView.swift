//
//  ContentView.swift
//  PokedexAsyncAwait
//
//  Created by Stephan Dowless on 1/4/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PokedexViewModel(serviceConfig: .asyncAwait)
    @State var showAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.pokemon) {pokemon in
                    PokemonRowView(pokemon: pokemon)
                        .onAppear {
                            guard let index = viewModel.pokemon.firstIndex(where: { $0.id == pokemon.id }) else { return }
                            if index == viewModel.pokemon.count - 1 {
                                viewModel.loadDataAsync()
                            }
                        }
                }
                .frame(height: 130)
                
            }
            .navigationTitle("Pokedex")
            .onReceive(viewModel.$error, perform: { error in
                if error != nil {
                    self.showAlert.toggle()
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error?.localizedDescription ?? "")
                )
            }
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
